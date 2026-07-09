using DevLearningHub.Api.Common;
using DevLearningHub.Api.DTOs;
using DevLearningHub.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace DevLearningHub.Api.Controllers;

[ApiController]
[Route("api/v1/me/practice-banks")]
[Authorize]
public sealed class PersonalPracticeBanksController : BaseApiController
{
    private readonly IPersonalPracticeService _service;
    public PersonalPracticeBanksController(IPersonalPracticeService service) => _service = service;

    [HttpPost("upload")]
    public async Task<ActionResult<ApiResponse<PersonalQuestionBankUploadResponse>>> Upload(
        IFormFile file,
        [FromForm] string title,
        [FromForm] string? description,
        CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized(ApiResponse<object>.Fail("Invalid token"));
        var res = await _service.Upload(CurrentUserId.Value, file, title, description, ct);
        return res.Success ? Ok(res) : BadRequest(res);
    }

    [HttpGet]
    public async Task<ActionResult<ApiResponse<List<PersonalQuestionBankSummaryResponse>>>> Mine(CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized(ApiResponse<object>.Fail("Invalid token"));
        return Ok(await _service.MyBanks(CurrentUserId.Value, ct));
    }

    [HttpGet("{bankId:long}")]
    public async Task<ActionResult<ApiResponse<PersonalQuestionBankDetailResponse>>> Detail(long bankId, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized(ApiResponse<object>.Fail("Invalid token"));
        var res = await _service.GetBank(CurrentUserId.Value, bankId, ct);
        return res.Success ? Ok(res) : NotFound(res);
    }

    [HttpDelete("{bankId:long}")]
    public async Task<ActionResult<ApiResponse<object>>> Delete(long bankId, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized(ApiResponse<object>.Fail("Invalid token"));
        var res = await _service.DeleteBank(CurrentUserId.Value, bankId, ct);
        return res.Success ? Ok(res) : NotFound(res);
    }

    [HttpPost("{bankId:long}/attempts")]
    public async Task<ActionResult<ApiResponse<PersonalPracticeAttemptResponse>>> Start(long bankId, StartPersonalPracticeAttemptRequest request, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized(ApiResponse<object>.Fail("Invalid token"));
        var res = await _service.StartAttempt(CurrentUserId.Value, bankId, request, ct);
        return res.Success ? Ok(res) : NotFound(res);
    }
}

[ApiController]
[Route("api/v1/me/practice-attempts")]
[Authorize]
public sealed class PersonalPracticeAttemptsController : BaseApiController
{
    private readonly IPersonalPracticeService _service;
    public PersonalPracticeAttemptsController(IPersonalPracticeService service) => _service = service;

    [HttpGet]
    public async Task<ActionResult<ApiResponse<List<PersonalPracticeAttemptResultResponse>>>> Mine(CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized(ApiResponse<object>.Fail("Invalid token"));
        return Ok(await _service.MyAttempts(CurrentUserId.Value, ct));
    }

    [HttpGet("{attemptId:long}")]
    public async Task<ActionResult<ApiResponse<PersonalPracticeAttemptResultResponse>>> Detail(long attemptId, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized(ApiResponse<object>.Fail("Invalid token"));
        var res = await _service.GetAttempt(CurrentUserId.Value, attemptId, ct);
        return res.Success ? Ok(res) : NotFound(res);
    }

    [HttpPost("{attemptId:long}/submit")]
    public async Task<ActionResult<ApiResponse<PersonalPracticeAttemptResultResponse>>> Submit(long attemptId, SubmitPersonalPracticeAttemptRequest request, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized(ApiResponse<object>.Fail("Invalid token"));
        var res = await _service.SubmitAttempt(CurrentUserId.Value, attemptId, request, ct);
        return res.Success ? Ok(res) : BadRequest(res);
    }
}
