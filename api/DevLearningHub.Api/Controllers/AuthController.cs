using System.Security.Claims;
using DevLearningHub.Api.Common;
using DevLearningHub.Api.DTOs;
using DevLearningHub.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;

namespace DevLearningHub.Api.Controllers;

[ApiController]
[Route("api/v1/auth")]
public sealed class AuthController : BaseApiController
{
    private readonly IAuthService _service;
    public AuthController(IAuthService service) => _service = service;

    [HttpPost("register")]
    [AllowAnonymous]
    [EnableRateLimiting("auth-register")]
    public async Task<ActionResult<ApiResponse<object>>> Register(RegisterRequest request, CancellationToken ct)
    {
        var res = await _service.Register(request, ct);
        return res.Success ? Ok(res) : BadRequest(res);
    }

    [HttpPost("login")]
    [AllowAnonymous]
    [EnableRateLimiting("auth-login")]
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
    public async Task<ActionResult<ApiResponse<object>>> Logout(LogoutRequest request, CancellationToken ct) => Ok(await _service.Logout(request, ct));

    [HttpPut("change-password")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<object>>> ChangePassword(ChangePasswordRequest request, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized(ApiResponse<object>.Fail("Invalid token"));
        var res = await _service.ChangePassword(CurrentUserId.Value, request, ct);
        return res.Success ? Ok(res) : BadRequest(res);
    }

    [HttpPost("forgot-password")]
    [AllowAnonymous]
    [EnableRateLimiting("auth-sensitive")]
    public async Task<ActionResult<ApiResponse<object>>> ForgotPassword(ForgotPasswordRequest request, CancellationToken ct)
        => Ok(await _service.ForgotPassword(request, ct));

    [HttpPost("reset-password")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<object>>> ResetPassword(ResetPasswordRequest request, CancellationToken ct)
    {
        var res = await _service.ResetPassword(request, ct);
        return res.Success ? Ok(res) : BadRequest(res);
    }

    [HttpPost("resend-email-verification")]
    [AllowAnonymous]
    [EnableRateLimiting("auth-sensitive")]
    public async Task<ActionResult<ApiResponse<object>>> ResendEmailVerification(ResendEmailVerificationRequest request, CancellationToken ct)
        => Ok(await _service.ResendEmailVerification(request, ct));

    [HttpPost("verify-email")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<object>>> VerifyEmail(VerifyEmailRequest request, CancellationToken ct)
    {
        var res = await _service.VerifyEmail(request, ct);
        return res.Success ? Ok(res) : BadRequest(res);
    }

    [HttpGet("me")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<CurrentUserResponse>>> Me(CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized(ApiResponse<CurrentUserResponse>.Fail("Token không hợp lệ"));
        return Ok(await _service.Me(CurrentUserId.Value, ct));
    }
}
