using DevLearningHub.Api.Entities;
using System.Data;
using Microsoft.EntityFrameworkCore;

namespace DevLearningHub.Api.Data;

public static class DatabaseSeeder
{
    public static async Task SeedAsync(IServiceProvider services)
    {
        using var scope = services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DevLearningHubDbContext>();
        await EnsureRolesAndPermissions(db);
        await EnsureAdminUser(db);
        await EnsureModeratorUser(db);
    }

    private static async Task EnsureRolesAndPermissions(DevLearningHubDbContext db)
    {
        var roles = new[]
        {
            new Role { Name = "User", NormalizedName = "USER", Description = "Standard learner", IsSystemRole = true, CreatedAt = DateTime.UtcNow },
            new Role { Name = "Moderator", NormalizedName = "MODERATOR", Description = "Forum moderator", IsSystemRole = true, CreatedAt = DateTime.UtcNow },
            new Role { Name = "Admin", NormalizedName = "ADMIN", Description = "System administrator", IsSystemRole = true, CreatedAt = DateTime.UtcNow }
        };
        foreach (var role in roles)
            if (!await db.Roles.AnyAsync(x => x.NormalizedName == role.NormalizedName)) db.Roles.Add(role);
        await db.SaveChangesAsync();

        var permissions = new[]
        {
            ("user.view", "View users", "User"),
            ("user.manage", "Manage users", "User"),
            ("role.manage", "Manage roles", "Auth"),
            ("permission.manage", "Manage permissions", "Auth"),
            ("category.manage", "Manage categories", "Learning"),
            ("question.manage", "Manage questions", "Learning"),
            ("quiz.manage", "Manage quizzes", "Learning"),
            ("forum.moderate", "Moderate forum", "Forum"),
            ("forum.answer.accept", "Accept forum answers", "Forum"),
            ("file.manage", "Manage files", "File"),
            ("code.run", "Run code playground", "Code"),
            ("code.submit", "Submit code", "Code"),
            ("code.manage", "Manage code judge", "Code"),
            ("audit.view", "View audit logs", "Audit"),
            ("personal_practice.manage_own", "Manage own personal practice banks", "Learning")
        };
        foreach (var p in permissions)
            if (!await db.Permissions.AnyAsync(x => x.Code == p.Item1))
                db.Permissions.Add(new Permission { Code = p.Item1, Name = p.Item2, Module = p.Item3, CreatedAt = DateTime.UtcNow });
        await db.SaveChangesAsync();

        var adminRole = await db.Roles.FirstAsync(x => x.NormalizedName == "ADMIN");
        foreach (var permissionId in await db.Permissions.Select(x => x.Id).ToListAsync())
        {
            if (!await db.RolePermissions.AnyAsync(x => x.RoleId == adminRole.Id && x.PermissionId == permissionId))
                db.RolePermissions.Add(new RolePermission { RoleId = adminRole.Id, PermissionId = permissionId });
        }
        await db.SaveChangesAsync();
        if (await PermissionGroupTablesExist(db))
            await EnsurePermissionGroups(db);
    }

    private static async Task EnsurePermissionGroups(DevLearningHubDbContext db)
    {
        var allPermissionCodes = await db.Permissions.Select(x => x.Code).ToListAsync();
        var groups = new (string Name, string Code, string Description, List<string> PermissionCodes)[]
        {
            ("System Admin Group", "system_admin_group", "All system permissions", allPermissionCodes),
            ("Quiz Manager Group", "quiz_manager_group", "Quiz and question management", new List<string> { "category.manage", "question.manage", "quiz.manage" }),
            ("Forum Moderator Group", "forum_moderator_group", "Forum moderation", new List<string> { "forum.moderate", "forum.answer.accept" }),
            ("Code Judge Admin Group", "code_judge_admin_group", "Code judge management", new List<string> { "code.manage", "code.submit", "code.run" }),
            ("Learner Personal Practice Group", "learner_personal_practice_group", "Own personal practice banks", new List<string> { "personal_practice.manage_own", "code.submit", "code.run" })
        };

        foreach (var groupInfo in groups)
        {
            var group = await db.PermissionGroups.Include(x => x.PermissionGroupPermissions).FirstOrDefaultAsync(x => x.Code == groupInfo.Code);
            if (group == null)
            {
                group = new PermissionGroup
                {
                    Name = groupInfo.Name,
                    Code = groupInfo.Code,
                    Description = groupInfo.Description,
                    IsSystem = true,
                    CreatedAt = DateTime.UtcNow
                };
                db.PermissionGroups.Add(group);
                await db.SaveChangesAsync();
            }

            var permissionIds = await db.Permissions.Where(x => groupInfo.PermissionCodes.Contains(x.Code)).Select(x => x.Id).ToListAsync();
            foreach (var permissionId in permissionIds)
            {
                if (!await db.PermissionGroupPermissions.AnyAsync(x => x.PermissionGroupId == group.Id && x.PermissionId == permissionId))
                    db.PermissionGroupPermissions.Add(new PermissionGroupPermission { PermissionGroupId = group.Id, PermissionId = permissionId });
            }
        }
        await db.SaveChangesAsync();

        var adminRole = await db.Roles.FirstAsync(x => x.NormalizedName == "ADMIN");
        var userRole = await db.Roles.FirstAsync(x => x.NormalizedName == "USER");
        var moderatorRole = await db.Roles.FirstAsync(x => x.NormalizedName == "MODERATOR");
        await AssignGroupToRole(db, adminRole.Id, "system_admin_group");
        await AssignGroupToRole(db, userRole.Id, "learner_personal_practice_group");
        await AssignGroupToRole(db, moderatorRole.Id, "forum_moderator_group");
        await db.SaveChangesAsync();
    }

    private static async Task<bool> PermissionGroupTablesExist(DevLearningHubDbContext db)
    {
        return await TableExists(db, "PermissionGroups")
            && await TableExists(db, "PermissionGroupPermissions")
            && await TableExists(db, "RolePermissionGroups")
            && await TableExists(db, "UserPermissionGroups");
    }

    private static async Task<bool> TableExists(DevLearningHubDbContext db, string tableName)
    {
        var connection = db.Database.GetDbConnection();
        var shouldClose = connection.State == ConnectionState.Closed;
        if (shouldClose) await connection.OpenAsync();
        try
        {
            await using var command = connection.CreateCommand();
            command.CommandText = "SELECT COUNT(1) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = @tableName";
            var parameter = command.CreateParameter();
            parameter.ParameterName = "@tableName";
            parameter.Value = tableName;
            command.Parameters.Add(parameter);
            var result = await command.ExecuteScalarAsync();
            return Convert.ToInt32(result) > 0;
        }
        finally
        {
            if (shouldClose) await connection.CloseAsync();
        }
    }

    private static async Task AssignGroupToRole(DevLearningHubDbContext db, long roleId, string groupCode)
    {
        var group = await db.PermissionGroups.FirstOrDefaultAsync(x => x.Code == groupCode);
        if (group != null && !await db.RolePermissionGroups.AnyAsync(x => x.RoleId == roleId && x.PermissionGroupId == group.Id))
            db.RolePermissionGroups.Add(new RolePermissionGroup { RoleId = roleId, PermissionGroupId = group.Id, AssignedAt = DateTime.UtcNow });
    }

    private static async Task EnsureAdminUser(DevLearningHubDbContext db)
    {
        const string email = "admin@example.com";
        var admin = await db.Users.FirstOrDefaultAsync(x => x.Email == email);
        if (admin == null)
        {
            admin = new User
            {
                FullName = "System Admin",
                UserName = "admin",
                Email = email,
                PasswordHash = BCrypt.Net.BCrypt.HashPassword("123456Aa"),
                Status = 1,
                EmailConfirmed = true,
                CreatedAt = DateTime.UtcNow
            };
            db.Users.Add(admin);
            await db.SaveChangesAsync();
            AddDefaultUserRows(db, admin);
            await db.SaveChangesAsync();
        }
        var role = await db.Roles.FirstAsync(x => x.NormalizedName == "ADMIN");
        if (!await db.UserRoles.AnyAsync(x => x.UserId == admin.Id && x.RoleId == role.Id))
        {
            db.UserRoles.Add(new UserRole { UserId = admin.Id, RoleId = role.Id, AssignedAt = DateTime.UtcNow });
            await db.SaveChangesAsync();
        }
    }

    private static async Task EnsureModeratorUser(DevLearningHubDbContext db)
    {
        const string email = "moderator@example.com";
        var moderator = await db.Users.FirstOrDefaultAsync(x => x.Email == email);
        if (moderator == null)
        {
            moderator = new User
            {
                FullName = "Forum Moderator",
                UserName = "moderator",
                Email = email,
                PasswordHash = BCrypt.Net.BCrypt.HashPassword("123456Aa"),
                Status = 1,
                EmailConfirmed = true,
                CreatedAt = DateTime.UtcNow
            };
            db.Users.Add(moderator);
            await db.SaveChangesAsync();
            AddDefaultUserRows(db, moderator);
            await db.SaveChangesAsync();
        }

        var role = await db.Roles.FirstAsync(x => x.NormalizedName == "MODERATOR");
        if (!await db.UserRoles.AnyAsync(x => x.UserId == moderator.Id && x.RoleId == role.Id))
        {
            db.UserRoles.Add(new UserRole { UserId = moderator.Id, RoleId = role.Id, AssignedAt = DateTime.UtcNow });
            await db.SaveChangesAsync();
        }

        var moderatorPermissionCodes = new[] { "forum.moderate", "forum.answer.accept" };
        var moderatorPermissions = await db.Permissions.Where(x => moderatorPermissionCodes.Contains(x.Code)).ToListAsync();
        foreach (var permission in moderatorPermissions)
        {
            if (!await db.RolePermissions.AnyAsync(x => x.RoleId == role.Id && x.PermissionId == permission.Id))
                db.RolePermissions.Add(new RolePermission { RoleId = role.Id, PermissionId = permission.Id });
        }
        await db.SaveChangesAsync();
    }

    private static void AddDefaultUserRows(DevLearningHubDbContext db, User user)
    {
        db.UserProfiles.Add(new UserProfile { UserId = user.Id, FullName = user.FullName, UpdatedAt = DateTime.UtcNow });
        db.UserLearningProfiles.Add(new UserLearningProfile { UserId = user.Id, CurrentLevel = 1, DailyGoalMinutes = 30, UpdatedAt = DateTime.UtcNow });
        db.UserStats.Add(new UserStat { UserId = user.Id, UpdatedAt = DateTime.UtcNow });
        db.UserSettings.Add(new UserSetting { UserId = user.Id, Theme = "light", Language = "vi", CodeEditorTheme = "dark", CodeEditorFontSize = 14, EnableEmailNotification = true, EnablePushNotification = true, UpdatedAt = DateTime.UtcNow });
    }
}
