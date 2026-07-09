using DevLearningHub.Api.Entities;
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
            new Role { Name = "User", NormalizedName = "USER", Description = "Người dùng hệ thống", IsSystemRole = true, CreatedAt = DateTime.UtcNow },
            new Role { Name = "Moderator", NormalizedName = "MODERATOR", Description = "Người kiểm duyệt", IsSystemRole = true, CreatedAt = DateTime.UtcNow },
            new Role { Name = "Admin", NormalizedName = "ADMIN", Description = "Quản trị viên", IsSystemRole = true, CreatedAt = DateTime.UtcNow }
        };
        foreach (var role in roles)
            if (!await db.Roles.AnyAsync(x => x.NormalizedName == role.NormalizedName)) db.Roles.Add(role);
        await db.SaveChangesAsync();

        var permissions = new[]
        {
            ("user.view", "Xem người dùng", "User"), ("user.manage", "Quản lý người dùng", "User"),
            ("role.manage", "Quản lý vai trò", "Auth"), ("category.manage", "Quản lý chủ đề", "Learning"),
            ("question.manage", "Quản lý câu hỏi", "Learning"), ("quiz.manage", "Quản lý bộ đề", "Learning"),
            ("file.manage", "Quản lý file", "File"), ("code.run", "Chạy code playground", "Code"), ("code.submit", "Nộp bài lập trình", "Code"), ("code.manage", "Quản lý bài lập trình", "Code"), ("forum.moderate", "Kiểm duyệt diễn đàn", "Forum"), ("forum.answer.accept", "Đánh dấu câu trả lời đúng", "Forum"), ("audit.view", "Xem audit", "Audit")
        };
        foreach (var p in permissions)
            if (!await db.Permissions.AnyAsync(x => x.Code == p.Item1))
                db.Permissions.Add(new Permission { Code = p.Item1, Name = p.Item2, Module = p.Item3, CreatedAt = DateTime.UtcNow });
        await db.SaveChangesAsync();

        var adminRole = await db.Roles.FirstAsync(x => x.NormalizedName == "ADMIN");
        foreach (var permissionId in await db.Permissions.Select(x => x.Id).ToListAsync())
            if (!await db.RolePermissions.AnyAsync(x => x.RoleId == adminRole.Id && x.PermissionId == permissionId))
                db.RolePermissions.Add(new RolePermission { RoleId = adminRole.Id, PermissionId = permissionId });
        await db.SaveChangesAsync();
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
            db.UserProfiles.Add(new UserProfile { UserId = admin.Id, FullName = admin.FullName, UpdatedAt = DateTime.UtcNow });
            db.UserLearningProfiles.Add(new UserLearningProfile { UserId = admin.Id, CurrentLevel = 1, DailyGoalMinutes = 30, UpdatedAt = DateTime.UtcNow });
            db.UserStats.Add(new UserStat { UserId = admin.Id, UpdatedAt = DateTime.UtcNow });
            db.UserSettings.Add(new UserSetting { UserId = admin.Id, Theme = "light", Language = "vi", CodeEditorTheme = "dark", CodeEditorFontSize = 14, EnableEmailNotification = true, EnablePushNotification = true, UpdatedAt = DateTime.UtcNow });
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
            db.UserProfiles.Add(new UserProfile { UserId = moderator.Id, FullName = moderator.FullName, UpdatedAt = DateTime.UtcNow });
            db.UserLearningProfiles.Add(new UserLearningProfile { UserId = moderator.Id, CurrentLevel = 1, DailyGoalMinutes = 30, UpdatedAt = DateTime.UtcNow });
            db.UserStats.Add(new UserStat { UserId = moderator.Id, UpdatedAt = DateTime.UtcNow });
            db.UserSettings.Add(new UserSetting { UserId = moderator.Id, Theme = "light", Language = "vi", CodeEditorTheme = "dark", CodeEditorFontSize = 14, EnableEmailNotification = true, EnablePushNotification = true, UpdatedAt = DateTime.UtcNow });
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
            {
                db.RolePermissions.Add(new RolePermission { RoleId = role.Id, PermissionId = permission.Id });
            }
        }
        await db.SaveChangesAsync();
    }

}