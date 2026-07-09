using System.Diagnostics;
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
    Task<ApiResponse<CodingProblemDetailResponse>> Problem(long? userId, long id, bool includeHidden, CancellationToken ct);
    Task<ApiResponse<CodeSubmissionResponse>> Submit(long userId, long problemId, CodeSubmitRequest request, CancellationToken ct);
    Task<ApiResponse<List<CodeSubmissionResponse>>> MySubmissions(long userId, long? problemId, CancellationToken ct);
    Task<ApiResponse<CodeSubmissionResponse>> SubmissionDetail(long userId, long submissionId, bool includeHiddenResults, CancellationToken ct);
    Task<ApiResponse<List<CodingProblemDetailResponse>>> AdminProblems(CancellationToken ct);
    Task<ApiResponse<CodingProblemDetailResponse>> AdminSaveProblem(long adminId, long? id, CodingProblemRequest request, CancellationToken ct);
    Task<ApiResponse<object>> AdminDeleteProblem(long id, CancellationToken ct);
}

public sealed class CodeJudgeService : ICodeJudgeService
{
    private readonly DevLearningHubDbContext _db;
    private readonly IWebHostEnvironment _env;
    private readonly ILogger<CodeJudgeService> _logger;

    public CodeJudgeService(DevLearningHubDbContext db, IWebHostEnvironment env, ILogger<CodeJudgeService> logger)
    {
        _db = db;
        _env = env;
        _logger = logger;
    }

    public List<SupportedLanguageResponse> Languages() => new()
    {
        new SupportedLanguageResponse { Value = "javascript", Label = "JavaScript", Runtime = "node main.js" },
        new SupportedLanguageResponse { Value = "python", Label = "Python", Runtime = "python main.py" },
        new SupportedLanguageResponse { Value = "cpp", Label = "C++17", Runtime = "g++ + executable" },
        new SupportedLanguageResponse { Value = "java", Label = "Java", Runtime = "javac + java Main" }
    };

    public async Task<ApiResponse<CodeRunResponse>> Run(long userId, CodeRunRequest request, CancellationToken ct)
    {
        var errors = ValidateRunRequest(request);
        if (errors.Count > 0) return ApiResponse<CodeRunResponse>.Fail("Dữ liệu chạy code không hợp lệ", errors);

        var result = await Execute(request.Language, request.SourceCode, request.Stdin ?? string.Empty, Math.Clamp(request.TimeLimitMs ?? 3000, 500, 10000), ct);
        _db.CodeSubmissions.Add(new CodeSubmission
        {
            UserId = userId,
            Language = NormalizeLanguage(request.Language),
            SourceCode = request.SourceCode,
            Stdin = request.Stdin,
            Status = result.Status,
            Verdict = result.Verdict,
            Output = result.Output,
            Error = result.Error,
            ExecutionTimeMs = result.ExecutionTimeMs,
            MemoryUsedKb = result.MemoryUsedKb,
            TotalTestCases = 0,
            PassedTestCases = 0,
            IsAccepted = result.Verdict == "Accepted",
            CreatedAt = DateTime.UtcNow
        });
        await _db.SaveChangesAsync(ct);
        return ApiResponse<CodeRunResponse>.Ok(result, result.Verdict == "Accepted" ? "Chạy code thành công" : "Chạy code hoàn tất nhưng có lỗi");
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

    public async Task<ApiResponse<CodingProblemDetailResponse>> Problem(long? userId, long id, bool includeHidden, CancellationToken ct)
    {
        var problem = await _db.CodingProblems.AsNoTracking().Include(x => x.TestCases).FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, ct);
        if (problem == null || (problem.Status != 1 && !includeHidden)) return ApiResponse<CodingProblemDetailResponse>.Fail("Không tìm thấy bài lập trình");
        var solved = userId.HasValue && await _db.CodeSubmissions.AsNoTracking().AnyAsync(x => x.UserId == userId.Value && x.ProblemId == id && x.IsAccepted, ct);
        return ApiResponse<CodingProblemDetailResponse>.Ok(MapDetail(problem, solved, includeHidden));
    }

    public async Task<ApiResponse<CodeSubmissionResponse>> Submit(long userId, long problemId, CodeSubmitRequest request, CancellationToken ct)
    {
        if (string.IsNullOrWhiteSpace(request.SourceCode) || request.SourceCode.Length > 20000)
            return ApiResponse<CodeSubmissionResponse>.Fail("Source code không hợp lệ hoặc quá dài");
        if (!IsSupportedLanguage(request.Language)) return ApiResponse<CodeSubmissionResponse>.Fail("Ngôn ngữ chưa được hỗ trợ");

        var problem = await _db.CodingProblems.Include(x => x.TestCases).FirstOrDefaultAsync(x => x.Id == problemId && !x.IsDeleted && x.Status == 1, ct);
        if (problem == null) return ApiResponse<CodeSubmissionResponse>.Fail("Không tìm thấy bài lập trình");
        var testCases = problem.TestCases.OrderBy(x => x.DisplayOrder).ToList();
        if (testCases.Count == 0) return ApiResponse<CodeSubmissionResponse>.Fail("Bài lập trình chưa có test case");

        var submission = new CodeSubmission
        {
            ProblemId = problem.Id,
            UserId = userId,
            Language = NormalizeLanguage(request.Language),
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
        var finalVerdict = "Accepted";
        var finalStatus = "Completed";
        var finalOutput = string.Empty;
        var finalError = string.Empty;

        foreach (var tc in testCases)
        {
            var result = await Execute(request.Language, request.SourceCode, tc.Input, Math.Clamp(problem.TimeLimitMs, 500, 10000), ct);
            var actual = NormalizeOutput(result.Output);
            var expected = NormalizeOutput(tc.ExpectedOutput);
            var ok = result.Verdict == "Accepted" && actual == expected;
            if (ok) passed++;
            else if (finalVerdict == "Accepted")
            {
                finalVerdict = result.Verdict == "Accepted" ? "Wrong Answer" : result.Verdict;
                finalOutput = result.Output;
                finalError = result.Error;
            }
            totalTime += result.ExecutionTimeMs;
            submission.TestCaseResults.Add(new CodeSubmissionTestCaseResult
            {
                TestCaseId = tc.Id,
                DisplayOrder = tc.DisplayOrder,
                Input = tc.IsHidden ? "[hidden]" : tc.Input,
                ExpectedOutput = tc.IsHidden ? "[hidden]" : tc.ExpectedOutput,
                ActualOutput = tc.IsHidden ? (ok ? "[accepted]" : "[wrong]") : result.Output,
                Error = result.Error,
                Status = ok ? "Accepted" : finalVerdict,
                Passed = ok,
                ExecutionTimeMs = result.ExecutionTimeMs
            });
        }

        submission.PassedTestCases = passed;
        submission.ExecutionTimeMs = totalTime;
        submission.IsAccepted = passed == testCases.Count;
        submission.Status = finalStatus;
        submission.Verdict = submission.IsAccepted ? "Accepted" : finalVerdict;
        submission.Output = finalOutput;
        submission.Error = finalError;
        problem.TotalSubmissions += 1;
        if (submission.IsAccepted) problem.AcceptedSubmissions += 1;
        await UpdateCodeStats(userId, submission.IsAccepted, ct);
        await _db.SaveChangesAsync(ct);

        var saved = await _db.CodeSubmissions.AsNoTracking().Include(x => x.Problem).Include(x => x.TestCaseResults).FirstAsync(x => x.Id == submission.Id, ct);
        return ApiResponse<CodeSubmissionResponse>.Ok(MapSubmission(saved, includeHiddenResults: false), submission.IsAccepted ? "Accepted" : submission.Verdict);
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
        if (errors.Count > 0) return ApiResponse<CodingProblemDetailResponse>.Fail("Dữ liệu bài lập trình không hợp lệ", errors);
        var slug = string.IsNullOrWhiteSpace(request.Slug) ? Slugify(request.Title) : Slugify(request.Slug);
        if (await _db.CodingProblems.AnyAsync(x => x.Slug == slug && x.Id != (id ?? 0) && !x.IsDeleted, ct))
            return ApiResponse<CodingProblemDetailResponse>.Fail("Slug đã tồn tại");

        CodingProblem problem;
        if (id.HasValue)
        {
            problem = await _db.CodingProblems.Include(x => x.TestCases).FirstOrDefaultAsync(x => x.Id == id.Value && !x.IsDeleted, ct)
                ?? throw new InvalidOperationException("Không tìm thấy bài lập trình");
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
        problem.StarterCodeJava = request.StarterCodeJava;
        problem.StarterCodeCpp = request.StarterCodeCpp;
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
        return ApiResponse<CodingProblemDetailResponse>.Ok(MapDetail(problem, false, true), id.HasValue ? "Cập nhật bài lập trình thành công" : "Tạo bài lập trình thành công");
    }

    public async Task<ApiResponse<object>> AdminDeleteProblem(long id, CancellationToken ct)
    {
        var problem = await _db.CodingProblems.FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, ct);
        if (problem == null) return ApiResponse<object>.Fail("Không tìm thấy bài lập trình");
        problem.IsDeleted = true;
        problem.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { id }, "Đã xóa bài lập trình");
    }

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
        if (string.IsNullOrWhiteSpace(r.SourceCode)) errors.Add(new ApiError { Field = "sourceCode", Message = "Source code không được trống" });
        if (r.SourceCode?.Length > 20000) errors.Add(new ApiError { Field = "sourceCode", Message = "Source code tối đa 20.000 ký tự" });
        if (!IsSupportedLanguage(r.Language)) errors.Add(new ApiError { Field = "language", Message = "Ngôn ngữ chưa được hỗ trợ" });
        return errors;
    }

    private static List<ApiError> ValidateProblem(CodingProblemRequest r)
    {
        var errors = new List<ApiError>();
        if (string.IsNullOrWhiteSpace(r.Title) || r.Title.Trim().Length < 5) errors.Add(new ApiError { Field = "title", Message = "Tiêu đề tối thiểu 5 ký tự" });
        if (string.IsNullOrWhiteSpace(r.Description) || r.Description.Trim().Length < 20) errors.Add(new ApiError { Field = "description", Message = "Mô tả tối thiểu 20 ký tự" });
        if (r.TestCases == null || r.TestCases.Count < 1) errors.Add(new ApiError { Field = "testCases", Message = "Cần ít nhất 1 test case" });
        if (r.TestCases != null && r.TestCases.Any(x => x.ExpectedOutput == null)) errors.Add(new ApiError { Field = "expectedOutput", Message = "Expected output không hợp lệ" });
        return errors;
    }

    private async Task<CodeRunResponse> Execute(string language, string sourceCode, string stdin, int timeLimitMs, CancellationToken ct)
    {
        var lang = NormalizeLanguage(language);
        var workRoot = Path.Combine(_env.ContentRootPath, "judge-temp");
        Directory.CreateDirectory(workRoot);
        var workDir = Path.Combine(workRoot, Guid.NewGuid().ToString("N"));
        Directory.CreateDirectory(workDir);
        try
        {
            return lang switch
            {
                "javascript" => await RunProcess("node", "main.js", workDir, "main.js", sourceCode, stdin, timeLimitMs, ct),
                "python" => await RunProcess("python", "main.py", workDir, "main.py", sourceCode, stdin, timeLimitMs, ct),
                "java" => await CompileAndRunJava(sourceCode, stdin, workDir, timeLimitMs, ct),
                "cpp" => await CompileAndRunCpp(sourceCode, stdin, workDir, timeLimitMs, ct),
                _ => new CodeRunResponse { Status = "Failed", Verdict = "Unsupported Language", Error = "Ngôn ngữ chưa được hỗ trợ" }
            };
        }
        catch (Exception ex)
        {
            _logger.LogWarning(ex, "Code execution failed");
            return new CodeRunResponse { Status = "Failed", Verdict = "Runtime Error", Error = "Runtime trên server chưa sẵn sàng hoặc code chạy lỗi: " + ex.Message };
        }
        finally
        {
            try { Directory.Delete(workDir, true); } catch { }
        }
    }

    private async Task<CodeRunResponse> CompileAndRunCpp(string sourceCode, string stdin, string workDir, int timeLimitMs, CancellationToken ct)
    {
        await File.WriteAllTextAsync(Path.Combine(workDir, "main.cpp"), sourceCode, ct);
        var exe = OperatingSystem.IsWindows() ? "main.exe" : "main";
        var compile = await ExecuteProcess("g++", $"main.cpp -O2 -std=c++17 -o {exe}", workDir, string.Empty, 10000, ct);
        if (compile.ExitCode != 0) return new CodeRunResponse { Status = "Failed", Verdict = "Compile Error", Error = compile.Error + compile.Output, ExecutionTimeMs = compile.ElapsedMs };
        return await ExecuteProcessToResponse(Path.Combine(workDir, exe), string.Empty, workDir, stdin, timeLimitMs, ct);
    }

    private async Task<CodeRunResponse> CompileAndRunJava(string sourceCode, string stdin, string workDir, int timeLimitMs, CancellationToken ct)
    {
        await File.WriteAllTextAsync(Path.Combine(workDir, "Main.java"), sourceCode, ct);
        var compile = await ExecuteProcess("javac", "Main.java", workDir, string.Empty, 10000, ct);
        if (compile.ExitCode != 0) return new CodeRunResponse { Status = "Failed", Verdict = "Compile Error", Error = compile.Error + compile.Output, ExecutionTimeMs = compile.ElapsedMs };
        return await ExecuteProcessToResponse("java", "-cp . Main", workDir, stdin, timeLimitMs, ct);
    }

    private async Task<CodeRunResponse> RunProcess(string fileName, string args, string workDir, string sourceFile, string sourceCode, string stdin, int timeLimitMs, CancellationToken ct)
    {
        await File.WriteAllTextAsync(Path.Combine(workDir, sourceFile), sourceCode, ct);
        return await ExecuteProcessToResponse(fileName, args, workDir, stdin, timeLimitMs, ct);
    }

    private async Task<CodeRunResponse> ExecuteProcessToResponse(string fileName, string args, string workDir, string stdin, int timeLimitMs, CancellationToken ct)
    {
        var p = await ExecuteProcess(fileName, args, workDir, stdin, timeLimitMs, ct);
        var outputLimit = TrimLong(p.Output);
        var errorLimit = TrimLong(p.Error);
        if (p.TimedOut) return new CodeRunResponse { Status = "Failed", Verdict = "Time Limit Exceeded", Output = outputLimit, Error = errorLimit, ExecutionTimeMs = p.ElapsedMs };
        if (p.ExitCode != 0) return new CodeRunResponse { Status = "Failed", Verdict = "Runtime Error", Output = outputLimit, Error = errorLimit, ExecutionTimeMs = p.ElapsedMs };
        return new CodeRunResponse { Status = "Completed", Verdict = "Accepted", Output = outputLimit, Error = errorLimit, ExecutionTimeMs = p.ElapsedMs };
    }

    private sealed record ProcResult(int ExitCode, string Output, string Error, int ElapsedMs, bool TimedOut);

    private static async Task<ProcResult> ExecuteProcess(string fileName, string args, string workDir, string stdin, int timeoutMs, CancellationToken ct)
    {
        var psi = new ProcessStartInfo
        {
            FileName = fileName,
            Arguments = args,
            WorkingDirectory = workDir,
            RedirectStandardInput = true,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            UseShellExecute = false,
            CreateNoWindow = true
        };
        using var process = new Process { StartInfo = psi, EnableRaisingEvents = true };
        var sw = Stopwatch.StartNew();
        process.Start();
        if (!string.IsNullOrEmpty(stdin)) await process.StandardInput.WriteAsync(stdin);
        process.StandardInput.Close();
        var outputTask = process.StandardOutput.ReadToEndAsync();
        var errorTask = process.StandardError.ReadToEndAsync();
        using var timeoutCts = CancellationTokenSource.CreateLinkedTokenSource(ct);
        timeoutCts.CancelAfter(timeoutMs);
        try
        {
            await process.WaitForExitAsync(timeoutCts.Token);
        }
        catch (OperationCanceledException)
        {
            try { process.Kill(entireProcessTree: true); } catch { }
            sw.Stop();
            return new ProcResult(-1, await outputTask, await errorTask, (int)sw.ElapsedMilliseconds, true);
        }
        sw.Stop();
        return new ProcResult(process.ExitCode, await outputTask, await errorTask, (int)sw.ElapsedMilliseconds, false);
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
        StarterCodeJava = p.StarterCodeJava,
        StarterCodeCpp = p.StarterCodeCpp,
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

    private static bool IsSupportedLanguage(string language) => new[] { "javascript", "python", "cpp", "java" }.Contains(NormalizeLanguage(language));
    private static string NormalizeLanguage(string language) => (language ?? string.Empty).Trim().ToLowerInvariant() switch
    {
        "js" or "node" or "javascript" => "javascript",
        "py" or "python3" or "python" => "python",
        "c++" or "cpp" or "cxx" => "cpp",
        "java" => "java",
        _ => (language ?? string.Empty).Trim().ToLowerInvariant()
    };
    private static byte DifficultyValue(string d) => d.Trim().ToLowerInvariant() switch { "easy" or "beginner" or "1" => 1, "medium" or "intermediate" or "2" => 2, "hard" or "advanced" or "3" => 3, _ => 0 };
    private static string NormalizeOutput(string s) => (s ?? string.Empty).Replace("\r\n", "\n").Trim();
    private static string TrimLong(string s) => string.IsNullOrEmpty(s) ? string.Empty : (s.Length <= 8000 ? s : s[..8000] + "\n...[output truncated]");
    private static string Slugify(string value)
    {
        var chars = value.Trim().ToLowerInvariant().Select(ch => char.IsLetterOrDigit(ch) ? ch : '-').ToArray();
        var slug = string.Join('-', new string(chars).Split('-', StringSplitOptions.RemoveEmptyEntries));
        return string.IsNullOrWhiteSpace(slug) ? Guid.NewGuid().ToString("N") : slug;
    }
}
