using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using DevLearningHub.Api.Common;
using DevLearningHub.Api.Configurations;
using DevLearningHub.Api.Data;
using DevLearningHub.Api.DTOs;
using DevLearningHub.Api.Entities;
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
            var handler = new JwtSecurityTokenHandler();
            var principal = handler.ValidateToken(token, new TokenValidationParameters
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
        catch { return null; }
    }
}

public interface IAuthService
{
    Task<ApiResponse<object>> Register(RegisterRequest request, CancellationToken ct);
    Task<ApiResponse<AuthResponse>> Login(LoginRequest request, string? ip, string? ua, CancellationToken ct);
    Task<ApiResponse<AuthResponse>> Refresh(RefreshTokenRequest request, string? ip, string? ua, CancellationToken ct);
    Task<ApiResponse<object>> Logout(long userId, LogoutRequest request, CancellationToken ct);
    Task<ApiResponse<CurrentUserResponse>> Me(long userId, CancellationToken ct);
}

public sealed class AuthService : IAuthService
{
    private readonly DevLearningHubDbContext _db;
    private readonly IJwtTokenService _jwt;
    private readonly JwtSettings _settings;

    public AuthService(DevLearningHubDbContext db, IJwtTokenService jwt, IOptions<JwtSettings> options)
    {
        _db = db; _jwt = jwt; _settings = options.Value;
    }

    public async Task<ApiResponse<object>> Register(RegisterRequest r, CancellationToken ct)
    {
        var errors = new List<ApiError>();
        if (string.IsNullOrWhiteSpace(r.FullName)) errors.Add(new() { Field = "fullName", Message = "Há» tÃªn khÃ´ng Ä‘Æ°á»£c trá»‘ng" });
        if (string.IsNullOrWhiteSpace(r.UserName)) errors.Add(new() { Field = "userName", Message = "TÃªn Ä‘Äƒng nháº­p khÃ´ng Ä‘Æ°á»£c trá»‘ng" });
        if (string.IsNullOrWhiteSpace(r.Email)) errors.Add(new() { Field = "email", Message = "Email khÃ´ng Ä‘Æ°á»£c trá»‘ng" });
        if (r.Password != r.ConfirmPassword) errors.Add(new() { Field = "confirmPassword", Message = "Máº­t kháº©u xÃ¡c nháº­n khÃ´ng khá»›p" });
        if (r.Password.Length < 8 || !r.Password.Any(char.IsUpper) || !r.Password.Any(char.IsLower) || !r.Password.Any(char.IsDigit))
            errors.Add(new() { Field = "password", Message = "Máº­t kháº©u tá»‘i thiá»ƒu 8 kÃ½ tá»±, cÃ³ chá»¯ hoa, chá»¯ thÆ°á»ng vÃ  sá»‘" });
        if (errors.Count > 0) return ApiResponse<object>.Fail("Dá»¯ liá»‡u Ä‘Äƒng kÃ½ khÃ´ng há»£p lá»‡", errors);

        var email = r.Email.Trim().ToLower();
        var username = r.UserName.Trim();
        if (await _db.Users.AnyAsync(x => x.Email == email && !x.IsDeleted, ct))
            return ApiResponse<object>.Fail("Email Ä‘Ã£ tá»“n táº¡i");
        if (await _db.Users.AnyAsync(x => x.UserName == username && !x.IsDeleted, ct))
            return ApiResponse<object>.Fail("TÃªn Ä‘Äƒng nháº­p Ä‘Ã£ tá»“n táº¡i");

        await using var tx = await _db.Database.BeginTransactionAsync(ct);

        var user = new User
        {
            FullName = r.FullName.Trim(),
            UserName = username,
            Email = email,
            PasswordHash = BCrypt.Net.BCrypt.HashPassword(r.Password),
            Status = 1,
            CreatedAt = DateTime.UtcNow
        };
        _db.Users.Add(user);
        await _db.SaveChangesAsync(ct);

        var role = await _db.Roles.FirstOrDefaultAsync(x => x.NormalizedName == "USER", ct);
        if (role != null) _db.UserRoles.Add(new UserRole { UserId = user.Id, RoleId = role.Id, AssignedAt = DateTime.UtcNow });

        _db.UserProfiles.Add(new UserProfile { UserId = user.Id, FullName = user.FullName, AvatarUrl = null, UpdatedAt = DateTime.UtcNow });
        _db.UserLearningProfiles.Add(new UserLearningProfile { UserId = user.Id, CurrentLevel = 1, DailyGoalMinutes = 30, UpdatedAt = DateTime.UtcNow });
        _db.UserStats.Add(new UserStat { UserId = user.Id, UpdatedAt = DateTime.UtcNow });
        _db.UserSettings.Add(new UserSetting { UserId = user.Id, Theme = "light", Language = "vi", CodeEditorTheme = "dark", CodeEditorFontSize = 14, EnableEmailNotification = true, EnablePushNotification = true, UpdatedAt = DateTime.UtcNow });
        await _db.SaveChangesAsync(ct);
        await tx.CommitAsync(ct);

        return ApiResponse<object>.Ok(new { user.Id, user.FullName, user.UserName, user.Email }, "ÄÄƒng kÃ½ thÃ nh cÃ´ng");
    }

    public async Task<ApiResponse<AuthResponse>> Login(LoginRequest r, string? ip, string? ua, CancellationToken ct)
    {
        var value = r.EmailOrUserName.Trim().ToLower();
        var user = await _db.Users
            .Include(x => x.UserRoles).ThenInclude(x => x.Role).ThenInclude(x => x.RolePermissions).ThenInclude(x => x.Permission)
            .Include(x => x.UserPermissions).ThenInclude(x => x.Permission)
            .FirstOrDefaultAsync(x => !x.IsDeleted && (x.Email.ToLower() == value || x.UserName.ToLower() == value), ct);
        if (user == null || string.IsNullOrWhiteSpace(user.PasswordHash) || !BCrypt.Net.BCrypt.Verify(r.Password, user.PasswordHash))
            return ApiResponse<AuthResponse>.Fail("TÃ i khoáº£n hoáº·c máº­t kháº©u khÃ´ng Ä‘Ãºng");
        if (user.Status != 1) return ApiResponse<AuthResponse>.Fail("TÃ i khoáº£n khÃ´ng hoáº¡t Ä‘á»™ng");

        user.LastLoginAt = DateTime.UtcNow;
        user.FailedLoginCount = 0;
        var response = await CreateAuthResponse(user, ip, ua, null, ct);
        await _db.SaveChangesAsync(ct);
        return ApiResponse<AuthResponse>.Ok(response, "ÄÄƒng nháº­p thÃ nh cÃ´ng");
    }

    public async Task<ApiResponse<AuthResponse>> Refresh(RefreshTokenRequest r, string? ip, string? ua, CancellationToken ct)
    {
        var userId = _jwt.GetUserIdFromExpiredToken(r.AccessToken);
        if (userId == null) return ApiResponse<AuthResponse>.Fail("Access token khÃ´ng há»£p lá»‡");
        var hash = _jwt.HashToken(r.RefreshToken);
        var old = await _db.RefreshTokens.FirstOrDefaultAsync(x => x.UserId == userId && x.TokenHash == hash, ct);
        if (old == null || old.RevokedAt != null || old.ExpiresAt <= DateTime.UtcNow) return ApiResponse<AuthResponse>.Fail("Refresh token khÃ´ng há»£p lá»‡");

        var user = await _db.Users.Include(x => x.UserRoles).ThenInclude(x => x.Role).ThenInclude(x => x.RolePermissions).ThenInclude(x => x.Permission)
            .Include(x => x.UserPermissions).ThenInclude(x => x.Permission)
            .FirstOrDefaultAsync(x => x.Id == userId, ct);
        if (user == null) return ApiResponse<AuthResponse>.Fail("KhÃ´ng tÃ¬m tháº¥y ngÆ°á»i dÃ¹ng");
        var response = await CreateAuthResponse(user, ip, ua, old, ct);
        await _db.SaveChangesAsync(ct);
        return ApiResponse<AuthResponse>.Ok(response, "Refresh token thÃ nh cÃ´ng");
    }

    public async Task<ApiResponse<object>> Logout(long userId, LogoutRequest r, CancellationToken ct) { var refreshToken = r?.RefreshToken?.Trim(); if (string.IsNullOrWhiteSpace(refreshToken)) return ApiResponse<object>.Ok(new { }, "ÄÄƒng xuáº¥t thÃ nh cÃ´ng"); var hash = _jwt.HashToken(refreshToken); var token = await _db.RefreshTokens.FirstOrDefaultAsync(x => x.UserId == userId && x.TokenHash == hash, ct); if (token != null && token.RevokedAt == null) { token.RevokedAt = DateTime.UtcNow; await _db.SaveChangesAsync(ct); } return ApiResponse<object>.Ok(new { }, "ÄÄƒng xuáº¥t thÃ nh cÃ´ng"); } public async Task<ApiResponse<CurrentUserResponse>> Me(long userId, CancellationToken ct)
    {
        var user = await _db.Users.Include(x => x.UserRoles).ThenInclude(x => x.Role).ThenInclude(x => x.RolePermissions).ThenInclude(x => x.Permission)
            .Include(x => x.UserPermissions).ThenInclude(x => x.Permission)
            .FirstOrDefaultAsync(x => x.Id == userId && !x.IsDeleted, ct);
        return user == null ? ApiResponse<CurrentUserResponse>.Fail("KhÃ´ng tÃ¬m tháº¥y ngÆ°á»i dÃ¹ng") : ApiResponse<CurrentUserResponse>.Ok(MapUser(user));
    }

    private async Task<AuthResponse> CreateAuthResponse(User user, string? ip, string? ua, RefreshToken? old, CancellationToken ct)
    {
        var roles = user.UserRoles.Select(x => x.Role.Name).Distinct().ToList();
        var permissions = user.UserRoles.SelectMany(x => x.Role.RolePermissions.Select(rp => rp.Permission.Code))
            .Concat(user.UserPermissions.Select(up => up.Permission.Code))
            .Distinct()
            .ToList();
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
        await Task.CompletedTask;
        return new AuthResponse { AccessToken = access, RefreshToken = refresh, ExpiresIn = _settings.AccessTokenExpirationMinutes * 60, User = MapUser(user) };
    }

    private static CurrentUserResponse MapUser(User user) => new()
    {
        Id = user.Id,
        FullName = user.FullName,
        UserName = user.UserName,
        Email = user.Email,
        AvatarUrl = user.AvatarUrl,
        Roles = user.UserRoles.Select(x => x.Role.Name).Distinct().ToList(),
        Permissions = user.UserRoles.SelectMany(x => x.Role.RolePermissions.Select(rp => rp.Permission.Code))
            .Concat(user.UserPermissions.Select(up => up.Permission.Code))
            .Distinct()
            .ToList()
    };
}

