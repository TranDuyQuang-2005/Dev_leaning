using DevLearningHub.Api.Entities;
using System.Data;
using System.Text.Json;
using Microsoft.EntityFrameworkCore;

namespace DevLearningHub.Api.Data;

public static class DatabaseSeeder
{
    public static async Task SeedAsync(IServiceProvider services)
    {
        using var scope = services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DevLearningHubDbContext>();
        await EnsureRolesAndPermissions(db);
        await EnsureLearningCategories(db);
        await EnsureAdminUser(db);
        await EnsureModeratorUser(db);
        if (await RoadmapTablesExist(db))
            await EnsureRoadmapContent(db);
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
            ("roadmap.manage", "Manage roadmap courses", "Learning"),
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
            ("Roadmap Manager Group", "roadmap_manager_group", "Roadmap and course management", new List<string> { "roadmap.manage", "category.manage", "quiz.manage", "code.manage" }),
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

    private static async Task<bool> RoadmapTablesExist(DevLearningHubDbContext db)
    {
        return await TableExists(db, "LearningTracks")
            && await TableExists(db, "RoadmapCourses")
            && await TableExists(db, "RoadmapModules")
            && await TableExists(db, "RoadmapLessons")
            && await TableExists(db, "UserLessonProgresses");
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

    private static async Task EnsureLearningCategories(DevLearningHubDbContext db)
    {
        var topics = new[]
        {
            "Java",
            "Python",
            "JavaScript",
            "React",
            "SQL",
            "System Design",
            "Algorithms",
            "Cloud",
            "DevOps"
        };

        for (var i = 0; i < topics.Length; i++)
        {
            var name = topics[i];
            var slug = Slugify(name);
            if (await db.Categories.AnyAsync(x => x.Slug == slug || x.Name == name)) continue;

            db.Categories.Add(new Category
            {
                Name = name,
                Slug = slug,
                Description = $"{name} learning track",
                DisplayOrder = (i + 1) * 10,
                Status = 1,
                CreatedAt = DateTime.UtcNow
            });
        }

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

    private static async Task EnsureRoadmapContent(DevLearningHubDbContext db)
    {
        var tracks = new[]
        {
            new LearningTrack { Title = "Frontend Developer", Slug = "frontend-developer", Description = "Lộ trình xây dựng giao diện web hiện đại từ nền tảng đến triển khai.", Level = "Beginner", EstimatedHours = 180, SortOrder = 10, IsPublished = true, CreatedAt = DateTime.UtcNow },
            new LearningTrack { Title = "Backend Developer", Slug = "backend-developer", Description = "Lộ trình API, database, security và vận hành backend.", Level = "Beginner", EstimatedHours = 200, SortOrder = 20, IsPublished = true, CreatedAt = DateTime.UtcNow },
            new LearningTrack { Title = "Fullstack Developer", Slug = "fullstack-developer", Description = "Kết hợp frontend, backend và triển khai sản phẩm hoàn chỉnh.", Level = "Intermediate", EstimatedHours = 260, SortOrder = 30, IsPublished = true, CreatedAt = DateTime.UtcNow },
            new LearningTrack { Title = "Algorithms & Problem Solving", Slug = "algorithms-problem-solving", Description = "Rèn tư duy thuật toán, cấu trúc dữ liệu và luyện giải bài.", Level = "Beginner", EstimatedHours = 150, SortOrder = 40, IsPublished = true, CreatedAt = DateTime.UtcNow },
            new LearningTrack { Title = "DevOps / Cloud", Slug = "devops-cloud", Description = "Nắm CI/CD, container, cloud basics và observability.", Level = "Intermediate", EstimatedHours = 160, SortOrder = 50, IsPublished = true, CreatedAt = DateTime.UtcNow }
        };

        foreach (var seed in tracks)
        {
            if (!await db.LearningTracks.AnyAsync(x => x.Slug == seed.Slug && !x.IsDeleted))
                db.LearningTracks.Add(seed);
        }
        await db.SaveChangesAsync();

        var frontend = await db.LearningTracks.FirstAsync(x => x.Slug == "frontend-developer");
        var backend = await db.LearningTracks.FirstAsync(x => x.Slug == "backend-developer");
        var algorithms = await db.LearningTracks.FirstAsync(x => x.Slug == "algorithms-problem-solving");

        var relatedCourses = new[]
        {
            new { TrackId = frontend.Id, Title = "HTML CSS từ Zero", Slug = "html-css-tu-zero", Level = "Beginner", Hours = 32, Order = 10 },
            new { TrackId = frontend.Id, Title = "JavaScript Cơ bản", Slug = "javascript-co-ban", Level = "Beginner", Hours = 42, Order = 20 },
            new { TrackId = frontend.Id, Title = "JavaScript Nâng cao", Slug = "javascript-nang-cao", Level = "Intermediate", Hours = 48, Order = 30 },
            new { TrackId = backend.Id, Title = "SQL Cơ bản", Slug = "sql-co-ban", Level = "Beginner", Hours = 28, Order = 10 },
            new { TrackId = algorithms.Id, Title = "Algorithms Cơ bản", Slug = "algorithms-co-ban", Level = "Beginner", Hours = 36, Order = 10 }
        };

        foreach (var item in relatedCourses)
        {
            if (await db.RoadmapCourses.AnyAsync(x => x.Slug == item.Slug && !x.IsDeleted)) continue;
            db.RoadmapCourses.Add(new RoadmapCourse
            {
                TrackId = item.TrackId,
                Title = item.Title,
                Slug = item.Slug,
                ShortDescription = $"{item.Title} giúp bạn chuẩn bị nền tảng trước khi vào các khóa chuyên sâu.",
                Description = $"Khóa {item.Title} tập trung vào kiến thức cốt lõi, bài luyện tập ngắn và ví dụ thực tế trong DevLearningHub.",
                Level = item.Level,
                EstimatedHours = item.Hours,
                RequirementsJson = JsonSerializer.Serialize(new[] { "Có máy tính và tinh thần luyện tập đều đặn" }),
                LearningOutcomesJson = JsonSerializer.Serialize(new[] { "Nắm khái niệm nền tảng", "Tự làm được bài tập cơ bản", "Sẵn sàng học khóa tiếp theo" }),
                SortOrder = item.Order,
                IsPublished = true,
                RequiresSequentialCompletion = true,
                CreatedAt = DateTime.UtcNow
            });
        }
        await db.SaveChangesAsync();

        if (await db.RoadmapCourses.AnyAsync(x => x.Slug == "reactjs-co-ban-den-nang-cao" && !x.IsDeleted))
            return;

        var quizSetId = await db.QuizSets
            .Where(x => !x.IsDeleted && (x.Title.Contains("React") || x.Title.Contains("JavaScript") || x.Slug.Contains("react") || x.Slug.Contains("javascript")))
            .OrderBy(x => x.Id)
            .Select(x => (long?)x.Id)
            .FirstOrDefaultAsync();
        var codingProblemId = await db.CodingProblems
            .Where(x => !x.IsDeleted && (x.Title.Contains("JavaScript") || x.Title.Contains("Array") || x.Tags!.Contains("javascript")))
            .OrderBy(x => x.Id)
            .Select(x => (long?)x.Id)
            .FirstOrDefaultAsync();

        var relatedIds = await db.RoadmapCourses
            .Where(x => new[] { "javascript-co-ban", "javascript-nang-cao", "html-css-tu-zero", "sql-co-ban", "algorithms-co-ban" }.Contains(x.Slug))
            .Select(x => x.Id)
            .ToListAsync();
        var reactCourse = new RoadmapCourse
        {
            TrackId = frontend.Id,
            Title = "ReactJS Cơ bản đến nâng cao",
            Slug = "reactjs-co-ban-den-nang-cao",
            ShortDescription = "Học React theo lộ trình module rõ ràng, từ component đến deploy.",
            Description = "Khóa học dẫn bạn qua cách tư duy SPA, JSX, component, hooks, routing, API, state management và xây dựng dự án thực tế.",
            Level = "Intermediate",
            EstimatedHours = 72,
            RequirementsJson = JsonSerializer.Serialize(new[]
            {
                "Hiểu mô hình Client-Server",
                "Nắm HTML/CSS cơ bản",
                "Nắm JavaScript cơ bản",
                "Biết sử dụng npm/node cơ bản"
            }),
            LearningOutcomesJson = JsonSerializer.Serialize(new[]
            {
                "Hiểu SPA/MPA",
                "Hiểu React component, props, state",
                "Sử dụng hooks cơ bản và nâng cao",
                "Làm việc với RESTful API",
                "Sử dụng routing",
                "Quản lý state với Context/Reducer hoặc Redux",
                "Tối ưu hiệu năng React app",
                "Triển khai ứng dụng lên Internet"
            }),
            RelatedCourseIdsJson = JsonSerializer.Serialize(relatedIds),
            PrerequisiteCourseIdsJson = JsonSerializer.Serialize(Array.Empty<long>()),
            SortOrder = 5,
            IsPublished = true,
            RequiresSequentialCompletion = true,
            CreatedAt = DateTime.UtcNow
        };
        db.RoadmapCourses.Add(reactCourse);
        await db.SaveChangesAsync();

        var modules = new (string Title, string Description, int Minutes, string[] Lessons)[]
        {
            ("Giới thiệu ReactJS", "Bức tranh tổng quan về React và cách học hiệu quả.", 45, new[] { "ReactJS là gì?", "SPA/MPA là gì?", "Vì sao nên học React?" }),
            ("Ôn lại JavaScript ES6+", "Các cú pháp JavaScript dùng hằng ngày trong React.", 80, new[] { "Arrow function", "Destructuring / Rest / Spread", "Modules", "Promise / async-await" }),
            ("React, ReactDOM và JSX", "Tạo phần tử, render UI và viết JSX có chủ đích.", 90, new[] { "React.createElement", "ReactDOM", "JSX", "Render list" }),
            ("Components và Props", "Chia UI thành component có thể tái sử dụng.", 95, new[] { "Function component", "Props", "Children props", "Event handling" }),
            ("State và Hooks cơ bản", "Quản lý dữ liệu thay đổi và side effects trong component.", 120, new[] { "useState", "Two-way binding", "useEffect", "useRef" }),
            ("Hooks nâng cao", "Tối ưu và chia sẻ logic với các hook nâng cao.", 130, new[] { "memo", "useCallback", "useMemo", "useReducer", "useContext" }),
            ("Styling trong React", "Tổ chức CSS phù hợp cho dự án React.", 75, new[] { "CSS thường", "CSS Modules", "SCSS", "classnames/clsx" }),
            ("React Router", "Xây dựng điều hướng và bảo vệ route.", 85, new[] { "Cài đặt router", "Layout route", "Protected route" }),
            ("Làm việc với API", "Gọi API, xử lý loading/error và phân trang.", 110, new[] { "RESTful API", "Axios/fetch", "Loading/error state", "Pagination/search" }),
            ("State Management", "Quản lý state ở cấp ứng dụng.", 100, new[] { "Context + reducer", "Redux workflow nếu có", "Redux thunk nếu có" }),
            ("Dự án thực tế", "Hoàn thiện mini project và triển khai.", 180, new[] { "Tạo base project", "Header/sidebar/layout", "Auth UI", "CRUD dữ liệu", "Deploy" })
        };

        for (var moduleIndex = 0; moduleIndex < modules.Length; moduleIndex++)
        {
            var moduleInfo = modules[moduleIndex];
            var module = new RoadmapModule
            {
                CourseId = reactCourse.Id,
                Title = moduleInfo.Title,
                Description = moduleInfo.Description,
                SortOrder = moduleIndex + 1,
                EstimatedMinutes = moduleInfo.Minutes,
                RequiresPreviousModuleCompletion = true,
                IsPublished = true,
                CreatedAt = DateTime.UtcNow
            };
            db.RoadmapModules.Add(module);
            await db.SaveChangesAsync();

            for (var lessonIndex = 0; lessonIndex < moduleInfo.Lessons.Length; lessonIndex++)
            {
                var title = moduleInfo.Lessons[lessonIndex];
                var isQuiz = quizSetId.HasValue && ((moduleIndex == 0 && lessonIndex == 1) || (moduleIndex == 4 && lessonIndex == 2));
                var isCode = codingProblemId.HasValue && ((moduleIndex == 1 && lessonIndex == 0) || (moduleIndex == 2 && lessonIndex == 3));
                db.RoadmapLessons.Add(new RoadmapLesson
                {
                    ModuleId = module.Id,
                    Title = title,
                    Type = isQuiz ? "Quiz" : isCode ? "CodePractice" : lessonIndex % 3 == 0 ? "Video" : "Reading",
                    Content = $"Nội dung mẫu cho bài {title}. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.",
                    VideoUrl = lessonIndex % 3 == 0 ? "https://example.com/roadmap-preview-video" : null,
                    QuizSetId = isQuiz ? quizSetId : null,
                    CodingProblemId = isCode ? codingProblemId : null,
                    EstimatedMinutes = 12 + lessonIndex * 3,
                    SortOrder = lessonIndex + 1,
                    IsPreview = moduleIndex == 0 && lessonIndex == 0,
                    RequiresPreviousLessonCompletion = true,
                    IsRequired = true,
                    IsPublished = true,
                    CreatedAt = DateTime.UtcNow
                });
            }
            await db.SaveChangesAsync();
        }

        reactCourse.TotalModules = await db.RoadmapModules.CountAsync(x => x.CourseId == reactCourse.Id && !x.IsDeleted);
        reactCourse.TotalLessons = await db.RoadmapLessons.CountAsync(x => x.Module.CourseId == reactCourse.Id && !x.IsDeleted);
        reactCourse.UpdatedAt = DateTime.UtcNow;
        await db.SaveChangesAsync();
    }

    private static string Slugify(string value)
    {
        var normalized = value.Trim().ToLowerInvariant().Normalize(System.Text.NormalizationForm.FormD);
        var chars = normalized
            .Where(ch => System.Globalization.CharUnicodeInfo.GetUnicodeCategory(ch) != System.Globalization.UnicodeCategory.NonSpacingMark)
            .Select(ch => char.IsLetterOrDigit(ch) ? ch : '-')
            .ToArray();
        return string.Join('-', new string(chars).Split('-', StringSplitOptions.RemoveEmptyEntries));
    }
}
