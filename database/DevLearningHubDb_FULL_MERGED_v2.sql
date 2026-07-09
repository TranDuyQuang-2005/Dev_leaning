/*
    DevLearningHubDb_FULL_MERGED_v2.sql
    Kiến trúc: Modular Monolith
    Mô hình: 1 API backend + 1 Database duy nhất + client/admin riêng

    Ghi chú:
    - Script này gộp các bảng từ bản Microservices v2 vào 1 database DevLearningHubDb.
    - Không chia AuthDb/UserDb/LearningDb/JudgeDb/ForumDb/... nữa.
    - Các bảng vẫn được giữ theo nhóm module: Auth, User, Learning, Judge, Forum, Notification, File, Gamification, Audit.
*/

IF DB_ID(N'DevLearningHubDb') IS NULL
BEGIN
    CREATE DATABASE DevLearningHubDb;
END
GO

USE DevLearningHubDb;
GO

/* ============================================================
   1. AUTH MODULE
   ============================================================ */

IF OBJECT_ID(N'dbo.UserPermissions', N'U') IS NOT NULL DROP TABLE dbo.UserPermissions;
IF OBJECT_ID(N'dbo.RolePermissions', N'U') IS NOT NULL DROP TABLE dbo.RolePermissions;
IF OBJECT_ID(N'dbo.UserRoles', N'U') IS NOT NULL DROP TABLE dbo.UserRoles;
IF OBJECT_ID(N'dbo.RefreshTokens', N'U') IS NOT NULL DROP TABLE dbo.RefreshTokens;
IF OBJECT_ID(N'dbo.UserDevices', N'U') IS NOT NULL DROP TABLE dbo.UserDevices;
IF OBJECT_ID(N'dbo.EmailVerificationTokens', N'U') IS NOT NULL DROP TABLE dbo.EmailVerificationTokens;
IF OBJECT_ID(N'dbo.PasswordResetTokens', N'U') IS NOT NULL DROP TABLE dbo.PasswordResetTokens;
IF OBJECT_ID(N'dbo.ExternalLogins', N'U') IS NOT NULL DROP TABLE dbo.ExternalLogins;
IF OBJECT_ID(N'dbo.Permissions', N'U') IS NOT NULL DROP TABLE dbo.Permissions;
IF OBJECT_ID(N'dbo.Roles', N'U') IS NOT NULL DROP TABLE dbo.Roles;
IF OBJECT_ID(N'dbo.Users', N'U') IS NOT NULL DROP TABLE dbo.Users;
GO

CREATE TABLE dbo.Users (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    FullName NVARCHAR(150) NOT NULL,
    UserName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) NOT NULL,
    PasswordHash NVARCHAR(500) NULL,
    AvatarUrl NVARCHAR(500) NULL,
    Status TINYINT NOT NULL DEFAULT 1,
    EmailConfirmed BIT NOT NULL DEFAULT 0,
    PhoneNumber NVARCHAR(20) NULL,
    PhoneConfirmed BIT NOT NULL DEFAULT 0,
    LastLoginAt DATETIME2 NULL,
    FailedLoginCount INT NOT NULL DEFAULT 0,
    LockoutEndAt DATETIME2 NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    DeletedAt DATETIME2 NULL
);
GO

CREATE UNIQUE INDEX UX_Users_Email ON dbo.Users(Email);
CREATE UNIQUE INDEX UX_Users_UserName ON dbo.Users(UserName);
GO

CREATE TABLE dbo.Roles (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    NormalizedName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(255) NULL,
    IsSystemRole BIT NOT NULL DEFAULT 0,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

CREATE UNIQUE INDEX UX_Roles_NormalizedName ON dbo.Roles(NormalizedName);
GO

CREATE TABLE dbo.Permissions (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Code NVARCHAR(100) NOT NULL,
    Name NVARCHAR(150) NOT NULL,
    Module NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

CREATE UNIQUE INDEX UX_Permissions_Code ON dbo.Permissions(Code);
GO

CREATE TABLE dbo.UserRoles (
    UserId BIGINT NOT NULL,
    RoleId BIGINT NOT NULL,
    AssignedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    AssignedBy BIGINT NULL,
    CONSTRAINT PK_UserRoles PRIMARY KEY (UserId, RoleId),
    CONSTRAINT FK_UserRoles_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id),
    CONSTRAINT FK_UserRoles_Roles FOREIGN KEY (RoleId) REFERENCES dbo.Roles(Id)
);
GO

CREATE TABLE dbo.RolePermissions (
    RoleId BIGINT NOT NULL,
    PermissionId BIGINT NOT NULL,
    CONSTRAINT PK_RolePermissions PRIMARY KEY (RoleId, PermissionId),
    CONSTRAINT FK_RolePermissions_Roles FOREIGN KEY (RoleId) REFERENCES dbo.Roles(Id),
    CONSTRAINT FK_RolePermissions_Permissions FOREIGN KEY (PermissionId) REFERENCES dbo.Permissions(Id)
);
GO

CREATE TABLE dbo.UserPermissions (
    UserId BIGINT NOT NULL,
    PermissionId BIGINT NOT NULL,
    AssignedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    AssignedBy BIGINT NULL,
    CONSTRAINT PK_UserPermissions PRIMARY KEY (UserId, PermissionId),
    CONSTRAINT FK_UserPermissions_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id),
    CONSTRAINT FK_UserPermissions_Permissions FOREIGN KEY (PermissionId) REFERENCES dbo.Permissions(Id)
);
GO

CREATE INDEX IX_UserPermissions_PermissionId ON dbo.UserPermissions(PermissionId);
GO

CREATE TABLE dbo.UserDevices (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    UserId BIGINT NOT NULL,
    DeviceName NVARCHAR(255) NULL,
    DeviceType NVARCHAR(50) NULL,
    Browser NVARCHAR(100) NULL,
    OperatingSystem NVARCHAR(100) NULL,
    IpAddress NVARCHAR(50) NULL,
    LastUsedAt DATETIME2 NULL,
    IsTrusted BIT NOT NULL DEFAULT 0,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_UserDevices_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id)
);
GO

CREATE TABLE dbo.RefreshTokens (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    UserId BIGINT NOT NULL,
    TokenHash NVARCHAR(500) NOT NULL,
    JwtId NVARCHAR(100) NULL,
    DeviceId BIGINT NULL,
    ExpiresAt DATETIME2 NOT NULL,
    RevokedAt DATETIME2 NULL,
    ReplacedByTokenHash NVARCHAR(500) NULL,
    IpAddress NVARCHAR(50) NULL,
    UserAgent NVARCHAR(500) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_RefreshTokens_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id),
    CONSTRAINT FK_RefreshTokens_UserDevices FOREIGN KEY (DeviceId) REFERENCES dbo.UserDevices(Id)
);
GO

CREATE TABLE dbo.EmailVerificationTokens (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    UserId BIGINT NOT NULL,
    TokenHash NVARCHAR(500) NOT NULL,
    ExpiresAt DATETIME2 NOT NULL,
    UsedAt DATETIME2 NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_EmailVerificationTokens_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id)
);
GO

CREATE TABLE dbo.PasswordResetTokens (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    UserId BIGINT NOT NULL,
    TokenHash NVARCHAR(500) NOT NULL,
    ExpiresAt DATETIME2 NOT NULL,
    UsedAt DATETIME2 NULL,
    IpAddress NVARCHAR(50) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_PasswordResetTokens_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id)
);
GO

CREATE TABLE dbo.ExternalLogins (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    UserId BIGINT NOT NULL,
    Provider NVARCHAR(50) NOT NULL,
    ProviderUserId NVARCHAR(255) NOT NULL,
    ProviderEmail NVARCHAR(255) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_ExternalLogins_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id)
);
GO

CREATE UNIQUE INDEX UX_ExternalLogins_Provider_UserId ON dbo.ExternalLogins(Provider, ProviderUserId);
GO

/* ============================================================
   2. USER MODULE
   ============================================================ */

IF OBJECT_ID(N'dbo.UserDailyActivities', N'U') IS NOT NULL DROP TABLE dbo.UserDailyActivities;
IF OBJECT_ID(N'dbo.UserSettings', N'U') IS NOT NULL DROP TABLE dbo.UserSettings;
IF OBJECT_ID(N'dbo.UserStats', N'U') IS NOT NULL DROP TABLE dbo.UserStats;
IF OBJECT_ID(N'dbo.UserLearningProfiles', N'U') IS NOT NULL DROP TABLE dbo.UserLearningProfiles;
IF OBJECT_ID(N'dbo.UserProfiles', N'U') IS NOT NULL DROP TABLE dbo.UserProfiles;
GO

CREATE TABLE dbo.UserProfiles (
    UserId BIGINT NOT NULL PRIMARY KEY,
    FullName NVARCHAR(150) NULL,
    AvatarUrl NVARCHAR(500) NULL,
    Headline NVARCHAR(255) NULL,
    Bio NVARCHAR(1000) NULL,
    Location NVARCHAR(150) NULL,
    WebsiteUrl NVARCHAR(500) NULL,
    GitHubUrl NVARCHAR(500) NULL,
    LinkedInUrl NVARCHAR(500) NULL,
    Education NVARCHAR(255) NULL,
    Company NVARCHAR(255) NULL,
    UpdatedAt DATETIME2 NULL,
    CONSTRAINT FK_UserProfiles_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id)
);
GO

CREATE TABLE dbo.UserLearningProfiles (
    UserId BIGINT NOT NULL PRIMARY KEY,
    CurrentLevel TINYINT NOT NULL DEFAULT 1,
    TargetRole NVARCHAR(100) NULL,
    PreferredLanguage NVARCHAR(100) NULL,
    DailyGoalMinutes INT NOT NULL DEFAULT 30,
    UpdatedAt DATETIME2 NULL,
    CONSTRAINT FK_UserLearningProfiles_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id)
);
GO

CREATE TABLE dbo.UserStats (
    UserId BIGINT NOT NULL PRIMARY KEY,
    TotalQuizAttempts INT NOT NULL DEFAULT 0,
    TotalCorrectAnswers INT NOT NULL DEFAULT 0,
    AverageQuizScore DECIMAL(5,2) NOT NULL DEFAULT 0,
    TotalCodeSubmissions INT NOT NULL DEFAULT 0,
    AcceptedCodeSubmissions INT NOT NULL DEFAULT 0,
    TotalPosts INT NOT NULL DEFAULT 0,
    TotalComments INT NOT NULL DEFAULT 0,
    Reputation INT NOT NULL DEFAULT 0,
    StreakDays INT NOT NULL DEFAULT 0,
    LastActivityAt DATETIME2 NULL,
    UpdatedAt DATETIME2 NULL,
    CONSTRAINT FK_UserStats_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id)
);
GO

CREATE TABLE dbo.UserSettings (
    UserId BIGINT NOT NULL PRIMARY KEY,
    Theme NVARCHAR(20) NOT NULL DEFAULT N'light',
    Language NVARCHAR(20) NOT NULL DEFAULT N'vi',
    CodeEditorTheme NVARCHAR(50) NOT NULL DEFAULT N'dark',
    CodeEditorFontSize INT NOT NULL DEFAULT 14,
    EnableEmailNotification BIT NOT NULL DEFAULT 1,
    EnablePushNotification BIT NOT NULL DEFAULT 1,
    HasCompletedOnboarding BIT NOT NULL DEFAULT 0,
    UpdatedAt DATETIME2 NULL,
    CONSTRAINT FK_UserSettings_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id)
);
GO

CREATE TABLE dbo.UserDailyActivities (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    UserId BIGINT NOT NULL,
    ActivityDate DATE NOT NULL,
    QuizCompletedCount INT NOT NULL DEFAULT 0,
    CodeSubmissionCount INT NOT NULL DEFAULT 0,
    AcceptedCodeCount INT NOT NULL DEFAULT 0,
    PostCreatedCount INT NOT NULL DEFAULT 0,
    CommentCreatedCount INT NOT NULL DEFAULT 0,
    StudyMinutes INT NOT NULL DEFAULT 0,
    XpEarned INT NOT NULL DEFAULT 0,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL,
    CONSTRAINT FK_UserDailyActivities_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id)
);
GO

CREATE UNIQUE INDEX UX_UserDailyActivities_User_Date ON dbo.UserDailyActivities(UserId, ActivityDate);
GO

/* ============================================================
   3. LEARNING / QUIZ MODULE
   ============================================================ */

IF OBJECT_ID(N'dbo.QuestionImportBatches', N'U') IS NOT NULL DROP TABLE dbo.QuestionImportBatches;
IF OBJECT_ID(N'dbo.UserTopicProgress', N'U') IS NOT NULL DROP TABLE dbo.UserTopicProgress;
IF OBJECT_ID(N'dbo.UserRoadmapProgress', N'U') IS NOT NULL DROP TABLE dbo.UserRoadmapProgress;
IF OBJECT_ID(N'dbo.RoadmapItems', N'U') IS NOT NULL DROP TABLE dbo.RoadmapItems;
IF OBJECT_ID(N'dbo.Roadmaps', N'U') IS NOT NULL DROP TABLE dbo.Roadmaps;
IF OBJECT_ID(N'dbo.QuizAttemptAnswerOptions', N'U') IS NOT NULL DROP TABLE dbo.QuizAttemptAnswerOptions;
IF OBJECT_ID(N'dbo.QuizAttemptAnswers', N'U') IS NOT NULL DROP TABLE dbo.QuizAttemptAnswers;
IF OBJECT_ID(N'dbo.QuizAttempts', N'U') IS NOT NULL DROP TABLE dbo.QuizAttempts;
IF OBJECT_ID(N'dbo.QuizSetQuestions', N'U') IS NOT NULL DROP TABLE dbo.QuizSetQuestions;
IF OBJECT_ID(N'dbo.QuizSets', N'U') IS NOT NULL DROP TABLE dbo.QuizSets;
IF OBJECT_ID(N'dbo.QuestionOptions', N'U') IS NOT NULL DROP TABLE dbo.QuestionOptions;
IF OBJECT_ID(N'dbo.Questions', N'U') IS NOT NULL DROP TABLE dbo.Questions;
IF OBJECT_ID(N'dbo.Categories', N'U') IS NOT NULL DROP TABLE dbo.Categories;
GO

CREATE TABLE dbo.Categories (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ParentId BIGINT NULL,
    Name NVARCHAR(100) NOT NULL,
    Slug NVARCHAR(150) NOT NULL,
    Description NVARCHAR(500) NULL,
    IconUrl NVARCHAR(500) NULL,
    DisplayOrder INT NOT NULL DEFAULT 0,
    Status TINYINT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_Categories_Parent FOREIGN KEY (ParentId) REFERENCES dbo.Categories(Id)
);
GO

CREATE UNIQUE INDEX UX_Categories_Slug ON dbo.Categories(Slug);
GO

CREATE TABLE dbo.Questions (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CategoryId BIGINT NOT NULL,
    CreatedByUserId BIGINT NOT NULL,
    Title NVARCHAR(255) NOT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    Explanation NVARCHAR(MAX) NULL,
    Difficulty TINYINT NOT NULL DEFAULT 1,
    QuestionType TINYINT NOT NULL DEFAULT 1,
    Status TINYINT NOT NULL DEFAULT 1,
    Version INT NOT NULL DEFAULT 1,
    Source NVARCHAR(255) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_Questions_Categories FOREIGN KEY (CategoryId) REFERENCES dbo.Categories(Id),
    CONSTRAINT FK_Questions_Users FOREIGN KEY (CreatedByUserId) REFERENCES dbo.Users(Id)
);
GO

CREATE TABLE dbo.QuestionOptions (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    QuestionId BIGINT NOT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    IsCorrect BIT NOT NULL DEFAULT 0,
    Explanation NVARCHAR(MAX) NULL,
    DisplayOrder INT NOT NULL DEFAULT 0,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_QuestionOptions_Questions FOREIGN KEY (QuestionId) REFERENCES dbo.Questions(Id)
);
GO

CREATE TABLE dbo.QuizSets (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CreatedByUserId BIGINT NOT NULL,
    CategoryId BIGINT NULL,
    Title NVARCHAR(255) NOT NULL,
    Slug NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    Difficulty TINYINT NOT NULL DEFAULT 1,
    QuizType TINYINT NOT NULL DEFAULT 1,
    TimeLimitMinutes INT NULL,
    PassingScore DECIMAL(5,2) NOT NULL DEFAULT 7,
    AllowReview BIT NOT NULL DEFAULT 1,
    ShuffleQuestions BIT NOT NULL DEFAULT 0,
    ShuffleOptions BIT NOT NULL DEFAULT 0,
    MaxAttempts INT NULL,
    Status TINYINT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_QuizSets_Users FOREIGN KEY (CreatedByUserId) REFERENCES dbo.Users(Id),
    CONSTRAINT FK_QuizSets_Categories FOREIGN KEY (CategoryId) REFERENCES dbo.Categories(Id)
);
GO

CREATE UNIQUE INDEX UX_QuizSets_Slug ON dbo.QuizSets(Slug);
GO

CREATE TABLE dbo.QuizSetQuestions (
    QuizSetId BIGINT NOT NULL,
    QuestionId BIGINT NOT NULL,
    DisplayOrder INT NOT NULL DEFAULT 0,
    Score DECIMAL(5,2) NOT NULL DEFAULT 1,
    CONSTRAINT PK_QuizSetQuestions PRIMARY KEY (QuizSetId, QuestionId),
    CONSTRAINT FK_QuizSetQuestions_QuizSets FOREIGN KEY (QuizSetId) REFERENCES dbo.QuizSets(Id),
    CONSTRAINT FK_QuizSetQuestions_Questions FOREIGN KEY (QuestionId) REFERENCES dbo.Questions(Id)
);
GO

CREATE TABLE dbo.QuizAttempts (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    UserId BIGINT NOT NULL,
    QuizSetId BIGINT NOT NULL,
    StartedAt DATETIME2 NOT NULL,
    SubmittedAt DATETIME2 NULL,
    DurationSeconds INT NULL,
    TotalQuestions INT NOT NULL DEFAULT 0,
    CorrectAnswers INT NOT NULL DEFAULT 0,
    WrongAnswers INT NOT NULL DEFAULT 0,
    SkippedAnswers INT NOT NULL DEFAULT 0,
    Score DECIMAL(6,2) NOT NULL DEFAULT 0,
    IsPassed BIT NOT NULL DEFAULT 0,
    Status TINYINT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_QuizAttempts_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id),
    CONSTRAINT FK_QuizAttempts_QuizSets FOREIGN KEY (QuizSetId) REFERENCES dbo.QuizSets(Id)
);
GO

CREATE TABLE dbo.QuizAttemptAnswers (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    QuizAttemptId BIGINT NOT NULL,
    QuestionId BIGINT NOT NULL,
    IsCorrect BIT NOT NULL DEFAULT 0,
    Score DECIMAL(5,2) NOT NULL DEFAULT 0,
    AnsweredAt DATETIME2 NULL,
    CONSTRAINT FK_QuizAttemptAnswers_QuizAttempts FOREIGN KEY (QuizAttemptId) REFERENCES dbo.QuizAttempts(Id),
    CONSTRAINT FK_QuizAttemptAnswers_Questions FOREIGN KEY (QuestionId) REFERENCES dbo.Questions(Id)
);
GO

CREATE TABLE dbo.QuizAttemptAnswerOptions (
    QuizAttemptAnswerId BIGINT NOT NULL,
    QuestionOptionId BIGINT NOT NULL,
    CONSTRAINT PK_QuizAttemptAnswerOptions PRIMARY KEY (QuizAttemptAnswerId, QuestionOptionId),
    CONSTRAINT FK_QAAO_Answers FOREIGN KEY (QuizAttemptAnswerId) REFERENCES dbo.QuizAttemptAnswers(Id),
    CONSTRAINT FK_QAAO_Options FOREIGN KEY (QuestionOptionId) REFERENCES dbo.QuestionOptions(Id)
);
GO

CREATE TABLE dbo.Roadmaps (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CategoryId BIGINT NOT NULL,
    CreatedByUserId BIGINT NOT NULL,
    Title NVARCHAR(255) NOT NULL,
    Slug NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    TargetLevel TINYINT NOT NULL DEFAULT 1,
    EstimatedHours INT NULL,
    Status TINYINT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_Roadmaps_Categories FOREIGN KEY (CategoryId) REFERENCES dbo.Categories(Id),
    CONSTRAINT FK_Roadmaps_Users FOREIGN KEY (CreatedByUserId) REFERENCES dbo.Users(Id)
);
GO

CREATE UNIQUE INDEX UX_Roadmaps_Slug ON dbo.Roadmaps(Slug);
GO

CREATE TABLE dbo.RoadmapItems (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    RoadmapId BIGINT NOT NULL,
    ParentItemId BIGINT NULL,
    Title NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    ItemType TINYINT NOT NULL,
    ReferenceId BIGINT NULL,
    ExternalUrl NVARCHAR(500) NULL,
    DisplayOrder INT NOT NULL DEFAULT 0,
    EstimatedMinutes INT NULL,
    IsRequired BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_RoadmapItems_Roadmaps FOREIGN KEY (RoadmapId) REFERENCES dbo.Roadmaps(Id),
    CONSTRAINT FK_RoadmapItems_Parent FOREIGN KEY (ParentItemId) REFERENCES dbo.RoadmapItems(Id)
);
GO

CREATE TABLE dbo.UserRoadmapProgress (
    UserId BIGINT NOT NULL,
    RoadmapId BIGINT NOT NULL,
    RoadmapItemId BIGINT NOT NULL,
    Status TINYINT NOT NULL DEFAULT 1,
    StartedAt DATETIME2 NULL,
    CompletedAt DATETIME2 NULL,
    UpdatedAt DATETIME2 NULL,
    CONSTRAINT PK_UserRoadmapProgress PRIMARY KEY (UserId, RoadmapItemId),
    CONSTRAINT FK_UserRoadmapProgress_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id),
    CONSTRAINT FK_UserRoadmapProgress_Roadmaps FOREIGN KEY (RoadmapId) REFERENCES dbo.Roadmaps(Id),
    CONSTRAINT FK_UserRoadmapProgress_Items FOREIGN KEY (RoadmapItemId) REFERENCES dbo.RoadmapItems(Id)
);
GO

CREATE TABLE dbo.UserTopicProgress (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    UserId BIGINT NOT NULL,
    CategoryId BIGINT NOT NULL,
    TotalQuestions INT NOT NULL DEFAULT 0,
    CompletedQuestions INT NOT NULL DEFAULT 0,
    CorrectAnswers INT NOT NULL DEFAULT 0,
    ProgressPercent DECIMAL(5,2) NOT NULL DEFAULT 0,
    LastPracticedAt DATETIME2 NULL,
    UpdatedAt DATETIME2 NULL,
    CONSTRAINT FK_UserTopicProgress_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id),
    CONSTRAINT FK_UserTopicProgress_Categories FOREIGN KEY (CategoryId) REFERENCES dbo.Categories(Id)
);
GO

CREATE UNIQUE INDEX UX_UserTopicProgress_User_Category ON dbo.UserTopicProgress(UserId, CategoryId);
GO

/* ============================================================
   4. JUDGE / CODE MODULE
   ============================================================ */

IF OBJECT_ID(N'dbo.SubmissionTestResults', N'U') IS NOT NULL DROP TABLE dbo.SubmissionTestResults;
IF OBJECT_ID(N'dbo.CodeSubmissions', N'U') IS NOT NULL DROP TABLE dbo.CodeSubmissions;
IF OBJECT_ID(N'dbo.CodeRunHistories', N'U') IS NOT NULL DROP TABLE dbo.CodeRunHistories;
IF OBJECT_ID(N'dbo.CodingProblemTags', N'U') IS NOT NULL DROP TABLE dbo.CodingProblemTags;
IF OBJECT_ID(N'dbo.ProblemTags', N'U') IS NOT NULL DROP TABLE dbo.ProblemTags;
IF OBJECT_ID(N'dbo.ProblemTestCases', N'U') IS NOT NULL DROP TABLE dbo.ProblemTestCases;
IF OBJECT_ID(N'dbo.ProblemSupportedLanguages', N'U') IS NOT NULL DROP TABLE dbo.ProblemSupportedLanguages;
IF OBJECT_ID(N'dbo.CodingProblems', N'U') IS NOT NULL DROP TABLE dbo.CodingProblems;
IF OBJECT_ID(N'dbo.ProgrammingLanguages', N'U') IS NOT NULL DROP TABLE dbo.ProgrammingLanguages;
GO

CREATE TABLE dbo.ProgrammingLanguages (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Code NVARCHAR(50) NOT NULL,
    Version NVARCHAR(50) NULL,
    Judge0LanguageId INT NULL,
    DefaultTemplate NVARCHAR(MAX) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

CREATE UNIQUE INDEX UX_ProgrammingLanguages_Code ON dbo.ProgrammingLanguages(Code);
GO

CREATE TABLE dbo.CodingProblems (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CategoryId BIGINT NULL,
    CreatedByUserId BIGINT NOT NULL,
    Title NVARCHAR(255) NOT NULL,
    Slug NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX) NOT NULL,
    InputDescription NVARCHAR(MAX) NULL,
    OutputDescription NVARCHAR(MAX) NULL,
    Constraints NVARCHAR(MAX) NULL,
    SampleInput NVARCHAR(MAX) NULL,
    SampleOutput NVARCHAR(MAX) NULL,
    Difficulty TINYINT NOT NULL DEFAULT 1,
    TimeLimitMs INT NOT NULL DEFAULT 1000,
    MemoryLimitMb INT NOT NULL DEFAULT 128,
    AcceptanceRate DECIMAL(5,2) NOT NULL DEFAULT 0,
    TotalSubmissions INT NOT NULL DEFAULT 0,
    AcceptedSubmissions INT NOT NULL DEFAULT 0,
    Status TINYINT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_CodingProblems_Categories FOREIGN KEY (CategoryId) REFERENCES dbo.Categories(Id),
    CONSTRAINT FK_CodingProblems_Users FOREIGN KEY (CreatedByUserId) REFERENCES dbo.Users(Id)
);
GO

CREATE UNIQUE INDEX UX_CodingProblems_Slug ON dbo.CodingProblems(Slug);
GO

CREATE TABLE dbo.ProblemSupportedLanguages (
    CodingProblemId BIGINT NOT NULL,
    ProgrammingLanguageId BIGINT NOT NULL,
    CONSTRAINT PK_ProblemSupportedLanguages PRIMARY KEY (CodingProblemId, ProgrammingLanguageId),
    CONSTRAINT FK_PSL_Problems FOREIGN KEY (CodingProblemId) REFERENCES dbo.CodingProblems(Id),
    CONSTRAINT FK_PSL_Languages FOREIGN KEY (ProgrammingLanguageId) REFERENCES dbo.ProgrammingLanguages(Id)
);
GO

CREATE TABLE dbo.ProblemTestCases (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CodingProblemId BIGINT NOT NULL,
    InputData NVARCHAR(MAX) NULL,
    ExpectedOutput NVARCHAR(MAX) NULL,
    IsHidden BIT NOT NULL DEFAULT 0,
    ScoreWeight DECIMAL(5,2) NOT NULL DEFAULT 1,
    DisplayOrder INT NOT NULL DEFAULT 0,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_ProblemTestCases_Problems FOREIGN KEY (CodingProblemId) REFERENCES dbo.CodingProblems(Id)
);
GO

CREATE TABLE dbo.ProblemTags (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Slug NVARCHAR(100) NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

CREATE UNIQUE INDEX UX_ProblemTags_Slug ON dbo.ProblemTags(Slug);
GO

CREATE TABLE dbo.CodingProblemTags (
    CodingProblemId BIGINT NOT NULL,
    ProblemTagId BIGINT NOT NULL,
    CONSTRAINT PK_CodingProblemTags PRIMARY KEY (CodingProblemId, ProblemTagId),
    CONSTRAINT FK_CodingProblemTags_Problems FOREIGN KEY (CodingProblemId) REFERENCES dbo.CodingProblems(Id),
    CONSTRAINT FK_CodingProblemTags_Tags FOREIGN KEY (ProblemTagId) REFERENCES dbo.ProblemTags(Id)
);
GO

CREATE TABLE dbo.CodeRunHistories (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    UserId BIGINT NOT NULL,
    CodingProblemId BIGINT NULL,
    ProgrammingLanguageId BIGINT NOT NULL,
    SourceCode NVARCHAR(MAX) NOT NULL,
    Stdin NVARCHAR(MAX) NULL,
    Stdout NVARCHAR(MAX) NULL,
    Stderr NVARCHAR(MAX) NULL,
    Status NVARCHAR(50) NOT NULL,
    ExecutionTimeMs INT NULL,
    MemoryUsedKb INT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_CodeRunHistories_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id),
    CONSTRAINT FK_CodeRunHistories_Problems FOREIGN KEY (CodingProblemId) REFERENCES dbo.CodingProblems(Id),
    CONSTRAINT FK_CodeRunHistories_Languages FOREIGN KEY (ProgrammingLanguageId) REFERENCES dbo.ProgrammingLanguages(Id)
);
GO

CREATE TABLE dbo.CodeSubmissions (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    UserId BIGINT NOT NULL,
    CodingProblemId BIGINT NOT NULL,
    ProgrammingLanguageId BIGINT NOT NULL,
    SourceCode NVARCHAR(MAX) NOT NULL,
    Status NVARCHAR(50) NOT NULL DEFAULT N'Pending',
    TotalTestCases INT NOT NULL DEFAULT 0,
    PassedTestCases INT NOT NULL DEFAULT 0,
    Score DECIMAL(6,2) NOT NULL DEFAULT 0,
    ExecutionTimeMs INT NULL,
    MemoryUsedKb INT NULL,
    ErrorMessage NVARCHAR(MAX) NULL,
    JudgeToken NVARCHAR(255) NULL,
    SubmittedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    JudgedAt DATETIME2 NULL,
    CONSTRAINT FK_CodeSubmissions_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id),
    CONSTRAINT FK_CodeSubmissions_Problems FOREIGN KEY (CodingProblemId) REFERENCES dbo.CodingProblems(Id),
    CONSTRAINT FK_CodeSubmissions_Languages FOREIGN KEY (ProgrammingLanguageId) REFERENCES dbo.ProgrammingLanguages(Id)
);
GO

CREATE TABLE dbo.SubmissionTestResults (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CodeSubmissionId BIGINT NOT NULL,
    ProblemTestCaseId BIGINT NOT NULL,
    Status NVARCHAR(50) NOT NULL,
    ActualOutput NVARCHAR(MAX) NULL,
    ExpectedOutput NVARCHAR(MAX) NULL,
    ExecutionTimeMs INT NULL,
    MemoryUsedKb INT NULL,
    ErrorMessage NVARCHAR(MAX) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_SubmissionTestResults_Submissions FOREIGN KEY (CodeSubmissionId) REFERENCES dbo.CodeSubmissions(Id),
    CONSTRAINT FK_SubmissionTestResults_TestCases FOREIGN KEY (ProblemTestCaseId) REFERENCES dbo.ProblemTestCases(Id)
);
GO

/* ============================================================
   5. FORUM MODULE
   ============================================================ */

IF OBJECT_ID(N'dbo.ModerationActions', N'U') IS NOT NULL DROP TABLE dbo.ModerationActions;
IF OBJECT_ID(N'dbo.Reports', N'U') IS NOT NULL DROP TABLE dbo.Reports;
IF OBJECT_ID(N'dbo.PostBookmarks', N'U') IS NOT NULL DROP TABLE dbo.PostBookmarks;
IF OBJECT_ID(N'dbo.CommentVotes', N'U') IS NOT NULL DROP TABLE dbo.CommentVotes;
IF OBJECT_ID(N'dbo.PostVotes', N'U') IS NOT NULL DROP TABLE dbo.PostVotes;
IF OBJECT_ID(N'dbo.PostTags', N'U') IS NOT NULL DROP TABLE dbo.PostTags;
IF OBJECT_ID(N'dbo.Comments', N'U') IS NOT NULL DROP TABLE dbo.Comments;
IF OBJECT_ID(N'dbo.Posts', N'U') IS NOT NULL DROP TABLE dbo.Posts;
IF OBJECT_ID(N'dbo.Tags', N'U') IS NOT NULL DROP TABLE dbo.Tags;
GO

CREATE TABLE dbo.Tags (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Slug NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

CREATE UNIQUE INDEX UX_Tags_Slug ON dbo.Tags(Slug);
GO

CREATE TABLE dbo.Posts (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    AuthorId BIGINT NOT NULL,
    Title NVARCHAR(255) NOT NULL,
    Slug NVARCHAR(255) NOT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    ContentHtml NVARCHAR(MAX) NULL,
    ViewCount INT NOT NULL DEFAULT 0,
    VoteScore INT NOT NULL DEFAULT 0,
    AnswerCount INT NOT NULL DEFAULT 0,
    AcceptedCommentId BIGINT NULL,
    Status TINYINT NOT NULL DEFAULT 1,
    LastActivityAt DATETIME2 NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_Posts_Users FOREIGN KEY (AuthorId) REFERENCES dbo.Users(Id)
);
GO

CREATE UNIQUE INDEX UX_Posts_Slug ON dbo.Posts(Slug);
GO

CREATE TABLE dbo.Comments (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    PostId BIGINT NOT NULL,
    AuthorId BIGINT NOT NULL,
    ParentCommentId BIGINT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    ContentHtml NVARCHAR(MAX) NULL,
    VoteScore INT NOT NULL DEFAULT 0,
    IsAcceptedAnswer BIT NOT NULL DEFAULT 0,
    Status TINYINT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_Comments_Posts FOREIGN KEY (PostId) REFERENCES dbo.Posts(Id),
    CONSTRAINT FK_Comments_Users FOREIGN KEY (AuthorId) REFERENCES dbo.Users(Id),
    CONSTRAINT FK_Comments_Parent FOREIGN KEY (ParentCommentId) REFERENCES dbo.Comments(Id)
);
GO

ALTER TABLE dbo.Posts
ADD CONSTRAINT FK_Posts_AcceptedComment FOREIGN KEY (AcceptedCommentId) REFERENCES dbo.Comments(Id);
GO

CREATE TABLE dbo.PostTags (
    PostId BIGINT NOT NULL,
    TagId BIGINT NOT NULL,
    CONSTRAINT PK_PostTags PRIMARY KEY (PostId, TagId),
    CONSTRAINT FK_PostTags_Posts FOREIGN KEY (PostId) REFERENCES dbo.Posts(Id),
    CONSTRAINT FK_PostTags_Tags FOREIGN KEY (TagId) REFERENCES dbo.Tags(Id)
);
GO

CREATE TABLE dbo.PostVotes (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    PostId BIGINT NOT NULL,
    UserId BIGINT NOT NULL,
    VoteType SMALLINT NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_PostVotes_Posts FOREIGN KEY (PostId) REFERENCES dbo.Posts(Id),
    CONSTRAINT FK_PostVotes_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id)
);
GO

CREATE UNIQUE INDEX UX_PostVotes_Post_User ON dbo.PostVotes(PostId, UserId);
GO

CREATE TABLE dbo.CommentVotes (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CommentId BIGINT NOT NULL,
    UserId BIGINT NOT NULL,
    VoteType SMALLINT NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_CommentVotes_Comments FOREIGN KEY (CommentId) REFERENCES dbo.Comments(Id),
    CONSTRAINT FK_CommentVotes_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id)
);
GO

CREATE UNIQUE INDEX UX_CommentVotes_Comment_User ON dbo.CommentVotes(CommentId, UserId);
GO

CREATE TABLE dbo.PostBookmarks (
    PostId BIGINT NOT NULL,
    UserId BIGINT NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_PostBookmarks PRIMARY KEY (PostId, UserId),
    CONSTRAINT FK_PostBookmarks_Posts FOREIGN KEY (PostId) REFERENCES dbo.Posts(Id),
    CONSTRAINT FK_PostBookmarks_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id)
);
GO

CREATE TABLE dbo.Reports (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ReporterId BIGINT NOT NULL,
    TargetType NVARCHAR(50) NOT NULL,
    TargetId BIGINT NOT NULL,
    Reason NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    Status TINYINT NOT NULL DEFAULT 1,
    ResolvedByUserId BIGINT NULL,
    ResolvedAt DATETIME2 NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Reports_Reporter FOREIGN KEY (ReporterId) REFERENCES dbo.Users(Id),
    CONSTRAINT FK_Reports_Resolver FOREIGN KEY (ResolvedByUserId) REFERENCES dbo.Users(Id)
);
GO

CREATE TABLE dbo.ModerationActions (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ModeratorId BIGINT NOT NULL,
    TargetType NVARCHAR(50) NOT NULL,
    TargetId BIGINT NOT NULL,
    ActionType NVARCHAR(100) NOT NULL,
    Reason NVARCHAR(255) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_ModerationActions_Users FOREIGN KEY (ModeratorId) REFERENCES dbo.Users(Id)
);
GO

/* ============================================================
   6. NOTIFICATION MODULE
   ============================================================ */

IF OBJECT_ID(N'dbo.UserNotificationSettings', N'U') IS NOT NULL DROP TABLE dbo.UserNotificationSettings;
IF OBJECT_ID(N'dbo.NotificationTemplates', N'U') IS NOT NULL DROP TABLE dbo.NotificationTemplates;
IF OBJECT_ID(N'dbo.Notifications', N'U') IS NOT NULL DROP TABLE dbo.Notifications;
GO

CREATE TABLE dbo.Notifications (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    UserId BIGINT NOT NULL,
    Title NVARCHAR(255) NOT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    NotificationType NVARCHAR(50) NOT NULL,
    ReferenceType NVARCHAR(50) NULL,
    ReferenceId BIGINT NULL,
    IsRead BIT NOT NULL DEFAULT 0,
    ReadAt DATETIME2 NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Notifications_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id)
);
GO

CREATE TABLE dbo.NotificationTemplates (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Code NVARCHAR(100) NOT NULL,
    TitleTemplate NVARCHAR(255) NOT NULL,
    ContentTemplate NVARCHAR(MAX) NOT NULL,
    NotificationType NVARCHAR(50) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

CREATE UNIQUE INDEX UX_NotificationTemplates_Code ON dbo.NotificationTemplates(Code);
GO

CREATE TABLE dbo.UserNotificationSettings (
    UserId BIGINT NOT NULL PRIMARY KEY,
    ReceiveForumNotification BIT NOT NULL DEFAULT 1,
    ReceiveQuizNotification BIT NOT NULL DEFAULT 1,
    ReceiveCodeNotification BIT NOT NULL DEFAULT 1,
    ReceiveSystemNotification BIT NOT NULL DEFAULT 1,
    ReceiveXpNotification BIT NOT NULL DEFAULT 1,
    UpdatedAt DATETIME2 NULL,
    CONSTRAINT FK_UserNotificationSettings_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id)
);
GO

/* ============================================================
   7. FILE MODULE
   ============================================================ */

IF OBJECT_ID(N'dbo.FileReferences', N'U') IS NOT NULL DROP TABLE dbo.FileReferences;
IF OBJECT_ID(N'dbo.Files', N'U') IS NOT NULL DROP TABLE dbo.Files;
GO

CREATE TABLE dbo.Files (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    UploadedByUserId BIGINT NOT NULL,
    OriginalFileName NVARCHAR(255) NOT NULL,
    StoredFileName NVARCHAR(255) NOT NULL,
    FileUrl NVARCHAR(500) NOT NULL,
    MimeType NVARCHAR(100) NOT NULL,
    FileSizeBytes BIGINT NOT NULL,
    StorageProvider NVARCHAR(50) NOT NULL DEFAULT N'Local',
    FileType NVARCHAR(50) NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    IsDeleted BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_Files_Users FOREIGN KEY (UploadedByUserId) REFERENCES dbo.Users(Id)
);
GO

CREATE TABLE dbo.FileReferences (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    FileId BIGINT NOT NULL,
    OwnerService NVARCHAR(100) NOT NULL,
    OwnerType NVARCHAR(100) NOT NULL,
    OwnerId BIGINT NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_FileReferences_Files FOREIGN KEY (FileId) REFERENCES dbo.Files(Id)
);
GO

CREATE TABLE dbo.QuestionImportBatches (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    FileId BIGINT NULL,
    ImportedByUserId BIGINT NOT NULL,
    TotalRows INT NOT NULL DEFAULT 0,
    SuccessRows INT NOT NULL DEFAULT 0,
    FailedRows INT NOT NULL DEFAULT 0,
    Status NVARCHAR(50) NOT NULL DEFAULT N'Pending',
    ErrorFileUrl NVARCHAR(500) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CompletedAt DATETIME2 NULL,
    CONSTRAINT FK_QuestionImportBatches_Files FOREIGN KEY (FileId) REFERENCES dbo.Files(Id),
    CONSTRAINT FK_QuestionImportBatches_Users FOREIGN KEY (ImportedByUserId) REFERENCES dbo.Users(Id)
);
GO

/* ============================================================
   8. GAMIFICATION MODULE
   ============================================================ */

IF OBJECT_ID(N'dbo.UserAchievements', N'U') IS NOT NULL DROP TABLE dbo.UserAchievements;
IF OBJECT_ID(N'dbo.Achievements', N'U') IS NOT NULL DROP TABLE dbo.Achievements;
IF OBJECT_ID(N'dbo.Leaderboards', N'U') IS NOT NULL DROP TABLE dbo.Leaderboards;
IF OBJECT_ID(N'dbo.XpTransactions', N'U') IS NOT NULL DROP TABLE dbo.XpTransactions;
IF OBJECT_ID(N'dbo.XpRules', N'U') IS NOT NULL DROP TABLE dbo.XpRules;
IF OBJECT_ID(N'dbo.UserGamificationProfiles', N'U') IS NOT NULL DROP TABLE dbo.UserGamificationProfiles;
GO

CREATE TABLE dbo.UserGamificationProfiles (
    UserId BIGINT NOT NULL PRIMARY KEY,
    TotalXp INT NOT NULL DEFAULT 0,
    Level INT NOT NULL DEFAULT 1,
    CurrentStreakDays INT NOT NULL DEFAULT 0,
    LongestStreakDays INT NOT NULL DEFAULT 0,
    LastXpEarnedAt DATETIME2 NULL,
    UpdatedAt DATETIME2 NULL,
    CONSTRAINT FK_UserGamificationProfiles_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id)
);
GO

CREATE TABLE dbo.XpRules (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ActionType NVARCHAR(100) NOT NULL,
    Points INT NOT NULL,
    Description NVARCHAR(255) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

CREATE UNIQUE INDEX UX_XpRules_ActionType ON dbo.XpRules(ActionType);
GO

CREATE TABLE dbo.XpTransactions (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    UserId BIGINT NOT NULL,
    ActionType NVARCHAR(100) NOT NULL,
    Points INT NOT NULL,
    ReferenceType NVARCHAR(50) NULL,
    ReferenceId BIGINT NULL,
    Description NVARCHAR(255) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_XpTransactions_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id)
);
GO

CREATE TABLE dbo.Leaderboards (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    UserId BIGINT NOT NULL,
    TotalXp INT NOT NULL DEFAULT 0,
    Level INT NOT NULL DEFAULT 1,
    RankPosition INT NOT NULL,
    PeriodType NVARCHAR(50) NOT NULL,
    PeriodStart DATE NULL,
    PeriodEnd DATE NULL,
    UpdatedAt DATETIME2 NULL,
    CONSTRAINT FK_Leaderboards_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id)
);
GO

CREATE TABLE dbo.Achievements (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Code NVARCHAR(100) NOT NULL,
    Name NVARCHAR(150) NOT NULL,
    Description NVARCHAR(500) NULL,
    IconUrl NVARCHAR(500) NULL,
    RequiredActionType NVARCHAR(100) NULL,
    RequiredValue INT NULL,
    XpReward INT NOT NULL DEFAULT 0,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

CREATE UNIQUE INDEX UX_Achievements_Code ON dbo.Achievements(Code);
GO

CREATE TABLE dbo.UserAchievements (
    UserId BIGINT NOT NULL,
    AchievementId BIGINT NOT NULL,
    EarnedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_UserAchievements PRIMARY KEY (UserId, AchievementId),
    CONSTRAINT FK_UserAchievements_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id),
    CONSTRAINT FK_UserAchievements_Achievements FOREIGN KEY (AchievementId) REFERENCES dbo.Achievements(Id)
);
GO

/* ============================================================
   9. AUDIT MODULE
   ============================================================ */

IF OBJECT_ID(N'dbo.SystemEvents', N'U') IS NOT NULL DROP TABLE dbo.SystemEvents;
IF OBJECT_ID(N'dbo.ApiRequestLogs', N'U') IS NOT NULL DROP TABLE dbo.ApiRequestLogs;
IF OBJECT_ID(N'dbo.AuditLogs', N'U') IS NOT NULL DROP TABLE dbo.AuditLogs;
GO

CREATE TABLE dbo.AuditLogs (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    UserId BIGINT NULL,
    Action NVARCHAR(100) NOT NULL,
    EntityName NVARCHAR(150) NULL,
    EntityId NVARCHAR(100) NULL,
    OldValues NVARCHAR(MAX) NULL,
    NewValues NVARCHAR(MAX) NULL,
    IpAddress NVARCHAR(50) NULL,
    UserAgent NVARCHAR(500) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_AuditLogs_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id)
);
GO

CREATE TABLE dbo.ApiRequestLogs (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    UserId BIGINT NULL,
    ServiceName NVARCHAR(100) NOT NULL DEFAULT N'DevLearningHub.Api',
    Method NVARCHAR(10) NOT NULL,
    Path NVARCHAR(500) NOT NULL,
    StatusCode INT NOT NULL,
    DurationMs INT NOT NULL,
    IpAddress NVARCHAR(50) NULL,
    UserAgent NVARCHAR(500) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_ApiRequestLogs_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id)
);
GO

CREATE TABLE dbo.SystemEvents (
    Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    EventName NVARCHAR(150) NOT NULL,
    SourceService NVARCHAR(100) NOT NULL,
    Payload NVARCHAR(MAX) NULL,
    Status NVARCHAR(50) NOT NULL DEFAULT N'Pending',
    ErrorMessage NVARCHAR(MAX) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    ProcessedAt DATETIME2 NULL
);
GO

/* ============================================================
   10. SEED DATA
   ============================================================ */

INSERT INTO dbo.Roles (Name, NormalizedName, Description, IsSystemRole)
VALUES
(N'User', N'USER', N'Người dùng hệ thống', 1),
(N'Moderator', N'MODERATOR', N'Người kiểm duyệt nội dung', 1),
(N'Admin', N'ADMIN', N'Quản trị viên hệ thống', 1);
GO

INSERT INTO dbo.Permissions (Code, Name, Module, Description)
VALUES
(N'user.view', N'Xem người dùng', N'User', N'Cho phép xem người dùng'),
(N'user.manage', N'Quản lý người dùng', N'User', N'Cho phép quản lý người dùng'),
(N'role.manage', N'Quản lý vai trò', N'Auth', N'Cho phép quản lý role/permission'),
(N'permission.assign', N'Gán quyền lẻ cho tài khoản', N'Auth', N'Cho phép gán/bỏ gán từng permission trực tiếp cho tài khoản'),
(N'category.manage', N'Quản lý chủ đề', N'Learning', N'Cho phép quản lý category'),
(N'question.manage', N'Quản lý câu hỏi', N'Learning', N'Cho phép quản lý question'),
(N'quiz.manage', N'Quản lý bộ đề', N'Learning', N'Cho phép quản lý quiz set'),
(N'roadmap.manage', N'Quản lý roadmap', N'Learning', N'Cho phép quản lý roadmap'),
(N'code.manage', N'Quản lý bài code', N'Judge', N'Cho phép quản lý coding problems'),
(N'post.moderate', N'Kiểm duyệt bài viết', N'Forum', N'Cho phép kiểm duyệt bài viết'),
(N'forum.answer.accept', N'Đánh dấu câu trả lời đúng', N'Forum', N'Cho phép đánh dấu câu trả lời đúng trong Forum'),
(N'file.manage', N'Quản lý file', N'File', N'Cho phép quản lý file'),
(N'audit.view', N'Xem audit log', N'Audit', N'Cho phép xem audit log');
GO

INSERT INTO dbo.RolePermissions (RoleId, PermissionId)
SELECT r.Id, p.Id
FROM dbo.Roles r
CROSS JOIN dbo.Permissions p
WHERE r.NormalizedName = N'ADMIN';
GO

INSERT INTO dbo.RolePermissions (RoleId, PermissionId)
SELECT r.Id, p.Id
FROM dbo.Roles r
JOIN dbo.Permissions p ON p.Code IN (N'post.moderate')
WHERE r.NormalizedName = N'MODERATOR';
GO

INSERT INTO dbo.Categories (Name, Slug, Description, DisplayOrder, Status)
VALUES
(N'SQL Cơ Bản', N'sql-co-ban', N'Chủ đề học SQL từ cơ bản', 1, 1),
(N'C# Cơ Bản', N'csharp-co-ban', N'Chủ đề học C# cơ bản', 2, 1),
(N'Angular Cơ Bản', N'angular-co-ban', N'Chủ đề học Angular cơ bản', 3, 1);
GO

INSERT INTO dbo.ProgrammingLanguages (Name, Code, Version, Judge0LanguageId, DefaultTemplate)
VALUES
(N'C#', N'csharp', N'.NET 9', NULL, N'using System; class Program { static void Main() { } }'),
(N'Python', N'python', N'3.x', NULL, N'print("Hello World")'),
(N'JavaScript', N'javascript', N'Node.js', NULL, N'console.log("Hello World");');
GO

INSERT INTO dbo.XpRules (ActionType, Points, Description)
VALUES
(N'CompleteQuiz', 10, N'Hoàn thành một bài quiz'),
(N'QuizPassed', 15, N'Đạt điểm qua bài quiz'),
(N'CodeAccepted', 30, N'Bài code được accepted'),
(N'PostCreated', 5, N'Tạo bài viết forum'),
(N'CommentAccepted', 20, N'Câu trả lời được chấp nhận'),
(N'DailyStreak', 10, N'Duy trì streak hằng ngày');
GO

INSERT INTO dbo.Achievements (Code, Name, Description, RequiredActionType, RequiredValue, XpReward)
VALUES
(N'FIRST_QUIZ', N'Bài quiz đầu tiên', N'Hoàn thành bài quiz đầu tiên', N'CompleteQuiz', 1, 10),
(N'FIRST_ACCEPTED_CODE', N'Accepted đầu tiên', N'Có bài code accepted đầu tiên', N'CodeAccepted', 1, 20),
(N'FIRST_POST', N'Bài viết đầu tiên', N'Tạo bài viết đầu tiên', N'PostCreated', 1, 5),
(N'SEVEN_DAY_STREAK', N'7 ngày liên tiếp', N'Học tập 7 ngày liên tiếp', N'DailyStreak', 7, 50);
GO

INSERT INTO dbo.NotificationTemplates (Code, TitleTemplate, ContentTemplate, NotificationType)
VALUES
(N'COMMENT_CREATED', N'Có bình luận mới', N'Bài viết của bạn có bình luận mới.', N'Forum'),
(N'QUIZ_COMPLETED', N'Hoàn thành quiz', N'Bạn đã hoàn thành một bài quiz.', N'Quiz'),
(N'CODE_ACCEPTED', N'Bài code Accepted', N'Bài code của bạn đã được chấp nhận.', N'Code'),
(N'XP_MILESTONE', N'Cột mốc XP', N'Bạn vừa đạt một cột mốc XP mới.', N'XP');
GO

PRINT N'DevLearningHubDb FULL MERGED v2 created successfully.';
GO
