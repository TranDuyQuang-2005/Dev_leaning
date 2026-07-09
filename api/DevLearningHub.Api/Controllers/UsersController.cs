using DevLearningHub.Api.Common;
using DevLearningHub.Api.DTOs;
using DevLearningHub.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace DevLearningHub.Api.Controllers;

[ApiController]
[Route("api/v1/users")]
[Authorize]
public sealed class UsersController : BaseApiController
{
    private readonly IUserModuleService _service;
    public UsersController(IUserModuleService service) => _service = service;

    [HttpGet("me/profile")]
    public async Task<ActionResult<ApiResponse<object>>> Profile(CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _service.GetProfile(CurrentUserId.Value, ct));
    }

    [HttpPut("me/profile")]
    public async Task<ActionResult<ApiResponse<object>>> UpdateProfile(UserProfileRequest request, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _service.UpdateProfile(CurrentUserId.Value, request, ct));
    }

    [HttpGet("me/settings")]
    public async Task<ActionResult<ApiResponse<object>>> Settings(CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _service.GetSettings(CurrentUserId.Value, ct));
    }

    [HttpPut("me/settings")]
    public async Task<ActionResult<ApiResponse<object>>> UpdateSettings(UserSettingsRequest request, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _service.UpdateSettings(CurrentUserId.Value, request, ct));
    }

    [HttpGet("me/stats")]
    public async Task<ActionResult<ApiResponse<object>>> Stats(CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _service.GetStats(CurrentUserId.Value, ct));
    }
}
