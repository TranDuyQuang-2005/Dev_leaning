SET NOCOUNT ON;

IF OBJECT_ID(N'dbo.PermissionGroups', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.PermissionGroups
    (
        Id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_PermissionGroups PRIMARY KEY,
        Name NVARCHAR(150) NOT NULL,
        Code NVARCHAR(100) NOT NULL,
        Description NVARCHAR(500) NULL,
        IsSystem BIT NOT NULL CONSTRAINT DF_PermissionGroups_IsSystem DEFAULT 0,
        CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_PermissionGroups_CreatedAt DEFAULT SYSUTCDATETIME(),
        UpdatedAt DATETIME2 NULL,
        IsDeleted BIT NOT NULL CONSTRAINT DF_PermissionGroups_IsDeleted DEFAULT 0
    );
END;

IF OBJECT_ID(N'dbo.PermissionGroupPermissions', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.PermissionGroupPermissions
    (
        PermissionGroupId BIGINT NOT NULL,
        PermissionId BIGINT NOT NULL,
        CONSTRAINT PK_PermissionGroupPermissions PRIMARY KEY (PermissionGroupId, PermissionId)
    );
END;

IF OBJECT_ID(N'dbo.RolePermissionGroups', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.RolePermissionGroups
    (
        RoleId BIGINT NOT NULL,
        PermissionGroupId BIGINT NOT NULL,
        AssignedAt DATETIME2 NOT NULL CONSTRAINT DF_RolePermissionGroups_AssignedAt DEFAULT SYSUTCDATETIME(),
        AssignedBy BIGINT NULL,
        CONSTRAINT PK_RolePermissionGroups PRIMARY KEY (RoleId, PermissionGroupId)
    );
END;

IF OBJECT_ID(N'dbo.UserPermissionGroups', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.UserPermissionGroups
    (
        UserId BIGINT NOT NULL,
        PermissionGroupId BIGINT NOT NULL,
        AssignedAt DATETIME2 NOT NULL CONSTRAINT DF_UserPermissionGroups_AssignedAt DEFAULT SYSUTCDATETIME(),
        AssignedBy BIGINT NULL,
        CONSTRAINT PK_UserPermissionGroups PRIMARY KEY (UserId, PermissionGroupId)
    );
END;

IF OBJECT_ID(N'dbo.PersonalQuestionBanks', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.PersonalQuestionBanks
    (
        Id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_PersonalQuestionBanks PRIMARY KEY,
        UserId BIGINT NOT NULL,
        Title NVARCHAR(255) NOT NULL,
        Description NVARCHAR(MAX) NULL,
        OriginalFileName NVARCHAR(255) NOT NULL,
        FileStorageKey NVARCHAR(500) NOT NULL,
        QuestionCount INT NOT NULL CONSTRAINT DF_PersonalQuestionBanks_QuestionCount DEFAULT 0,
        Visibility NVARCHAR(30) NOT NULL CONSTRAINT DF_PersonalQuestionBanks_Visibility DEFAULT N'Private',
        CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_PersonalQuestionBanks_CreatedAt DEFAULT SYSUTCDATETIME(),
        UpdatedAt DATETIME2 NULL,
        IsDeleted BIT NOT NULL CONSTRAINT DF_PersonalQuestionBanks_IsDeleted DEFAULT 0
    );
END;

IF OBJECT_ID(N'dbo.PersonalQuestions', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.PersonalQuestions
    (
        Id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_PersonalQuestions PRIMARY KEY,
        BankId BIGINT NOT NULL,
        UserId BIGINT NOT NULL,
        QuestionText NVARCHAR(MAX) NOT NULL,
        QuestionType NVARCHAR(50) NOT NULL CONSTRAINT DF_PersonalQuestions_QuestionType DEFAULT N'single_choice',
        Difficulty NVARCHAR(30) NOT NULL CONSTRAINT DF_PersonalQuestions_Difficulty DEFAULT N'medium',
        Explanation NVARCHAR(MAX) NULL,
        Tags NVARCHAR(500) NULL,
        CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_PersonalQuestions_CreatedAt DEFAULT SYSUTCDATETIME(),
        UpdatedAt DATETIME2 NULL,
        IsDeleted BIT NOT NULL CONSTRAINT DF_PersonalQuestions_IsDeleted DEFAULT 0
    );
END;

IF OBJECT_ID(N'dbo.PersonalQuestionOptions', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.PersonalQuestionOptions
    (
        Id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_PersonalQuestionOptions PRIMARY KEY,
        QuestionId BIGINT NOT NULL,
        Label NVARCHAR(5) NOT NULL,
        Text NVARCHAR(MAX) NOT NULL,
        IsCorrect BIT NOT NULL CONSTRAINT DF_PersonalQuestionOptions_IsCorrect DEFAULT 0
    );
END;

IF OBJECT_ID(N'dbo.PersonalPracticeAttempts', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.PersonalPracticeAttempts
    (
        Id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_PersonalPracticeAttempts PRIMARY KEY,
        UserId BIGINT NOT NULL,
        BankId BIGINT NOT NULL,
        StartedAt DATETIME2 NOT NULL CONSTRAINT DF_PersonalPracticeAttempts_StartedAt DEFAULT SYSUTCDATETIME(),
        SubmittedAt DATETIME2 NULL,
        Score DECIMAL(6,2) NOT NULL CONSTRAINT DF_PersonalPracticeAttempts_Score DEFAULT 0,
        TotalQuestions INT NOT NULL CONSTRAINT DF_PersonalPracticeAttempts_TotalQuestions DEFAULT 0,
        CorrectCount INT NOT NULL CONSTRAINT DF_PersonalPracticeAttempts_CorrectCount DEFAULT 0,
        Status NVARCHAR(30) NOT NULL CONSTRAINT DF_PersonalPracticeAttempts_Status DEFAULT N'InProgress'
    );
END;

IF OBJECT_ID(N'dbo.PersonalPracticeAttemptAnswers', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.PersonalPracticeAttemptAnswers
    (
        Id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_PersonalPracticeAttemptAnswers PRIMARY KEY,
        AttemptId BIGINT NOT NULL,
        QuestionId BIGINT NOT NULL,
        SelectedOptionLabel NVARCHAR(5) NULL,
        IsCorrect BIT NOT NULL CONSTRAINT DF_PersonalPracticeAttemptAnswers_IsCorrect DEFAULT 0
    );
END;

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_PermissionGroups_Code' AND object_id = OBJECT_ID(N'dbo.PermissionGroups'))
    CREATE UNIQUE INDEX IX_PermissionGroups_Code ON dbo.PermissionGroups(Code);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_PermissionGroupPermissions_PermissionId' AND object_id = OBJECT_ID(N'dbo.PermissionGroupPermissions'))
    CREATE INDEX IX_PermissionGroupPermissions_PermissionId ON dbo.PermissionGroupPermissions(PermissionId);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_RolePermissionGroups_PermissionGroupId' AND object_id = OBJECT_ID(N'dbo.RolePermissionGroups'))
    CREATE INDEX IX_RolePermissionGroups_PermissionGroupId ON dbo.RolePermissionGroups(PermissionGroupId);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_UserPermissionGroups_PermissionGroupId' AND object_id = OBJECT_ID(N'dbo.UserPermissionGroups'))
    CREATE INDEX IX_UserPermissionGroups_PermissionGroupId ON dbo.UserPermissionGroups(PermissionGroupId);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_PersonalQuestionBanks_UserId_IsDeleted' AND object_id = OBJECT_ID(N'dbo.PersonalQuestionBanks'))
    CREATE INDEX IX_PersonalQuestionBanks_UserId_IsDeleted ON dbo.PersonalQuestionBanks(UserId, IsDeleted);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_PersonalPracticeAttempts_BankId' AND object_id = OBJECT_ID(N'dbo.PersonalPracticeAttempts'))
    CREATE INDEX IX_PersonalPracticeAttempts_BankId ON dbo.PersonalPracticeAttempts(BankId);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_PersonalPracticeAttempts_UserId_BankId' AND object_id = OBJECT_ID(N'dbo.PersonalPracticeAttempts'))
    CREATE INDEX IX_PersonalPracticeAttempts_UserId_BankId ON dbo.PersonalPracticeAttempts(UserId, BankId);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_PersonalQuestions_BankId' AND object_id = OBJECT_ID(N'dbo.PersonalQuestions'))
    CREATE INDEX IX_PersonalQuestions_BankId ON dbo.PersonalQuestions(BankId);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_PersonalQuestions_UserId_BankId_IsDeleted' AND object_id = OBJECT_ID(N'dbo.PersonalQuestions'))
    CREATE INDEX IX_PersonalQuestions_UserId_BankId_IsDeleted ON dbo.PersonalQuestions(UserId, BankId, IsDeleted);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_PersonalPracticeAttemptAnswers_AttemptId' AND object_id = OBJECT_ID(N'dbo.PersonalPracticeAttemptAnswers'))
    CREATE INDEX IX_PersonalPracticeAttemptAnswers_AttemptId ON dbo.PersonalPracticeAttemptAnswers(AttemptId);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_PersonalPracticeAttemptAnswers_QuestionId' AND object_id = OBJECT_ID(N'dbo.PersonalPracticeAttemptAnswers'))
    CREATE INDEX IX_PersonalPracticeAttemptAnswers_QuestionId ON dbo.PersonalPracticeAttemptAnswers(QuestionId);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_PersonalQuestionOptions_QuestionId' AND object_id = OBJECT_ID(N'dbo.PersonalQuestionOptions'))
    CREATE INDEX IX_PersonalQuestionOptions_QuestionId ON dbo.PersonalQuestionOptions(QuestionId);

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_PermissionGroupPermissions_PermissionGroups_PermissionGroupId')
    ALTER TABLE dbo.PermissionGroupPermissions ADD CONSTRAINT FK_PermissionGroupPermissions_PermissionGroups_PermissionGroupId FOREIGN KEY (PermissionGroupId) REFERENCES dbo.PermissionGroups(Id) ON DELETE CASCADE;

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_PermissionGroupPermissions_Permissions_PermissionId')
    ALTER TABLE dbo.PermissionGroupPermissions ADD CONSTRAINT FK_PermissionGroupPermissions_Permissions_PermissionId FOREIGN KEY (PermissionId) REFERENCES dbo.Permissions(Id) ON DELETE CASCADE;

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_RolePermissionGroups_PermissionGroups_PermissionGroupId')
    ALTER TABLE dbo.RolePermissionGroups ADD CONSTRAINT FK_RolePermissionGroups_PermissionGroups_PermissionGroupId FOREIGN KEY (PermissionGroupId) REFERENCES dbo.PermissionGroups(Id) ON DELETE CASCADE;

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_RolePermissionGroups_Roles_RoleId')
    ALTER TABLE dbo.RolePermissionGroups ADD CONSTRAINT FK_RolePermissionGroups_Roles_RoleId FOREIGN KEY (RoleId) REFERENCES dbo.Roles(Id) ON DELETE CASCADE;

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_UserPermissionGroups_PermissionGroups_PermissionGroupId')
    ALTER TABLE dbo.UserPermissionGroups ADD CONSTRAINT FK_UserPermissionGroups_PermissionGroups_PermissionGroupId FOREIGN KEY (PermissionGroupId) REFERENCES dbo.PermissionGroups(Id) ON DELETE CASCADE;

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_UserPermissionGroups_Users_UserId')
    ALTER TABLE dbo.UserPermissionGroups ADD CONSTRAINT FK_UserPermissionGroups_Users_UserId FOREIGN KEY (UserId) REFERENCES dbo.Users(Id) ON DELETE CASCADE;

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_PersonalQuestionBanks_Users_UserId')
    ALTER TABLE dbo.PersonalQuestionBanks ADD CONSTRAINT FK_PersonalQuestionBanks_Users_UserId FOREIGN KEY (UserId) REFERENCES dbo.Users(Id);

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_PersonalQuestions_PersonalQuestionBanks_BankId')
    ALTER TABLE dbo.PersonalQuestions ADD CONSTRAINT FK_PersonalQuestions_PersonalQuestionBanks_BankId FOREIGN KEY (BankId) REFERENCES dbo.PersonalQuestionBanks(Id) ON DELETE CASCADE;

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_PersonalQuestionOptions_PersonalQuestions_QuestionId')
    ALTER TABLE dbo.PersonalQuestionOptions ADD CONSTRAINT FK_PersonalQuestionOptions_PersonalQuestions_QuestionId FOREIGN KEY (QuestionId) REFERENCES dbo.PersonalQuestions(Id) ON DELETE CASCADE;

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_PersonalPracticeAttempts_PersonalQuestionBanks_BankId')
    ALTER TABLE dbo.PersonalPracticeAttempts ADD CONSTRAINT FK_PersonalPracticeAttempts_PersonalQuestionBanks_BankId FOREIGN KEY (BankId) REFERENCES dbo.PersonalQuestionBanks(Id);

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_PersonalPracticeAttemptAnswers_PersonalPracticeAttempts_AttemptId')
    ALTER TABLE dbo.PersonalPracticeAttemptAnswers ADD CONSTRAINT FK_PersonalPracticeAttemptAnswers_PersonalPracticeAttempts_AttemptId FOREIGN KEY (AttemptId) REFERENCES dbo.PersonalPracticeAttempts(Id) ON DELETE CASCADE;

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_PersonalPracticeAttemptAnswers_PersonalQuestions_QuestionId')
    ALTER TABLE dbo.PersonalPracticeAttemptAnswers ADD CONSTRAINT FK_PersonalPracticeAttemptAnswers_PersonalQuestions_QuestionId FOREIGN KEY (QuestionId) REFERENCES dbo.PersonalQuestions(Id);
