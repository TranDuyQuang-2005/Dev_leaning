using DevLearningHub.Api.Common;
using DevLearningHub.Api.Data;
using DevLearningHub.Api.DTOs;
using DevLearningHub.Api.Entities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace DevLearningHub.Api.Controllers;

[ApiController]
[Route("api/v1/admin")]
[Authorize(Roles = "Admin")]
public sealed class AdminController : BaseApiController
{
    private readonly DevLearningHubDbContext _db;
    public AdminController(DevLearningHubDbContext db) => _db = db;

    [HttpGet("users")]
    public async Task<ActionResult<ApiResponse<List<AdminUserResponse>>>> Users(CancellationToken ct)
    {
        var users = await _db.Users.AsNoTracking()
            .Include(x => x.UserRoles).ThenInclude(x => x.Role).ThenInclude(x => x.RolePermissions).ThenInclude(x => x.Permission)
            .Include(x => x.UserPermissions).ThenInclude(x => x.Permission)
            .Where(x => !x.IsDeleted)
            .OrderBy(x => x.Id)
            .ToListAsync(ct);

        return Ok(ApiResponse<List<AdminUserResponse>>.Ok(users.Select(MapUser).ToList()));
    }

    [HttpGet("roles")]
    public async Task<ActionResult<ApiResponse<List<AdminRoleResponse>>>> Roles(CancellationToken ct)
    {
        var roles = await _db.Roles.AsNoTracking()
            .Include(x => x.RolePermissions).ThenInclude(x => x.Permission)
            .OrderBy(x => x.Id)
            .ToListAsync(ct);
        return Ok(ApiResponse<List<AdminRoleResponse>>.Ok(roles.Select(MapRole).ToList()));
    }

    [HttpGet("permissions")]
    public async Task<ActionResult<ApiResponse<List<AdminPermissionOptionResponse>>>> Permissions(CancellationToken ct)
    {
        var permissions = await _db.Permissions.AsNoTracking()
            .OrderBy(x => x.Module)
            .ThenBy(x => x.Code)
            .Select(x => new AdminPermissionOptionResponse
            {
                Id = x.Id,
                Code = x.Code,
                Name = x.Name,
                Module = x.Module,
                Description = x.Description,
                Assigned = false,
                InheritedFromRole = false,
                Effective = false
            })
            .ToListAsync(ct);
        return Ok(ApiResponse<List<AdminPermissionOptionResponse>>.Ok(permissions));
    }

    [HttpGet("users/{userId:long}/roles")]
    public async Task<ActionResult<ApiResponse<AdminUserRolesResponse>>> UserRoles(long userId, CancellationToken ct)
    {
        var response = await BuildUserRolesResponse(userId, ct);
        if (response == null) return Ok(ApiResponse<AdminUserRolesResponse>.Fail("Không tìm thấy tài khoản"));
        return Ok(ApiResponse<AdminUserRolesResponse>.Ok(response));
    }

    [HttpPut("users/{userId:long}/roles")]
    public async Task<ActionResult<ApiResponse<AdminUserRolesResponse>>> UpdateUserRoles(long userId, UpdateUserRolesRequest request, CancellationToken ct)
    {
        var user = await _db.Users.Include(x => x.UserRoles).FirstOrDefaultAsync(x => x.Id == userId && !x.IsDeleted, ct);
        if (user == null) return Ok(ApiResponse<AdminUserRolesResponse>.Fail("Không tìm thấy tài khoản"));

        var roleIds = (request.RoleIds ?? new List<long>()).Distinct().ToList();
        if (roleIds.Count == 0) return Ok(ApiResponse<AdminUserRolesResponse>.Fail("Mỗi tài khoản phải có ít nhất 1 quyền/role"));

        var roles = await _db.Roles.Where(x => roleIds.Contains(x.Id)).ToListAsync(ct);
        if (roles.Count != roleIds.Count) return Ok(ApiResponse<AdminUserRolesResponse>.Fail("Danh sách quyền/role không hợp lệ"));

        if (CurrentUserId == userId)
        {
            var adminRole = await _db.Roles.FirstOrDefaultAsync(x => x.NormalizedName == "ADMIN", ct);
            if (adminRole != null && !roleIds.Contains(adminRole.Id))
            {
                return Ok(ApiResponse<AdminUserRolesResponse>.Fail("Không được tự gỡ quyền Admin của chính tài khoản đang đăng nhập"));
            }
        }

        await using var tx = await _db.Database.BeginTransactionAsync(ct);
        var currentRoles = await _db.UserRoles.Where(x => x.UserId == userId).ToListAsync(ct);
        _db.UserRoles.RemoveRange(currentRoles);
        foreach (var roleId in roleIds)
        {
            _db.UserRoles.Add(new UserRole
            {
                UserId = userId,
                RoleId = roleId,
                AssignedBy = CurrentUserId,
                AssignedAt = DateTime.UtcNow
            });
        }
        user.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);
        await tx.CommitAsync(ct);

        var response = await BuildUserRolesResponse(userId, ct);
        return Ok(ApiResponse<AdminUserRolesResponse>.Ok(response!, "Cập nhật phân quyền tài khoản thành công. Nếu tài khoản đang đăng nhập, cần đăng xuất/đăng nhập lại để JWT nhận quyền mới."));
    }

    [HttpGet("users/{userId:long}/permissions")]
    public async Task<ActionResult<ApiResponse<AdminUserPermissionsResponse>>> UserPermissions(long userId, CancellationToken ct)
    {
        var response = await BuildUserPermissionsResponse(userId, ct);
        if (response == null) return Ok(ApiResponse<AdminUserPermissionsResponse>.Fail("Không tìm thấy tài khoản"));
        return Ok(ApiResponse<AdminUserPermissionsResponse>.Ok(response));
    }

    [HttpPut("users/{userId:long}/permissions")]
    public async Task<ActionResult<ApiResponse<AdminUserPermissionsResponse>>> UpdateUserPermissions(long userId, UpdateUserPermissionsRequest request, CancellationToken ct)
    {
        var user = await _db.Users.Include(x => x.UserPermissions).FirstOrDefaultAsync(x => x.Id == userId && !x.IsDeleted, ct);
        if (user == null) return Ok(ApiResponse<AdminUserPermissionsResponse>.Fail("Không tìm thấy tài khoản"));

        var permissionIds = (request.PermissionIds ?? new List<long>()).Distinct().ToList();
        var permissions = await _db.Permissions.Where(x => permissionIds.Contains(x.Id)).ToListAsync(ct);
        if (permissions.Count != permissionIds.Count)
        {
            return Ok(ApiResponse<AdminUserPermissionsResponse>.Fail("Danh sách quyền lẻ không hợp lệ"));
        }

        if (CurrentUserId == userId)
        {
            var roleManagePermission = await _db.Permissions.FirstOrDefaultAsync(x => x.Code == "role.manage", ct);
            if (roleManagePermission != null)
            {
                var roleManagePermissionId = roleManagePermission.Id;
                var hasRoleManageThroughRole = await _db.UserRoles
                    .Where(x => x.UserId == userId)
                    .SelectMany(x => x.Role.RolePermissions)
                    .AnyAsync(x => x.PermissionId == roleManagePermissionId, ct);

                var keepsRoleManageDirectly = permissionIds.Contains(roleManagePermissionId);
                if (!hasRoleManageThroughRole && !keepsRoleManageDirectly)
                {
                    return Ok(ApiResponse<AdminUserPermissionsResponse>.Fail("Không được tự gỡ quyền role.manage cuối cùng của chính tài khoản đang đăng nhập"));
                }
            }
        }

        await using var tx = await _db.Database.BeginTransactionAsync(ct);
        var currentPermissions = await _db.UserPermissions.Where(x => x.UserId == userId).ToListAsync(ct);
        _db.UserPermissions.RemoveRange(currentPermissions);
        foreach (var permissionId in permissionIds)
        {
            _db.UserPermissions.Add(new UserPermission
            {
                UserId = userId,
                PermissionId = permissionId,
                AssignedBy = CurrentUserId,
                AssignedAt = DateTime.UtcNow
            });
        }
        user.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);
        await tx.CommitAsync(ct);

        var response = await BuildUserPermissionsResponse(userId, ct);
        return Ok(ApiResponse<AdminUserPermissionsResponse>.Ok(response!, "Cập nhật quyền lẻ cho tài khoản thành công. Nếu tài khoản đang đăng nhập, cần logout/login lại để JWT nhận quyền mới."));
    }

    [HttpPost("users/assign-role")]
    public async Task<ActionResult<ApiResponse<object>>> AssignRole(RoleAssignRequest request, CancellationToken ct)
    {
        var exists = await _db.UserRoles.AnyAsync(x => x.UserId == request.UserId && x.RoleId == request.RoleId, ct);
        if (exists) return Ok(ApiResponse<object>.Ok(new { }, "User đã có role này"));

        _db.UserRoles.Add(new UserRole
        {
            UserId = request.UserId,
            RoleId = request.RoleId,
            AssignedBy = CurrentUserId,
            AssignedAt = DateTime.UtcNow
        });
        await _db.SaveChangesAsync(ct);
        return Ok(ApiResponse<object>.Ok(new { }, "Gán role thành công"));
    }

    private async Task<AdminUserPermissionsResponse?> BuildUserPermissionsResponse(long userId, CancellationToken ct)
    {
        var user = await _db.Users.AsNoTracking()
            .Include(x => x.UserRoles).ThenInclude(x => x.Role).ThenInclude(x => x.RolePermissions).ThenInclude(x => x.Permission)
            .Include(x => x.UserPermissions).ThenInclude(x => x.Permission)
            .FirstOrDefaultAsync(x => x.Id == userId && !x.IsDeleted, ct);
        if (user == null) return null;

        var directPermissionIds = user.UserPermissions.Select(x => x.PermissionId).ToHashSet();
        var roleSources = user.UserRoles
            .SelectMany(ur => ur.Role.RolePermissions.Select(rp => new
            {
                rp.PermissionId,
                RoleName = ur.Role.Name
            }))
            .GroupBy(x => x.PermissionId)
            .ToDictionary(g => g.Key, g => g.Select(x => x.RoleName).Distinct().OrderBy(x => x).ToList());

        var permissions = await _db.Permissions.AsNoTracking()
            .OrderBy(x => x.Module)
            .ThenBy(x => x.Code)
            .ToListAsync(ct);

        return new AdminUserPermissionsResponse
        {
            User = MapUser(user),
            Permissions = permissions.Select(permission =>
            {
                var inherited = roleSources.TryGetValue(permission.Id, out var sourceRoles);
                var assigned = directPermissionIds.Contains(permission.Id);
                return new AdminPermissionOptionResponse
                {
                    Id = permission.Id,
                    Code = permission.Code,
                    Name = permission.Name,
                    Module = permission.Module,
                    Description = permission.Description,
                    Assigned = assigned,
                    InheritedFromRole = inherited,
                    Effective = assigned || inherited,
                    SourceRoles = sourceRoles ?? new List<string>()
                };
            }).ToList()
        };
    }

    private async Task<AdminUserRolesResponse?> BuildUserRolesResponse(long userId, CancellationToken ct)
    {
        var user = await _db.Users.AsNoTracking()
            .Include(x => x.UserRoles).ThenInclude(x => x.Role).ThenInclude(x => x.RolePermissions).ThenInclude(x => x.Permission)
            .FirstOrDefaultAsync(x => x.Id == userId && !x.IsDeleted, ct);
        if (user == null) return null;

        var assignedRoleIds = user.UserRoles.Select(x => x.RoleId).ToHashSet();
        var roles = await _db.Roles.AsNoTracking()
            .Include(x => x.RolePermissions).ThenInclude(x => x.Permission)
            .OrderBy(x => x.Id)
            .ToListAsync(ct);

        return new AdminUserRolesResponse
        {
            User = MapUser(user),
            Roles = roles.Select(role => new AdminUserRoleOptionResponse
            {
                Id = role.Id,
                Name = role.Name,
                NormalizedName = role.NormalizedName,
                Description = role.Description,
                IsSystemRole = role.IsSystemRole,
                Permissions = role.RolePermissions.OrderBy(x => x.Permission.Module).ThenBy(x => x.Permission.Code).Select(x => x.Permission.Code).ToList(),
                Assigned = assignedRoleIds.Contains(role.Id)
            }).ToList()
        };
    }

    private static AdminUserResponse MapUser(User user) => new()
    {
        Id = user.Id,
        FullName = user.FullName,
        UserName = user.UserName,
        Email = user.Email,
        Status = user.Status,
        CreatedAt = user.CreatedAt,
        Roles = user.UserRoles
            .OrderBy(x => x.Role.Id)
            .Select(x => MapRole(x.Role))
            .ToList()
    };

    private static AdminRoleResponse MapRole(Role role) => new()
    {
        Id = role.Id,
        Name = role.Name,
        NormalizedName = role.NormalizedName,
        Description = role.Description,
        IsSystemRole = role.IsSystemRole,
        Permissions = role.RolePermissions
            .OrderBy(x => x.Permission.Module)
            .ThenBy(x => x.Permission.Code)
            .Select(x => x.Permission.Code)
            .ToList()
    };
}
