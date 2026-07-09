USE DevLearningHubDb;
GO

IF COL_LENGTH('dbo.Posts', 'AcceptedCommentId') IS NULL
BEGIN
    ALTER TABLE dbo.Posts ADD AcceptedCommentId BIGINT NULL;
END;
GO

IF COL_LENGTH('dbo.Comments', 'IsAcceptedAnswer') IS NULL
BEGIN
    ALTER TABLE dbo.Comments ADD IsAcceptedAnswer BIT NOT NULL CONSTRAINT DF_Comments_IsAcceptedAnswer DEFAULT 0;
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Posts_AcceptedComment')
BEGIN
    ALTER TABLE dbo.Posts
    ADD CONSTRAINT FK_Posts_AcceptedComment FOREIGN KEY (AcceptedCommentId) REFERENCES dbo.Comments(Id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Roles WHERE NormalizedName = 'USER')
    INSERT INTO dbo.Roles (Name, NormalizedName, Description, IsSystemRole, CreatedAt)
    VALUES (N'User', N'USER', N'Người dùng hệ thống', 1, SYSUTCDATETIME());

IF NOT EXISTS (SELECT 1 FROM dbo.Roles WHERE NormalizedName = 'MODERATOR')
    INSERT INTO dbo.Roles (Name, NormalizedName, Description, IsSystemRole, CreatedAt)
    VALUES (N'Moderator', N'MODERATOR', N'Người kiểm duyệt nội dung Forum', 1, SYSUTCDATETIME());

IF NOT EXISTS (SELECT 1 FROM dbo.Roles WHERE NormalizedName = 'ADMIN')
    INSERT INTO dbo.Roles (Name, NormalizedName, Description, IsSystemRole, CreatedAt)
    VALUES (N'Admin', N'ADMIN', N'Quản trị viên hệ thống', 1, SYSUTCDATETIME());
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Permissions WHERE Code = 'forum.answer.accept')
    INSERT INTO dbo.Permissions (Code, Name, Module, Description, CreatedAt)
    VALUES (N'forum.answer.accept', N'Đánh dấu câu trả lời đúng', N'Forum', N'Cho phép đánh dấu/bỏ đánh dấu accepted answer trong Forum', SYSUTCDATETIME());

IF NOT EXISTS (SELECT 1 FROM dbo.Permissions WHERE Code = 'role.manage')
    INSERT INTO dbo.Permissions (Code, Name, Module, Description, CreatedAt)
    VALUES (N'role.manage', N'Quản lý vai trò', N'Auth', N'Cho phép phân quyền tài khoản', SYSUTCDATETIME());
GO

DECLARE @AdminRoleId BIGINT = (SELECT TOP 1 Id FROM dbo.Roles WHERE NormalizedName = 'ADMIN');
DECLARE @ModeratorRoleId BIGINT = (SELECT TOP 1 Id FROM dbo.Roles WHERE NormalizedName = 'MODERATOR');
DECLARE @AcceptPermId BIGINT = (SELECT TOP 1 Id FROM dbo.Permissions WHERE Code = 'forum.answer.accept');
DECLARE @RoleManagePermId BIGINT = (SELECT TOP 1 Id FROM dbo.Permissions WHERE Code = 'role.manage');

IF @AdminRoleId IS NOT NULL AND @AcceptPermId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.RolePermissions WHERE RoleId = @AdminRoleId AND PermissionId = @AcceptPermId)
    INSERT INTO dbo.RolePermissions (RoleId, PermissionId) VALUES (@AdminRoleId, @AcceptPermId);

IF @ModeratorRoleId IS NOT NULL AND @AcceptPermId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.RolePermissions WHERE RoleId = @ModeratorRoleId AND PermissionId = @AcceptPermId)
    INSERT INTO dbo.RolePermissions (RoleId, PermissionId) VALUES (@ModeratorRoleId, @AcceptPermId);

IF @AdminRoleId IS NOT NULL AND @RoleManagePermId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.RolePermissions WHERE RoleId = @AdminRoleId AND PermissionId = @RoleManagePermId)
    INSERT INTO dbo.RolePermissions (RoleId, PermissionId) VALUES (@AdminRoleId, @RoleManagePermId);
GO
