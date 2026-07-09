USE DevLearningHubDb;
GO

/* ============================================================
   V13 - User Direct Permissions
   Mục tiêu:
   - Phân quyền theo từng quyền lẻ cho từng tài khoản.
   - Role vẫn tồn tại như nhóm quyền, nhưng Admin có thể gán thêm/bớt permission trực tiếp cho account.
   - Effective permission = quyền từ RolePermissions + quyền trực tiếp từ UserPermissions.
   ============================================================ */

IF OBJECT_ID(N'dbo.UserPermissions', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.UserPermissions (
        UserId BIGINT NOT NULL,
        PermissionId BIGINT NOT NULL,
        AssignedAt DATETIME2 NOT NULL CONSTRAINT DF_UserPermissions_AssignedAt DEFAULT SYSUTCDATETIME(),
        AssignedBy BIGINT NULL,
        CONSTRAINT PK_UserPermissions PRIMARY KEY (UserId, PermissionId),
        CONSTRAINT FK_UserPermissions_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id),
        CONSTRAINT FK_UserPermissions_Permissions FOREIGN KEY (PermissionId) REFERENCES dbo.Permissions(Id)
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_UserPermissions_PermissionId' AND object_id = OBJECT_ID('dbo.UserPermissions'))
BEGIN
    CREATE INDEX IX_UserPermissions_PermissionId ON dbo.UserPermissions(PermissionId);
END;
GO

DECLARE @Permissions TABLE(Code NVARCHAR(100), Name NVARCHAR(150), Module NVARCHAR(100), Description NVARCHAR(255));
INSERT INTO @Permissions(Code, Name, Module, Description)
VALUES
(N'user.view', N'Xem người dùng', N'User', N'Cho phép xem danh sách/người dùng'),
(N'user.manage', N'Quản lý người dùng', N'User', N'Cho phép khóa/mở/tạo/sửa người dùng'),
(N'permission.assign', N'Gán quyền lẻ cho tài khoản', N'Auth', N'Cho phép gán/bỏ gán từng permission trực tiếp cho tài khoản'),
(N'role.manage', N'Quản lý vai trò', N'Auth', N'Cho phép quản lý role/role permission'),
(N'category.manage', N'Quản lý chủ đề', N'Learning', N'Cho phép quản lý category'),
(N'question.manage', N'Quản lý câu hỏi', N'Learning', N'Cho phép quản lý question'),
(N'quiz.manage', N'Quản lý bộ đề', N'Learning', N'Cho phép quản lý quiz set'),
(N'roadmap.manage', N'Quản lý roadmap', N'Learning', N'Cho phép quản lý roadmap'),
(N'code.manage', N'Quản lý bài code', N'Judge', N'Cho phép quản lý coding problems và test cases'),
(N'post.moderate', N'Kiểm duyệt bài viết', N'Forum', N'Cho phép ẩn/khôi phục/xử lý report forum'),
(N'forum.answer.accept', N'Đánh dấu câu trả lời đúng', N'Forum', N'Cho phép đánh dấu/bỏ đánh dấu accepted answer'),
(N'file.manage', N'Quản lý file', N'File', N'Cho phép quản lý file upload'),
(N'audit.view', N'Xem audit log', N'Audit', N'Cho phép xem nhật ký hệ thống');

INSERT INTO dbo.Permissions(Code, Name, Module, Description, CreatedAt)
SELECT p.Code, p.Name, p.Module, p.Description, SYSUTCDATETIME()
FROM @Permissions p
WHERE NOT EXISTS (SELECT 1 FROM dbo.Permissions x WHERE x.Code = p.Code);
GO

DECLARE @AdminRoleId BIGINT = (SELECT TOP 1 Id FROM dbo.Roles WHERE NormalizedName = N'ADMIN');
DECLARE @ModeratorRoleId BIGINT = (SELECT TOP 1 Id FROM dbo.Roles WHERE NormalizedName = N'MODERATOR');

IF @AdminRoleId IS NOT NULL
BEGIN
    INSERT INTO dbo.RolePermissions(RoleId, PermissionId)
    SELECT @AdminRoleId, p.Id
    FROM dbo.Permissions p
    WHERE NOT EXISTS (
        SELECT 1 FROM dbo.RolePermissions rp
        WHERE rp.RoleId = @AdminRoleId AND rp.PermissionId = p.Id
    );
END;

IF @ModeratorRoleId IS NOT NULL
BEGIN
    INSERT INTO dbo.RolePermissions(RoleId, PermissionId)
    SELECT @ModeratorRoleId, p.Id
    FROM dbo.Permissions p
    WHERE p.Code IN (N'post.moderate', N'forum.answer.accept')
      AND NOT EXISTS (
        SELECT 1 FROM dbo.RolePermissions rp
        WHERE rp.RoleId = @ModeratorRoleId AND rp.PermissionId = p.Id
    );
END;
GO

SELECT N'Upgrade v13 User Direct Permissions completed' AS Message;
GO
