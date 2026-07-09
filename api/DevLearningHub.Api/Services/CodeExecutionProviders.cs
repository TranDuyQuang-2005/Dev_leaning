using System.ComponentModel;
using System.Diagnostics;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;
using DevLearningHub.Api.DTOs;
using Microsoft.Extensions.Options;

namespace DevLearningHub.Api.Services;

public sealed class CodeRunnerOptions
{
    public string Provider { get; set; } = "Local";
    public int DefaultTimeLimitMs { get; set; } = 5000;
    public int MaxOutputBytes { get; set; } = 262144;
    public Judge0Options Judge0 { get; set; } = new();
}

public sealed class Judge0Options
{
    public string BaseUrl { get; set; } = "http://localhost:2358";
    public int TimeoutSeconds { get; set; } = 20;
}

public sealed record CodeExecutionTestCase(long? TestCaseId, int DisplayOrder, string Input, string ExpectedOutput, bool IsHidden);

public sealed class CodeExecutionTestCaseResult
{
    public CodeExecutionTestCase TestCase { get; init; } = new(null, 0, string.Empty, string.Empty, false);
    public CodeRunResponse Response { get; init; } = new();
    public string ActualOutput { get; init; } = string.Empty;
    public string Error { get; init; } = string.Empty;
    public string Verdict { get; init; } = string.Empty;
    public bool Passed { get; init; }
}

public interface ICodeExecutionProvider
{
    string Name { get; }
    Task<CodeRunResponse> RunAsync(string languageCode, string sourceCode, string stdin, int timeLimitMs, CancellationToken ct);
    Task<IReadOnlyList<CodeExecutionTestCaseResult>> ExecuteTestCasesAsync(string languageCode, string sourceCode, IReadOnlyList<CodeExecutionTestCase> testCases, int timeLimitMs, CancellationToken ct);
}

public abstract class CodeExecutionProviderBase : ICodeExecutionProvider
{
    private readonly int _maxOutputChars;

    protected CodeExecutionProviderBase(IOptions<CodeRunnerOptions> options)
    {
        _maxOutputChars = Math.Clamp(options.Value.MaxOutputBytes, 1024, 1024 * 1024);
    }

    public abstract string Name { get; }
    public abstract Task<CodeRunResponse> RunAsync(string languageCode, string sourceCode, string stdin, int timeLimitMs, CancellationToken ct);

    public virtual async Task<IReadOnlyList<CodeExecutionTestCaseResult>> ExecuteTestCasesAsync(string languageCode, string sourceCode, IReadOnlyList<CodeExecutionTestCase> testCases, int timeLimitMs, CancellationToken ct)
    {
        var results = new List<CodeExecutionTestCaseResult>();
        foreach (var testCase in testCases)
        {
            var response = await RunAsync(languageCode, sourceCode, testCase.Input, timeLimitMs, ct);
            var actual = NormalizeOutput(response.Stdout);
            var expected = NormalizeOutput(testCase.ExpectedOutput);
            var ok = response.Verdict == JudgeVerdict.Accepted && actual == expected;
            var verdict = ok ? JudgeVerdict.Accepted : response.Verdict == JudgeVerdict.Accepted ? JudgeVerdict.WrongAnswer : response.Verdict;
            results.Add(new CodeExecutionTestCaseResult
            {
                TestCase = testCase,
                Response = response,
                ActualOutput = response.Stdout,
                Error = string.IsNullOrWhiteSpace(response.Stderr) ? response.CompileOutput : response.Stderr,
                Verdict = verdict,
                Passed = ok
            });
        }

        return results;
    }

    protected CodeRunResponse Response(string status, string verdict, string language, string stdout = "", string stderr = "", string compileOutput = "", int elapsedMs = 0, int memoryUsedKb = 0)
    {
        var response = new CodeRunResponse
        {
            Status = status,
            Verdict = verdict,
            Stdout = TrimLong(stdout),
            Stderr = TrimLong(stderr),
            CompileOutput = TrimLong(compileOutput),
            ExecutionTimeMs = elapsedMs,
            MemoryUsedKb = memoryUsedKb,
            Language = language
        };
        MirrorLegacyOutputFields(response);
        return response;
    }

    protected string TrimLong(string s)
        => string.IsNullOrEmpty(s) ? string.Empty : s.Length <= _maxOutputChars ? s : s[.._maxOutputChars] + "\n...[output truncated]...";

    protected static void MirrorLegacyOutputFields(CodeRunResponse response)
    {
        response.Output = response.Stdout;
        response.Error = string.IsNullOrWhiteSpace(response.Stderr) ? response.CompileOutput : response.Stderr;
    }

    protected static string NormalizeOutput(string s)
    {
        var normalized = (s ?? string.Empty).Replace("\r\n", "\n").Replace('\r', '\n');
        var lines = normalized.Split('\n').Select(x => x.TrimEnd()).ToArray();
        return string.Join('\n', lines).TrimEnd('\n');
    }

    protected static class JudgeStatus
    {
        public const string Success = "Success";
        public const string Failed = "Failed";
    }

    protected static class JudgeVerdict
    {
        public const string Accepted = "Accepted";
        public const string CompilationError = "CompilationError";
        public const string RuntimeError = "RuntimeError";
        public const string TimeLimitExceeded = "TimeLimitExceeded";
        public const string WrongAnswer = "WrongAnswer";
        public const string InternalError = "InternalError";
    }
}

public sealed class LocalCodeExecutionProvider : CodeExecutionProviderBase
{
    private const int CompileTimeoutMs = 10000;

    private static readonly IReadOnlyList<CodeLanguageDefinition> LanguageDefinitions = new List<CodeLanguageDefinition>
    {
        new("python", "Python 3"),
        new("javascript", "Node.js"),
        new("typescript", "Node.js + TypeScript compiler"),
        new("java", "JDK"),
        new("c", "GCC"),
        new("cpp", "G++"),
        new("csharp", ".NET SDK"),
        new("go", "Go")
    };

    private readonly ILogger<LocalCodeExecutionProvider> _logger;

    public LocalCodeExecutionProvider(IOptions<CodeRunnerOptions> options, ILogger<LocalCodeExecutionProvider> logger) : base(options)
    {
        _logger = logger;
    }

    public override string Name => "Local";

    public override async Task<CodeRunResponse> RunAsync(string languageCode, string sourceCode, string stdin, int timeLimitMs, CancellationToken ct)
    {
        var language = GetLanguage(languageCode);
        if (language == null)
        {
            return Response(JudgeStatus.Failed, JudgeVerdict.InternalError, languageCode, stderr: "Language is not supported.");
        }

        var workRoot = Path.Combine(Path.GetTempPath(), "DevLearningHubJudge");
        Directory.CreateDirectory(workRoot);
        var workDir = Path.Combine(workRoot, Guid.NewGuid().ToString("N"));
        Directory.CreateDirectory(workDir);

        try
        {
            return language.Code switch
            {
                "python" => await RunPython(sourceCode, stdin, workDir, timeLimitMs, ct),
                "javascript" => await RunSource(language, "node", "main.js", workDir, "main.js", sourceCode, stdin, timeLimitMs, ct),
                "typescript" => await CompileAndRunTypeScript(sourceCode, stdin, workDir, timeLimitMs, ct),
                "java" => await CompileAndRun(language, "javac", "Main.java", "java", "Main", workDir, "Main.java", sourceCode, stdin, timeLimitMs, ct),
                "c" => await CompileAndRunNative(language, "gcc", $"main.c -O2 -o {NativeExeName()}", NativeExeName(), workDir, "main.c", sourceCode, stdin, timeLimitMs, ct),
                "cpp" => await CompileAndRunNative(language, "g++", $"main.cpp -std=c++17 -O2 -o {NativeExeName()}", NativeExeName(), workDir, "main.cpp", sourceCode, stdin, timeLimitMs, ct),
                "csharp" => await CompileAndRunCsharp(sourceCode, stdin, workDir, timeLimitMs, ct),
                "go" => await RunSource(language, "go", "run main.go", workDir, "main.go", sourceCode, stdin, timeLimitMs, ct),
                _ => Response(JudgeStatus.Failed, JudgeVerdict.InternalError, language.Code, stderr: "Language is not supported.")
            };
        }
        catch (Exception ex)
        {
            _logger.LogWarning(ex, "Local code execution failed for {Language}", language.Code);
            return Response(JudgeStatus.Failed, JudgeVerdict.InternalError, language.Code, stderr: "Internal runner error. Production should use Docker, Judge0, or a dedicated sandbox.");
        }
        finally
        {
            try { Directory.Delete(workDir, true); } catch { }
        }
    }

    private async Task<CodeRunResponse> RunPython(string sourceCode, string stdin, string workDir, int timeLimitMs, CancellationToken ct)
    {
        var language = GetLanguage("python")!;
        await File.WriteAllTextAsync(Path.Combine(workDir, "main.py"), sourceCode, ct);
        var result = await ExecuteProcess("python", "main.py", workDir, stdin, timeLimitMs, ct);
        if (result.MissingRuntime && OperatingSystem.IsWindows())
        {
            result = await ExecuteProcess("py", "main.py", workDir, stdin, timeLimitMs, ct);
        }
        return ProcessResultToResponse(language, result);
    }

    private async Task<CodeRunResponse> RunSource(CodeLanguageDefinition language, string fileName, string args, string workDir, string sourceFile, string sourceCode, string stdin, int timeLimitMs, CancellationToken ct)
    {
        await File.WriteAllTextAsync(Path.Combine(workDir, sourceFile), sourceCode, ct);
        var result = await ExecuteProcess(CommandName(fileName), args, workDir, stdin, timeLimitMs, ct);
        return ProcessResultToResponse(language, result);
    }

    private async Task<CodeRunResponse> CompileAndRunTypeScript(string sourceCode, string stdin, string workDir, int timeLimitMs, CancellationToken ct)
    {
        var language = GetLanguage("typescript")!;
        await File.WriteAllTextAsync(Path.Combine(workDir, "main.ts"), sourceCode, ct);
        Directory.CreateDirectory(Path.Combine(workDir, "out"));
        var compile = await ExecuteProcess(CommandName("npx"), "tsc main.ts --target ES2020 --module commonjs --outDir out", workDir, string.Empty, CompileTimeoutMs, ct);
        if (compile.MissingRuntime)
        {
            return Response(JudgeStatus.Failed, JudgeVerdict.CompilationError, language.Code, compileOutput: "TypeScript runtime/compiler is not installed. Please install Node.js and TypeScript.", elapsedMs: compile.ElapsedMs);
        }
        if (compile.TimedOut)
        {
            return Response(JudgeStatus.Failed, JudgeVerdict.TimeLimitExceeded, language.Code, compileOutput: TrimLong(compile.Error + compile.Output), elapsedMs: compile.ElapsedMs);
        }
        if (compile.ExitCode != 0)
        {
            return Response(JudgeStatus.Failed, JudgeVerdict.CompilationError, language.Code, compileOutput: TrimLong(compile.Error + compile.Output), elapsedMs: compile.ElapsedMs);
        }

        var run = await ExecuteProcess("node", "out/main.js", workDir, stdin, timeLimitMs, ct);
        var response = ProcessResultToResponse(language, run);
        response.CompileOutput = TrimLong(compile.Output + compile.Error);
        MirrorLegacyOutputFields(response);
        return response;
    }

    private async Task<CodeRunResponse> CompileAndRun(CodeLanguageDefinition language, string compiler, string compileArgs, string runner, string runArgs, string workDir, string sourceFile, string sourceCode, string stdin, int timeLimitMs, CancellationToken ct)
    {
        await File.WriteAllTextAsync(Path.Combine(workDir, sourceFile), sourceCode, ct);
        var compile = await ExecuteProcess(CommandName(compiler), compileArgs, workDir, string.Empty, CompileTimeoutMs, ct);
        if (compile.MissingRuntime)
        {
            return Response(JudgeStatus.Failed, JudgeVerdict.CompilationError, language.Code, compileOutput: $"{language.RequiredRuntime} runtime/compiler is not installed.", elapsedMs: compile.ElapsedMs);
        }
        if (compile.TimedOut)
        {
            return Response(JudgeStatus.Failed, JudgeVerdict.TimeLimitExceeded, language.Code, compileOutput: TrimLong(compile.Error + compile.Output), elapsedMs: compile.ElapsedMs);
        }
        if (compile.ExitCode != 0)
        {
            return Response(JudgeStatus.Failed, JudgeVerdict.CompilationError, language.Code, compileOutput: TrimLong(compile.Error + compile.Output), elapsedMs: compile.ElapsedMs);
        }

        var run = await ExecuteProcess(CommandName(runner), runArgs, workDir, stdin, timeLimitMs, ct);
        var response = ProcessResultToResponse(language, run);
        response.CompileOutput = TrimLong(compile.Output + compile.Error);
        MirrorLegacyOutputFields(response);
        return response;
    }

    private async Task<CodeRunResponse> CompileAndRunNative(CodeLanguageDefinition language, string compiler, string compileArgs, string exeName, string workDir, string sourceFile, string sourceCode, string stdin, int timeLimitMs, CancellationToken ct)
    {
        await File.WriteAllTextAsync(Path.Combine(workDir, sourceFile), sourceCode, ct);
        var compile = await ExecuteProcess(CommandName(compiler), compileArgs, workDir, string.Empty, CompileTimeoutMs, ct);
        if (compile.MissingRuntime)
        {
            return Response(JudgeStatus.Failed, JudgeVerdict.CompilationError, language.Code, compileOutput: $"{language.RequiredRuntime} runtime/compiler is not installed.", elapsedMs: compile.ElapsedMs);
        }
        if (compile.TimedOut)
        {
            return Response(JudgeStatus.Failed, JudgeVerdict.TimeLimitExceeded, language.Code, compileOutput: TrimLong(compile.Error + compile.Output), elapsedMs: compile.ElapsedMs);
        }
        if (compile.ExitCode != 0)
        {
            return Response(JudgeStatus.Failed, JudgeVerdict.CompilationError, language.Code, compileOutput: TrimLong(compile.Error + compile.Output), elapsedMs: compile.ElapsedMs);
        }

        var executable = Path.Combine(workDir, exeName);
        var run = await ExecuteProcess(executable, string.Empty, workDir, stdin, timeLimitMs, ct);
        var response = ProcessResultToResponse(language, run);
        response.CompileOutput = TrimLong(compile.Output + compile.Error);
        MirrorLegacyOutputFields(response);
        return response;
    }

    private async Task<CodeRunResponse> CompileAndRunCsharp(string sourceCode, string stdin, string workDir, int timeLimitMs, CancellationToken ct)
    {
        var language = GetLanguage("csharp")!;
        await File.WriteAllTextAsync(Path.Combine(workDir, "Program.cs"), sourceCode, ct);
        await File.WriteAllTextAsync(Path.Combine(workDir, "Main.csproj"), "<Project Sdk=\"Microsoft.NET.Sdk\"><PropertyGroup><OutputType>Exe</OutputType><TargetFramework>net9.0</TargetFramework><ImplicitUsings>enable</ImplicitUsings><Nullable>enable</Nullable></PropertyGroup></Project>", ct);
        var compile = await ExecuteProcess("dotnet", "build Main.csproj --nologo -v quiet", workDir, string.Empty, CompileTimeoutMs, ct);
        if (compile.MissingRuntime)
        {
            return Response(JudgeStatus.Failed, JudgeVerdict.CompilationError, language.Code, compileOutput: ".NET SDK is not installed.", elapsedMs: compile.ElapsedMs);
        }
        if (compile.TimedOut)
        {
            return Response(JudgeStatus.Failed, JudgeVerdict.TimeLimitExceeded, language.Code, compileOutput: TrimLong(compile.Error + compile.Output), elapsedMs: compile.ElapsedMs);
        }
        if (compile.ExitCode != 0)
        {
            return Response(JudgeStatus.Failed, JudgeVerdict.CompilationError, language.Code, compileOutput: TrimLong(compile.Error + compile.Output), elapsedMs: compile.ElapsedMs);
        }

        var run = await ExecuteProcess("dotnet", "bin/Debug/net9.0/Main.dll", workDir, stdin, timeLimitMs, ct);
        var response = ProcessResultToResponse(language, run);
        response.CompileOutput = TrimLong(compile.Output + compile.Error);
        MirrorLegacyOutputFields(response);
        return response;
    }

    private CodeRunResponse ProcessResultToResponse(CodeLanguageDefinition language, ProcResult p)
    {
        if (p.MissingRuntime)
        {
            return Response(JudgeStatus.Failed, JudgeVerdict.RuntimeError, language.Code, stderr: $"{language.RequiredRuntime} runtime/compiler is not installed.", elapsedMs: p.ElapsedMs);
        }
        if (p.TimedOut)
        {
            return Response(JudgeStatus.Failed, JudgeVerdict.TimeLimitExceeded, language.Code, stdout: p.Output, stderr: p.Error, elapsedMs: p.ElapsedMs);
        }
        if (p.ExitCode != 0)
        {
            return Response(JudgeStatus.Failed, JudgeVerdict.RuntimeError, language.Code, stdout: p.Output, stderr: p.Error, elapsedMs: p.ElapsedMs);
        }
        return Response(JudgeStatus.Success, JudgeVerdict.Accepted, language.Code, stdout: p.Output, stderr: p.Error, elapsedMs: p.ElapsedMs);
    }

    private sealed record ProcResult(int ExitCode, string Output, string Error, int ElapsedMs, bool TimedOut, bool MissingRuntime);

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
        ApplyMinimalEnvironment(psi, workDir);

        using var process = new Process { StartInfo = psi, EnableRaisingEvents = true };
        var sw = Stopwatch.StartNew();
        try
        {
            process.Start();
        }
        catch (Win32Exception ex)
        {
            sw.Stop();
            return new ProcResult(-1, string.Empty, $"{fileName} is not installed or not available on PATH. {ex.Message}", (int)sw.ElapsedMilliseconds, false, true);
        }

        if (!string.IsNullOrEmpty(stdin)) await process.StandardInput.WriteAsync(stdin);
        process.StandardInput.Close();
        var outputTask = process.StandardOutput.ReadToEndAsync(ct);
        var errorTask = process.StandardError.ReadToEndAsync(ct);
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
            return new ProcResult(-1, await ReadSafe(outputTask), await ReadSafe(errorTask), (int)sw.ElapsedMilliseconds, true, false);
        }
        sw.Stop();
        return new ProcResult(process.ExitCode, await ReadSafe(outputTask), await ReadSafe(errorTask), (int)sw.ElapsedMilliseconds, false, false);
    }

    private static async Task<string> ReadSafe(Task<string> task)
    {
        try { return await task; }
        catch { return string.Empty; }
    }

    private static void ApplyMinimalEnvironment(ProcessStartInfo psi, string workDir)
    {
        psi.Environment.Clear();
        CopyEnv(psi, "PATH");
        CopyEnv(psi, "Path");
        CopyEnv(psi, "PATHEXT");
        CopyEnv(psi, "SystemRoot");
        CopyEnv(psi, "WINDIR");
        CopyEnv(psi, "HOME");
        CopyEnv(psi, "USERPROFILE");
        CopyEnv(psi, "ProgramFiles");
        CopyEnv(psi, "ProgramFiles(x86)");
        psi.Environment["TMP"] = workDir;
        psi.Environment["TEMP"] = workDir;
        psi.Environment["DOTNET_CLI_HOME"] = workDir;
        psi.Environment["DOTNET_NOLOGO"] = "1";
        psi.Environment["DOTNET_SKIP_FIRST_TIME_EXPERIENCE"] = "1";
    }

    private static void CopyEnv(ProcessStartInfo psi, string name)
    {
        var value = Environment.GetEnvironmentVariable(name);
        if (!string.IsNullOrWhiteSpace(value) && !psi.Environment.ContainsKey(name))
        {
            psi.Environment[name] = value;
        }
    }

    private static CodeLanguageDefinition? GetLanguage(string language)
    {
        var normalized = NormalizeLanguage(language);
        return LanguageDefinitions.FirstOrDefault(x => x.Code == normalized);
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

    private static string NativeExeName() => OperatingSystem.IsWindows() ? "main.exe" : "main";

    private static string CommandName(string value)
    {
        if (!OperatingSystem.IsWindows()) return value;
        return value.Equals("npx", StringComparison.OrdinalIgnoreCase) ? "npx.cmd" : value;
    }

    private sealed record CodeLanguageDefinition(string Code, string RequiredRuntime);
}

public sealed class Judge0ExecutionProvider : CodeExecutionProviderBase
{
    public const string UnavailableMessage = "Judge0 service is not available. Please start Judge0 or switch CodeRunner:Provider to Local.";

    private static readonly IReadOnlyDictionary<string, int> LanguageIds = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase)
    {
        ["python"] = 71,
        ["javascript"] = 63,
        ["typescript"] = 74,
        ["java"] = 62,
        ["c"] = 50,
        ["cpp"] = 54,
        ["csharp"] = 51,
        ["go"] = 60
    };

    private readonly HttpClient _http;
    private readonly CodeRunnerOptions _options;
    private readonly ILogger<Judge0ExecutionProvider> _logger;

    public Judge0ExecutionProvider(HttpClient http, IOptions<CodeRunnerOptions> options, ILogger<Judge0ExecutionProvider> logger) : base(options)
    {
        _http = http;
        _options = options.Value;
        _logger = logger;
    }

    public override string Name => "Judge0";

    public override async Task<CodeRunResponse> RunAsync(string languageCode, string sourceCode, string stdin, int timeLimitMs, CancellationToken ct)
    {
        var language = NormalizeLanguage(languageCode);
        if (!LanguageIds.TryGetValue(language, out var languageId))
        {
            return Response(JudgeStatus.Failed, JudgeVerdict.InternalError, languageCode, stderr: "Language is not supported by Judge0 provider.");
        }

        var baseUri = TryBuildBaseUri();
        if (baseUri == null || !await IsAvailableAsync(baseUri, ct))
        {
            return Response(JudgeStatus.Failed, JudgeVerdict.InternalError, language, stderr: UnavailableMessage);
        }

        try
        {
            var submit = new Judge0SubmissionRequest
            {
                SourceCode = sourceCode,
                LanguageId = languageId,
                Stdin = stdin,
                CpuTimeLimit = Math.Max(1, Math.Ceiling(timeLimitMs / 1000d))
            };
            using var timeout = CancellationTokenSource.CreateLinkedTokenSource(ct);
            timeout.CancelAfter(TimeSpan.FromSeconds(Math.Clamp(_options.Judge0.TimeoutSeconds, 1, 120)));

            var submitResponse = await _http.PostAsJsonAsync(BuildUri(baseUri, "submissions?base64_encoded=false&wait=false"), submit, timeout.Token);
            if (!submitResponse.IsSuccessStatusCode)
            {
                return Response(JudgeStatus.Failed, JudgeVerdict.InternalError, language, stderr: $"Judge0 submit failed with HTTP {(int)submitResponse.StatusCode}.");
            }

            var tokenResponse = await submitResponse.Content.ReadFromJsonAsync<Judge0TokenResponse>(cancellationToken: timeout.Token);
            if (string.IsNullOrWhiteSpace(tokenResponse?.Token))
            {
                return Response(JudgeStatus.Failed, JudgeVerdict.InternalError, language, stderr: "Judge0 did not return a submission token.");
            }

            var startedAt = DateTime.UtcNow;
            while (DateTime.UtcNow - startedAt < TimeSpan.FromSeconds(Math.Clamp(_options.Judge0.TimeoutSeconds, 1, 120)))
            {
                var resultResponse = await _http.GetAsync(BuildUri(baseUri, $"submissions/{tokenResponse.Token}?base64_encoded=false"), timeout.Token);
                if (!resultResponse.IsSuccessStatusCode)
                {
                    return Response(JudgeStatus.Failed, JudgeVerdict.InternalError, language, stderr: $"Judge0 poll failed with HTTP {(int)resultResponse.StatusCode}.");
                }

                var result = await resultResponse.Content.ReadFromJsonAsync<Judge0SubmissionResponse>(cancellationToken: timeout.Token);
                if (result?.Status != null && result.Status.Id > 2)
                {
                    return MapJudge0Response(language, result);
                }

                await Task.Delay(TimeSpan.FromMilliseconds(500), timeout.Token);
            }

            return Response(JudgeStatus.Failed, JudgeVerdict.TimeLimitExceeded, language, stderr: "Judge0 polling timed out.");
        }
        catch (Exception ex) when (ex is HttpRequestException or TaskCanceledException or OperationCanceledException)
        {
            _logger.LogWarning(ex, "Judge0 provider failed for {Language}", language);
            return Response(JudgeStatus.Failed, JudgeVerdict.InternalError, language, stderr: UnavailableMessage);
        }
    }

    private async Task<bool> IsAvailableAsync(Uri baseUri, CancellationToken ct)
    {
        try
        {
            using var timeout = CancellationTokenSource.CreateLinkedTokenSource(ct);
            timeout.CancelAfter(TimeSpan.FromSeconds(Math.Min(Math.Clamp(_options.Judge0.TimeoutSeconds, 1, 120), 5)));
            var response = await _http.GetAsync(BuildUri(baseUri, "about"), timeout.Token);
            return response.IsSuccessStatusCode;
        }
        catch (Exception ex) when (ex is HttpRequestException or TaskCanceledException or OperationCanceledException)
        {
            _logger.LogWarning(ex, "Judge0 health check failed");
            return false;
        }
    }

    private CodeRunResponse MapJudge0Response(string language, Judge0SubmissionResponse result)
    {
        var stdout = result.Stdout ?? string.Empty;
        var stderr = result.Stderr ?? string.Empty;
        var compileOutput = result.CompileOutput ?? string.Empty;
        var elapsedMs = ParseTimeMs(result.Time);
        var memory = result.Memory ?? 0;
        var verdict = result.Status?.Id switch
        {
            3 => JudgeVerdict.Accepted,
            4 => JudgeVerdict.WrongAnswer,
            5 => JudgeVerdict.TimeLimitExceeded,
            6 => JudgeVerdict.CompilationError,
            >= 7 and <= 12 => JudgeVerdict.RuntimeError,
            _ => JudgeVerdict.InternalError
        };
        var status = verdict == JudgeVerdict.Accepted ? JudgeStatus.Success : JudgeStatus.Failed;
        return Response(status, verdict, language, stdout, stderr, compileOutput, elapsedMs, memory);
    }

    private Uri? TryBuildBaseUri()
    {
        if (Uri.TryCreate(_options.Judge0.BaseUrl, UriKind.Absolute, out var uri)) return uri;
        return null;
    }

    private static Uri BuildUri(Uri baseUri, string pathAndQuery) => new(baseUri, pathAndQuery);

    private static int ParseTimeMs(JsonElement? time)
    {
        if (time == null) return 0;
        try
        {
            var element = time.Value;
            if (element.ValueKind == JsonValueKind.Number && element.TryGetDouble(out var numeric)) return (int)Math.Round(numeric * 1000);
            if (element.ValueKind == JsonValueKind.String && double.TryParse(element.GetString(), out var textValue)) return (int)Math.Round(textValue * 1000);
        }
        catch
        {
            return 0;
        }

        return 0;
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

    private sealed class Judge0SubmissionRequest
    {
        [JsonPropertyName("source_code")]
        public string SourceCode { get; set; } = string.Empty;

        [JsonPropertyName("language_id")]
        public int LanguageId { get; set; }

        [JsonPropertyName("stdin")]
        public string Stdin { get; set; } = string.Empty;

        [JsonPropertyName("cpu_time_limit")]
        public double CpuTimeLimit { get; set; }
    }

    private sealed class Judge0TokenResponse
    {
        [JsonPropertyName("token")]
        public string? Token { get; set; }
    }

    private sealed class Judge0SubmissionResponse
    {
        [JsonPropertyName("stdout")]
        public string? Stdout { get; set; }

        [JsonPropertyName("stderr")]
        public string? Stderr { get; set; }

        [JsonPropertyName("compile_output")]
        public string? CompileOutput { get; set; }

        [JsonPropertyName("time")]
        public JsonElement? Time { get; set; }

        [JsonPropertyName("memory")]
        public int? Memory { get; set; }

        [JsonPropertyName("status")]
        public Judge0Status? Status { get; set; }
    }

    private sealed class Judge0Status
    {
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [JsonPropertyName("description")]
        public string Description { get; set; } = string.Empty;
    }
}
