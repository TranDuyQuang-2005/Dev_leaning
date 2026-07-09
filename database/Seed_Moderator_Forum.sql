USE DevLearningHubDb;
GO

-- Script dự phòng nếu muốn kiểm tra nhanh role Moderator sau khi API seeder chạy.
SELECT u.Id, u.Email, u.UserName, r.Name AS RoleName
FROM Users u
JOIN UserRoles ur ON ur.UserId = u.Id
JOIN Roles r ON r.Id = ur.RoleId
WHERE u.Email IN ('admin@example.com','moderator@example.com');
GO
