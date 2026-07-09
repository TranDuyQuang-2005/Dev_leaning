using DevLearningHub.Api.Common;
using DevLearningHub.Api.DTOs;
using DevLearningHub.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace DevLearningHub.Api.Controllers;

[ApiController]
[Route("api/v1/admin/code")]
[Authorize(Roles = "Admin")]
public sealed class AdminCodeJudgeController : BaseApiController
{
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
}
