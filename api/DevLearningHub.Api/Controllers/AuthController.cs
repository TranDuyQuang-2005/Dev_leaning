using System.Security.Claims;
using DevLearningHub.Api.Common;
using DevLearningHub.Api.DTOs;
using DevLearningHub.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace DevLearningHub.Api.Controllers;

[ApiController]
[Route("api/v1/auth")]
public sealed class AuthController : BaseApiController
{
    private readonly IAuthService _service;
    public AuthController(IAuthService service) => _service = service;

    [HttpPost("register")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<object>>> Register(RegisterRequest request, CancellationToken ct)
    {
        var res = await _service.Register(request, ct);
        return res.Success ? Ok(res) : BadRequest(res);
    }

    [HttpPost("login")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<AuthResponse>>> Login(LoginRequest request, CancellationToken ct)
    {
        var res = await _service.Login(request, HttpContext.Connection.RemoteIpAddress?.ToString(), Request.Headers.UserAgent.ToString(), ct);
        return res.Success ? Ok(res) : Unauthorized(res);
    }

    [HttpPost("refresh-token")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<AuthResponse>>> Refresh(RefreshTokenRequest request, CancellationToken ct)
    {
        var res = await _service.Refresh(request, HttpContext.Connection.RemoteIpAddress?.ToString(), Request.Headers.UserAgent.ToString(), ct);
        return res.Success ? Ok(res) : Unauthorized(res);
    }

    [HttpPost("logout")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<object>>> Logout(LogoutRequest request, CancellationToken ct) => Ok(await _service.Logout(CurrentUserId ?? 0, request, ct));

    [HttpGet("me")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<CurrentUserResponse>>> Me(CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized(ApiResponse<CurrentUserResponse>.Fail("Token khÃ´ng há»£p lá»‡"));
        return Ok(await _service.Me(CurrentUserId.Value, ct));
    }
}

