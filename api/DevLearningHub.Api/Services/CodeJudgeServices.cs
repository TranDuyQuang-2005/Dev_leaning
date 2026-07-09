using DevLearningHub.Api.Common;
using DevLearningHub.Api.Data;
using DevLearningHub.Api.DTOs;
using DevLearningHub.Api.Entities;
using Microsoft.EntityFrameworkCore;

namespace DevLearningHub.Api.Services;

public interface ICodeJudgeService
{
    List<SupportedLanguageResponse> Languages();
    Task<ApiResponse<CodeRunResponse>> Run(long userId, CodeRunRequest request, CancellationToken ct);
    Task<ApiResponse<PagedResult<CodingProblemSummaryResponse>>> Problems(long? userId, string? keyword, string? difficulty, int pageIndex, int pageSize, CancellationToken ct);
    Task<ApiResponse<CodingProblemDetailResponse>> Problem(long? userId, long id, bool includeHidden, CancellationToken ct, long? lessonId = null);
    Task<ApiResponse<CodeSubmissionResponse>> Submit(long userId, long problemId, CodeSubmitRequest request, CancellationToken ct);
    Task<ApiResponse<List<CodeSubmissionResponse>>> MySubmissions(long userId, long? problemId, CancellationToken ct);
    Task<ApiResponse<CodeSubmissionResponse>> SubmissionDetail(long userId, long submissionId, bool includeHiddenResults, CancellationToken ct);
    Task<ApiResponse<List<CodingProblemDetailResponse>>> AdminProblems(CancellationToken ct);
    Task<ApiResponse<CodingProblemDetailResponse>> AdminSaveProblem(long adminId, long? id, CodingProblemRequest request, CancellationToken ct);
    Task<ApiResponse<object>> AdminDeleteProblem(long id, CancellationToken ct);
}

public sealed class CodeJudgeService : ICodeJudgeService
{
    private const int MaxSourceLength = 20000;

    private static readonly IReadOnlyList<CodeLanguageDefinition> LanguageDefinitions = new List<CodeLanguageDefinition>
    {
        new("python", "Python", "3.x", "py", "print(\"Hello, World!\")", null, "python main.py", false, true, 5000, 262144, 1, "Python 3"),
        new("javascript", "JavaScript", "Node.js", "js", "console.log(\"Hello, World!\");", null, "node main.js", false, true, 5000, 262144, 2, "Node.js"),
        new("typescript", "TypeScript", "ES2020", "ts", "const message: string = \"Hello, World!\";\nconsole.log(message);", "npx tsc main.ts --target ES2020 --module commonjs --outDir out", "node out/main.js", true, true, 5000, 262144, 3, "Node.js + TypeScript compiler"),
        new("java", "Java", "JDK", "java", "public class Main {\n    public static void main(String[] args) {\n        System.out.println(\"Hello, World!\");\n    }\n}", "javac Main.java", "java Main", true, true, 5000, 262144, 4, "JDK"),
        new("c", "C", "C11", "c", "#include <stdio.h>\nint main() {\n    printf(\"Hello, World!\\n\");\n    return 0;\n}", "gcc main.c -O2 -o main", "./main", true, true, 5000, 262144, 5, "GCC"),
        new("cpp", "C++17", "C++17", "cpp", "#include <bits/stdc++.h>\nusing namespace std;\nint main() {\n    cout << \"Hello, World!\" << endl;\n    return 0;\n}", "g++ main.cpp -std=c++17 -O2 -o main", "./main", true, true, 5000, 262144, 6, "G++"),
        new("csharp", "C#", ".NET", "cs", "using System;\npublic class Program {\n    public static void Main() {\n        Console.WriteLine(\"Hello, World!\");\n    }\n}", "dotnet build Main.csproj --nologo -v quiet", "dotnet bin/Debug/net9.0/Main.dll", true, true, 5000, 262144, 7, ".NET SDK"),
        new("go", "Go", "1.x", "go", "package main\nimport \"fmt\"\nfunc main() {\n    fmt.Println(\"Hello, World!\")\n}", null, "go run main.go", false, true, 5000, 262144, 8, "Go")
    };

    private readonly DevLearningHubDbContext _db;
    private readonly ICodeExecutionProvider _executionProvider;
    private readonly INotificationService _notifications;
    private readonly IRoadmapService _roadmaps;

    public CodeJudgeService(
        DevLearningHubDbContext db,
        ICodeExecutionProvider executionProvider,
        INotificationService notifications,
        IRoadmapService roadmaps)
    {
        _db = db;
        _executionProvider = executionProvider;
        _notifications = notifications;
        _roadmaps = roadmaps;
    }

    public List<SupportedLanguageResponse> Languages()
        => LanguageDefinitions
            .Where(x => x.IsActive)
            .OrderBy(x => x.SortOrder)
            .Select(MapLanguage)
            .ToList();

    public async Task<ApiResponse<CodeRunResponse>> Run(long userId, CodeRunRequest request, CancellationToken ct)
    {
        var errors = ValidateRunRequest(request);
        if (errors.Count > 0) return ApiResponse<CodeRunResponse>.Fail("Code run request is invalid", errors);

        var lessonId = RoadmapContextLessonId(request.LessonId, request.RoadmapLessonId);
        if (lessonId.HasValue)
        {
            var access = request.CodingProblemId.HasValue
                ? await _roadmaps.CanAccessCodeLessonAsync(userId, lessonId.Value, request.CodingProblemId.Value, ct)
                : await _roadmaps.CanStartLessonAsync(userId, lessonId.Value, ct);
            if (!access.CanAccess)
                return ApiResponse<CodeRunResponse>.Fail(access.Message ?? "Bài code practice đang bị khóa. Hãy hoàn thành bài học trước đó.");
        }

        var language = GetLanguage(request.Language)!;
        var result = await _executionProvider.RunAsync(language.Code, request.SourceCode, request.Stdin ?? string.Empty, Math.Clamp(request.TimeLimitMs ?? language.TimeLimitMs, 500, 10000), ct);
        var submission = new CodeSubmission
        {
            UserId = userId,
            Language = language.Code,
            SourceCode = request.SourceCode,
            Stdin = request.Stdin,
            Status = result.Status,
            Verdict = result.Verdict,
            Output = result.Stdout,
            Error = string.IsNullOrWhiteSpace(result.Stderr) ? result.CompileOutput : result.Stderr,
            ExecutionTimeMs = result.ExecutionTimeMs,
            MemoryUsedKb = result.MemoryUsedKb,
            TotalTestCases = 0,
            PassedTestCases = 0,
            IsAccepted = result.Verdict == JudgeVerdict.Accepted,
            CreatedAt = DateTime.UtcNow
        };
        _db.CodeSubmissions.Add(submission);
        await _db.SaveChangesAsync(ct);

        result.SubmissionId = submission.Id;
        result.Language = language.Code;
        MirrorLegacyOutputFields(result);

        return ApiResponse<CodeRunResponse>.Ok(result, result.Verdict == JudgeVerdict.Accepted ? "Code executed successfully" : result.Verdict);
    }

    public async Task<ApiResponse<PagedResult<CodingProblemSummaryResponse>>> Problems(long? userId, string? keyword, string? difficulty, int pageIndex, int pageSize, CancellationToken ct)
    {
        var query = _db.CodingProblems.AsNoTracking().Where(x => !x.IsDeleted && x.Status == 1);
        if (!string.IsNullOrWhiteSpace(keyword))
        {
            var kw = keyword.Trim();
            query = query.Where(x => x.Title.Contains(kw) || x.Slug.Contains(kw) || (x.Tags != null && x.Tags.Contains(kw)));
        }
        if (!string.IsNullOrWhiteSpace(difficulty) && difficulty != "all")
        {
            var d = DifficultyValue(difficulty);
            if (d > 0) query = query.Where(x => x.Difficulty == d);
        }
        pageIndex = Math.Max(1, pageIndex);
        pageSize = Math.Clamp(pageSize, 1, 100);
        var total = await query.CountAsync(ct);
        var problems = await query.OrderBy(x => x.Id).Skip((pageIndex - 1) * pageSize).Take(pageSize).ToListAsync(ct);
        var solvedIds = userId.HasValue
            ? await _db.CodeSubmissions.AsNoTracking().Where(x => x.UserId == userId.Value && x.IsAccepted && x.ProblemId != null).Select(x => x.ProblemId!.Value).Distinct().ToListAsync(ct)
            : new List<long>();
        var items = problems.Select(x => MapSummary(x, solvedIds.Contains(x.Id))).ToList();
        return ApiResponse<PagedResult<CodingProblemSummaryResponse>>.Ok(PagedResult<CodingProblemSummaryResponse>.Create(items, pageIndex, pageSize, total));
    }

    public async Task<ApiResponse<CodingProblemDetailResponse>> Problem(long? userId, long id, bool includeHidden, CancellationToken ct, long? lessonId = null)
    {
        var problem = await _db.CodingProblems.AsNoTracking().Include(x => x.TestCases).FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, ct);
        if (problem == null || (problem.Status != 1 && !includeHidden)) return ApiResponse<CodingProblemDetailResponse>.Fail("Coding problem not found");
        if (lessonId.HasValue)
        {
            if (!userId.HasValue) return ApiResponse<CodingProblemDetailResponse>.Fail("Unauthorized");
            var access = await _roadmaps.CanAccessCodeLessonAsync(userId.Value, lessonId.Value, id, ct);
            if (!access.CanAccess)
                return ApiResponse<CodingProblemDetailResponse>.Fail(access.Message ?? "Bài code practice đang bị khóa. Hãy hoàn thành bài học trước đó.");
        }
        var solved = userId.HasValue && await _db.CodeSubmissions.AsNoTracking().AnyAsync(x => x.UserId == userId.Value && x.ProblemId == id && x.IsAccepted, ct);
        return ApiResponse<CodingProblemDetailResponse>.Ok(MapDetail(problem, solved, includeHidden));
    }

    public async Task<ApiResponse<CodeSubmissionResponse>> Submit(long userId, long problemId, CodeSubmitRequest request, CancellationToken ct)
    {
        if (string.IsNullOrWhiteSpace(request.SourceCode) || request.SourceCode.Length > MaxSourceLength)
            return ApiResponse<CodeSubmissionResponse>.Fail("Source code is empty or too long");

        var language = GetLanguage(request.Language);
        if (language == null) return ApiResponse<CodeSubmissionResponse>.Fail("Language is not supported");

        var problem = await _db.CodingProblems.Include(x => x.TestCases).FirstOrDefaultAsync(x => x.Id == problemId && !x.IsDeleted && x.Status == 1, ct);
        if (problem == null) return ApiResponse<CodeSubmissionResponse>.Fail("Coding problem not found");

        var lessonId = RoadmapContextLessonId(request.LessonId, request.RoadmapLessonId);
        if (lessonId.HasValue)
        {
            var access = await _roadmaps.CanAccessCodeLessonAsync(userId, lessonId.Value, problem.Id, ct);
            if (!access.CanAccess)
                return ApiResponse<CodeSubmissionResponse>.Fail(access.Message ?? "Bài code practice đang bị khóa. Hãy hoàn thành bài học trước đó.");
        }

        var testCases = problem.TestCases.OrderBy(x => x.DisplayOrder).ToList();
        if (testCases.Count == 0) return ApiResponse<CodeSubmissionResponse>.Fail("Coding problem has no test cases");

        var submission = new CodeSubmission
        {
            ProblemId = problem.Id,
            UserId = userId,
            Language = language.Code,
            SourceCode = request.SourceCode,
            Status = "Running",
            Verdict = "Running",
            TotalTestCases = testCases.Count,
            CreatedAt = DateTime.UtcNow
        };
        _db.CodeSubmissions.Add(submission);
        await _db.SaveChangesAsync(ct);

        var totalTime = 0;
        var passed = 0;
        var finalVerdict = JudgeVerdict.Accepted;
        var finalStatus = "Completed";
        var finalOutput = string.Empty;
        var finalError = string.Empty;

        foreach (var tc in testCases)
        {
            var result = await _executionProvider.RunAsync(language.Code, request.SourceCode, tc.Input, Math.Clamp(problem.TimeLimitMs, 500, 10000), ct);
            var actual = NormalizeOutput(result.Stdout);
            var expected = NormalizeOutput(tc.ExpectedOutput);
            var ok = result.Verdict == JudgeVerdict.Accepted && actual == expected;
            var caseVerdict = ok ? JudgeVerdict.Accepted : (result.Verdict == JudgeVerdict.Accepted ? JudgeVerdict.WrongAnswer : result.Verdict);

            if (ok) passed++;
            else if (finalVerdict == JudgeVerdict.Accepted)
            {
                finalVerdict = caseVerdict;
                finalOutput = result.Stdout;
                finalError = string.IsNullOrWhiteSpace(result.Stderr) ? result.CompileOutput : result.Stderr;
            }

            totalTime += result.ExecutionTimeMs;
            submission.TestCaseResults.Add(new CodeSubmissionTestCaseResult
            {
                TestCaseId = tc.Id,
                DisplayOrder = tc.DisplayOrder,
                Input = tc.IsHidden ? "[hidden]" : tc.Input,
                ExpectedOutput = tc.IsHidden ? "[hidden]" : tc.ExpectedOutput,
                ActualOutput = tc.IsHidden ? (ok ? "[accepted]" : "[wrong]") : result.Stdout,
                Error = string.IsNullOrWhiteSpace(result.Stderr) ? result.CompileOutput : result.Stderr,
                Status = caseVerdict,
                Passed = ok,
                ExecutionTimeMs = result.ExecutionTimeMs
            });
        }

        submission.PassedTestCases = passed;
        submission.ExecutionTimeMs = totalTime;
        submission.IsAccepted = passed == testCases.Count;
        submission.Status = finalStatus;
        submission.Verdict = submission.IsAccepted ? JudgeVerdict.Accepted : finalVerdict;
        submission.Output = finalOutput;
        submission.Error = finalError;
        problem.TotalSubmissions += 1;
        if (submission.IsAccepted) problem.AcceptedSubmissions += 1;
        await UpdateCodeStats(userId, submission.IsAccepted, ct);
        await _db.SaveChangesAsync(ct);
        if (submission.IsAccepted)
        {
            if (lessonId.HasValue)
                await _roadmaps.CompleteCodeLessonIfAcceptedAsync(userId, lessonId.Value, problem.Id, submission.Id, ct);
            else
                await _roadmaps.CompleteCodeLessonIfAcceptedAsync(userId, problem.Id, submission.Id, ct);
            await _notifications.CreateAsync(
                userId,
                "code.accepted",
                "Bài nộp được chấp nhận",
                $"Bài nộp của bạn cho {problem.Title} đã Accepted.",
                $"/learner/submissions/{submission.Id}",
                new { eventKey = $"code.accepted:{submission.Id}", submissionId = submission.Id, problemId = problem.Id },
                ct);
        }

        var saved = await _db.CodeSubmissions.AsNoTracking().Include(x => x.Problem).Include(x => x.TestCaseResults).FirstAsync(x => x.Id == submission.Id, ct);
        return ApiResponse<CodeSubmissionResponse>.Ok(MapSubmission(saved, includeHiddenResults: false), submission.IsAccepted ? JudgeVerdict.Accepted : submission.Verdict);
    }

    public async Task<ApiResponse<List<CodeSubmissionResponse>>> MySubmissions(long userId, long? problemId, CancellationToken ct)
    {
        var query = _db.CodeSubmissions.AsNoTracking().Include(x => x.Problem).Where(x => x.UserId == userId);
        if (problemId.HasValue) query = query.Where(x => x.ProblemId == problemId.Value);
        var rows = await query.OrderByDescending(x => x.CreatedAt).Take(50).ToListAsync(ct);
        return ApiResponse<List<CodeSubmissionResponse>>.Ok(rows.Select(x => MapSubmission(x, false)).ToList());
    }

    public async Task<ApiResponse<CodeSubmissionResponse>> SubmissionDetail(long userId, long submissionId, bool includeHiddenResults, CancellationToken ct)
    {
        var submission = await _db.CodeSubmissions.AsNoTracking()
            .Include(x => x.Problem)
            .Include(x => x.TestCaseResults).ThenInclude(x => x.TestCase)
            .FirstOrDefaultAsync(x => x.Id == submissionId, ct);
        if (submission == null) return ApiResponse<CodeSubmissionResponse>.Fail("Submission not found");
        if (!includeHiddenResults && submission.UserId != userId) return ApiResponse<CodeSubmissionResponse>.Fail("Submission not found");
        return ApiResponse<CodeSubmissionResponse>.Ok(MapSubmission(submission, includeHiddenResults));
    }

    public async Task<ApiResponse<List<CodingProblemDetailResponse>>> AdminProblems(CancellationToken ct)
    {
        var rows = await _db.CodingProblems.AsNoTracking().Include(x => x.TestCases).Where(x => !x.IsDeleted).OrderByDescending(x => x.Id).ToListAsync(ct);
        return ApiResponse<List<CodingProblemDetailResponse>>.Ok(rows.Select(x => MapDetail(x, false, true)).ToList());
    }

    public async Task<ApiResponse<CodingProblemDetailResponse>> AdminSaveProblem(long adminId, long? id, CodingProblemRequest request, CancellationToken ct)
    {
        var errors = ValidateProblem(request);
        if (errors.Count > 0) return ApiResponse<CodingProblemDetailResponse>.Fail("Coding problem request is invalid", errors);
        var slug = string.IsNullOrWhiteSpace(request.Slug) ? Slugify(request.Title) : Slugify(request.Slug);
        if (await _db.CodingProblems.AnyAsync(x => x.Slug == slug && x.Id != (id ?? 0) && !x.IsDeleted, ct))
            return ApiResponse<CodingProblemDetailResponse>.Fail("Slug already exists");

        CodingProblem problem;
        if (id.HasValue)
        {
            problem = await _db.CodingProblems.Include(x => x.TestCases).FirstOrDefaultAsync(x => x.Id == id.Value && !x.IsDeleted, ct)
                ?? throw new InvalidOperationException("Coding problem not found");
            problem.UpdatedAt = DateTime.UtcNow;
            _db.CodingTestCases.RemoveRange(problem.TestCases);
        }
        else
        {
            problem = new CodingProblem { CreatedByUserId = adminId, CreatedAt = DateTime.UtcNow };
            _db.CodingProblems.Add(problem);
        }

        problem.Title = request.Title.Trim();
        problem.Slug = slug;
        problem.Description = request.Description.Trim();
        problem.InputFormat = request.InputFormat;
        problem.OutputFormat = request.OutputFormat;
        problem.Constraints = request.Constraints;
        problem.ExamplesJson = request.ExamplesJson;
        problem.Tags = request.Tags;
        problem.StarterCodeJavaScript = request.StarterCodeJavaScript;
        problem.StarterCodePython = request.StarterCodePython;
        problem.StarterCodeTypeScript = request.StarterCodeTypeScript;
        problem.StarterCodeJava = request.StarterCodeJava;
        problem.StarterCodeC = request.StarterCodeC;
        problem.StarterCodeCpp = request.StarterCodeCpp;
        problem.StarterCodeCsharp = request.StarterCodeCsharp;
        problem.StarterCodeGo = request.StarterCodeGo;
        problem.Difficulty = request.Difficulty;
        problem.Status = request.Status;
        problem.TimeLimitMs = Math.Clamp(request.TimeLimitMs, 500, 10000);
        problem.MemoryLimitKb = Math.Clamp(request.MemoryLimitKb, 32768, 1048576);
        problem.TestCases = request.TestCases.OrderBy(x => x.DisplayOrder).Select((tc, i) => new CodingTestCase
        {
            Input = tc.Input ?? string.Empty,
            ExpectedOutput = tc.ExpectedOutput ?? string.Empty,
            Explanation = tc.Explanation,
            IsHidden = tc.IsHidden,
            DisplayOrder = tc.DisplayOrder > 0 ? tc.DisplayOrder : i + 1,
            CreatedAt = DateTime.UtcNow
        }).ToList();
        await _db.SaveChangesAsync(ct);
        return ApiResponse<CodingProblemDetailResponse>.Ok(MapDetail(problem, false, true), id.HasValue ? "Coding problem updated" : "Coding problem created");
    }

    public async Task<ApiResponse<object>> AdminDeleteProblem(long id, CancellationToken ct)
    {
        var problem = await _db.CodingProblems.FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, ct);
        if (problem == null) return ApiResponse<object>.Fail("Coding problem not found");
        problem.IsDeleted = true;
        problem.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { id }, "Coding problem deleted");
    }

    private static long? RoadmapContextLessonId(long? lessonId, long? roadmapLessonId)
        => lessonId ?? roadmapLessonId;

    private async Task UpdateCodeStats(long userId, bool accepted, CancellationToken ct)
    {
        var stats = await _db.UserStats.FirstOrDefaultAsync(x => x.UserId == userId, ct);
        if (stats == null)
        {
            stats = new UserStat { UserId = userId, UpdatedAt = DateTime.UtcNow };
            _db.UserStats.Add(stats);
        }
        stats.TotalCodeSubmissions += 1;
        if (accepted)
        {
            stats.AcceptedCodeSubmissions += 1;
            stats.Reputation += 10;
        }
        stats.LastActivityAt = DateTime.UtcNow;
        stats.UpdatedAt = DateTime.UtcNow;
    }

    private static List<ApiError> ValidateRunRequest(CodeRunRequest r)
    {
        var errors = new List<ApiError>();
        if (string.IsNullOrWhiteSpace(r.SourceCode)) errors.Add(new ApiError { Field = "sourceCode", Message = "Source code is required" });
        if (r.SourceCode?.Length > MaxSourceLength) errors.Add(new ApiError { Field = "sourceCode", Message = $"Source code is limited to {MaxSourceLength} characters" });
        if (GetLanguage(r.Language) == null) errors.Add(new ApiError { Field = "language", Message = "Language is not supported" });
        return errors;
    }

    private static List<ApiError> ValidateProblem(CodingProblemRequest r)
    {
        var errors = new List<ApiError>();
        if (string.IsNullOrWhiteSpace(r.Title) || r.Title.Trim().Length < 5) errors.Add(new ApiError { Field = "title", Message = "Title must be at least 5 characters" });
        if (string.IsNullOrWhiteSpace(r.Description) || r.Description.Trim().Length < 20) errors.Add(new ApiError { Field = "description", Message = "Description must be at least 20 characters" });
        if (r.TestCases == null || r.TestCases.Count < 1) errors.Add(new ApiError { Field = "testCases", Message = "At least one test case is required" });
        if (r.TestCases != null && r.TestCases.Any(x => x.ExpectedOutput == null)) errors.Add(new ApiError { Field = "expectedOutput", Message = "Expected output is required" });
        return errors;
    }

    private static CodingProblemSummaryResponse MapSummary(CodingProblem p, bool solved) => new()
    {
        Id = p.Id,
        Title = p.Title,
        Slug = p.Slug,
        Description = p.Description,
        Difficulty = p.Difficulty,
        Tags = p.Tags,
        Status = p.Status,
        TimeLimitMs = p.TimeLimitMs,
        MemoryLimitKb = p.MemoryLimitKb,
        TotalSubmissions = p.TotalSubmissions,
        AcceptedSubmissions = p.AcceptedSubmissions,
        AcceptanceRate = p.TotalSubmissions == 0 ? 0 : Math.Round(p.AcceptedSubmissions * 100m / p.TotalSubmissions, 1),
        SolvedByCurrentUser = solved
    };

    private static CodingProblemDetailResponse MapDetail(CodingProblem p, bool solved, bool includeHidden) => new()
    {
        Id = p.Id,
        Title = p.Title,
        Slug = p.Slug,
        Description = p.Description,
        Difficulty = p.Difficulty,
        Tags = p.Tags,
        Status = p.Status,
        TimeLimitMs = p.TimeLimitMs,
        MemoryLimitKb = p.MemoryLimitKb,
        TotalSubmissions = p.TotalSubmissions,
        AcceptedSubmissions = p.AcceptedSubmissions,
        AcceptanceRate = p.TotalSubmissions == 0 ? 0 : Math.Round(p.AcceptedSubmissions * 100m / p.TotalSubmissions, 1),
        SolvedByCurrentUser = solved,
        InputFormat = p.InputFormat,
        OutputFormat = p.OutputFormat,
        Constraints = p.Constraints,
        ExamplesJson = p.ExamplesJson,
        StarterCodeJavaScript = p.StarterCodeJavaScript,
        StarterCodePython = p.StarterCodePython,
        StarterCodeTypeScript = p.StarterCodeTypeScript,
        StarterCodeJava = p.StarterCodeJava,
        StarterCodeC = p.StarterCodeC,
        StarterCodeCpp = p.StarterCodeCpp,
        StarterCodeCsharp = p.StarterCodeCsharp,
        StarterCodeGo = p.StarterCodeGo,
        TestCases = p.TestCases.OrderBy(x => x.DisplayOrder).Where(x => includeHidden || !x.IsHidden).Select(x => new CodingTestCaseResponse
        {
            Id = x.Id,
            Input = x.Input,
            ExpectedOutput = x.ExpectedOutput,
            Explanation = x.Explanation,
            IsHidden = x.IsHidden,
            DisplayOrder = x.DisplayOrder
        }).ToList()
    };

    private static CodeSubmissionResponse MapSubmission(CodeSubmission s, bool includeHiddenResults) => new()
    {
        Id = s.Id,
        ProblemId = s.ProblemId,
        ProblemTitle = s.Problem?.Title ?? "Playground Run",
        Language = s.Language,
        Status = s.Status,
        Verdict = s.Verdict,
        Output = s.Output ?? string.Empty,
        Error = s.Error ?? string.Empty,
        ExecutionTimeMs = s.ExecutionTimeMs,
        MemoryUsedKb = s.MemoryUsedKb,
        PassedTestCases = s.PassedTestCases,
        TotalTestCases = s.TotalTestCases,
        IsAccepted = s.IsAccepted,
        CreatedAt = s.CreatedAt,
        TestCaseResults = s.TestCaseResults.OrderBy(x => x.DisplayOrder).Select(x => new CodeTestCaseResultResponse
        {
            Id = x.Id,
            TestCaseId = x.TestCaseId,
            DisplayOrder = x.DisplayOrder,
            Input = includeHiddenResults && x.TestCase != null ? x.TestCase.Input : x.Input,
            ExpectedOutput = includeHiddenResults && x.TestCase != null ? x.TestCase.ExpectedOutput : x.ExpectedOutput,
            ActualOutput = x.ActualOutput,
            Error = x.Error,
            Status = x.Status,
            Passed = x.Passed,
            ExecutionTimeMs = x.ExecutionTimeMs
        }).ToList()
    };

    private static SupportedLanguageResponse MapLanguage(CodeLanguageDefinition language) => new()
    {
        Value = language.Code,
        Label = language.DisplayName,
        Runtime = language.RequiredRuntime,
        Enabled = language.IsActive,
        LanguageCode = language.Code,
        DisplayName = language.DisplayName,
        Version = language.Version,
        FileExtension = language.FileExtension,
        DefaultTemplate = language.DefaultTemplate,
        CompileCommand = language.CompileCommand,
        RunCommand = language.RunCommand,
        IsCompiled = language.IsCompiled,
        IsActive = language.IsActive,
        TimeLimitMs = language.TimeLimitMs,
        MemoryLimitKb = language.MemoryLimitKb,
        SortOrder = language.SortOrder,
        RequiredRuntime = language.RequiredRuntime
    };

    private static CodeLanguageDefinition? GetLanguage(string language)
    {
        var normalized = NormalizeLanguage(language);
        return LanguageDefinitions.FirstOrDefault(x => x.Code == normalized && x.IsActive);
    }

    private static string NormalizeLanguage(string language) => (language ?? string.Empty).Trim().ToLowerInvariant() switch
    {
        "js" or "node" or "javascript" => "javascript",
        "ts" or "typescript" => "typescript",
        "py" or "python3" or "python" => "python",
        "c++" or "cplusplus" or "cpp" or "cxx" => "cpp",
        "c#" or "cs" or "csharp" => "csharp",
        "golang" or "go" => "go",
        "java" => "java",
        "c" => "c",
        _ => (language ?? string.Empty).Trim().ToLowerInvariant()
    };

    private static byte DifficultyValue(string d) => d.Trim().ToLowerInvariant() switch { "easy" or "beginner" or "1" => 1, "medium" or "intermediate" or "2" => 2, "hard" or "advanced" or "3" => 3, _ => 0 };

    private static string NormalizeOutput(string s)
    {
        var normalized = (s ?? string.Empty).Replace("\r\n", "\n").Replace('\r', '\n');
        var lines = normalized.Split('\n').Select(x => x.TrimEnd()).ToArray();
        return string.Join('\n', lines).TrimEnd('\n');
    }

    private static string Slugify(string value)
    {
        var chars = value.Trim().ToLowerInvariant().Select(ch => char.IsLetterOrDigit(ch) ? ch : '-').ToArray();
        var slug = string.Join('-', new string(chars).Split('-', StringSplitOptions.RemoveEmptyEntries));
        return string.IsNullOrWhiteSpace(slug) ? Guid.NewGuid().ToString("N") : slug;
    }

    private static void MirrorLegacyOutputFields(CodeRunResponse response)
    {
        response.Output = response.Stdout;
        response.Error = string.IsNullOrWhiteSpace(response.Stderr) ? response.CompileOutput : response.Stderr;
    }

    private sealed record CodeLanguageDefinition(
        string Code,
        string DisplayName,
        string Version,
        string FileExtension,
        string DefaultTemplate,
        string? CompileCommand,
        string RunCommand,
        bool IsCompiled,
        bool IsActive,
        int TimeLimitMs,
        int MemoryLimitKb,
        int SortOrder,
        string RequiredRuntime);

    private static class JudgeStatus
    {
        public const string Success = "Success";
        public const string Failed = "Failed";
    }

    private static class JudgeVerdict
    {
        public const string Accepted = "Accepted";
        public const string CompilationError = "CompilationError";
        public const string RuntimeError = "RuntimeError";
        public const string TimeLimitExceeded = "TimeLimitExceeded";
        public const string WrongAnswer = "WrongAnswer";
        public const string InternalError = "InternalError";
    }
}
