using DevLearningHub.Api.Common;
using DevLearningHub.Api.DTOs;
using DevLearningHub.Api.Security;
using DevLearningHub.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Text;
using System.Text.Json;

namespace DevLearningHub.Api.Controllers;

[ApiController]
[Route("api/v1/admin/code")]
[RequirePermission("code.manage")]
public sealed class AdminCodeJudgeController : BaseApiController
{
    private static readonly JsonSerializerOptions ImportJsonOptions = new(JsonSerializerDefaults.Web)
    {
        PropertyNameCaseInsensitive = true
    };

    private readonly ICodeJudgeService _service;
    public AdminCodeJudgeController(ICodeJudgeService service) => _service = service;

    [HttpGet("problems")]
    public async Task<ActionResult<ApiResponse<List<CodingProblemDetailResponse>>>> Problems(CancellationToken ct)
        => Ok(await _service.AdminProblems(ct));

    [HttpGet("problems/{id:long}")]
    public async Task<ActionResult<ApiResponse<CodingProblemDetailResponse>>> Problem(long id, CancellationToken ct)
    {
        var res = await _service.Problem(CurrentUserId, id, true, ct);
        return res.Success ? Ok(res) : NotFound(res);
    }

    [HttpPost("problems")]
    public async Task<ActionResult<ApiResponse<CodingProblemDetailResponse>>> Create(CodingProblemRequest request, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        var res = await _service.AdminSaveProblem(CurrentUserId.Value, null, request, ct);
        return res.Success ? Ok(res) : BadRequest(res);
    }

    [HttpPost("problems/import")]
    [Consumes("application/json")]
    public async Task<ActionResult<ApiResponse<CodingProblemImportResult>>> ImportJson([FromBody] List<CodingProblemImportRequest> problems, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        var res = await _service.AdminImportProblems(CurrentUserId.Value, problems ?? new List<CodingProblemImportRequest>(), ct);
        return res.Success ? Ok(res) : BadRequest(res);
    }

    [HttpPost("problems/import")]
    [Consumes("multipart/form-data")]
    public async Task<ActionResult<ApiResponse<CodingProblemImportResult>>> ImportFile(IFormFile file, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        try
        {
            var problems = await ParseImportFile(file, ct);
            var res = await _service.AdminImportProblems(CurrentUserId.Value, problems, ct);
            return res.Success ? Ok(res) : BadRequest(res);
        }
        catch (Exception ex)
        {
            return BadRequest(ApiResponse<CodingProblemImportResult>.Fail(ex.Message));
        }
    }

    [HttpPut("problems/{id:long}")]
    public async Task<ActionResult<ApiResponse<CodingProblemDetailResponse>>> Update(long id, CodingProblemRequest request, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        var res = await _service.AdminSaveProblem(CurrentUserId.Value, id, request, ct);
        return res.Success ? Ok(res) : BadRequest(res);
    }

    [HttpDelete("problems/{id:long}")]
    public async Task<ActionResult<ApiResponse<object>>> Delete(long id, CancellationToken ct)
    {
        var res = await _service.AdminDeleteProblem(id, ct);
        return res.Success ? Ok(res) : BadRequest(res);
    }

    [HttpGet("submissions/{submissionId:long}")]
    public async Task<ActionResult<ApiResponse<CodeSubmissionResponse>>> Submission(long submissionId, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        var res = await _service.SubmissionDetail(CurrentUserId.Value, submissionId, true, ct);
        return res.Success ? Ok(res) : NotFound(res);
    }

    private static async Task<List<CodingProblemImportRequest>> ParseImportFile(IFormFile file, CancellationToken ct)
    {
        if (file == null || file.Length == 0) throw new InvalidOperationException("Import file is required");
        var ext = Path.GetExtension(file.FileName).ToLowerInvariant();
        if (ext is not ".json" and not ".csv") throw new InvalidOperationException("Only JSON and CSV import files are supported");

        await using var stream = file.OpenReadStream();
        using var reader = new StreamReader(stream, Encoding.UTF8, detectEncodingFromByteOrderMarks: true);
        var content = await reader.ReadToEndAsync(ct);
        if (ext == ".json")
        {
            return JsonSerializer.Deserialize<List<CodingProblemImportRequest>>(content, ImportJsonOptions) ?? new List<CodingProblemImportRequest>();
        }

        return ParseCsv(content);
    }

    private static List<CodingProblemImportRequest> ParseCsv(string csv)
    {
        var rows = ParseCsvRows(csv);
        if (rows.Count < 2) throw new InvalidOperationException("CSV must include a header and at least one problem row");

        var headers = rows[0].Select(NormalizeHeader).ToList();
        var result = new List<CodingProblemImportRequest>();
        for (var i = 1; i < rows.Count; i++)
        {
            var row = rows[i];
            if (row.All(string.IsNullOrWhiteSpace)) continue;
            var testCases = ReadValue(headers, row, "testCasesJson", "test_cases_json", "testcases");
            var input = ReadValue(headers, row, "input", "sampleInput");
            var expected = ReadValue(headers, row, "expectedOutput", "expected_output", "output");
            result.Add(new CodingProblemImportRequest
            {
                Title = ReadValue(headers, row, "title"),
                Slug = ReadValue(headers, row, "slug"),
                Description = ReadValue(headers, row, "description"),
                Difficulty = ReadByte(headers, row, 1, "difficulty"),
                Tags = ReadValue(headers, row, "tags"),
                InputFormat = ReadValue(headers, row, "inputFormat", "input_format"),
                OutputFormat = ReadValue(headers, row, "outputFormat", "output_format"),
                Constraints = ReadValue(headers, row, "constraints"),
                ExamplesJson = ReadValue(headers, row, "examplesJson", "examples_json"),
                StarterCodeJavaScript = ReadValue(headers, row, "starterCodeJavaScript", "starter_js", "starterCodeJs"),
                StarterCodePython = ReadValue(headers, row, "starterCodePython", "starter_python"),
                StarterCodeTypeScript = ReadValue(headers, row, "starterCodeTypeScript", "starter_ts"),
                StarterCodeJava = ReadValue(headers, row, "starterCodeJava", "starter_java"),
                StarterCodeC = ReadValue(headers, row, "starterCodeC", "starter_c"),
                StarterCodeCpp = ReadValue(headers, row, "starterCodeCpp", "starter_cpp"),
                StarterCodeCsharp = ReadValue(headers, row, "starterCodeCsharp", "starter_csharp"),
                StarterCodeGo = ReadValue(headers, row, "starterCodeGo", "starter_go"),
                TimeLimitMs = ReadInt(headers, row, 2000, "timeLimitMs", "time_limit_ms"),
                MemoryLimitKb = ReadInt(headers, row, 131072, "memoryLimitKb", "memory_limit_kb"),
                TestCases = ParseTestCases(testCases, input, expected, ReadBool(headers, row, false, "isHidden", "hidden"))
            });
        }

        return result;
    }

    private static List<CodingTestCaseRequest> ParseTestCases(string testCasesJson, string input, string expectedOutput, bool isHidden)
    {
        if (!string.IsNullOrWhiteSpace(testCasesJson))
            return JsonSerializer.Deserialize<List<CodingTestCaseRequest>>(testCasesJson, ImportJsonOptions) ?? new List<CodingTestCaseRequest>();

        return new List<CodingTestCaseRequest>
        {
            new()
            {
                Input = input,
                ExpectedOutput = expectedOutput,
                IsHidden = isHidden,
                DisplayOrder = 1
            }
        };
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

    private static int ReadInt(List<string> headers, List<string> row, int fallback, params string[] names)
        => int.TryParse(ReadValue(headers, row, names), out var value) ? value : fallback;

    private static byte ReadByte(List<string> headers, List<string> row, byte fallback, params string[] names)
        => byte.TryParse(ReadValue(headers, row, names), out var value) ? value : fallback;

    private static bool ReadBool(List<string> headers, List<string> row, bool fallback, params string[] names)
        => bool.TryParse(ReadValue(headers, row, names), out var value) ? value : fallback;

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
