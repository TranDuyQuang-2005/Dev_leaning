using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using DevLearningHub.Api.Common;
using DevLearningHub.Api.Configurations;
using DevLearningHub.Api.Data;
using DevLearningHub.Api.DTOs;
using DevLearningHub.Api.Entities;
using DevLearningHub.Api.Utilities;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;

namespace DevLearningHub.Api.Services;

public interface IJwtTokenService
{
    string GenerateAccessToken(User user, IReadOnlyCollection<string> roles, IReadOnlyCollection<string> permissions, out string jwtId);
    string GenerateRefreshToken();
    string HashToken(string token);
    long? GetUserIdFromExpiredToken(string token);
}

public sealed class JwtTokenService : IJwtTokenService
{
    private readonly JwtSettings _settings;
    public JwtTokenService(IOptions<JwtSettings> options) => _settings = options.Value;

    public string GenerateAccessToken(User user, IReadOnlyCollection<string> roles, IReadOnlyCollection<string> permissions, out string jwtId)
    {
        jwtId = Guid.NewGuid().ToString("N");
        var claims = new List<Claim>
        {
            new(JwtRegisteredClaimNames.Jti, jwtId),
            new(JwtRegisteredClaimNames.Sub, user.Id.ToString()),
            new(ClaimTypes.NameIdentifier, user.Id.ToString()),
            new(ClaimTypes.Name, user.UserName),
            new(ClaimTypes.Email, user.Email),
            new("fullName", user.FullName)
        };
        claims.AddRange(roles.Select(r => new Claim(ClaimTypes.Role, r)));
        claims.AddRange(permissions.Select(p => new Claim("permission", p)));
        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_settings.SecretKey));
        var token = new JwtSecurityToken(_settings.Issuer, _settings.Audience, claims, expires: DateTime.UtcNow.AddMinutes(_settings.AccessTokenExpirationMinutes), signingCredentials: new SigningCredentials(key, SecurityAlgorithms.HmacSha256));
        return new JwtSecurityTokenHandler().WriteToken(token);
    }

    public string GenerateRefreshToken() => Convert.ToBase64String(RandomNumberGenerator.GetBytes(64));
    public string HashToken(string token) => Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(token)));

    public long? GetUserIdFromExpiredToken(string token)
    {
        try
        {
            var principal = new JwtSecurityTokenHandler().ValidateToken(token, new TokenValidationParameters
            {
                ValidateAudience = true,
                ValidateIssuer = true,
                ValidAudience = _settings.Audience,
                ValidIssuer = _settings.Issuer,
                ValidateIssuerSigningKey = true,
                IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_settings.SecretKey)),
                ValidateLifetime = false
            }, out _);

            var value = principal.FindFirstValue(ClaimTypes.NameIdentifier);
            return long.TryParse(value, out var id) ? id : null;
        }
        catch
        {
            return null;
        }
    }
}

public interface IAuthService
{
    Task<ApiResponse<object>> Register(RegisterRequest request, CancellationToken ct);
    Task<ApiResponse<AuthResponse>> Login(LoginRequest request, string? ip, string? ua, CancellationToken ct);
    Task<ApiResponse<AuthResponse>> Refresh(RefreshTokenRequest request, string? ip, string? ua, CancellationToken ct);
    Task<ApiResponse<object>> Logout(long userId, LogoutRequest request, CancellationToken ct);
    Task<ApiResponse<CurrentUserResponse>> Me(long userId, CancellationToken ct);
    Task<ApiResponse<object>> ChangePassword(long userId, ChangePasswordRequest request, CancellationToken ct);
    Task<ApiResponse<object>> ForgotPassword(ForgotPasswordRequest request, CancellationToken ct);
    Task<ApiResponse<object>> ResetPassword(ResetPasswordRequest request, CancellationToken ct);
    Task<ApiResponse<object>> ResendEmailVerification(ResendEmailVerificationRequest request, CancellationToken ct);
    Task<ApiResponse<object>> VerifyEmail(VerifyEmailRequest request, CancellationToken ct);
}

public sealed class AuthService : IAuthService
{
    private readonly DevLearningHubDbContext _db;
    private readonly IJwtTokenService _jwt;
    private readonly IPermissionService _permissions;
    private readonly IEmailService _email;
    private readonly JwtSettings _settings;
    private readonly EmailOptions _emailOptions;
    private readonly ILogger<AuthService> _logger;
    private const int MaxFailedLoginCount = 5;
    private static readonly TimeSpan LockoutDuration = TimeSpan.FromMinutes(15);
    private static readonly TimeSpan VerificationResendCooldown = TimeSpan.FromMinutes(1);

    public AuthService(
        DevLearningHubDbContext db,
        IJwtTokenService jwt,
        IPermissionService permissions,
        IEmailService email,
        IOptions<JwtSettings> options,
        IOptions<EmailOptions> emailOptions,
        ILogger<AuthService> logger)
    {
        _db = db;
        _jwt = jwt;
        _permissions = permissions;
        _email = email;
        _settings = options.Value;
        _emailOptions = emailOptions.Value;
        _logger = logger;
    }

    public async Task<ApiResponse<object>> Register(RegisterRequest r, CancellationToken ct)
    {
        var errors = new List<ApiError>();
        if (string.IsNullOrWhiteSpace(r.FullName)) errors.Add(new() { Field = "fullName", Message = "Full name is required" });
        if (string.IsNullOrWhiteSpace(r.UserName)) errors.Add(new() { Field = "userName", Message = "User name is required" });
        var emailValidation = EmailValidationHelper.Validate(r.Email);
        if (!emailValidation.IsValid) errors.AddRange(emailValidation.Errors);
        errors.AddRange(ValidateNewPassword(r.Password, r.ConfirmPassword, "password"));
        if (errors.Count > 0)
        {
            if (!string.IsNullOrWhiteSpace(emailValidation.SuggestedEmail))
            {
                var message = emailValidation.Message ?? "Email có vẻ bị nhập sai.";
                return new ApiResponse<object>
                {
                    Success = false,
                    Message = message,
                    Data = new EmailSuggestionResponse { SuggestedEmail = emailValidation.SuggestedEmail },
                    Errors = errors,
                    SuggestedEmail = emailValidation.SuggestedEmail
                };
            }

            return ApiResponse<object>.Fail(emailValidation.Message ?? "Validation failed", errors);
        }

        var email = emailValidation.NormalizedEmail;
        var username = r.UserName.Trim();
        if (await _db.Users.AnyAsync(x => x.Email == email && !x.IsDeleted, ct))
            return ApiResponse<object>.Fail("Email already exists");
        if (await _db.Users.AnyAsync(x => x.UserName == username && !x.IsDeleted, ct))
            return ApiResponse<object>.Fail("User name already exists");

        await using var tx = await _db.Database.BeginTransactionAsync(ct);
        var user = new User
        {
            FullName = r.FullName.Trim(),
            UserName = username,
            Email = email,
            PasswordHash = BCrypt.Net.BCrypt.HashPassword(r.Password),
            Status = 1,
            EmailConfirmed = false,
            CreatedAt = DateTime.UtcNow
        };
        _db.Users.Add(user);
        await _db.SaveChangesAsync(ct);

        var role = await _db.Roles.FirstOrDefaultAsync(x => x.NormalizedName == "USER", ct);
        if (role != null) _db.UserRoles.Add(new UserRole { UserId = user.Id, RoleId = role.Id, AssignedAt = DateTime.UtcNow });
        _db.UserProfiles.Add(new UserProfile { UserId = user.Id, FullName = user.FullName, UpdatedAt = DateTime.UtcNow });
        _db.UserLearningProfiles.Add(new UserLearningProfile { UserId = user.Id, CurrentLevel = 1, DailyGoalMinutes = 30, UpdatedAt = DateTime.UtcNow });
        _db.UserStats.Add(new UserStat { UserId = user.Id, UpdatedAt = DateTime.UtcNow });
        _db.UserSettings.Add(new UserSetting { UserId = user.Id, Theme = "light", Language = "vi", CodeEditorTheme = "dark", CodeEditorFontSize = 14, EnableEmailNotification = true, EnablePushNotification = true, UpdatedAt = DateTime.UtcNow });

        var verificationToken = _jwt.GenerateRefreshToken();
        _db.EmailVerificationTokens.Add(new EmailVerificationToken
        {
            UserId = user.Id,
            TokenHash = _jwt.HashToken(verificationToken),
            ExpiresAt = DateTime.UtcNow.AddHours(24),
            CreatedAt = DateTime.UtcNow
        });
        await _db.SaveChangesAsync(ct);

        try
        {
            await _email.SendEmailVerificationAsync(user.Email, user.FullName, BuildFrontendUrl("verify-email", user.Email, verificationToken), ct);
        }
        catch (Exception ex) when (IsEmailFailure(ex))
        {
            await tx.RollbackAsync(ct);
            _logger.LogWarning(ex, "Failed to send verification email to {Email}", user.Email);
            return ApiResponse<object>.Fail(GetEmailFailureMessage(ex, "Không thể hoàn tất đăng ký vì gửi email xác thực thất bại. Vui lòng kiểm tra cấu hình SMTP."));
        }

        await tx.CommitAsync(ct);

        return ApiResponse<object>.Ok(new { user.Id, user.FullName, user.UserName, user.Email }, $"Hệ thống đã gửi email xác thực đến {user.Email}. Vui lòng mở hộp thư và bấm liên kết xác thực.");
    }

    public async Task<ApiResponse<AuthResponse>> Login(LoginRequest r, string? ip, string? ua, CancellationToken ct)
    {
        var value = (r.EmailOrUserName ?? string.Empty).Trim().ToLowerInvariant();
        var user = await _db.Users
            .Include(x => x.UserRoles).ThenInclude(x => x.Role)
            .FirstOrDefaultAsync(x => !x.IsDeleted && (x.Email.ToLower() == value || x.UserName.ToLower() == value), ct);

        if (user == null) return ApiResponse<AuthResponse>.Fail("Account or password is incorrect");
        if (user.LockoutEndAt.HasValue && user.LockoutEndAt.Value > DateTime.UtcNow)
            return ApiResponse<AuthResponse>.Fail("Account is temporarily locked");
        if (user.Status != 1) return ApiResponse<AuthResponse>.Fail("Account is not active");

        if (string.IsNullOrWhiteSpace(user.PasswordHash) || !BCrypt.Net.BCrypt.Verify(r.Password, user.PasswordHash))
        {
            user.FailedLoginCount += 1;
            if (user.FailedLoginCount >= MaxFailedLoginCount)
            {
                user.LockoutEndAt = DateTime.UtcNow.Add(LockoutDuration);
            }
            await _db.SaveChangesAsync(ct);
            return ApiResponse<AuthResponse>.Fail("Account or password is incorrect");
        }

        if (!user.EmailConfirmed)
        {
            return ApiResponse<AuthResponse>.Fail("Email chưa được xác thực. Vui lòng kiểm tra hộp thư hoặc gửi lại email xác thực.");
        }

        user.LastLoginAt = DateTime.UtcNow;
        user.FailedLoginCount = 0;
        user.LockoutEndAt = null;
        var response = await CreateAuthResponse(user, ip, ua, null, ct);
        await _db.SaveChangesAsync(ct);
        return ApiResponse<AuthResponse>.Ok(response, "Login successfully");
    }

    public async Task<ApiResponse<AuthResponse>> Refresh(RefreshTokenRequest r, string? ip, string? ua, CancellationToken ct)
    {
        if (string.IsNullOrWhiteSpace(r.AccessToken) || string.IsNullOrWhiteSpace(r.RefreshToken))
            return ApiResponse<AuthResponse>.Fail("Refresh token is invalid");

        var userId = _jwt.GetUserIdFromExpiredToken(r.AccessToken);
        if (userId == null) return ApiResponse<AuthResponse>.Fail("Access token is invalid");
        var hash = _jwt.HashToken(r.RefreshToken);
        var old = await _db.RefreshTokens.FirstOrDefaultAsync(x => x.UserId == userId && x.TokenHash == hash, ct);
        if (old == null || old.RevokedAt != null || old.ExpiresAt <= DateTime.UtcNow) return ApiResponse<AuthResponse>.Fail("Refresh token is invalid");

        var user = await _db.Users.Include(x => x.UserRoles).ThenInclude(x => x.Role).FirstOrDefaultAsync(x => x.Id == userId && !x.IsDeleted, ct);
        if (user == null) return ApiResponse<AuthResponse>.Fail("User not found");
        if (user.LockoutEndAt.HasValue && user.LockoutEndAt.Value > DateTime.UtcNow) return ApiResponse<AuthResponse>.Fail("Account is temporarily locked");
        var response = await CreateAuthResponse(user, ip, ua, old, ct);
        await _db.SaveChangesAsync(ct);
        return ApiResponse<AuthResponse>.Ok(response, "Refresh token successfully");
    }

    public async Task<ApiResponse<object>> Logout(long userId, LogoutRequest r, CancellationToken ct)
    {
        var refreshToken = r?.RefreshToken?.Trim();
        if (string.IsNullOrWhiteSpace(refreshToken))
            return ApiResponse<object>.Ok(new { }, "Logout successfully");

        var hash = _jwt.HashToken(refreshToken);
        var token = await _db.RefreshTokens.FirstOrDefaultAsync(x => x.UserId == userId && x.TokenHash == hash, ct);
        if (token != null && token.RevokedAt == null)
        {
            token.RevokedAt = DateTime.UtcNow;
            await _db.SaveChangesAsync(ct);
        }
        return ApiResponse<object>.Ok(new { }, "Logout successfully");
    }

    public async Task<ApiResponse<CurrentUserResponse>> Me(long userId, CancellationToken ct)
    {
        var user = await _db.Users.Include(x => x.UserRoles).ThenInclude(x => x.Role).FirstOrDefaultAsync(x => x.Id == userId && !x.IsDeleted, ct);
        return user == null ? ApiResponse<CurrentUserResponse>.Fail("User not found") : ApiResponse<CurrentUserResponse>.Ok(await MapUser(user, ct));
    }

    public async Task<ApiResponse<object>> ChangePassword(long userId, ChangePasswordRequest r, CancellationToken ct)
    {
        var errors = ValidateNewPassword(r.NewPassword, r.ConfirmPassword, "newPassword");
        if (string.IsNullOrWhiteSpace(r.CurrentPassword)) errors.Add(new ApiError { Field = "currentPassword", Message = "Current password is required" });
        if (errors.Count > 0) return ApiResponse<object>.Fail("Validation failed", errors);

        var user = await _db.Users.FirstOrDefaultAsync(x => x.Id == userId && !x.IsDeleted, ct);
        if (user == null || string.IsNullOrWhiteSpace(user.PasswordHash)) return ApiResponse<object>.Fail("User not found");
        if (!BCrypt.Net.BCrypt.Verify(r.CurrentPassword, user.PasswordHash)) return ApiResponse<object>.Fail("Current password is incorrect");

        user.PasswordHash = BCrypt.Net.BCrypt.HashPassword(r.NewPassword);
        user.UpdatedAt = DateTime.UtcNow;
        await RevokeRefreshTokens(user.Id, ct);
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { }, "Password changed. Please sign in again.");
    }

    public async Task<ApiResponse<object>> ForgotPassword(ForgotPasswordRequest r, CancellationToken ct)
    {
        var email = (r.Email ?? string.Empty).Trim().ToLowerInvariant();
        var user = await _db.Users.FirstOrDefaultAsync(x => x.Email == email && !x.IsDeleted, ct);
        if (user != null)
        {
            var token = _jwt.GenerateRefreshToken();
            _db.PasswordResetTokens.Add(new PasswordResetToken
            {
                UserId = user.Id,
                TokenHash = _jwt.HashToken(token),
                ExpiresAt = DateTime.UtcNow.AddMinutes(30),
                CreatedAt = DateTime.UtcNow
            });
            await _db.SaveChangesAsync(ct);
            try
            {
                await _email.SendPasswordResetAsync(user.Email, user.FullName, BuildFrontendUrl("reset-password", user.Email, token), ct);
            }
            catch (Exception ex) when (IsEmailFailure(ex))
            {
                _logger.LogWarning(ex, "Failed to send password reset email to {Email}", user.Email);
                return ApiResponse<object>.Fail(GetEmailFailureMessage(ex, "Không gửi được email đặt lại mật khẩu. Vui lòng kiểm tra cấu hình SMTP."));
            }
        }
        return ApiResponse<object>.Ok(new { }, "Nếu email tồn tại, hướng dẫn đặt lại mật khẩu đã được gửi.");
    }

    public async Task<ApiResponse<object>> ResetPassword(ResetPasswordRequest r, CancellationToken ct)
    {
        var errors = ValidateNewPassword(r.NewPassword, r.ConfirmPassword, "newPassword");
        if (string.IsNullOrWhiteSpace(r.Email)) errors.Add(new ApiError { Field = "email", Message = "Email is required" });
        if (string.IsNullOrWhiteSpace(r.Token)) errors.Add(new ApiError { Field = "token", Message = "Token is required" });
        if (errors.Count > 0) return ApiResponse<object>.Fail("Validation failed", errors);

        var user = await _db.Users.FirstOrDefaultAsync(x => x.Email == r.Email.Trim().ToLowerInvariant() && !x.IsDeleted, ct);
        if (user == null) return ApiResponse<object>.Fail("Token is invalid or expired");
        var hash = _jwt.HashToken(r.Token);
        var token = await _db.PasswordResetTokens.FirstOrDefaultAsync(x => x.UserId == user.Id && x.TokenHash == hash && x.UsedAt == null, ct);
        if (token == null || token.ExpiresAt <= DateTime.UtcNow) return ApiResponse<object>.Fail("Token is invalid or expired");

        token.UsedAt = DateTime.UtcNow;
        user.PasswordHash = BCrypt.Net.BCrypt.HashPassword(r.NewPassword);
        user.UpdatedAt = DateTime.UtcNow;
        user.FailedLoginCount = 0;
        user.LockoutEndAt = null;
        await RevokeRefreshTokens(user.Id, ct);
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { }, "Password reset successfully");
    }

    public async Task<ApiResponse<object>> ResendEmailVerification(ResendEmailVerificationRequest r, CancellationToken ct)
    {
        var email = (r.Email ?? string.Empty).Trim().ToLowerInvariant();
        var user = await _db.Users.FirstOrDefaultAsync(x => x.Email == email && !x.IsDeleted, ct);
        if (user == null)
        {
            return ApiResponse<object>.Ok(new { }, "Nếu tài khoản cần xác thực, email xác thực đã được gửi.");
        }

        if (user.EmailConfirmed)
        {
            return ApiResponse<object>.Ok(new { }, "Tài khoản đã được xác thực.");
        }

        var lastToken = await _db.EmailVerificationTokens
            .AsNoTracking()
            .Where(x => x.UserId == user.Id && x.UsedAt == null)
            .OrderByDescending(x => x.CreatedAt)
            .FirstOrDefaultAsync(ct);
        if (lastToken != null && lastToken.CreatedAt > DateTime.UtcNow.Subtract(VerificationResendCooldown))
        {
            return ApiResponse<object>.Fail("Vui lòng chờ ít nhất 1 phút trước khi gửi lại email xác thực.");
        }

        var token = _jwt.GenerateRefreshToken();
        _db.EmailVerificationTokens.Add(new EmailVerificationToken
        {
            UserId = user.Id,
            TokenHash = _jwt.HashToken(token),
            ExpiresAt = DateTime.UtcNow.AddHours(24),
            CreatedAt = DateTime.UtcNow
        });
        await _db.SaveChangesAsync(ct);

        try
        {
            await _email.SendEmailVerificationAsync(user.Email, user.FullName, BuildFrontendUrl("verify-email", user.Email, token), ct);
        }
        catch (Exception ex) when (IsEmailFailure(ex))
        {
            _logger.LogWarning(ex, "Failed to resend verification email to {Email}", user.Email);
            return ApiResponse<object>.Fail(GetEmailFailureMessage(ex, "Không gửi được email xác thực. Vui lòng kiểm tra cấu hình SMTP."));
        }

        return ApiResponse<object>.Ok(new { }, "Email xác thực đã được gửi. Vui lòng kiểm tra hộp thư.");
    }

    public async Task<ApiResponse<object>> VerifyEmail(VerifyEmailRequest r, CancellationToken ct)
    {
        var user = await _db.Users.FirstOrDefaultAsync(x => x.Email == r.Email.Trim().ToLowerInvariant() && !x.IsDeleted, ct);
        if (user == null) return ApiResponse<object>.Fail("Token is invalid or expired");
        var hash = _jwt.HashToken(r.Token);
        var token = await _db.EmailVerificationTokens.FirstOrDefaultAsync(x => x.UserId == user.Id && x.TokenHash == hash && x.UsedAt == null, ct);
        if (token == null || token.ExpiresAt <= DateTime.UtcNow) return ApiResponse<object>.Fail("Token is invalid or expired");
        token.UsedAt = DateTime.UtcNow;
        user.EmailConfirmed = true;
        user.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { }, "Email verified successfully");
    }

    private async Task<AuthResponse> CreateAuthResponse(User user, string? ip, string? ua, RefreshToken? old, CancellationToken ct)
    {
        var roles = user.UserRoles.Select(x => x.Role.Name).Distinct().ToList();
        var permissions = await _permissions.GetEffectivePermissionCodes(user.Id, ct);
        var access = _jwt.GenerateAccessToken(user, roles, permissions, out var jwtId);
        var refresh = _jwt.GenerateRefreshToken();
        var refreshHash = _jwt.HashToken(refresh);
        if (old != null)
        {
            old.RevokedAt = DateTime.UtcNow;
            old.ReplacedByTokenHash = refreshHash;
        }
        _db.RefreshTokens.Add(new RefreshToken
        {
            UserId = user.Id,
            TokenHash = refreshHash,
            JwtId = jwtId,
            ExpiresAt = DateTime.UtcNow.AddDays(_settings.RefreshTokenExpirationDays),
            IpAddress = ip,
            UserAgent = ua,
            CreatedAt = DateTime.UtcNow
        });
        return new AuthResponse { AccessToken = access, RefreshToken = refresh, ExpiresIn = _settings.AccessTokenExpirationMinutes * 60, User = await MapUser(user, ct) };
    }

    private async Task RevokeRefreshTokens(long userId, CancellationToken ct)
    {
        var tokens = await _db.RefreshTokens.Where(x => x.UserId == userId && x.RevokedAt == null && x.ExpiresAt > DateTime.UtcNow).ToListAsync(ct);
        foreach (var token in tokens) token.RevokedAt = DateTime.UtcNow;
    }

    private static List<ApiError> ValidateNewPassword(string password, string confirmPassword, string field)
    {
        var errors = new List<ApiError>();
        password ??= string.Empty;
        confirmPassword ??= string.Empty;
        if (string.IsNullOrWhiteSpace(password)) errors.Add(new ApiError { Field = field, Message = "Password is required" });
        if (password != confirmPassword) errors.Add(new ApiError { Field = "confirmPassword", Message = "Passwords do not match" });
        if (password.Length < 8 || !password.Any(char.IsUpper) || !password.Any(char.IsLower) || !password.Any(char.IsDigit) || !password.Any(c => !char.IsLetterOrDigit(c)))
            errors.Add(new ApiError { Field = field, Message = "Password must be at least 8 characters and include upper, lower, digit and special character" });
        return errors;
    }

    private async Task<CurrentUserResponse> MapUser(User user, CancellationToken ct)
    {
        var roles = user.UserRoles.Select(x => x.Role.Name).Distinct().ToList();
        var permissions = await _permissions.GetEffectivePermissionCodes(user.Id, ct);
        var isAdminPortalAllowed = roles.Any(x => x.Equals("Admin", StringComparison.OrdinalIgnoreCase) || x.Equals("Moderator", StringComparison.OrdinalIgnoreCase))
            || permissions.Any(x => x.Equals("admin.access", StringComparison.OrdinalIgnoreCase));

        return new CurrentUserResponse
        {
            UserId = user.Id,
            Id = user.Id,
            FullName = user.FullName,
            UserName = user.UserName,
            Email = user.Email,
            AvatarUrl = user.AvatarUrl,
            Roles = roles,
            Permissions = permissions,
            EffectivePermissions = permissions,
            IsAdminPortalAllowed = isAdminPortalAllowed
        };
    }

    private string BuildFrontendUrl(string path, string email, string token)
    {
        var baseUrl = string.IsNullOrWhiteSpace(_emailOptions.FrontendBaseUrl)
            ? "http://localhost:4200"
            : _emailOptions.FrontendBaseUrl.TrimEnd('/');
        return $"{baseUrl}/{path}?email={Uri.EscapeDataString(email)}&token={Uri.EscapeDataString(token)}";
    }

    private static bool IsEmailFailure(Exception ex)
        => ex is InvalidOperationException || ex is System.Net.Mail.SmtpException || ex is IOException || ex is OperationCanceledException;

    private static string GetEmailFailureMessage(Exception ex, string fallback)
        => ex is InvalidOperationException { Message: EmailService.SmtpNotConfiguredMessage }
            ? EmailService.SmtpNotConfiguredMessage
            : fallback;
}
