SET NOCOUNT ON;

IF OBJECT_ID(N'dbo.Notifications', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Notifications
    (
        Id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Notifications PRIMARY KEY,
        UserId BIGINT NOT NULL,
        [Type] NVARCHAR(100) NOT NULL,
        Title NVARCHAR(255) NOT NULL,
        [Message] NVARCHAR(1000) NOT NULL,
        LinkUrl NVARCHAR(500) NULL,
        IsRead BIT NOT NULL CONSTRAINT DF_Notifications_IsRead DEFAULT (0),
        ReadAt DATETIME2 NULL,
        CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_Notifications_CreatedAt DEFAULT (SYSUTCDATETIME()),
        MetadataJson NVARCHAR(MAX) NULL
    );
END;

IF COL_LENGTH(N'dbo.Notifications', N'UserId') IS NULL
    ALTER TABLE dbo.Notifications ADD UserId BIGINT NOT NULL CONSTRAINT DF_Notifications_UserId DEFAULT (0);

IF COL_LENGTH(N'dbo.Notifications', N'Type') IS NULL
    ALTER TABLE dbo.Notifications ADD [Type] NVARCHAR(100) NOT NULL CONSTRAINT DF_Notifications_Type DEFAULT (N'system');

IF COL_LENGTH(N'dbo.Notifications', N'Title') IS NULL
    ALTER TABLE dbo.Notifications ADD Title NVARCHAR(255) NOT NULL CONSTRAINT DF_Notifications_Title DEFAULT (N'Notification');

IF COL_LENGTH(N'dbo.Notifications', N'Message') IS NULL
    ALTER TABLE dbo.Notifications ADD [Message] NVARCHAR(1000) NOT NULL CONSTRAINT DF_Notifications_Message DEFAULT (N'');

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
BEGIN
    ALTER TABLE dbo.Notifications WITH CHECK
    ADD CONSTRAINT FK_Notifications_Users_UserId
        FOREIGN KEY (UserId) REFERENCES dbo.Users(Id) ON DELETE NO ACTION;
END;
