using System.Text.Json;
using DevLearningHub.Api.Common;
using DevLearningHub.Api.Data;
using DevLearningHub.Api.DTOs;
using DevLearningHub.Api.Entities;
using DevLearningHub.Api.Security;
using DevLearningHub.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace DevLearningHub.Api.Controllers;

[ApiController]
[Route("api/v1/admin")]
[RequirePermission("permission.manage")]
public sealed class AdminPermissionGroupsController : BaseApiController
{
    private readonly IPermissionService _permissions;
    private readonly DevLearningHubDbContext _db;

    public AdminPermissionGroupsController(IPermissionService permissions, DevLearningHubDbContext db)
    {
        _permissions = permissions;
        _db = db;
    }

    [HttpGet("permission-groups")]
    public async Task<ActionResult<ApiResponse<List<PermissionGroupResponse>>>> Groups(CancellationToken ct)
        => Ok(await _permissions.GetGroups(ct));

    [HttpGet("permission-groups/{id:long}")]
    public async Task<ActionResult<ApiResponse<PermissionGroupResponse>>> Group(long id, CancellationToken ct)
    {
        var res = await _permissions.GetGroup(id, ct);
        return res.Success ? Ok(res) : NotFound(res);
    }

    [HttpPost("permission-groups")]
    public async Task<ActionResult<ApiResponse<PermissionGroupResponse>>> CreateGroup(PermissionGroupRequest request, CancellationToken ct)
    {
        var res = await _permissions.CreateGroup(request, ct);
        if (res.Success) await WriteAudit("permission_group.create", "PermissionGroup", res.Data?.Id.ToString(), null, res.Data, ct);
        return res.Success ? Ok(res) : BadRequest(res);
    }

    [HttpPut("permission-groups/{id:long}")]
    public async Task<ActionResult<ApiResponse<PermissionGroupResponse>>> UpdateGroup(long id, PermissionGroupRequest request, CancellationToken ct)
    {
        var old = await _db.PermissionGroups.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id, ct);
        var res = await _permissions.UpdateGroup(id, request, ct);
        if (res.Success) await WriteAudit("permission_group.update", "PermissionGroup", id.ToString(), old, res.Data, ct);
        return res.Success ? Ok(res) : BadRequest(res);
    }

    [HttpDelete("permission-groups/{id:long}")]
    public async Task<ActionResult<ApiResponse<object>>> DeleteGroup(long id, CancellationToken ct)
    {
        var old = await _db.PermissionGroups.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id, ct);
        var res = await _permissions.DeleteGroup(id, ct);
        if (res.Success) await WriteAudit("permission_group.delete", "PermissionGroup", id.ToString(), old, null, ct);
        return res.Success ? Ok(res) : BadRequest(res);
    }

    [HttpPost("permission-groups/{id:long}/permissions")]
    public async Task<ActionResult<ApiResponse<PermissionGroupResponse>>> AssignPermissions(long id, PermissionIdsRequest request, CancellationToken ct)
    {
        var res = await _permissions.AssignPermissions(id, request.PermissionIds, ct);
        if (res.Success) await WriteAudit("permission_group.permissions.assign", "PermissionGroup", id.ToString(), null, request, ct);
        return res.Success ? Ok(res) : BadRequest(res);
    }

    [HttpDelete("permission-groups/{id:long}/permissions/{permissionId:long}")]
    public async Task<ActionResult<ApiResponse<object>>> RemovePermission(long id, long permissionId, CancellationToken ct)
    {
        var res = await _permissions.RemovePermission(id, permissionId, ct);
        if (res.Success) await WriteAudit("permission_group.permissions.remove", "PermissionGroup", id.ToString(), null, new { permissionId }, ct);
        return Ok(res);
    }

    [HttpPost("roles/{roleId:long}/permission-groups")]
    public async Task<ActionResult<ApiResponse<object>>> AssignGroupsToRole(long roleId, PermissionGroupAssignRequest request, CancellationToken ct)
    {
        var res = await _permissions.AssignGroupsToRole(roleId, request.PermissionGroupIds, CurrentUserId, ct);
        if (res.Success) await WriteAudit("role.permission_groups.assign", "Role", roleId.ToString(), null, request, ct);
        return res.Success ? Ok(res) : BadRequest(res);
    }

    [HttpDelete("roles/{roleId:long}/permission-groups/{permissionGroupId:long}")]
    public async Task<ActionResult<ApiResponse<object>>> RemoveGroupFromRole(long roleId, long permissionGroupId, CancellationToken ct)
    {
        var res = await _permissions.RemoveGroupFromRole(roleId, permissionGroupId, ct);
        if (res.Success) await WriteAudit("role.permission_groups.remove", "Role", roleId.ToString(), null, new { permissionGroupId }, ct);
        return Ok(res);
    }

    [HttpPost("users/{userId:long}/permission-groups")]
    public async Task<ActionResult<ApiResponse<object>>> AssignGroupsToUser(long userId, PermissionGroupAssignRequest request, CancellationToken ct)
    {
        var res = await _permissions.AssignGroupsToUser(userId, request.PermissionGroupIds, CurrentUserId, ct);
        if (res.Success) await WriteAudit("user.permission_groups.assign", "User", userId.ToString(), null, request, ct);
        return res.Success ? Ok(res) : BadRequest(res);
    }

    [HttpDelete("users/{userId:long}/permission-groups/{permissionGroupId:long}")]
    public async Task<ActionResult<ApiResponse<object>>> RemoveGroupFromUser(long userId, long permissionGroupId, CancellationToken ct)
    {
        var res = await _permissions.RemoveGroupFromUser(userId, permissionGroupId, ct);
        if (res.Success) await WriteAudit("user.permission_groups.remove", "User", userId.ToString(), null, new { permissionGroupId }, ct);
        return Ok(res);
    }

    [HttpGet("users/{userId:long}/effective-permissions")]
    public async Task<ActionResult<ApiResponse<EffectivePermissionsResponse>>> EffectivePermissions(long userId, CancellationToken ct)
    {
        var res = await _permissions.GetEffectivePermissions(userId, ct);
        return res == null
            ? NotFound(ApiResponse<EffectivePermissionsResponse>.Fail("User not found"))
            : Ok(ApiResponse<EffectivePermissionsResponse>.Ok(res));
    }

    private async Task WriteAudit(string action, string targetType, string? targetId, object? oldValue, object? newValue, CancellationToken ct)
    {
        _db.AuditLogs.Add(new AuditLog
        {
            UserId = CurrentUserId,
            Action = action,
            EntityName = targetType,
            EntityId = targetId,
            OldValues = oldValue == null ? null : JsonSerializer.Serialize(oldValue),
            NewValues = newValue == null ? null : JsonSerializer.Serialize(newValue),
            IpAddress = HttpContext.Connection.RemoteIpAddress?.ToString(),
            UserAgent = Request.Headers.UserAgent.ToString(),
            CreatedAt = DateTime.UtcNow
        });
        await _db.SaveChangesAsync(ct);
    }
}

[ApiController]
[Route("api/v1/admin")]
[Authorize]
public sealed class AdminUsersSecurityController : BaseApiController
{
    private readonly DevLearningHubDbContext _db;
    private readonly INotificationService _notifications;

    public AdminUsersSecurityController(DevLearningHubDbContext db, INotificationService notifications)
    {
        _db = db;
        _notifications = notifications;
    }

    [HttpPost("users/{userId:long}/lock")]
    [RequirePermission("user.manage")]
    public async Task<ActionResult<ApiResponse<object>>> LockUser(long userId, LockUserRequest request, CancellationToken ct)
    {
        var user = await _db.Users.FirstOrDefaultAsync(x => x.Id == userId && !x.IsDeleted, ct);
        if (user == null) return NotFound(ApiResponse<object>.Fail("User not found"));
        if (CurrentUserId == userId)
        {
            var adminRoleId = await _db.Roles.Where(x => x.NormalizedName == "ADMIN").Select(x => x.Id).FirstOrDefaultAsync(ct);
            var adminCount = await _db.UserRoles.CountAsync(x => x.RoleId == adminRoleId && !x.User.IsDeleted, ct);
            if (adminCount <= 1) return BadRequest(ApiResponse<object>.Fail("Cannot lock the last admin account"));
        }
        var old = new { user.Status, user.LockoutEndAt };
        user.Status = 0;
        user.LockoutEndAt = request.LockUntil ?? DateTime.UtcNow.AddDays(3650);
        user.UpdatedAt = DateTime.UtcNow;
        await WriteAudit("user.lock", "User", userId.ToString(), old, new { user.Status, user.LockoutEndAt, request.Reason }, ct);
        await _db.SaveChangesAsync(ct);
        await _notifications.CreateAsync(
            userId,
            "account.locked",
            "Tài khoản đã bị khóa",
            "Tài khoản của bạn đã tạm thời bị khóa. Vui lòng liên hệ quản trị viên nếu bạn cần hỗ trợ.",
            "/login",
            new { eventKey = $"account.locked:{userId}:{user.LockoutEndAt:O}", targetUserId = userId, actorUserId = CurrentUserId },
            ct);
        return Ok(ApiResponse<object>.Ok(new { userId }, "User locked"));
    }

    [HttpPost("users/{userId:long}/unlock")]
    [RequirePermission("user.manage")]
    public async Task<ActionResult<ApiResponse<object>>> UnlockUser(long userId, CancellationToken ct)
    {
        var user = await _db.Users.FirstOrDefaultAsync(x => x.Id == userId && !x.IsDeleted, ct);
        if (user == null) return NotFound(ApiResponse<object>.Fail("User not found"));
        var old = new { user.Status, user.LockoutEndAt };
        user.Status = 1;
        user.LockoutEndAt = null;
        user.FailedLoginCount = 0;
        user.UpdatedAt = DateTime.UtcNow;
        await WriteAudit("user.unlock", "User", userId.ToString(), old, new { user.Status, user.LockoutEndAt }, ct);
        await _db.SaveChangesAsync(ct);
        await _notifications.CreateAsync(
            userId,
            "account.unlocked",
            "Tài khoản đã được mở khóa",
            "Tài khoản của bạn đã được mở khóa. Bạn có thể đăng nhập và tiếp tục học tập.",
            "/login",
            new { eventKey = $"account.unlocked:{userId}:{DateTime.UtcNow:yyyyMMddHHmmss}", targetUserId = userId, actorUserId = CurrentUserId },
            ct);
        return Ok(ApiResponse<object>.Ok(new { userId }, "User unlocked"));
    }

    [HttpGet("audit-logs")]
    [RequirePermission("audit.view")]
    public async Task<ActionResult<ApiResponse<PagedResult<AuditLogResponse>>>> AuditLogs(
        [FromQuery] long? actorUserId,
        [FromQuery] string? action,
        [FromQuery] string? targetType,
        [FromQuery] DateTime? fromDate,
        [FromQuery] DateTime? toDate,
        [FromQuery] int pageIndex = 1,
        [FromQuery] int pageSize = 20,
        CancellationToken ct = default)
    {
        var query = _db.AuditLogs.AsNoTracking().AsQueryable();
        if (actorUserId.HasValue) query = query.Where(x => x.UserId == actorUserId.Value);
        if (!string.IsNullOrWhiteSpace(action)) query = query.Where(x => x.Action.Contains(action));
        if (!string.IsNullOrWhiteSpace(targetType)) query = query.Where(x => x.EntityName == targetType);
        if (fromDate.HasValue) query = query.Where(x => x.CreatedAt >= fromDate.Value);
        if (toDate.HasValue) query = query.Where(x => x.CreatedAt <= toDate.Value);
        pageIndex = Math.Max(1, pageIndex);
        pageSize = Math.Clamp(pageSize, 1, 100);
        var total = await query.CountAsync(ct);
        var rows = await query.OrderByDescending(x => x.CreatedAt).Skip((pageIndex - 1) * pageSize).Take(pageSize)
            .Select(x => new AuditLogResponse
            {
                Id = x.Id,
                ActorUserId = x.UserId,
                Action = x.Action,
                TargetType = x.EntityName,
                TargetId = x.EntityId,
                OldValueJson = x.OldValues,
                NewValueJson = x.NewValues,
                IpAddress = x.IpAddress,
                UserAgent = x.UserAgent,
                CreatedAt = x.CreatedAt
            })
            .ToListAsync(ct);
        return Ok(ApiResponse<PagedResult<AuditLogResponse>>.Ok(PagedResult<AuditLogResponse>.Create(rows, pageIndex, pageSize, total)));
    }

    private async Task WriteAudit(string action, string targetType, string? targetId, object? oldValue, object? newValue, CancellationToken ct)
    {
        _db.AuditLogs.Add(new AuditLog
        {
            UserId = CurrentUserId,
            Action = action,
            EntityName = targetType,
            EntityId = targetId,
            OldValues = oldValue == null ? null : JsonSerializer.Serialize(oldValue),
            NewValues = newValue == null ? null : JsonSerializer.Serialize(newValue),
            IpAddress = HttpContext.Connection.RemoteIpAddress?.ToString(),
            UserAgent = Request.Headers.UserAgent.ToString(),
            CreatedAt = DateTime.UtcNow
        });
        await _db.SaveChangesAsync(ct);
    }
}
