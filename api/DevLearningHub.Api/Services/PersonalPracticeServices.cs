using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using DevLearningHub.Api.Common;
using DevLearningHub.Api.Data;
using DevLearningHub.Api.DTOs;
using DevLearningHub.Api.Entities;
using Microsoft.EntityFrameworkCore;

namespace DevLearningHub.Api.Services;

public interface IPersonalPracticeService
{
    Task<ApiResponse<PersonalQuestionBankUploadResponse>> Upload(long userId, IFormFile file, string title, string? description, CancellationToken ct);
    Task<ApiResponse<List<PersonalQuestionBankSummaryResponse>>> MyBanks(long userId, CancellationToken ct);
    Task<ApiResponse<PersonalQuestionBankDetailResponse>> GetBank(long userId, long bankId, CancellationToken ct);
    Task<ApiResponse<object>> DeleteBank(long userId, long bankId, CancellationToken ct);
    Task<ApiResponse<PersonalPracticeAttemptResponse>> StartAttempt(long userId, long bankId, StartPersonalPracticeAttemptRequest request, CancellationToken ct);
    Task<ApiResponse<PersonalPracticeAttemptResultResponse>> SubmitAttempt(long userId, long attemptId, SubmitPersonalPracticeAttemptRequest request, CancellationToken ct);
    Task<ApiResponse<List<PersonalPracticeAttemptResultResponse>>> MyAttempts(long userId, CancellationToken ct);
    Task<ApiResponse<PersonalPracticeAttemptResultResponse>> GetAttempt(long userId, long attemptId, CancellationToken ct);
}

public sealed class PersonalPracticeService : IPersonalPracticeService
{
    private readonly DevLearningHubDbContext _db;
    private readonly IWebHostEnvironment _env;
    private const long MaxFileBytes = 5 * 1024 * 1024;
    private const int MaxRows = 1000;

    public PersonalPracticeService(DevLearningHubDbContext db, IWebHostEnvironment env)
    {
        _db = db;
        _env = env;
    }

    public async Task<ApiResponse<PersonalQuestionBankUploadResponse>> Upload(long userId, IFormFile file, string title, string? description, CancellationToken ct)
    {
        var errors = ValidateUpload(file, title);
        if (errors.Count > 0) return ApiResponse<PersonalQuestionBankUploadResponse>.Fail("Validation failed", errors);

        var parsed = await ParseFile(file, ct);
        if (parsed.Errors.Count > 0)
        {
            return new ApiResponse<PersonalQuestionBankUploadResponse>
            {
                Success = false,
                Message = "Question file is invalid",
                Data = new PersonalQuestionBankUploadResponse { Title = title, ImportErrors = parsed.Errors },
                Errors = parsed.Errors.Select(x => new ApiError { Field = "file", Message = x }).ToList()
            };
        }

        var root = Path.Combine(_env.ContentRootPath, "uploads", "personal-practice");
        Directory.CreateDirectory(root);
        var ext = Path.GetExtension(file.FileName).ToLowerInvariant();
        var stored = $"{Guid.NewGuid():N}{ext}";
        var storedPath = Path.Combine(root, stored);
        await using (var fs = File.Create(storedPath))
        {
            await file.CopyToAsync(fs, ct);
        }

        await using var tx = await _db.Database.BeginTransactionAsync(ct);
        var bank = new PersonalQuestionBank
        {
            UserId = userId,
            Title = title.Trim(),
            Description = description,
            OriginalFileName = Path.GetFileName(file.FileName),
            FileStorageKey = stored,
            Visibility = "Private",
            QuestionCount = parsed.Questions.Count,
            CreatedAt = DateTime.UtcNow
        };
        _db.PersonalQuestionBanks.Add(bank);
        await _db.SaveChangesAsync(ct);

        foreach (var q in parsed.Questions)
        {
            q.UserId = userId;
            q.BankId = bank.Id;
            _db.PersonalQuestions.Add(q);
        }
        await _db.SaveChangesAsync(ct);
        await tx.CommitAsync(ct);

        return ApiResponse<PersonalQuestionBankUploadResponse>.Ok(new PersonalQuestionBankUploadResponse
        {
            BankId = bank.Id,
            Title = bank.Title,
            QuestionCount = bank.QuestionCount,
            CreatedAt = bank.CreatedAt,
            ImportWarnings = parsed.Warnings
        }, "Personal question bank uploaded");
    }

    public async Task<ApiResponse<List<PersonalQuestionBankSummaryResponse>>> MyBanks(long userId, CancellationToken ct)
    {
        var rows = await _db.PersonalQuestionBanks.AsNoTracking()
            .Where(x => x.UserId == userId && !x.IsDeleted)
            .OrderByDescending(x => x.CreatedAt)
            .Select(x => new PersonalQuestionBankSummaryResponse
            {
                Id = x.Id,
                Title = x.Title,
                Description = x.Description,
                QuestionCount = x.QuestionCount,
                CreatedAt = x.CreatedAt
            })
            .ToListAsync(ct);
        return ApiResponse<List<PersonalQuestionBankSummaryResponse>>.Ok(rows);
    }

    public async Task<ApiResponse<PersonalQuestionBankDetailResponse>> GetBank(long userId, long bankId, CancellationToken ct)
    {
        var bank = await _db.PersonalQuestionBanks.AsNoTracking()
            .Include(x => x.Questions.Where(q => !q.IsDeleted)).ThenInclude(x => x.Options)
            .FirstOrDefaultAsync(x => x.Id == bankId && x.UserId == userId && !x.IsDeleted, ct);
        return bank == null
            ? ApiResponse<PersonalQuestionBankDetailResponse>.Fail("Personal question bank not found")
            : ApiResponse<PersonalQuestionBankDetailResponse>.Ok(MapBankDetail(bank));
    }

    public async Task<ApiResponse<object>> DeleteBank(long userId, long bankId, CancellationToken ct)
    {
        var bank = await _db.PersonalQuestionBanks.Include(x => x.Questions).FirstOrDefaultAsync(x => x.Id == bankId && x.UserId == userId && !x.IsDeleted, ct);
        if (bank == null) return ApiResponse<object>.Fail("Personal question bank not found");
        bank.IsDeleted = true;
        bank.UpdatedAt = DateTime.UtcNow;
        foreach (var question in bank.Questions) question.IsDeleted = true;
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { bankId }, "Personal question bank deleted");
    }

    public async Task<ApiResponse<PersonalPracticeAttemptResponse>> StartAttempt(long userId, long bankId, StartPersonalPracticeAttemptRequest request, CancellationToken ct)
    {
        var bank = await _db.PersonalQuestionBanks.AsNoTracking()
            .Include(x => x.Questions.Where(q => !q.IsDeleted)).ThenInclude(x => x.Options)
            .FirstOrDefaultAsync(x => x.Id == bankId && x.UserId == userId && !x.IsDeleted, ct);
        if (bank == null) return ApiResponse<PersonalPracticeAttemptResponse>.Fail("Personal question bank not found");

        var questions = bank.Questions.ToList();
        if (request.ShuffleQuestions) questions = questions.OrderBy(_ => Guid.NewGuid()).ToList();
        if (request.NumberOfQuestions.HasValue) questions = questions.Take(Math.Clamp(request.NumberOfQuestions.Value, 1, questions.Count)).ToList();

        var attempt = new PersonalPracticeAttempt
        {
            UserId = userId,
            BankId = bankId,
            StartedAt = DateTime.UtcNow,
            Status = "InProgress",
            TotalQuestions = questions.Count,
            Answers = questions.Select(q => new PersonalPracticeAttemptAnswer { QuestionId = q.Id, IsCorrect = false }).ToList()
        };
        _db.PersonalPracticeAttempts.Add(attempt);
        await _db.SaveChangesAsync(ct);

        return ApiResponse<PersonalPracticeAttemptResponse>.Ok(new PersonalPracticeAttemptResponse
        {
            AttemptId = attempt.Id,
            BankId = bankId,
            BankTitle = bank.Title,
            StartedAt = attempt.StartedAt,
            Questions = questions.Select(q => MapQuestionForTake(q, request.ShuffleOptions)).ToList()
        }, "Personal practice attempt started");
    }

    public async Task<ApiResponse<PersonalPracticeAttemptResultResponse>> SubmitAttempt(long userId, long attemptId, SubmitPersonalPracticeAttemptRequest request, CancellationToken ct)
    {
        var attempt = await _db.PersonalPracticeAttempts
            .Include(x => x.Bank)
            .Include(x => x.Answers).ThenInclude(x => x.Question).ThenInclude(x => x.Options)
            .FirstOrDefaultAsync(x => x.Id == attemptId && x.UserId == userId && !x.Bank.IsDeleted, ct);
        if (attempt == null) return ApiResponse<PersonalPracticeAttemptResultResponse>.Fail("Practice attempt not found");
        if (attempt.Status != "InProgress") return ApiResponse<PersonalPracticeAttemptResultResponse>.Fail("Practice attempt was already submitted");

        var optionLabelsById = attempt.Answers
            .SelectMany(x => x.Question.Options)
            .GroupBy(x => x.Id)
            .ToDictionary(x => x.Key, x => NormalizeOptionKey(x.First().Label));

        var answerMap = (request.Answers ?? new List<PersonalPracticeAnswerRequest>())
            .Select(x => new { x.QuestionId, Selected = NormalizeSelectedOption(x, optionLabelsById) })
            .Where(x => !string.IsNullOrWhiteSpace(x.Selected))
            .GroupBy(x => x.QuestionId)
            .ToDictionary(x => x.Key, x => x.First().Selected!);

        var correct = 0;
        foreach (var answer in attempt.Answers)
        {
            answer.SelectedOptionLabel = answerMap.TryGetValue(answer.QuestionId, out var selected) ? selected : null;
            var correctLabel = NormalizeOptionKey(answer.Question.Options.FirstOrDefault(x => x.IsCorrect)?.Label);
            answer.IsCorrect = !string.IsNullOrWhiteSpace(answer.SelectedOptionLabel)
                && string.Equals(answer.SelectedOptionLabel, correctLabel, StringComparison.OrdinalIgnoreCase);
            if (answer.IsCorrect) correct++;
        }

        attempt.CorrectCount = correct;
        attempt.Score = attempt.TotalQuestions == 0 ? 0 : Math.Round(correct * 10m / attempt.TotalQuestions, 2);
        attempt.SubmittedAt = DateTime.UtcNow;
        attempt.Status = "Submitted";
        await _db.SaveChangesAsync(ct);

        return ApiResponse<PersonalPracticeAttemptResultResponse>.Ok(MapAttemptResult(attempt), "Practice attempt submitted");
    }

    public async Task<ApiResponse<List<PersonalPracticeAttemptResultResponse>>> MyAttempts(long userId, CancellationToken ct)
    {
        var rows = await _db.PersonalPracticeAttempts.AsNoTracking()
            .Include(x => x.Bank)
            .Include(x => x.Answers).ThenInclude(x => x.Question).ThenInclude(x => x.Options)
            .Where(x => x.UserId == userId && !x.Bank.IsDeleted)
            .OrderByDescending(x => x.StartedAt)
            .Take(100)
            .ToListAsync(ct);
        return ApiResponse<List<PersonalPracticeAttemptResultResponse>>.Ok(rows.Select(MapAttemptResult).ToList());
    }

    public async Task<ApiResponse<PersonalPracticeAttemptResultResponse>> GetAttempt(long userId, long attemptId, CancellationToken ct)
    {
        var attempt = await _db.PersonalPracticeAttempts.AsNoTracking()
            .Include(x => x.Bank)
            .Include(x => x.Answers).ThenInclude(x => x.Question).ThenInclude(x => x.Options)
            .FirstOrDefaultAsync(x => x.Id == attemptId && x.UserId == userId && !x.Bank.IsDeleted, ct);
        return attempt == null
            ? ApiResponse<PersonalPracticeAttemptResultResponse>.Fail("Practice attempt not found")
            : ApiResponse<PersonalPracticeAttemptResultResponse>.Ok(MapAttemptResult(attempt));
    }

    private static List<ApiError> ValidateUpload(IFormFile file, string title)
    {
        var errors = new List<ApiError>();
        if (string.IsNullOrWhiteSpace(title)) errors.Add(new ApiError { Field = "title", Message = "Title is required" });
        if (file == null || file.Length == 0) errors.Add(new ApiError { Field = "file", Message = "File is required" });
        if (file != null && file.Length > MaxFileBytes) errors.Add(new ApiError { Field = "file", Message = "File size must be 5MB or less" });
        if (file != null)
        {
            var ext = Path.GetExtension(file.FileName).ToLowerInvariant();
            if (ext is not ".csv" and not ".json") errors.Add(new ApiError { Field = "file", Message = "Only CSV and JSON are currently supported" });
            if (!string.IsNullOrWhiteSpace(file.ContentType)
                && !file.ContentType.Contains("csv", StringComparison.OrdinalIgnoreCase)
                && !file.ContentType.Contains("json", StringComparison.OrdinalIgnoreCase)
                && file.ContentType != "application/vnd.ms-excel"
                && file.ContentType != "text/plain")
                errors.Add(new ApiError { Field = "file", Message = "File MIME type is not allowed" });
        }
        return errors;
    }

    private async Task<ParseResult> ParseFile(IFormFile file, CancellationToken ct)
    {
        await using var stream = file.OpenReadStream();
        using var reader = new StreamReader(stream, Encoding.UTF8, detectEncodingFromByteOrderMarks: true);
        var content = await reader.ReadToEndAsync(ct);
        return Path.GetExtension(file.FileName).Equals(".json", StringComparison.OrdinalIgnoreCase)
            ? ParseJson(content)
            : ParseCsv(content);
    }

    private static ParseResult ParseJson(string json)
    {
        try
        {
            var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
            using var document = JsonDocument.Parse(json);
            List<PersonalQuestionImportRow> rows;
            if (document.RootElement.ValueKind == JsonValueKind.Object
                && TryGetPropertyIgnoreCase(document.RootElement, "questions", out var questions)
                && questions.ValueKind == JsonValueKind.Array)
            {
                rows = questions.Deserialize<List<PersonalQuestionImportRow>>(options) ?? new();
            }
            else
            {
                rows = JsonSerializer.Deserialize<List<PersonalQuestionImportRow>>(json, options) ?? new();
            }
            return BuildQuestions(rows);
        }
        catch (Exception ex)
        {
            return new ParseResult { Errors = { $"JSON parse error: {ex.Message}" } };
        }
    }

    private static ParseResult ParseCsv(string csv)
    {
        var rows = ParseCsvRows(csv);
        if (rows.Count < 2) return new ParseResult { Errors = { "CSV must include a header and at least one question row." } };
        var headers = rows[0].Select(NormalizeHeader).ToList();
        var importRows = new List<PersonalQuestionImportRow>();
        for (var i = 1; i < rows.Count; i++)
        {
            var row = rows[i];
            if (row.All(string.IsNullOrWhiteSpace)) continue;
            importRows.Add(new PersonalQuestionImportRow
            {
                LineNumber = i + 1,
                QuestionText = ReadValue(headers, row, "question_text", "questiontext", "question"),
                QuestionType = ReadValue(headers, row, "question_type", "questiontype"),
                OptionA = ReadValue(headers, row, "option_a", "optiona", "a"),
                OptionB = ReadValue(headers, row, "option_b", "optionb", "b"),
                OptionC = ReadValue(headers, row, "option_c", "optionc", "c"),
                OptionD = ReadValue(headers, row, "option_d", "optiond", "d"),
                CorrectAnswer = ReadValue(headers, row, "correct_answer", "correctanswer", "correct_option", "correctoption", "correct"),
                Explanation = ReadValue(headers, row, "explanation"),
                Difficulty = ReadValue(headers, row, "difficulty"),
                Tags = ReadValue(headers, row, "tags")
            });
        }
        return BuildQuestions(importRows);
    }

    private static ParseResult BuildQuestions(List<PersonalQuestionImportRow> rows)
    {
        var result = new ParseResult();
        if (rows.Count > MaxRows) result.Errors.Add($"File contains too many rows. Maximum is {MaxRows}.");
        foreach (var row in rows)
        {
            var line = row.LineNumber == 0 ? rows.IndexOf(row) + 1 : row.LineNumber;
            var questionType = string.IsNullOrWhiteSpace(row.QuestionType) ? "single_choice" : row.QuestionType.Trim().ToLowerInvariant();
            var questionText = FirstNonEmpty(row.QuestionText, row.Content, row.Question, row.Title);
            var importOptions = BuildImportOptions(row);
            var correctRaw = FirstNonEmpty(row.CorrectAnswer, row.CorrectOption, row.CorrectAnswerSnake, row.CorrectOptionSnake);
            var correctKey = NormalizeOptionKey(correctRaw);
            if (questionType != "single_choice") result.Errors.Add($"Line {line}: only single_choice is supported.");
            if (string.IsNullOrWhiteSpace(questionText)) result.Errors.Add($"Line {line}: question_text/content is required.");
            if (importOptions.Count < 2) result.Errors.Add($"Line {line}: at least two options are required.");
            foreach (var option in importOptions)
            {
                var optionKey = NormalizeOptionKey(option.Label);
                if (optionKey == null)
                {
                    result.Errors.Add($"Line {line}: option keys must be A, B, C or D.");
                    break;
                }
                option.Label = optionKey;
            }
            if (importOptions.Select(x => x.Label).Distinct(StringComparer.OrdinalIgnoreCase).Count() != importOptions.Count)
            {
                result.Errors.Add($"Line {line}: option keys must be unique.");
            }
            if (string.IsNullOrWhiteSpace(correctRaw))
            {
                var correctFromOption = importOptions.Where(x => x.IsCorrect).Select(x => x.Label).Distinct(StringComparer.OrdinalIgnoreCase).ToList();
                if (correctFromOption.Count == 1) correctKey = correctFromOption[0];
            }
            else if (correctKey == null)
            {
                result.Errors.Add($"Line {line}: correct option must be A, B, C or D.");
            }
            if (correctKey == null)
            {
                result.Errors.Add($"Line {line}: correctAnswer/correctOption is required.");
            }
            else if (!importOptions.Any(x => string.Equals(x.Label, correctKey, StringComparison.OrdinalIgnoreCase)))
            {
                result.Errors.Add($"Line {line}: correct option {correctKey} does not match any option.");
            }
            foreach (var option in importOptions)
            {
                option.IsCorrect = string.Equals(option.Label, correctKey, StringComparison.OrdinalIgnoreCase);
            }
            if (importOptions.Count(x => x.IsCorrect) != 1) result.Errors.Add($"Line {line}: exactly one option must be correct.");
            var difficulty = NormalizeDifficulty(row.Difficulty);
            if (!string.IsNullOrWhiteSpace(row.Difficulty) && difficulty == "medium" && !row.Difficulty.Equals("medium", StringComparison.OrdinalIgnoreCase))
                result.Warnings.Add($"Line {line}: unknown difficulty was converted to medium.");

            if (result.Errors.Any(x => x.StartsWith($"Line {line}:"))) continue;

            result.Questions.Add(new PersonalQuestion
            {
                QuestionText = questionText.Trim(),
                QuestionType = questionType,
                Difficulty = difficulty,
                Explanation = row.Explanation,
                Tags = FirstNonEmpty(row.Tags, row.Topic),
                CreatedAt = DateTime.UtcNow,
                Options = importOptions.Select(x => new PersonalQuestionOption
                {
                    Label = x.Label,
                    Text = x.Text.Trim(),
                    IsCorrect = x.IsCorrect
                }).ToList()
            });
        }
        if (result.Questions.Count == 0 && result.Errors.Count == 0) result.Errors.Add("No question rows were found.");
        return result;
    }

    private static List<ImportOption> BuildImportOptions(PersonalQuestionImportRow row)
    {
        if (row.Options?.Count > 0)
        {
            return row.Options
                .Select((option, index) => new ImportOption
                {
                    Label = FirstNonEmpty(option.Key, option.Label, option.OptionLabel, Letter(index)).ToUpperInvariant(),
                    Text = FirstNonEmpty(option.Content, option.Text, option.OptionText, option.AnswerText),
                    IsCorrect = option.IsCorrect ?? option.Correct ?? false
                })
                .Where(x => !string.IsNullOrWhiteSpace(x.Text))
                .ToList();
        }

        return new[] { row.OptionA, row.OptionB, row.OptionC, row.OptionD }
            .Select((text, index) => new ImportOption { Label = Letter(index), Text = text ?? string.Empty })
            .Where(x => !string.IsNullOrWhiteSpace(x.Text))
            .ToList();
    }

    private static string Letter(int index) => ((char)('A' + index)).ToString();

    private static string FirstNonEmpty(params string?[] values)
        => values.FirstOrDefault(x => !string.IsNullOrWhiteSpace(x))?.Trim() ?? string.Empty;

    private static string NormalizeDifficulty(string? difficulty)
    {
        var value = (difficulty ?? string.Empty).Trim().ToLowerInvariant();
        return value is "easy" or "medium" or "hard" ? value : "medium";
    }

    private static PersonalQuestionBankDetailResponse MapBankDetail(PersonalQuestionBank bank) => new()
    {
        Id = bank.Id,
        Title = bank.Title,
        Description = bank.Description,
        QuestionCount = bank.QuestionCount,
        CreatedAt = bank.CreatedAt,
        Questions = bank.Questions.OrderBy(x => x.Id).Select(x => MapQuestionForTake(x, false)).ToList()
    };

    private static PersonalQuestionTakeResponse MapQuestionForTake(PersonalQuestion q, bool shuffleOptions, string? selectedOptionLabel = null)
    {
        var options = q.Options.OrderBy(x => x.Label).ToList();
        if (shuffleOptions) options = options.OrderBy(_ => Guid.NewGuid()).ToList();
        return new PersonalQuestionTakeResponse
        {
            Id = q.Id,
            QuestionText = q.QuestionText,
            Content = q.QuestionText,
            QuestionType = q.QuestionType,
            Difficulty = DisplayDifficulty(q.Difficulty),
            Topic = TopicFromTags(q.Tags),
            Tags = q.Tags,
            SelectedOptionLabel = selectedOptionLabel,
            SelectedAnswer = selectedOptionLabel,
            Options = options.Select(x => new PersonalQuestionOptionTakeResponse
            {
                Id = x.Id,
                Key = x.Label,
                Label = x.Label,
                Text = x.Text,
                Content = x.Text
            }).ToList()
        };
    }

    private static PersonalPracticeAttemptResultResponse MapAttemptResult(PersonalPracticeAttempt attempt)
    {
        var answers = attempt.Answers.OrderBy(x => x.Id).ToList();
        return new PersonalPracticeAttemptResultResponse
        {
            Id = attempt.Id,
            AttemptId = attempt.Id,
            BankId = attempt.BankId,
            BankTitle = attempt.Bank.Title,
            Score = attempt.Score,
            TotalQuestions = attempt.TotalQuestions,
            CorrectCount = attempt.CorrectCount,
            Status = attempt.Status,
            StartedAt = attempt.StartedAt,
            SubmittedAt = attempt.SubmittedAt,
            Questions = answers.Select(MapQuestionResult).ToList(),
            Details = answers.Select(MapAnswerResult).ToList()
        };
    }

    private static PersonalPracticeQuestionResultResponse MapQuestionResult(PersonalPracticeAttemptAnswer answer)
    {
        var review = BuildReview(answer);
        return new PersonalPracticeQuestionResultResponse
        {
            QuestionId = answer.QuestionId,
            Id = answer.QuestionId,
            QuestionText = answer.Question.QuestionText,
            Content = answer.Question.QuestionText,
            QuestionType = answer.Question.QuestionType,
            Difficulty = DisplayDifficulty(answer.Question.Difficulty),
            Topic = TopicFromTags(answer.Question.Tags),
            Tags = answer.Question.Tags,
            SelectedOptionLabel = review.SelectedOptionLabel,
            SelectedOption = review.SelectedOption,
            SelectedOptionKey = review.SelectedOptionKey,
            SelectedAnswer = review.SelectedOption,
            CorrectOptionLabel = review.CorrectOptionLabel,
            CorrectOption = review.CorrectOption,
            CorrectOptionKey = review.CorrectOptionKey,
            CorrectAnswer = review.CorrectOption,
            SelectedAnswerText = review.SelectedAnswerText,
            CorrectAnswerText = review.CorrectAnswerText,
            IsCorrect = review.IsCorrect,
            Explanation = review.Explanation,
            Warning = review.Warning,
            Options = review.Options
        };
    }

    private static PersonalPracticeAnswerResultResponse MapAnswerResult(PersonalPracticeAttemptAnswer answer)
        => BuildReview(answer);

    private static PersonalPracticeAnswerResultResponse BuildReview(PersonalPracticeAttemptAnswer answer)
    {
        var selectedKey = NormalizeOptionKey(answer.SelectedOptionLabel);
        var correct = answer.Question.Options.FirstOrDefault(o => o.IsCorrect);
        var correctKey = NormalizeOptionKey(correct?.Label);
        var orderedOptions = answer.Question.Options.OrderBy(x => x.Label).ToList();
        var selectedOption = orderedOptions.FirstOrDefault(o => string.Equals(NormalizeOptionKey(o.Label), selectedKey, StringComparison.OrdinalIgnoreCase));
        var correctOption = orderedOptions.FirstOrDefault(o => string.Equals(NormalizeOptionKey(o.Label), correctKey, StringComparison.OrdinalIgnoreCase));

        return new PersonalPracticeAnswerResultResponse
        {
            QuestionId = answer.QuestionId,
            SelectedOptionLabel = selectedKey,
            SelectedOption = selectedKey,
            SelectedOptionKey = selectedKey,
            CorrectOptionLabel = correctKey,
            CorrectOption = correctKey,
            CorrectOptionKey = correctKey,
            SelectedAnswerText = selectedOption?.Text,
            CorrectAnswerText = correctOption?.Text,
            IsCorrect = answer.IsCorrect,
            Explanation = answer.Question.Explanation,
            Warning = correctKey == null ? "Chưa có đáp án đúng" : null,
            Options = orderedOptions.Select(o =>
            {
                var key = NormalizeOptionKey(o.Label) ?? o.Label;
                return new PersonalPracticeOptionReviewResponse
                {
                    Id = o.Id,
                    Key = key,
                    Label = key,
                    Content = o.Text,
                    Text = o.Text,
                    IsSelected = string.Equals(key, selectedKey, StringComparison.OrdinalIgnoreCase),
                    IsCorrect = o.IsCorrect
                };
            }).ToList()
        };
    }

    private static string DisplayDifficulty(string? difficulty)
        => (difficulty ?? string.Empty).Trim().ToLowerInvariant() switch
        {
            "easy" => "Easy",
            "hard" => "Hard",
            _ => "Medium"
        };

    private static string? TopicFromTags(string? tags)
        => string.IsNullOrWhiteSpace(tags)
            ? null
            : tags.Split(',', ';', '|').Select(x => x.Trim()).FirstOrDefault(x => !string.IsNullOrWhiteSpace(x));

    private static string? NormalizeSelectedOption(PersonalPracticeAnswerRequest answer, IReadOnlyDictionary<long, string?> optionLabelsById)
    {
        if (answer.SelectedOptionId.HasValue
            && optionLabelsById.TryGetValue(answer.SelectedOptionId.Value, out var optionKey)
            && !string.IsNullOrWhiteSpace(optionKey))
        {
            return optionKey;
        }

        return NormalizeOptionKey(FirstNonEmpty(answer.SelectedOptionKey, answer.SelectedOption, answer.SelectedOptionLabel, answer.SelectedAnswer));
    }

    private static string? NormalizeOptionKey(string? value)
    {
        var clean = (value ?? string.Empty).Trim().ToUpperInvariant();
        return clean is "A" or "B" or "C" or "D" ? clean : null;
    }

    private static bool TryGetPropertyIgnoreCase(JsonElement element, string name, out JsonElement value)
    {
        foreach (var property in element.EnumerateObject())
        {
            if (property.NameEquals(name) || property.Name.Equals(name, StringComparison.OrdinalIgnoreCase))
            {
                value = property.Value;
                return true;
            }
        }

        value = default;
        return false;
    }

    private sealed class ParseResult
    {
        public List<PersonalQuestion> Questions { get; set; } = new();
        public List<string> Errors { get; set; } = new();
        public List<string> Warnings { get; set; } = new();
    }

    private sealed class PersonalQuestionImportRow
    {
        public int LineNumber { get; set; }
        public string QuestionText { get; set; } = string.Empty;
        public string Content { get; set; } = string.Empty;
        public string Question { get; set; } = string.Empty;
        public string Title { get; set; } = string.Empty;
        public string QuestionType { get; set; } = string.Empty;
        public string OptionA { get; set; } = string.Empty;
        public string OptionB { get; set; } = string.Empty;
        public string OptionC { get; set; } = string.Empty;
        public string OptionD { get; set; } = string.Empty;
        public string CorrectAnswer { get; set; } = string.Empty;
        public string CorrectOption { get; set; } = string.Empty;
        [JsonPropertyName("correct_answer")]
        public string CorrectAnswerSnake { get; set; } = string.Empty;
        [JsonPropertyName("correct_option")]
        public string CorrectOptionSnake { get; set; } = string.Empty;
        [JsonPropertyName("option_a")]
        public string OptionASnake { get => OptionA; set => OptionA = value; }
        [JsonPropertyName("option_b")]
        public string OptionBSnake { get => OptionB; set => OptionB = value; }
        [JsonPropertyName("option_c")]
        public string OptionCSnake { get => OptionC; set => OptionC = value; }
        [JsonPropertyName("option_d")]
        public string OptionDSnake { get => OptionD; set => OptionD = value; }
        public string? Explanation { get; set; }
        public string? Difficulty { get; set; }
        public string? Topic { get; set; }
        public string? Tags { get; set; }
        public List<PersonalQuestionImportOption> Options { get; set; } = new();
    }

    private sealed class PersonalQuestionImportOption
    {
        public string? Key { get; set; }
        public string? Label { get; set; }
        public string? OptionLabel { get; set; }
        public string? Content { get; set; }
        public string? Text { get; set; }
        public string? OptionText { get; set; }
        public string? AnswerText { get; set; }
        public bool? IsCorrect { get; set; }
        public bool? Correct { get; set; }
    }

    private sealed class ImportOption
    {
        public string Label { get; set; } = string.Empty;
        public string Text { get; set; } = string.Empty;
        public bool IsCorrect { get; set; }
    }

    private static string ReadValue(List<string> headers, List<string> row, params string[] names)
    {
        foreach (var name in names.Select(NormalizeHeader))
        {
            var index = headers.FindIndex(x => x == name);
            if (index >= 0 && index < row.Count) return row[index].Trim();
        }
        return string.Empty;
    }

    private static string NormalizeHeader(string value)
        => new string((value ?? string.Empty).Trim().ToLowerInvariant().Where(char.IsLetterOrDigit).ToArray());

    private static List<List<string>> ParseCsvRows(string csv)
    {
        if (!string.IsNullOrEmpty(csv) && csv[0] == '\ufeff') csv = csv[1..];
        var rows = new List<List<string>>();
        var row = new List<string>();
        var field = new StringBuilder();
        var inQuotes = false;

        for (var i = 0; i < csv.Length; i++)
        {
            var ch = csv[i];
            if (ch == '"')
            {
                if (inQuotes && i + 1 < csv.Length && csv[i + 1] == '"')
                {
                    field.Append('"');
                    i++;
                }
                else
                {
                    inQuotes = !inQuotes;
                }
            }
            else if (ch == ',' && !inQuotes)
            {
                row.Add(field.ToString());
                field.Clear();
            }
            else if ((ch == '\n' || ch == '\r') && !inQuotes)
            {
                if (ch == '\r' && i + 1 < csv.Length && csv[i + 1] == '\n') i++;
                row.Add(field.ToString());
                field.Clear();
                if (row.Any(x => !string.IsNullOrWhiteSpace(x))) rows.Add(row);
                row = new List<string>();
            }
            else
            {
                field.Append(ch);
            }
        }
        row.Add(field.ToString());
        if (row.Any(x => !string.IsNullOrWhiteSpace(x))) rows.Add(row);
        return rows;
    }
}
