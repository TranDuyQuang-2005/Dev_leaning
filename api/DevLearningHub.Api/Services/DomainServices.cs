using System.Text;
using System.Text.Json;
using DevLearningHub.Api.Common;
using DevLearningHub.Api.Data;
using DevLearningHub.Api.DTOs;
using DevLearningHub.Api.Entities;
using Microsoft.EntityFrameworkCore;

namespace DevLearningHub.Api.Services;

public interface IUserModuleService
{
    Task<ApiResponse<object>> GetProfile(long userId, CancellationToken ct);
    Task<ApiResponse<object>> UpdateProfile(long userId, UserProfileRequest r, CancellationToken ct);
    Task<ApiResponse<object>> GetSettings(long userId, CancellationToken ct);
    Task<ApiResponse<object>> UpdateSettings(long userId, UserSettingsRequest r, CancellationToken ct);
    Task<ApiResponse<object>> GetStats(long userId, CancellationToken ct);
}

public sealed class UserModuleService : IUserModuleService
{
    private readonly DevLearningHubDbContext _db;
    public UserModuleService(DevLearningHubDbContext db) => _db = db;

    public async Task<ApiResponse<object>> GetProfile(long userId, CancellationToken ct)
    {
        var profile = await _db.UserProfiles.FirstOrDefaultAsync(x => x.UserId == userId, ct);
        if (profile == null)
        {
            profile = new UserProfile { UserId = userId, UpdatedAt = DateTime.UtcNow };
            _db.UserProfiles.Add(profile);
            await _db.SaveChangesAsync(ct);
        }
        return ApiResponse<object>.Ok(profile, "Lấy profile thành công");
    }

    public async Task<ApiResponse<object>> UpdateProfile(long userId, UserProfileRequest r, CancellationToken ct)
    {
        var profile = await _db.UserProfiles.FirstOrDefaultAsync(x => x.UserId == userId, ct) ?? new UserProfile { UserId = userId };
        if (_db.Entry(profile).State == EntityState.Detached) _db.UserProfiles.Add(profile);
        profile.FullName = r.FullName;
        profile.AvatarUrl = r.AvatarUrl;
        profile.Headline = r.Headline;
        profile.Bio = r.Bio;
        profile.Location = r.Location;
        profile.WebsiteUrl = r.WebsiteUrl;
        profile.GitHubUrl = r.GitHubUrl;
        profile.LinkedInUrl = r.LinkedInUrl;
        profile.Education = r.Education;
        profile.Company = r.Company;
        profile.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(profile, "Cập nhật profile thành công");
    }

    public async Task<ApiResponse<object>> GetSettings(long userId, CancellationToken ct)
    {
        var settings = await _db.UserSettings.FirstOrDefaultAsync(x => x.UserId == userId, ct);
        if (settings == null)
        {
            settings = new UserSetting { UserId = userId, UpdatedAt = DateTime.UtcNow };
            _db.UserSettings.Add(settings);
            await _db.SaveChangesAsync(ct);
        }
        return ApiResponse<object>.Ok(settings, "Lấy cài đặt thành công");
    }

    public async Task<ApiResponse<object>> UpdateSettings(long userId, UserSettingsRequest r, CancellationToken ct)
    {
        var settings = await _db.UserSettings.FirstOrDefaultAsync(x => x.UserId == userId, ct) ?? new UserSetting { UserId = userId };
        if (_db.Entry(settings).State == EntityState.Detached) _db.UserSettings.Add(settings);
        settings.Theme = r.Theme;
        settings.Language = r.Language;
        settings.CodeEditorTheme = r.CodeEditorTheme;
        settings.CodeEditorFontSize = r.CodeEditorFontSize;
        settings.EnableEmailNotification = r.EnableEmailNotification;
        settings.EnablePushNotification = r.EnablePushNotification;
        settings.HasCompletedOnboarding = r.HasCompletedOnboarding;
        settings.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(settings, "Cập nhật cài đặt thành công");
    }

    public async Task<ApiResponse<object>> GetStats(long userId, CancellationToken ct)
    {
        var stats = await _db.UserStats.FirstOrDefaultAsync(x => x.UserId == userId, ct);
        if (stats == null)
        {
            stats = new UserStat { UserId = userId, UpdatedAt = DateTime.UtcNow };
            _db.UserStats.Add(stats);
            await _db.SaveChangesAsync(ct);
        }
        return ApiResponse<object>.Ok(stats, "Lấy thống kê thành công");
    }
}

public interface ILearningModuleService
{
    Task<ApiResponse<PagedResult<CategoryResponse>>> GetCategories(string? keyword, int pageIndex, int pageSize, CancellationToken ct);
    Task<ApiResponse<CategoryResponse>> CreateCategory(CategoryRequest r, CancellationToken ct);
    Task<ApiResponse<CategoryResponse>> UpdateCategory(long id, CategoryRequest r, CancellationToken ct);
    Task<ApiResponse<object>> DeleteCategory(long id, CancellationToken ct);
    Task<ApiResponse<QuestionResponse>> CreateQuestion(long userId, QuestionRequest r, CancellationToken ct);
    Task<ApiResponse<PagedResult<QuestionResponse>>> GetQuestions(long? categoryId, int pageIndex, int pageSize, CancellationToken ct);
    Task<ApiResponse<QuestionResponse>> UpdateQuestion(long id, QuestionRequest r, CancellationToken ct);
    Task<ApiResponse<object>> DeleteQuestion(long id, CancellationToken ct);
    Task<ApiResponse<PagedResult<QuizSetResponse>>> GetQuizSets(long? categoryId, int pageIndex, int pageSize, CancellationToken ct);
    Task<ApiResponse<QuizSetResponse>> GetQuizSet(long id, CancellationToken ct);
    Task<ApiResponse<QuizSetResponse>> CreateQuizSet(long userId, QuizSetRequest r, CancellationToken ct);
    Task<ApiResponse<QuizSetResponse>> UpdateQuizSet(long id, QuizSetRequest r, CancellationToken ct);
    Task<ApiResponse<object>> DeleteQuizSet(long id, CancellationToken ct);
    Task<ApiResponse<QuizAttemptResponse>> StartAttempt(long userId, StartQuizAttemptRequest r, CancellationToken ct);
    Task<ApiResponse<QuizAttemptDetailResultResponse>> SubmitAttempt(long userId, long attemptId, SubmitQuizAttemptRequest r, CancellationToken ct);
    Task<ApiResponse<QuizAttemptDetailResultResponse>> GetAttemptResult(long userId, long attemptId, CancellationToken ct);
    Task<ApiResponse<List<QuizSubmitResultResponse>>> MyAttempts(long userId, CancellationToken ct);
}

public sealed class LearningModuleService : ILearningModuleService
{
    private readonly DevLearningHubDbContext _db;
    private readonly INotificationService _notifications;
    private readonly IRoadmapService _roadmaps;

    public LearningModuleService(DevLearningHubDbContext db, INotificationService notifications, IRoadmapService roadmaps)
    {
        _db = db;
        _notifications = notifications;
        _roadmaps = roadmaps;
    }

    public async Task<ApiResponse<PagedResult<CategoryResponse>>> GetCategories(string? keyword, int pageIndex, int pageSize, CancellationToken ct)
    {
        var query = _db.Categories.AsNoTracking().Where(x => !x.IsDeleted);
        if (!string.IsNullOrWhiteSpace(keyword)) query = query.Where(x => x.Name.Contains(keyword) || x.Slug.Contains(keyword));
        pageIndex = Math.Max(1, pageIndex);
        pageSize = Math.Clamp(pageSize, 1, 100);
        var total = await query.CountAsync(ct);
        var items = await query.OrderBy(x => x.DisplayOrder).Skip((pageIndex - 1) * pageSize).Take(pageSize)
            .Select(x => new CategoryResponse(x.Id, x.ParentId, x.Name, x.Slug, x.Description, x.IconUrl, x.DisplayOrder, x.Status))
            .ToListAsync(ct);
        return ApiResponse<PagedResult<CategoryResponse>>.Ok(PagedResult<CategoryResponse>.Create(items, pageIndex, pageSize, total));
    }

    public async Task<ApiResponse<CategoryResponse>> CreateCategory(CategoryRequest r, CancellationToken ct)
    {
        if (string.IsNullOrWhiteSpace(r.Name) || string.IsNullOrWhiteSpace(r.Slug)) return ApiResponse<CategoryResponse>.Fail("Tên và slug không được trống");
        var slug = r.Slug.Trim().ToLower();
        if (await _db.Categories.AnyAsync(x => x.Slug == slug && !x.IsDeleted, ct)) return ApiResponse<CategoryResponse>.Fail("Slug đã tồn tại");
        var c = new Category { ParentId = r.ParentId, Name = r.Name.Trim(), Slug = slug, Description = r.Description, IconUrl = r.IconUrl, DisplayOrder = r.DisplayOrder, Status = r.Status, CreatedAt = DateTime.UtcNow };
        _db.Categories.Add(c);
        await _db.SaveChangesAsync(ct);
        return ApiResponse<CategoryResponse>.Ok(new CategoryResponse(c.Id, c.ParentId, c.Name, c.Slug, c.Description, c.IconUrl, c.DisplayOrder, c.Status), "Tạo chủ đề thành công");
    }


    public async Task<ApiResponse<CategoryResponse>> UpdateCategory(long id, CategoryRequest r, CancellationToken ct)
    {
        var c = await _db.Categories.FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, ct);
        if (c == null) return ApiResponse<CategoryResponse>.Fail("Không tìm thấy category");
        if (string.IsNullOrWhiteSpace(r.Name) || string.IsNullOrWhiteSpace(r.Slug)) return ApiResponse<CategoryResponse>.Fail("Tên và slug không được trống");
        var slug = r.Slug.Trim().ToLower();
        if (await _db.Categories.AnyAsync(x => x.Id != id && x.Slug == slug && !x.IsDeleted, ct)) return ApiResponse<CategoryResponse>.Fail("Slug đã tồn tại");
        c.ParentId = r.ParentId;
        c.Name = r.Name.Trim();
        c.Slug = slug;
        c.Description = r.Description;
        c.IconUrl = r.IconUrl;
        c.DisplayOrder = r.DisplayOrder;
        c.Status = r.Status;
        c.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);
        return ApiResponse<CategoryResponse>.Ok(new CategoryResponse(c.Id, c.ParentId, c.Name, c.Slug, c.Description, c.IconUrl, c.DisplayOrder, c.Status), "Cập nhật category thành công");
    }

    public async Task<ApiResponse<object>> DeleteCategory(long id, CancellationToken ct)
    {
        var c = await _db.Categories.FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, ct);
        if (c == null) return ApiResponse<object>.Fail("Không tìm thấy category");
        var usedByQuestion = await _db.Questions.AnyAsync(x => x.CategoryId == id && !x.IsDeleted, ct);
        var usedByQuizSet = await _db.QuizSets.AnyAsync(x => x.CategoryId == id && !x.IsDeleted, ct);
        if (usedByQuestion || usedByQuizSet) return ApiResponse<object>.Fail("Category đang được sử dụng, không thể xóa. Hãy đổi category của câu hỏi/bộ đề trước.");
        c.IsDeleted = true;
        c.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { id }, "Xóa category thành công");
    }

    public async Task<ApiResponse<QuestionResponse>> CreateQuestion(long userId, QuestionRequest r, CancellationToken ct)
    {
        var errors = ValidateQuestion(r);
        if (errors.Count > 0) return ApiResponse<QuestionResponse>.Fail("Dữ liệu câu hỏi không hợp lệ", errors);
        if (!await _db.Categories.AnyAsync(x => x.Id == r.CategoryId && !x.IsDeleted, ct)) return ApiResponse<QuestionResponse>.Fail("Chủ đề không tồn tại");

        var q = new Question
        {
            CategoryId = r.CategoryId,
            CreatedByUserId = userId,
            Title = r.Title.Trim(),
            Content = r.Content.Trim(),
            Explanation = r.Explanation,
            Difficulty = r.Difficulty,
            QuestionType = r.QuestionType,
            Status = r.Status,
            Source = r.Source,
            CreatedAt = DateTime.UtcNow,
            Options = r.Options.Select(o => new QuestionOption { Content = o.Content.Trim(), IsCorrect = o.IsCorrect, Explanation = o.Explanation, DisplayOrder = o.DisplayOrder, CreatedAt = DateTime.UtcNow }).ToList()
        };
        _db.Questions.Add(q);
        await _db.SaveChangesAsync(ct);
        return ApiResponse<QuestionResponse>.Ok(MapQuestion(q), "Tạo câu hỏi thành công");
    }

    public async Task<ApiResponse<PagedResult<QuestionResponse>>> GetQuestions(long? categoryId, int pageIndex, int pageSize, CancellationToken ct)
    {
        var query = _db.Questions.AsNoTracking().Include(x => x.Options).Where(x => !x.IsDeleted);
        if (categoryId.HasValue) query = query.Where(x => x.CategoryId == categoryId.Value);
        pageIndex = Math.Max(1, pageIndex);
        pageSize = Math.Clamp(pageSize, 1, 100);
        var total = await query.CountAsync(ct);
        var questionItems = await query.OrderByDescending(x => x.CreatedAt).Skip((pageIndex - 1) * pageSize).Take(pageSize).ToListAsync(ct);
        var items = questionItems.Select(MapQuestion).ToList();
        return ApiResponse<PagedResult<QuestionResponse>>.Ok(PagedResult<QuestionResponse>.Create(items, pageIndex, pageSize, total));
    }


    public async Task<ApiResponse<QuestionResponse>> UpdateQuestion(long id, QuestionRequest r, CancellationToken ct)
    {
        var question = await _db.Questions.Include(x => x.Options).FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, ct);
        if (question == null) return ApiResponse<QuestionResponse>.Fail("Không tìm thấy câu hỏi");
        var errors = ValidateQuestion(r);
        if (errors.Count > 0) return ApiResponse<QuestionResponse>.Fail("Dữ liệu câu hỏi không hợp lệ", errors);
        var categoryExists = await _db.Categories.AnyAsync(x => x.Id == r.CategoryId && !x.IsDeleted, ct);
        if (!categoryExists) return ApiResponse<QuestionResponse>.Fail("CategoryId không tồn tại");

        question.CategoryId = r.CategoryId;
        question.Title = r.Title.Trim();
        question.Content = r.Content.Trim();
        question.Explanation = r.Explanation;
        question.Difficulty = r.Difficulty;
        question.QuestionType = r.QuestionType;
        question.Status = r.Status;
        question.Source = r.Source;
        question.Version += 1;
        question.UpdatedAt = DateTime.UtcNow;

        foreach (var option in question.Options) option.IsDeleted = true;
        var order = 1;
        foreach (var o in r.Options.OrderBy(x => x.DisplayOrder))
        {
            question.Options.Add(new QuestionOption
            {
                Content = o.Content.Trim(),
                IsCorrect = o.IsCorrect,
                Explanation = o.Explanation,
                DisplayOrder = o.DisplayOrder > 0 ? o.DisplayOrder : order,
                CreatedAt = DateTime.UtcNow
            });
            order++;
        }

        await _db.SaveChangesAsync(ct);
        return ApiResponse<QuestionResponse>.Ok(MapQuestion(question), "Cập nhật câu hỏi thành công");
    }

    public async Task<ApiResponse<object>> DeleteQuestion(long id, CancellationToken ct)
    {
        var question = await _db.Questions.Include(x => x.Options).FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, ct);
        if (question == null) return ApiResponse<object>.Fail("Không tìm thấy câu hỏi");
        question.IsDeleted = true;
        question.UpdatedAt = DateTime.UtcNow;
        foreach (var option in question.Options) option.IsDeleted = true;
        var links = await _db.QuizSetQuestions.Where(x => x.QuestionId == id).ToListAsync(ct);
        _db.QuizSetQuestions.RemoveRange(links);
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { id }, "Xóa câu hỏi thành công");
    }


    public async Task<ApiResponse<PagedResult<QuizSetResponse>>> GetQuizSets(long? categoryId, int pageIndex, int pageSize, CancellationToken ct)
    {
        var query = _db.QuizSets.AsNoTracking()
            .Where(x => !x.IsDeleted && x.Status != 0);
        if (categoryId.HasValue) query = query.Where(x => x.CategoryId == categoryId.Value);
        pageIndex = Math.Max(1, pageIndex);
        pageSize = Math.Clamp(pageSize, 1, 100);
        var total = await query.CountAsync(ct);
        var quizSets = await query.OrderByDescending(x => x.CreatedAt)
            .Skip((pageIndex - 1) * pageSize)
            .Take(pageSize)
            .Select(x => new
            {
                x.Id,
                x.CategoryId,
                x.Title,
                x.Slug,
                x.Description,
                x.Difficulty,
                x.QuizType,
                x.TimeLimitMinutes,
                x.PassingScore,
                x.AllowReview,
                x.ShuffleQuestions,
                x.ShuffleOptions,
                x.MaxAttempts,
                x.Status,
                QuestionCount = x.QuizSetQuestions.Count()
            })
            .ToListAsync(ct);
        var items = quizSets.Select(x => new QuizSetResponse
        {
            Id = x.Id,
            CategoryId = x.CategoryId,
            Title = x.Title,
            Slug = x.Slug,
            Description = x.Description,
            Difficulty = x.Difficulty,
            QuizType = x.QuizType,
            TimeLimitMinutes = x.TimeLimitMinutes,
            PassingScore = x.PassingScore,
            AllowReview = x.AllowReview,
            ShuffleQuestions = x.ShuffleQuestions,
            ShuffleOptions = x.ShuffleOptions,
            MaxAttempts = x.MaxAttempts,
            Status = x.Status,
            QuestionCount = x.QuestionCount,
            Questions = new List<QuizSetQuestionRequest>()
        }).ToList();
        return ApiResponse<PagedResult<QuizSetResponse>>.Ok(PagedResult<QuizSetResponse>.Create(items, pageIndex, pageSize, total));
    }

    public async Task<ApiResponse<QuizSetResponse>> GetQuizSet(long id, CancellationToken ct)
    {
        var qs = await _db.QuizSets.AsNoTracking()
            .Include(x => x.QuizSetQuestions)
            .FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, ct);
        if (qs == null) return ApiResponse<QuizSetResponse>.Fail("Không tìm thấy bộ đề");
        return ApiResponse<QuizSetResponse>.Ok(MapQuizSet(qs), "Lấy bộ đề thành công");
    }

    public async Task<ApiResponse<QuizSetResponse>> CreateQuizSet(long userId, QuizSetRequest r, CancellationToken ct)
    {
        var validation = await ValidateQuizSetRequest(r, null, ct);
        if (!validation.Success) return validation;

        var slug = r.Slug.Trim().ToLower();
        var qs = new QuizSet
        {
            CreatedByUserId = userId,
            CategoryId = r.CategoryId,
            Title = r.Title.Trim(),
            Slug = slug,
            Description = r.Description,
            Difficulty = r.Difficulty,
            QuizType = r.QuizType,
            TimeLimitMinutes = r.TimeLimitMinutes,
            PassingScore = r.PassingScore,
            AllowReview = r.AllowReview,
            ShuffleQuestions = r.ShuffleQuestions,
            ShuffleOptions = r.ShuffleOptions,
            MaxAttempts = r.MaxAttempts,
            Status = r.Status,
            CreatedAt = DateTime.UtcNow,
            QuizSetQuestions = NormalizeQuizSetQuestions(r.Questions)
        };
        _db.QuizSets.Add(qs);
        await _db.SaveChangesAsync(ct);
        return ApiResponse<QuizSetResponse>.Ok(MapQuizSet(qs), "Tạo bộ đề thành công");
    }

    public async Task<ApiResponse<QuizSetResponse>> UpdateQuizSet(long id, QuizSetRequest r, CancellationToken ct)
    {
        var qs = await _db.QuizSets.Include(x => x.QuizSetQuestions).FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, ct);
        if (qs == null) return ApiResponse<QuizSetResponse>.Fail("Không tìm thấy bộ đề");
        var validation = await ValidateQuizSetRequest(r, id, ct);
        if (!validation.Success) return validation;

        qs.CategoryId = r.CategoryId;
        qs.Title = r.Title.Trim();
        qs.Slug = r.Slug.Trim().ToLower();
        qs.Description = r.Description;
        qs.Difficulty = r.Difficulty;
        qs.QuizType = r.QuizType;
        qs.TimeLimitMinutes = r.TimeLimitMinutes;
        qs.PassingScore = r.PassingScore;
        qs.AllowReview = r.AllowReview;
        qs.ShuffleQuestions = r.ShuffleQuestions;
        qs.ShuffleOptions = r.ShuffleOptions;
        qs.MaxAttempts = r.MaxAttempts;
        qs.Status = r.Status;
        qs.UpdatedAt = DateTime.UtcNow;

        _db.QuizSetQuestions.RemoveRange(qs.QuizSetQuestions);
        qs.QuizSetQuestions = NormalizeQuizSetQuestions(r.Questions);
        await _db.SaveChangesAsync(ct);
        return ApiResponse<QuizSetResponse>.Ok(MapQuizSet(qs), "Cập nhật bộ đề thành công");
    }

    public async Task<ApiResponse<object>> DeleteQuizSet(long id, CancellationToken ct)
    {
        var qs = await _db.QuizSets.FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, ct);
        if (qs == null) return ApiResponse<object>.Fail("Không tìm thấy bộ đề");
        qs.IsDeleted = true;
        qs.Status = 0;
        qs.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { id }, "Xóa bộ đề thành công");
    }

    public async Task<ApiResponse<QuizAttemptResponse>> StartAttempt(long userId, StartQuizAttemptRequest r, CancellationToken ct)
    {
        var quiz = await _db.QuizSets
            .AsSplitQuery()
            .Include(x => x.QuizSetQuestions)
                .ThenInclude(x => x.Question)
                    .ThenInclude(x => x.Options)
            .FirstOrDefaultAsync(x => x.Id == r.QuizSetId && !x.IsDeleted && x.Status != 0, ct);
        if (quiz == null) return ApiResponse<QuizAttemptResponse>.Fail("Không tìm thấy bộ đề hoặc bộ đề chưa được kích hoạt");
        if (!quiz.QuizSetQuestions.Any()) return ApiResponse<QuizAttemptResponse>.Fail("Bộ đề chưa có câu hỏi");

        var lessonId = RoadmapContextLessonId(r.LessonId, r.RoadmapLessonId);
        if (lessonId.HasValue)
        {
            var access = await _roadmaps.CanAccessQuizLessonAsync(userId, lessonId.Value, quiz.Id, ct);
            if (!access.CanAccess)
                return ApiResponse<QuizAttemptResponse>.Fail(access.Message ?? "Bài quiz đang bị khóa. Hãy hoàn thành bài học trước đó.");
        }

        if (quiz.MaxAttempts.HasValue)
        {
            var submittedCount = await _db.QuizAttempts.CountAsync(x => x.UserId == userId && x.QuizSetId == quiz.Id && x.Status == 2, ct);
            if (submittedCount >= quiz.MaxAttempts.Value)
            {
                return ApiResponse<QuizAttemptResponse>.Fail($"Bạn đã hết số lượt làm bài cho bộ đề này. Tối đa {quiz.MaxAttempts.Value} lượt.");
            }
        }

        var attempt = new QuizAttempt
        {
            UserId = userId,
            QuizSetId = quiz.Id,
            StartedAt = DateTime.UtcNow,
            CreatedAt = DateTime.UtcNow,
            TotalQuestions = quiz.QuizSetQuestions.Count,
            Status = 1
        };
        _db.QuizAttempts.Add(attempt);
        await _db.SaveChangesAsync(ct);

        var questionItems = quiz.QuizSetQuestions.AsEnumerable();
        questionItems = quiz.ShuffleQuestions
            ? questionItems.OrderBy(_ => Guid.NewGuid())
            : questionItems.OrderBy(x => x.DisplayOrder);

        return ApiResponse<QuizAttemptResponse>.Ok(new QuizAttemptResponse
        {
            AttemptId = attempt.Id,
            QuizSetId = quiz.Id,
            QuizTitle = quiz.Title,
            StartedAt = attempt.StartedAt,
            TimeLimitMinutes = quiz.TimeLimitMinutes,
            PassingScore = quiz.PassingScore,
            AllowReview = quiz.AllowReview,
            MaxAttempts = quiz.MaxAttempts,
            Questions = questionItems.Select(x =>
            {
                var optionItems = x.Question.Options.Where(o => !o.IsDeleted).AsEnumerable();
                optionItems = quiz.ShuffleOptions ? optionItems.OrderBy(_ => Guid.NewGuid()) : optionItems.OrderBy(o => o.DisplayOrder);
                return new QuizQuestionForTakeResponse
                {
                    Id = x.Question.Id,
                    Content = x.Question.Content,
                    QuestionType = x.Question.QuestionType,
                    Options = optionItems.Select(o => new QuizOptionForTakeResponse { Id = o.Id, Content = o.Content }).ToList()
                };
            }).ToList()
        }, "Bắt đầu làm quiz thành công");
    }

    public async Task<ApiResponse<QuizAttemptDetailResultResponse>> SubmitAttempt(long userId, long attemptId, SubmitQuizAttemptRequest r, CancellationToken ct)
    {
        var attempt = await _db.QuizAttempts.AsSplitQuery().Include(x => x.QuizSet).ThenInclude(x => x.QuizSetQuestions).ThenInclude(x => x.Question).ThenInclude(x => x.Options)
            .FirstOrDefaultAsync(x => x.Id == attemptId && x.UserId == userId, ct);
        if (attempt == null) return ApiResponse<QuizAttemptDetailResultResponse>.Fail("Không tìm thấy lần làm bài");
        if (attempt.Status == 2) return ApiResponse<QuizAttemptDetailResultResponse>.Fail("Bài đã được nộp");

        var lessonId = RoadmapContextLessonId(r.LessonId, r.RoadmapLessonId);
        if (lessonId.HasValue)
        {
            var access = await _roadmaps.CanAccessQuizLessonAsync(userId, lessonId.Value, attempt.QuizSetId, ct);
            if (!access.CanAccess)
                return ApiResponse<QuizAttemptDetailResultResponse>.Fail(access.Message ?? "Bài quiz đang bị khóa. Hãy hoàn thành bài học trước đó.");
        }

        var answerMap = r.Answers.ToDictionary(x => x.QuestionId, x => x.SelectedOptionIds.Distinct().OrderBy(id => id).ToList());
        int correct = 0, wrong = 0, skipped = 0;
        decimal rawScore = 0, maxScore = 0;

        foreach (var item in attempt.QuizSet.QuizSetQuestions)
        {
            maxScore += item.Score;
            var question = item.Question;
            var correctIds = question.Options.Where(o => o.IsCorrect && !o.IsDeleted).Select(o => o.Id).OrderBy(id => id).ToList();
            if (!answerMap.TryGetValue(question.Id, out var selected) || selected.Count == 0)
            {
                skipped++;
                continue;
            }
            var isCorrect = correctIds.SequenceEqual(selected);
            if (isCorrect) { correct++; rawScore += item.Score; } else wrong++;

            _db.QuizAttemptAnswers.Add(new QuizAttemptAnswer
            {
                QuizAttemptId = attempt.Id,
                QuestionId = question.Id,
                IsCorrect = isCorrect,
                Score = isCorrect ? item.Score : 0,
                AnsweredAt = DateTime.UtcNow,
                SelectedOptions = selected.Select(optionId => new QuizAttemptAnswerOption { QuestionOptionId = optionId }).ToList()
            });
        }

        attempt.CorrectAnswers = correct;
        attempt.WrongAnswers = wrong;
        attempt.SkippedAnswers = skipped;
        attempt.Score = maxScore > 0 ? Math.Round(rawScore / maxScore * 10, 2) : 0;
        attempt.IsPassed = attempt.Score >= attempt.QuizSet.PassingScore;
        attempt.DurationSeconds = (int)(DateTime.UtcNow - attempt.StartedAt).TotalSeconds;
        attempt.SubmittedAt = DateTime.UtcNow;
        attempt.Status = 2;

        var stat = await _db.UserStats.FirstOrDefaultAsync(x => x.UserId == userId, ct);
        if (stat != null)
        {
            stat.TotalQuizAttempts += 1;
            stat.TotalCorrectAnswers += correct;
            stat.AverageQuizScore = await _db.QuizAttempts.Where(x => x.UserId == userId && x.Status == 2).AverageAsync(x => (decimal?)x.Score, ct) ?? attempt.Score;
            stat.LastActivityAt = DateTime.UtcNow;
            stat.UpdatedAt = DateTime.UtcNow;
        }

        await _db.SaveChangesAsync(ct);
        if (attempt.IsPassed)
        {
            if (lessonId.HasValue)
                await _roadmaps.CompleteQuizLessonIfPassedAsync(userId, lessonId.Value, attempt.QuizSetId, attempt.Id, attempt.Score, ct);
            else
                await _roadmaps.CompleteQuizLessonIfPassedAsync(userId, attempt.QuizSetId, attempt.Id, attempt.Score, ct);
            await _notifications.CreateAsync(
                userId,
                "quiz.passed",
                "Hoàn thành bài quiz",
                $"Bạn đã vượt qua bài quiz {attempt.QuizSet.Title} với điểm {attempt.Score}.",
                "/learner/quiz-history",
                new { eventKey = $"quiz.passed:{attempt.Id}", attemptId = attempt.Id, quizSetId = attempt.QuizSetId, score = attempt.Score },
                ct);
        }

        var detail = await BuildAttemptResult(userId, attempt.Id, ct);
        if (detail == null) return ApiResponse<QuizAttemptDetailResultResponse>.Fail("Không tải được kết quả chi tiết sau khi nộp bài");
        return ApiResponse<QuizAttemptDetailResultResponse>.Ok(detail, "Nộp bài thành công");
    }

    public async Task<ApiResponse<QuizAttemptDetailResultResponse>> GetAttemptResult(long userId, long attemptId, CancellationToken ct)
    {
        var detail = await BuildAttemptResult(userId, attemptId, ct);
        if (detail == null) return ApiResponse<QuizAttemptDetailResultResponse>.Fail("Không tìm thấy kết quả bài làm");
        return ApiResponse<QuizAttemptDetailResultResponse>.Ok(detail, "Lấy kết quả chi tiết thành công");
    }

    public async Task<ApiResponse<List<QuizSubmitResultResponse>>> MyAttempts(long userId, CancellationToken ct)
    {
        var items = await _db.QuizAttempts.AsNoTracking()
            .Where(x => x.UserId == userId)
            .OrderByDescending(x => x.CreatedAt)
            .Select(x => new QuizSubmitResultResponse
            {
                AttemptId = x.Id,
                QuizSetId = x.QuizSetId,
                QuizTitle = x.QuizSet.Title,
                TotalQuestions = x.TotalQuestions,
                CorrectAnswers = x.CorrectAnswers,
                WrongAnswers = x.WrongAnswers,
                SkippedAnswers = x.SkippedAnswers,
                Score = x.Score,
                IsPassed = x.IsPassed,
                DurationSeconds = x.DurationSeconds ?? 0,
                StartedAt = x.StartedAt,
                SubmittedAt = x.SubmittedAt
            })
            .ToListAsync(ct);
        return ApiResponse<List<QuizSubmitResultResponse>>.Ok(items, "Lấy lịch sử làm quiz thành công");
    }

    private static long? RoadmapContextLessonId(long? lessonId, long? roadmapLessonId)
        => lessonId ?? roadmapLessonId;

    private async Task<QuizAttemptDetailResultResponse?> BuildAttemptResult(long userId, long attemptId, CancellationToken ct)
    {
        var attempt = await _db.QuizAttempts
            .AsNoTracking()
            .AsSplitQuery()
            .Include(x => x.QuizSet)
                .ThenInclude(x => x.QuizSetQuestions)
                    .ThenInclude(x => x.Question)
                        .ThenInclude(x => x.Options)
            .Include(x => x.Answers)
                .ThenInclude(x => x.SelectedOptions)
            .FirstOrDefaultAsync(x => x.Id == attemptId && x.UserId == userId, ct);

        if (attempt == null) return null;

        var answerMap = attempt.Answers.ToDictionary(x => x.QuestionId, x => x);
        var questions = new List<QuizQuestionResultResponse>();

        foreach (var item in attempt.QuizSet.QuizSetQuestions.OrderBy(x => x.DisplayOrder))
        {
            var question = item.Question;
            answerMap.TryGetValue(question.Id, out var answer);

            var selectedIds = answer?.SelectedOptions
                .Select(x => x.QuestionOptionId)
                .Distinct()
                .OrderBy(x => x)
                .ToList() ?? new List<long>();

            var correctIds = question.Options
                .Where(x => x.IsCorrect && !x.IsDeleted)
                .Select(x => x.Id)
                .OrderBy(x => x)
                .ToList();

            questions.Add(new QuizQuestionResultResponse
            {
                Id = question.Id,
                Content = question.Content,
                Explanation = question.Explanation,
                IsCorrect = answer?.IsCorrect ?? false,
                Score = answer?.Score ?? 0,
                SelectedOptionIds = selectedIds,
                CorrectOptionIds = correctIds,
                Options = question.Options
                    .Where(x => !x.IsDeleted)
                    .OrderBy(x => x.DisplayOrder)
                    .Select(x => new QuizOptionResultResponse
                    {
                        Id = x.Id,
                        Content = x.Content,
                        IsCorrect = x.IsCorrect,
                        IsSelected = selectedIds.Contains(x.Id),
                        Explanation = x.Explanation,
                        DisplayOrder = x.DisplayOrder
                    })
                    .ToList()
            });
        }

        return new QuizAttemptDetailResultResponse
        {
            AttemptId = attempt.Id,
            QuizSetId = attempt.QuizSetId,
            QuizTitle = attempt.QuizSet.Title,
            TotalQuestions = attempt.TotalQuestions,
            CorrectAnswers = attempt.CorrectAnswers,
            WrongAnswers = attempt.WrongAnswers,
            SkippedAnswers = attempt.SkippedAnswers,
            Score = attempt.Score,
            IsPassed = attempt.IsPassed,
            DurationSeconds = attempt.DurationSeconds ?? 0,
            StartedAt = attempt.StartedAt,
            SubmittedAt = attempt.SubmittedAt,
            Questions = questions
        };
    }

    private async Task<ApiResponse<QuizSetResponse>> ValidateQuizSetRequest(QuizSetRequest r, long? currentId, CancellationToken ct)
    {
        if (string.IsNullOrWhiteSpace(r.Title) || string.IsNullOrWhiteSpace(r.Slug)) return ApiResponse<QuizSetResponse>.Fail("Tên bộ đề và slug không được trống");
        if (r.Questions.Count == 0) return ApiResponse<QuizSetResponse>.Fail("Bộ đề phải có ít nhất 1 câu hỏi");
        if (r.PassingScore < 0 || r.PassingScore > 10) return ApiResponse<QuizSetResponse>.Fail("Passing score phải nằm trong khoảng 0 - 10");
        if (r.TimeLimitMinutes.HasValue && r.TimeLimitMinutes.Value <= 0) return ApiResponse<QuizSetResponse>.Fail("Thời gian làm bài phải lớn hơn 0 phút");
        if (r.MaxAttempts.HasValue && r.MaxAttempts.Value <= 0) return ApiResponse<QuizSetResponse>.Fail("MaxAttempts phải lớn hơn 0");

        var slug = r.Slug.Trim().ToLower();
        if (await _db.QuizSets.AnyAsync(x => x.Slug == slug && !x.IsDeleted && (!currentId.HasValue || x.Id != currentId.Value), ct)) return ApiResponse<QuizSetResponse>.Fail("Slug đã tồn tại");
        if (r.CategoryId.HasValue && !await _db.Categories.AnyAsync(x => x.Id == r.CategoryId.Value && !x.IsDeleted, ct)) return ApiResponse<QuizSetResponse>.Fail("CategoryId không tồn tại");

        var questionIds = r.Questions.Select(x => x.QuestionId).Distinct().ToList();
        var existed = await _db.Questions.Where(x => questionIds.Contains(x.Id) && !x.IsDeleted).Select(x => x.Id).ToListAsync(ct);
        var missing = questionIds.Except(existed).ToList();
        if (missing.Count > 0) return ApiResponse<QuizSetResponse>.Fail($"Có QuestionId không tồn tại hoặc đã xóa: {string.Join(", ", missing)}");
        return ApiResponse<QuizSetResponse>.Ok(new QuizSetResponse());
    }

    private static List<QuizSetQuestion> NormalizeQuizSetQuestions(List<QuizSetQuestionRequest> questions)
    {
        return questions
            .GroupBy(x => x.QuestionId)
            .Select((g, index) =>
            {
                var first = g.First();
                return new QuizSetQuestion
                {
                    QuestionId = first.QuestionId,
                    DisplayOrder = first.DisplayOrder > 0 ? first.DisplayOrder : index + 1,
                    Score = first.Score > 0 ? first.Score : 1
                };
            })
            .OrderBy(x => x.DisplayOrder)
            .ToList();
    }

    private static QuizSetResponse MapQuizSet(QuizSet x) => new()
    {
        Id = x.Id,
        CategoryId = x.CategoryId,
        Title = x.Title,
        Slug = x.Slug,
        Description = x.Description,
        Difficulty = x.Difficulty,
        QuizType = x.QuizType,
        TimeLimitMinutes = x.TimeLimitMinutes,
        PassingScore = x.PassingScore,
        AllowReview = x.AllowReview,
        ShuffleQuestions = x.ShuffleQuestions,
        ShuffleOptions = x.ShuffleOptions,
        MaxAttempts = x.MaxAttempts,
        Status = x.Status,
        QuestionCount = x.QuizSetQuestions?.Count ?? 0,
        Questions = x.QuizSetQuestions?.OrderBy(q => q.DisplayOrder).Select(q => new QuizSetQuestionRequest { QuestionId = q.QuestionId, DisplayOrder = q.DisplayOrder, Score = q.Score }).ToList() ?? new()
    };

    private static List<ApiError> ValidateQuestion(QuestionRequest r)
    {
        var errors = new List<ApiError>();
        if (r.CategoryId <= 0) errors.Add(new() { Field = "categoryId", Message = "CategoryId không hợp lệ" });
        if (string.IsNullOrWhiteSpace(r.Title)) errors.Add(new() { Field = "title", Message = "Title không được trống" });
        if (string.IsNullOrWhiteSpace(r.Content)) errors.Add(new() { Field = "content", Message = "Content không được trống" });
        if (r.Options.Count < 2) errors.Add(new() { Field = "options", Message = "Cần ít nhất 2 đáp án" });
        if (!r.Options.Any(x => x.IsCorrect)) errors.Add(new() { Field = "options", Message = "Cần ít nhất 1 đáp án đúng" });
        return errors;
    }

    private static QuestionResponse MapQuestion(Question q) => new()
    {
        Id = q.Id,
        CategoryId = q.CategoryId,
        CreatedByUserId = q.CreatedByUserId,
        Title = q.Title,
        Content = q.Content,
        Explanation = q.Explanation,
        Difficulty = q.Difficulty,
        QuestionType = q.QuestionType,
        Status = q.Status,
        Options = q.Options.Where(o => !o.IsDeleted).OrderBy(o => o.DisplayOrder).Select(o => new QuestionOptionResponse { Id = o.Id, Content = o.Content, IsCorrect = o.IsCorrect, Explanation = o.Explanation, DisplayOrder = o.DisplayOrder }).ToList()
    };

    private static QuizSubmitResultResponse MapSubmit(QuizAttempt x) => new()
    {
        AttemptId = x.Id,
        QuizSetId = x.QuizSetId,
        QuizTitle = x.QuizSet?.Title ?? $"Quiz set #{x.QuizSetId}",
        TotalQuestions = x.TotalQuestions,
        CorrectAnswers = x.CorrectAnswers,
        WrongAnswers = x.WrongAnswers,
        SkippedAnswers = x.SkippedAnswers,
        Score = x.Score,
        IsPassed = x.IsPassed,
        DurationSeconds = x.DurationSeconds ?? 0,
        StartedAt = x.StartedAt,
        SubmittedAt = x.SubmittedAt
    };
}

public interface IFileModuleService
{
    Task<ApiResponse<FileUploadResponse>> Upload(long userId, IFormFile file, string fileType, CancellationToken ct);
    Task<ApiResponse<ImportQuestionResult>> ImportQuestionsJson(long userId, IFormFile file, CancellationToken ct);
    Task<ApiResponse<ImportQuestionResult>> ImportQuestionsCsv(long userId, IFormFile file, CancellationToken ct);
}

public sealed class FileModuleService : IFileModuleService
{
    private readonly DevLearningHubDbContext _db;
    private readonly IWebHostEnvironment _env;
    private readonly ILearningModuleService _learning;

    public FileModuleService(DevLearningHubDbContext db, IWebHostEnvironment env, ILearningModuleService learning)
    {
        _db = db; _env = env; _learning = learning;
    }

    public async Task<ApiResponse<FileUploadResponse>> Upload(long userId, IFormFile file, string fileType, CancellationToken ct)
    {
        if (file.Length == 0) return ApiResponse<FileUploadResponse>.Fail("File rỗng");

        var root = Path.Combine(_env.ContentRootPath, "uploads", fileType);
        Directory.CreateDirectory(root);
        var ext = Path.GetExtension(file.FileName);
        var stored = $"{Guid.NewGuid():N}{ext}";
        var path = Path.Combine(root, stored);
        await using (var fs = File.Create(path))
        {
            await file.CopyToAsync(fs, ct);
        }

        var entity = new AppFile
        {
            UploadedByUserId = userId,
            OriginalFileName = file.FileName,
            StoredFileName = stored,
            FileUrl = $"/uploads/{fileType}/{stored}",
            MimeType = file.ContentType,
            FileSizeBytes = file.Length,
            FileType = fileType,
            StorageProvider = "Local",
            CreatedAt = DateTime.UtcNow
        };
        _db.Files.Add(entity);
        await _db.SaveChangesAsync(ct);

        return ApiResponse<FileUploadResponse>.Ok(new FileUploadResponse { FileId = entity.Id, FileUrl = entity.FileUrl, OriginalFileName = entity.OriginalFileName }, "Upload file thành công");
    }

    public async Task<ApiResponse<ImportQuestionResult>> ImportQuestionsJson(long userId, IFormFile file, CancellationToken ct)
    {
        var upload = await Upload(userId, file, "question-imports", ct);
        if (!upload.Success || upload.Data == null) return ApiResponse<ImportQuestionResult>.Fail("Upload file import thất bại");

        var storedPath = Path.Combine(_env.ContentRootPath, upload.Data.FileUrl.TrimStart('/').Replace('/', Path.DirectorySeparatorChar));
        var json = await File.ReadAllTextAsync(storedPath, ct);
        var questions = JsonSerializer.Deserialize<List<QuestionRequest>>(json, new JsonSerializerOptions { PropertyNameCaseInsensitive = true }) ?? new();

        return await ImportQuestionRequests(userId, upload.Data.FileId, questions, "Import câu hỏi JSON hoàn tất", ct);
    }

    public async Task<ApiResponse<ImportQuestionResult>> ImportQuestionsCsv(long userId, IFormFile file, CancellationToken ct)
    {
        if (file.Length == 0) return ApiResponse<ImportQuestionResult>.Fail("File import rỗng");

        var ext = Path.GetExtension(file.FileName).ToLowerInvariant();
        if (ext != ".csv")
        {
            return ApiResponse<ImportQuestionResult>.Fail("Hiện tại hệ thống nhận file CSV mở được bằng Excel. Hãy tải template CSV, điền trong Excel rồi lưu lại dạng .csv.");
        }

        var upload = await Upload(userId, file, "question-imports", ct);
        if (!upload.Success || upload.Data == null) return ApiResponse<ImportQuestionResult>.Fail("Upload file import thất bại");

        var storedPath = Path.Combine(_env.ContentRootPath, upload.Data.FileUrl.TrimStart('/').Replace('/', Path.DirectorySeparatorChar));
        var csv = await File.ReadAllTextAsync(storedPath, Encoding.UTF8, ct);
        var parsed = await BuildQuestionsFromCsv(csv, ct);

        if (parsed.Errors.Count > 0)
        {
            var failedOnly = new ImportQuestionResult
            {
                BatchId = 0,
                TotalRows = parsed.TotalRows,
                SuccessRows = 0,
                FailedRows = parsed.Errors.Count,
                Errors = parsed.Errors
            };
            return new ApiResponse<ImportQuestionResult>
            {
                Success = false,
                Message = "File CSV chưa hợp lệ. Hãy sửa các dòng lỗi rồi import lại.",
                Data = failedOnly
            };
        }

        return await ImportQuestionRequests(userId, upload.Data.FileId, parsed.Questions, "Import câu hỏi CSV/Excel hoàn tất", ct);
    }

    private async Task<ApiResponse<ImportQuestionResult>> ImportQuestionRequests(long userId, long fileId, List<QuestionRequest> questions, string successMessage, CancellationToken ct)
    {
        var batch = new QuestionImportBatch
        {
            FileId = fileId,
            ImportedByUserId = userId,
            TotalRows = questions.Count,
            Status = "Processing",
            CreatedAt = DateTime.UtcNow
        };
        _db.QuestionImportBatches.Add(batch);
        await _db.SaveChangesAsync(ct);

        var result = new ImportQuestionResult { BatchId = batch.Id, TotalRows = questions.Count };
        for (int i = 0; i < questions.Count; i++)
        {
            var res = await _learning.CreateQuestion(userId, questions[i], ct);
            if (res.Success) result.SuccessRows++;
            else
            {
                result.FailedRows++;
                result.Errors.Add($"Dòng {i + 2}: {res.Message}");
            }
        }

        batch.SuccessRows = result.SuccessRows;
        batch.FailedRows = result.FailedRows;
        batch.Status = result.FailedRows == 0 ? "Completed" : "CompletedWithErrors";
        batch.CompletedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);

        return ApiResponse<ImportQuestionResult>.Ok(result, successMessage);
    }

    private sealed class CsvQuestionBuildResult
    {
        public int TotalRows { get; set; }
        public List<QuestionRequest> Questions { get; set; } = new();
        public List<string> Errors { get; set; } = new();
    }

    private async Task<CsvQuestionBuildResult> BuildQuestionsFromCsv(string csv, CancellationToken ct)
    {
        var rows = ParseCsvRows(csv);
        var result = new CsvQuestionBuildResult { TotalRows = Math.Max(rows.Count - 1, 0) };
        if (rows.Count < 2)
        {
            result.Errors.Add("File CSV phải có dòng tiêu đề và ít nhất 1 dòng câu hỏi.");
            return result;
        }

        var headers = rows[0].Select(NormalizeHeader).ToList();
        var categories = await _db.Categories.Where(x => !x.IsDeleted).ToListAsync(ct);

        for (int rowIndex = 1; rowIndex < rows.Count; rowIndex++)
        {
            var row = rows[rowIndex];
            if (row.All(string.IsNullOrWhiteSpace)) continue;

            try
            {
                var category = ResolveCategory(headers, row, categories);
                if (category == null)
                {
                    result.Errors.Add($"Dòng {rowIndex + 1}: Không tìm thấy category. Hãy nhập CategoryId hoặc CategorySlug/CategoryName đúng.");
                    continue;
                }

                var title = ReadValue(headers, row, "title", "questiontitle", "tieude");
                var content = ReadValue(headers, row, "content", "question", "questioncontent", "noidung");
                var explanation = ReadValue(headers, row, "explanation", "questionexplanation", "solution", "loigiaithich");
                var source = ReadValue(headers, row, "source", "nguon");
                var difficulty = ParseByte(ReadValue(headers, row, "difficulty", "level", "dokho"), 1);
                var correctRaw = ReadValue(headers, row, "correctoption", "correctanswer", "correct", "dapandung");

                var options = new List<QuestionOptionRequest>();
                AddOption(headers, row, options, "a", 1);
                AddOption(headers, row, options, "b", 2);
                AddOption(headers, row, options, "c", 3);
                AddOption(headers, row, options, "d", 4);

                if (string.IsNullOrWhiteSpace(title)) title = content.Length > 80 ? content[..80] : content;
                if (string.IsNullOrWhiteSpace(content))
                {
                    result.Errors.Add($"Dòng {rowIndex + 1}: Nội dung câu hỏi không được trống.");
                    continue;
                }
                if (options.Count < 2)
                {
                    result.Errors.Add($"Dòng {rowIndex + 1}: Cần ít nhất 2 đáp án.");
                    continue;
                }

                MarkCorrectOption(options, correctRaw);
                if (!options.Any(x => x.IsCorrect))
                {
                    result.Errors.Add($"Dòng {rowIndex + 1}: Chưa xác định đáp án đúng. CorrectOption nên là A/B/C/D hoặc 1/2/3/4.");
                    continue;
                }

                result.Questions.Add(new QuestionRequest
                {
                    CategoryId = category.Id,
                    Title = title,
                    Content = content,
                    Explanation = explanation,
                    Difficulty = difficulty,
                    QuestionType = 1,
                    Status = 2,
                    Source = string.IsNullOrWhiteSpace(source) ? "Excel/CSV Import" : source,
                    Options = options
                });
            }
            catch (Exception ex)
            {
                result.Errors.Add($"Dòng {rowIndex + 1}: {ex.Message}");
            }
        }

        return result;
    }

    private static Category? ResolveCategory(List<string> headers, List<string> row, List<Category> categories)
    {
        var idRaw = ReadValue(headers, row, "categoryid", "category_id", "madanhmuc");
        if (long.TryParse(idRaw, out var categoryId))
            return categories.FirstOrDefault(x => x.Id == categoryId);

        var slug = ReadValue(headers, row, "categoryslug", "slug", "duongdan").Trim().ToLowerInvariant();
        if (!string.IsNullOrWhiteSpace(slug))
            return categories.FirstOrDefault(x => x.Slug.ToLower() == slug);

        var name = ReadValue(headers, row, "categoryname", "category", "danhmuc").Trim().ToLowerInvariant();
        if (!string.IsNullOrWhiteSpace(name))
            return categories.FirstOrDefault(x => x.Name.ToLower() == name);

        return null;
    }

    private static void AddOption(List<string> headers, List<string> row, List<QuestionOptionRequest> options, string letter, int order)
    {
        var upper = letter.ToUpperInvariant();
        var content = ReadValue(headers, row, $"option{letter}", $"option{upper}", $"answer{letter}", $"answer{upper}", $"option{order}", $"answer{order}", $"dapan{letter}", $"dapan{order}");
        if (string.IsNullOrWhiteSpace(content)) return;

        var explanation = ReadValue(headers, row, $"option{letter}explanation", $"option{upper}explanation", $"answer{letter}explanation", $"answer{upper}explanation", $"giaithich{letter}", $"giaithich{order}");
        options.Add(new QuestionOptionRequest
        {
            Content = content.Trim(),
            Explanation = explanation,
            DisplayOrder = order
        });
    }

    private static void MarkCorrectOption(List<QuestionOptionRequest> options, string raw)
    {
        var correct = (raw ?? string.Empty).Trim();
        if (string.IsNullOrWhiteSpace(correct)) return;

        var normalized = correct.ToLowerInvariant();
        var order = normalized switch
        {
            "a" => 1,
            "b" => 2,
            "c" => 3,
            "d" => 4,
            _ => int.TryParse(normalized, out var n) ? n : 0
        };

        if (order > 0)
        {
            foreach (var option in options) option.IsCorrect = option.DisplayOrder == order;
            return;
        }

        foreach (var option in options)
            option.IsCorrect = string.Equals(option.Content.Trim(), correct, StringComparison.OrdinalIgnoreCase);
    }

    private static byte ParseByte(string raw, byte fallback)
        => byte.TryParse(raw, out var value) ? value : fallback;

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

        for (int i = 0; i < csv.Length; i++)
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
