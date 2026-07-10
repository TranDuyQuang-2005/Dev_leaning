SET NOCOUNT ON;

IF OBJECT_ID(N'dbo.Notifications', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Notifications
    (
        Id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Notifications PRIMARY KEY,
        UserId BIGINT NOT NULL,
        NotificationType NVARCHAR(100) NOT NULL CONSTRAINT DF_Notifications_NotificationType DEFAULT (N'general'),
        Title NVARCHAR(255) NOT NULL CONSTRAINT DF_Notifications_Title DEFAULT (N'Thông báo'),
        Content NVARCHAR(MAX) NOT NULL,
        LinkUrl NVARCHAR(500) NULL,
        IsRead BIT NOT NULL CONSTRAINT DF_Notifications_IsRead DEFAULT (0),
        ReadAt DATETIME2 NULL,
        CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_Notifications_CreatedAt DEFAULT (SYSUTCDATETIME()),
        MetadataJson NVARCHAR(MAX) NULL
    );
END;

IF COL_LENGTH(N'dbo.Notifications', N'UserId') IS NULL
    ALTER TABLE dbo.Notifications ADD UserId BIGINT NOT NULL CONSTRAINT DF_Notifications_UserId DEFAULT (0);

IF COL_LENGTH(N'dbo.Notifications', N'Title') IS NULL
    ALTER TABLE dbo.Notifications ADD Title NVARCHAR(255) NOT NULL CONSTRAINT DF_Notifications_Title DEFAULT (N'Thông báo');

IF COL_LENGTH(N'dbo.Notifications', N'Content') IS NULL
    ALTER TABLE dbo.Notifications ADD Content NVARCHAR(MAX) NULL;

IF COL_LENGTH(N'dbo.Notifications', N'NotificationType') IS NULL
BEGIN
    ALTER TABLE dbo.Notifications ADD NotificationType NVARCHAR(100) NULL;

    IF COL_LENGTH(N'dbo.Notifications', N'Type') IS NOT NULL
    BEGIN
        EXEC(N'
            UPDATE dbo.Notifications
            SET NotificationType = NULLIF(LTRIM(RTRIM([Type])), N'''')
            WHERE NotificationType IS NULL OR LTRIM(RTRIM(NotificationType)) = N'''';
        ');
    END;
END;

IF COL_LENGTH(N'dbo.Notifications', N'LinkUrl') IS NULL
    ALTER TABLE dbo.Notifications ADD LinkUrl NVARCHAR(500) NULL;

IF COL_LENGTH(N'dbo.Notifications', N'IsRead') IS NULL
    ALTER TABLE dbo.Notifications ADD IsRead BIT NOT NULL CONSTRAINT DF_Notifications_IsRead DEFAULT (0);

IF COL_LENGTH(N'dbo.Notifications', N'ReadAt') IS NULL
    ALTER TABLE dbo.Notifications ADD ReadAt DATETIME2 NULL;

IF COL_LENGTH(N'dbo.Notifications', N'CreatedAt') IS NULL
    ALTER TABLE dbo.Notifications ADD CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_Notifications_CreatedAt DEFAULT (SYSUTCDATETIME());

IF COL_LENGTH(N'dbo.Notifications', N'MetadataJson') IS NULL
    ALTER TABLE dbo.Notifications ADD MetadataJson NVARCHAR(MAX) NULL;

IF COL_LENGTH(N'dbo.Notifications', N'Message') IS NOT NULL
BEGIN
    EXEC(N'
        UPDATE dbo.Notifications
        SET Content = COALESCE(
            NULLIF(LTRIM(RTRIM(Content)), N''''),
            NULLIF(LTRIM(RTRIM([Message])), N''''),
            NULLIF(LTRIM(RTRIM(Title)), N''''),
            N''Thông báo''
        )
        WHERE Content IS NULL OR LTRIM(RTRIM(Content)) = N'''';
    ');
END
ELSE
BEGIN
    EXEC(N'
        UPDATE dbo.Notifications
        SET Content = COALESCE(
            NULLIF(LTRIM(RTRIM(Content)), N''''),
            NULLIF(LTRIM(RTRIM(Title)), N''''),
            N''Thông báo''
        )
        WHERE Content IS NULL OR LTRIM(RTRIM(Content)) = N'''';
    ');
END;

EXEC(N'
    UPDATE dbo.Notifications
    SET NotificationType = COALESCE(NULLIF(LTRIM(RTRIM(NotificationType)), N''''), N''general'')
    WHERE NotificationType IS NULL OR LTRIM(RTRIM(NotificationType)) = N'''';
');

EXEC(N'
    UPDATE dbo.Notifications
    SET Title = COALESCE(NULLIF(LTRIM(RTRIM(Title)), N''''), N''Thông báo'')
    WHERE Title IS NULL OR LTRIM(RTRIM(Title)) = N'''';
');

IF EXISTS
(
    SELECT 1
    FROM sys.columns
    WHERE object_id = OBJECT_ID(N'dbo.Notifications')
      AND name = N'NotificationType'
      AND is_nullable = 1
)
BEGIN
    ALTER TABLE dbo.Notifications ALTER COLUMN NotificationType NVARCHAR(100) NOT NULL;
END;

IF EXISTS
(
    SELECT 1
    FROM sys.columns
    WHERE object_id = OBJECT_ID(N'dbo.Notifications')
      AND name = N'Content'
      AND is_nullable = 1
)
BEGIN
    ALTER TABLE dbo.Notifications ALTER COLUMN Content NVARCHAR(MAX) NOT NULL;
END;

IF EXISTS
(
    SELECT 1
    FROM sys.columns
    WHERE object_id = OBJECT_ID(N'dbo.Notifications')
      AND name = N'Title'
      AND is_nullable = 1
)
BEGIN
    ALTER TABLE dbo.Notifications ALTER COLUMN Title NVARCHAR(255) NOT NULL;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM sys.default_constraints dc
    JOIN sys.columns c ON c.object_id = dc.parent_object_id AND c.column_id = dc.parent_column_id
    WHERE dc.parent_object_id = OBJECT_ID(N'dbo.Notifications')
      AND c.name = N'NotificationType'
)
BEGIN
    ALTER TABLE dbo.Notifications
    ADD CONSTRAINT DF_Notifications_NotificationType DEFAULT (N'general') FOR NotificationType;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_Notifications_UserId'
      AND object_id = OBJECT_ID(N'dbo.Notifications')
)
BEGIN
    CREATE INDEX IX_Notifications_UserId
        ON dbo.Notifications (UserId);
END;

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_Notifications_IsRead'
      AND object_id = OBJECT_ID(N'dbo.Notifications')
)
BEGIN
    CREATE INDEX IX_Notifications_IsRead
        ON dbo.Notifications (IsRead);
END;

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_Notifications_CreatedAt'
      AND object_id = OBJECT_ID(N'dbo.Notifications')
)
BEGIN
    CREATE INDEX IX_Notifications_CreatedAt
        ON dbo.Notifications (CreatedAt DESC);
END;

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_Notifications_UserId_IsRead_CreatedAt'
      AND object_id = OBJECT_ID(N'dbo.Notifications')
)
BEGIN
    CREATE INDEX IX_Notifications_UserId_IsRead_CreatedAt
        ON dbo.Notifications (UserId, IsRead, CreatedAt DESC);
END;

IF OBJECT_ID(N'dbo.Users', N'U') IS NOT NULL
   AND NOT EXISTS
(
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = N'FK_Notifications_Users_UserId'
      AND parent_object_id = OBJECT_ID(N'dbo.Notifications')
)
   AND NOT EXISTS
(
    SELECT 1
    FROM dbo.Notifications n
    LEFT JOIN dbo.Users u ON u.Id = n.UserId
    WHERE u.Id IS NULL
)
BEGIN
    ALTER TABLE dbo.Notifications WITH CHECK
    ADD CONSTRAINT FK_Notifications_Users_UserId
        FOREIGN KEY (UserId) REFERENCES dbo.Users(Id) ON DELETE NO ACTION;
END;
