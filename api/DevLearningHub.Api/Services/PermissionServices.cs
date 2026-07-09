using DevLearningHub.Api.Common;
using DevLearningHub.Api.Data;
using DevLearningHub.Api.DTOs;
using DevLearningHub.Api.Entities;
using Microsoft.EntityFrameworkCore;

namespace DevLearningHub.Api.Services;

public interface IPermissionService
{
    Task<bool> HasPermission(long userId, string permissionCode, CancellationToken ct);
    Task<EffectivePermissionsResponse?> GetEffectivePermissions(long userId, CancellationToken ct);
    Task<List<string>> GetEffectivePermissionCodes(long userId, CancellationToken ct);
    Task<ApiResponse<List<PermissionGroupResponse>>> GetGroups(CancellationToken ct);
    Task<ApiResponse<PermissionGroupResponse>> GetGroup(long id, CancellationToken ct);
    Task<ApiResponse<PermissionGroupResponse>> CreateGroup(PermissionGroupRequest request, CancellationToken ct);
    Task<ApiResponse<PermissionGroupResponse>> UpdateGroup(long id, PermissionGroupRequest request, CancellationToken ct);
    Task<ApiResponse<object>> DeleteGroup(long id, CancellationToken ct);
    Task<ApiResponse<PermissionGroupResponse>> AssignPermissions(long id, List<long> permissionIds, CancellationToken ct);
    Task<ApiResponse<object>> RemovePermission(long id, long permissionId, CancellationToken ct);
    Task<ApiResponse<object>> AssignGroupsToRole(long roleId, List<long> groupIds, long? actorId, CancellationToken ct);
    Task<ApiResponse<object>> RemoveGroupFromRole(long roleId, long groupId, CancellationToken ct);
    Task<ApiResponse<object>> AssignGroupsToUser(long userId, List<long> groupIds, long? actorId, CancellationToken ct);
    Task<ApiResponse<object>> RemoveGroupFromUser(long userId, long groupId, CancellationToken ct);
}

public sealed class PermissionService : IPermissionService
{
    private readonly DevLearningHubDbContext _db;
    public PermissionService(DevLearningHubDbContext db) => _db = db;

    public async Task<bool> HasPermission(long userId, string permissionCode, CancellationToken ct)
        => (await GetEffectivePermissionCodes(userId, ct)).Contains(permissionCode, StringComparer.OrdinalIgnoreCase);

    public async Task<List<string>> GetEffectivePermissionCodes(long userId, CancellationToken ct)
    {
        var response = await GetEffectivePermissions(userId, ct);
        return response?.EffectivePermissions ?? new List<string>();
    }

    public async Task<EffectivePermissionsResponse?> GetEffectivePermissions(long userId, CancellationToken ct)
    {
        var userExists = await _db.Users.AsNoTracking().AnyAsync(x => x.Id == userId && !x.IsDeleted, ct);
        if (!userExists) return null;

        var directPermissions = await _db.UserPermissions.AsNoTracking()
            .Where(x => x.UserId == userId)
            .Select(x => x.Permission.Code)
            .ToListAsync(ct);

        var rolePermissions = await _db.UserRoles.AsNoTracking()
            .Where(x => x.UserId == userId)
            .SelectMany(x => x.Role.RolePermissions.Select(rp => rp.Permission.Code))
            .ToListAsync(ct);

        var roleGroups = await _db.UserRoles.AsNoTracking()
            .Where(x => x.UserId == userId)
            .SelectMany(x => x.Role.RolePermissionGroups.Select(rpg => rpg.PermissionGroup))
            .Where(x => !x.IsDeleted)
            .Select(x => new PermissionGroupEffectiveResponse
            {
                Id = x.Id,
                Code = x.Code,
                Name = x.Name,
                Permissions = x.PermissionGroupPermissions.Select(p => p.Permission.Code).ToList()
            })
            .ToListAsync(ct);

        var userGroups = await _db.UserPermissionGroups.AsNoTracking()
            .Where(x => x.UserId == userId && !x.PermissionGroup.IsDeleted)
            .Select(x => new PermissionGroupEffectiveResponse
            {
                Id = x.PermissionGroup.Id,
                Code = x.PermissionGroup.Code,
                Name = x.PermissionGroup.Name,
                Permissions = x.PermissionGroup.PermissionGroupPermissions.Select(p => p.Permission.Code).ToList()
            })
            .ToListAsync(ct);

        var effective = directPermissions
            .Concat(rolePermissions)
            .Concat(roleGroups.SelectMany(x => x.Permissions))
            .Concat(userGroups.SelectMany(x => x.Permissions))
            .Where(x => !string.IsNullOrWhiteSpace(x))
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .OrderBy(x => x)
            .ToList();

        return new EffectivePermissionsResponse
        {
            UserId = userId,
            DirectPermissions = directPermissions.Distinct().OrderBy(x => x).ToList(),
            RolePermissions = rolePermissions.Distinct().OrderBy(x => x).ToList(),
            RolePermissionGroups = roleGroups.OrderBy(x => x.Code).ToList(),
            UserPermissionGroups = userGroups.OrderBy(x => x.Code).ToList(),
            EffectivePermissions = effective
        };
    }

    public async Task<ApiResponse<List<PermissionGroupResponse>>> GetGroups(CancellationToken ct)
    {
        var groups = await _db.PermissionGroups.AsNoTracking()
            .Include(x => x.PermissionGroupPermissions).ThenInclude(x => x.Permission)
            .Where(x => !x.IsDeleted)
            .OrderBy(x => x.Code)
            .ToListAsync(ct);
        return ApiResponse<List<PermissionGroupResponse>>.Ok(groups.Select(MapGroup).ToList());
    }

    public async Task<ApiResponse<PermissionGroupResponse>> GetGroup(long id, CancellationToken ct)
    {
        var group = await LoadGroup(id, ct);
        return group == null
            ? ApiResponse<PermissionGroupResponse>.Fail("Permission group not found")
            : ApiResponse<PermissionGroupResponse>.Ok(MapGroup(group));
    }

    public async Task<ApiResponse<PermissionGroupResponse>> CreateGroup(PermissionGroupRequest request, CancellationToken ct)
    {
        var errors = ValidateGroup(request);
        if (errors.Count > 0) return ApiResponse<PermissionGroupResponse>.Fail("Validation failed", errors);

        var code = NormalizeCode(request.Code);
        if (await _db.PermissionGroups.AnyAsync(x => x.Code == code, ct))
            return ApiResponse<PermissionGroupResponse>.Fail("Permission group code already exists");

        var permissionIds = request.PermissionIds.Distinct().ToList();
        if (!await PermissionIdsValid(permissionIds, ct))
            return ApiResponse<PermissionGroupResponse>.Fail("Permission list is invalid");

        var group = new PermissionGroup
        {
            Name = request.Name.Trim(),
            Code = code,
            Description = request.Description,
            CreatedAt = DateTime.UtcNow,
            PermissionGroupPermissions = permissionIds.Select(x => new PermissionGroupPermission { PermissionId = x }).ToList()
        };
        _db.PermissionGroups.Add(group);
        await _db.SaveChangesAsync(ct);
        return ApiResponse<PermissionGroupResponse>.Ok(MapGroup((await LoadGroup(group.Id, ct))!), "Permission group created");
    }

    public async Task<ApiResponse<PermissionGroupResponse>> UpdateGroup(long id, PermissionGroupRequest request, CancellationToken ct)
    {
        var group = await _db.PermissionGroups.Include(x => x.PermissionGroupPermissions).FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, ct);
        if (group == null) return ApiResponse<PermissionGroupResponse>.Fail("Permission group not found");

        var errors = ValidateGroup(request);
        if (errors.Count > 0) return ApiResponse<PermissionGroupResponse>.Fail("Validation failed", errors);
        var code = NormalizeCode(request.Code);
        if (await _db.PermissionGroups.AnyAsync(x => x.Id != id && x.Code == code, ct))
            return ApiResponse<PermissionGroupResponse>.Fail("Permission group code already exists");

        var permissionIds = request.PermissionIds.Distinct().ToList();
        if (!await PermissionIdsValid(permissionIds, ct))
            return ApiResponse<PermissionGroupResponse>.Fail("Permission list is invalid");

        group.Name = request.Name.Trim();
        group.Code = code;
        group.Description = request.Description;
        group.UpdatedAt = DateTime.UtcNow;
        _db.PermissionGroupPermissions.RemoveRange(group.PermissionGroupPermissions);
        foreach (var permissionId in permissionIds)
            group.PermissionGroupPermissions.Add(new PermissionGroupPermission { PermissionGroupId = group.Id, PermissionId = permissionId });
        await _db.SaveChangesAsync(ct);
        return ApiResponse<PermissionGroupResponse>.Ok(MapGroup((await LoadGroup(group.Id, ct))!), "Permission group updated");
    }

    public async Task<ApiResponse<object>> DeleteGroup(long id, CancellationToken ct)
    {
        var group = await _db.PermissionGroups.FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, ct);
        if (group == null) return ApiResponse<object>.Fail("Permission group not found");
        if (group.IsSystem) return ApiResponse<object>.Fail("System permission group cannot be deleted");
        var assigned = await _db.RolePermissionGroups.AnyAsync(x => x.PermissionGroupId == id, ct)
            || await _db.UserPermissionGroups.AnyAsync(x => x.PermissionGroupId == id, ct);
        if (assigned) return ApiResponse<object>.Fail("Permission group is assigned. Detach it before deleting.");
        group.IsDeleted = true;
        group.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { id }, "Permission group deleted");
    }

    public async Task<ApiResponse<PermissionGroupResponse>> AssignPermissions(long id, List<long> permissionIds, CancellationToken ct)
    {
        var group = await _db.PermissionGroups.Include(x => x.PermissionGroupPermissions).FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, ct);
        if (group == null) return ApiResponse<PermissionGroupResponse>.Fail("Permission group not found");
        permissionIds = permissionIds.Distinct().ToList();
        if (!await PermissionIdsValid(permissionIds, ct)) return ApiResponse<PermissionGroupResponse>.Fail("Permission list is invalid");
        _db.PermissionGroupPermissions.RemoveRange(group.PermissionGroupPermissions);
        foreach (var permissionId in permissionIds)
            group.PermissionGroupPermissions.Add(new PermissionGroupPermission { PermissionGroupId = group.Id, PermissionId = permissionId });
        group.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);
        return ApiResponse<PermissionGroupResponse>.Ok(MapGroup((await LoadGroup(id, ct))!), "Permissions assigned to group");
    }

    public async Task<ApiResponse<object>> RemovePermission(long id, long permissionId, CancellationToken ct)
    {
        var row = await _db.PermissionGroupPermissions.FirstOrDefaultAsync(x => x.PermissionGroupId == id && x.PermissionId == permissionId, ct);
        if (row != null)
        {
            _db.PermissionGroupPermissions.Remove(row);
            await _db.SaveChangesAsync(ct);
        }
        return ApiResponse<object>.Ok(new { id, permissionId }, "Permission removed from group");
    }

    public async Task<ApiResponse<object>> AssignGroupsToRole(long roleId, List<long> groupIds, long? actorId, CancellationToken ct)
    {
        if (!await _db.Roles.AnyAsync(x => x.Id == roleId, ct)) return ApiResponse<object>.Fail("Role not found");
        groupIds = groupIds.Distinct().ToList();
        if (!await GroupIdsValid(groupIds, ct)) return ApiResponse<object>.Fail("Permission group list is invalid");
        foreach (var groupId in groupIds)
        {
            if (!await _db.RolePermissionGroups.AnyAsync(x => x.RoleId == roleId && x.PermissionGroupId == groupId, ct))
                _db.RolePermissionGroups.Add(new RolePermissionGroup { RoleId = roleId, PermissionGroupId = groupId, AssignedAt = DateTime.UtcNow, AssignedBy = actorId });
        }
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { roleId, permissionGroupIds = groupIds }, "Permission groups assigned to role");
    }

    public async Task<ApiResponse<object>> RemoveGroupFromRole(long roleId, long groupId, CancellationToken ct)
    {
        var row = await _db.RolePermissionGroups.FirstOrDefaultAsync(x => x.RoleId == roleId && x.PermissionGroupId == groupId, ct);
        if (row != null)
        {
            _db.RolePermissionGroups.Remove(row);
            await _db.SaveChangesAsync(ct);
        }
        return ApiResponse<object>.Ok(new { roleId, permissionGroupId = groupId }, "Permission group removed from role");
    }

    public async Task<ApiResponse<object>> AssignGroupsToUser(long userId, List<long> groupIds, long? actorId, CancellationToken ct)
    {
        if (!await _db.Users.AnyAsync(x => x.Id == userId && !x.IsDeleted, ct)) return ApiResponse<object>.Fail("User not found");
        groupIds = groupIds.Distinct().ToList();
        if (!await GroupIdsValid(groupIds, ct)) return ApiResponse<object>.Fail("Permission group list is invalid");
        foreach (var groupId in groupIds)
        {
            if (!await _db.UserPermissionGroups.AnyAsync(x => x.UserId == userId && x.PermissionGroupId == groupId, ct))
                _db.UserPermissionGroups.Add(new UserPermissionGroup { UserId = userId, PermissionGroupId = groupId, AssignedAt = DateTime.UtcNow, AssignedBy = actorId });
        }
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { userId, permissionGroupIds = groupIds }, "Permission groups assigned to user");
    }

    public async Task<ApiResponse<object>> RemoveGroupFromUser(long userId, long groupId, CancellationToken ct)
    {
        var row = await _db.UserPermissionGroups.FirstOrDefaultAsync(x => x.UserId == userId && x.PermissionGroupId == groupId, ct);
        if (row != null)
        {
            _db.UserPermissionGroups.Remove(row);
            await _db.SaveChangesAsync(ct);
        }
        return ApiResponse<object>.Ok(new { userId, permissionGroupId = groupId }, "Permission group removed from user");
    }

    private async Task<PermissionGroup?> LoadGroup(long id, CancellationToken ct)
        => await _db.PermissionGroups.AsNoTracking()
            .Include(x => x.PermissionGroupPermissions).ThenInclude(x => x.Permission)
            .FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, ct);

    private async Task<bool> PermissionIdsValid(List<long> ids, CancellationToken ct)
        => ids.Count == await _db.Permissions.CountAsync(x => ids.Contains(x.Id), ct);

    private async Task<bool> GroupIdsValid(List<long> ids, CancellationToken ct)
        => ids.Count == await _db.PermissionGroups.CountAsync(x => ids.Contains(x.Id) && !x.IsDeleted, ct);

    private static List<ApiError> ValidateGroup(PermissionGroupRequest request)
    {
        var errors = new List<ApiError>();
        if (string.IsNullOrWhiteSpace(request.Name)) errors.Add(new ApiError { Field = "name", Message = "Name is required" });
        if (string.IsNullOrWhiteSpace(request.Code)) errors.Add(new ApiError { Field = "code", Message = "Code is required" });
        return errors;
    }

    private static string NormalizeCode(string code)
        => (code ?? string.Empty).Trim().ToLowerInvariant().Replace(' ', '_');

    private static PermissionGroupResponse MapGroup(PermissionGroup group) => new()
    {
        Id = group.Id,
        Name = group.Name,
        Code = group.Code,
        Description = group.Description,
        IsSystem = group.IsSystem,
        CreatedAt = group.CreatedAt,
        Permissions = group.PermissionGroupPermissions
            .OrderBy(x => x.Permission.Module)
            .ThenBy(x => x.Permission.Code)
            .Select(x => new AdminPermissionOptionResponse
            {
                Id = x.Permission.Id,
                Code = x.Permission.Code,
                Name = x.Permission.Name,
                Module = x.Permission.Module,
                Description = x.Permission.Description,
                Assigned = true,
                Effective = true
            })
            .ToList()
    };
}
