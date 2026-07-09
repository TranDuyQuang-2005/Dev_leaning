using DevLearningHub.Api.Common;
using DevLearningHub.Api.DTOs;
using DevLearningHub.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace DevLearningHub.Api.Controllers;

[ApiController]
[Route("api/v1/code")]
public sealed class CodeJudgeController : BaseApiController
{
    private readonly ICodeJudgeService _service;
    public CodeJudgeController(ICodeJudgeService service) => _service = service;

    [HttpGet("languages")]
    [AllowAnonymous]
    public ActionResult<ApiResponse<List<SupportedLanguageResponse>>> Languages()
        => Ok(ApiResponse<List<SupportedLanguageResponse>>.Ok(_service.Languages()));

    [HttpPost("run")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<CodeRunResponse>>> Run(CodeRunRequest request, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        var res = await _service.Run(CurrentUserId.Value, request, ct);
        return res.Success ? Ok(res) : BadRequest(res);
    }

    [HttpGet("problems")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<PagedResult<CodingProblemSummaryResponse>>>> Problems(
        [FromQuery] string? keyword,
        [FromQuery] string? difficulty,
        [FromQuery] int pageIndex = 1,
        [FromQuery] int pageSize = 20,
        CancellationToken ct = default)
    {
        var res = await _service.Problems(CurrentUserId, keyword, difficulty, pageIndex, pageSize, ct);
        return Ok(res);
    }

    [HttpGet("problems/{id:long}")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<CodingProblemDetailResponse>>> Problem(long id, CancellationToken ct)
    {
        var res = await _service.Problem(CurrentUserId, id, false, ct);
        return res.Success ? Ok(res) : NotFound(res);
    }

    [HttpPost("problems/{id:long}/submit")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<CodeSubmissionResponse>>> Submit(long id, CodeSubmitRequest request, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        var res = await _service.Submit(CurrentUserId.Value, id, request, ct);
        return res.Success ? Ok(res) : BadRequest(res);
    }

    [HttpGet("submissions/my")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<List<CodeSubmissionResponse>>>> MySubmissions([FromQuery] long? problemId, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _service.MySubmissions(CurrentUserId.Value, problemId, ct));
    }
}
