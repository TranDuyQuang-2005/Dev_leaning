IF OBJECT_ID('dbo.LearningTracks', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.LearningTracks (
        Id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_LearningTracks PRIMARY KEY,
        Title NVARCHAR(255) NOT NULL,
        Slug NVARCHAR(255) NOT NULL,
        Description NVARCHAR(MAX) NULL,
        Level NVARCHAR(50) NOT NULL CONSTRAINT DF_LearningTracks_Level DEFAULT 'Beginner',
        EstimatedHours INT NOT NULL CONSTRAINT DF_LearningTracks_EstimatedHours DEFAULT 0,
        ThumbnailUrl NVARCHAR(500) NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_LearningTracks_SortOrder DEFAULT 0,
        IsPublished BIT NOT NULL CONSTRAINT DF_LearningTracks_IsPublished DEFAULT 1,
        CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_LearningTracks_CreatedAt DEFAULT SYSUTCDATETIME(),
        UpdatedAt DATETIME2 NULL,
        IsDeleted BIT NOT NULL CONSTRAINT DF_LearningTracks_IsDeleted DEFAULT 0
    );
END;

IF OBJECT_ID('dbo.RoadmapCourses', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.RoadmapCourses (
        Id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_RoadmapCourses PRIMARY KEY,
        TrackId BIGINT NOT NULL,
        Title NVARCHAR(255) NOT NULL,
        Slug NVARCHAR(255) NOT NULL,
        ShortDescription NVARCHAR(500) NULL,
        Description NVARCHAR(MAX) NULL,
        Level NVARCHAR(50) NOT NULL CONSTRAINT DF_RoadmapCourses_Level DEFAULT 'Beginner',
        EstimatedHours INT NOT NULL CONSTRAINT DF_RoadmapCourses_EstimatedHours DEFAULT 0,
        TotalModules INT NOT NULL CONSTRAINT DF_RoadmapCourses_TotalModules DEFAULT 0,
        TotalLessons INT NOT NULL CONSTRAINT DF_RoadmapCourses_TotalLessons DEFAULT 0,
        RequirementsJson NVARCHAR(MAX) NULL,
        LearningOutcomesJson NVARCHAR(MAX) NULL,
        RelatedCourseIdsJson NVARCHAR(MAX) NULL,
        PrerequisiteCourseIdsJson NVARCHAR(MAX) NULL,
        ThumbnailUrl NVARCHAR(500) NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_RoadmapCourses_SortOrder DEFAULT 0,
        IsPublished BIT NOT NULL CONSTRAINT DF_RoadmapCourses_IsPublished DEFAULT 1,
        RequiresSequentialCompletion BIT NOT NULL CONSTRAINT DF_RoadmapCourses_RequiresSequentialCompletion DEFAULT 1,
        UnlockAfterCourseId BIGINT NULL,
        CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_RoadmapCourses_CreatedAt DEFAULT SYSUTCDATETIME(),
        UpdatedAt DATETIME2 NULL,
        IsDeleted BIT NOT NULL CONSTRAINT DF_RoadmapCourses_IsDeleted DEFAULT 0,
        CONSTRAINT FK_RoadmapCourses_LearningTracks_TrackId FOREIGN KEY (TrackId) REFERENCES dbo.LearningTracks(Id)
    );
END;

IF OBJECT_ID('dbo.RoadmapModules', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.RoadmapModules (
        Id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_RoadmapModules PRIMARY KEY,
        CourseId BIGINT NOT NULL,
        Title NVARCHAR(255) NOT NULL,
        Description NVARCHAR(MAX) NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_RoadmapModules_SortOrder DEFAULT 0,
        EstimatedMinutes INT NOT NULL CONSTRAINT DF_RoadmapModules_EstimatedMinutes DEFAULT 0,
        RequiresPreviousModuleCompletion BIT NOT NULL CONSTRAINT DF_RoadmapModules_RequiresPrevious DEFAULT 1,
        IsLockedByDefault BIT NOT NULL CONSTRAINT DF_RoadmapModules_IsLockedByDefault DEFAULT 0,
        IsPublished BIT NOT NULL CONSTRAINT DF_RoadmapModules_IsPublished DEFAULT 1,
        CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_RoadmapModules_CreatedAt DEFAULT SYSUTCDATETIME(),
        UpdatedAt DATETIME2 NULL,
        IsDeleted BIT NOT NULL CONSTRAINT DF_RoadmapModules_IsDeleted DEFAULT 0,
        CONSTRAINT FK_RoadmapModules_RoadmapCourses_CourseId FOREIGN KEY (CourseId) REFERENCES dbo.RoadmapCourses(Id) ON DELETE CASCADE
    );
END;

IF OBJECT_ID('dbo.RoadmapLessons', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.RoadmapLessons (
        Id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_RoadmapLessons PRIMARY KEY,
        ModuleId BIGINT NOT NULL,
        Title NVARCHAR(255) NOT NULL,
        Type NVARCHAR(50) NOT NULL CONSTRAINT DF_RoadmapLessons_Type DEFAULT 'Reading',
        Content NVARCHAR(MAX) NULL,
        VideoUrl NVARCHAR(500) NULL,
        VideoFileId BIGINT NULL,
        QuizSetId BIGINT NULL,
        CodingProblemId BIGINT NULL,
        EstimatedMinutes INT NOT NULL CONSTRAINT DF_RoadmapLessons_EstimatedMinutes DEFAULT 0,
        SortOrder INT NOT NULL CONSTRAINT DF_RoadmapLessons_SortOrder DEFAULT 0,
        IsPreview BIT NOT NULL CONSTRAINT DF_RoadmapLessons_IsPreview DEFAULT 0,
        IsPublished BIT NOT NULL CONSTRAINT DF_RoadmapLessons_IsPublished DEFAULT 1,
        RequiresPreviousLessonCompletion BIT NOT NULL CONSTRAINT DF_RoadmapLessons_RequiresPrevious DEFAULT 1,
        IsRequired BIT NOT NULL CONSTRAINT DF_RoadmapLessons_IsRequired DEFAULT 1,
        UnlockAfterLessonId BIGINT NULL,
        CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_RoadmapLessons_CreatedAt DEFAULT SYSUTCDATETIME(),
        UpdatedAt DATETIME2 NULL,
        IsDeleted BIT NOT NULL CONSTRAINT DF_RoadmapLessons_IsDeleted DEFAULT 0,
        CONSTRAINT FK_RoadmapLessons_RoadmapModules_ModuleId FOREIGN KEY (ModuleId) REFERENCES dbo.RoadmapModules(Id) ON DELETE CASCADE,
        CONSTRAINT FK_RoadmapLessons_QuizSets_QuizSetId FOREIGN KEY (QuizSetId) REFERENCES dbo.QuizSets(Id),
        CONSTRAINT FK_RoadmapLessons_CodingProblems_CodingProblemId FOREIGN KEY (CodingProblemId) REFERENCES dbo.CodingProblems(Id)
    );
END;

IF OBJECT_ID('dbo.RoadmapLessons', 'U') IS NOT NULL AND COL_LENGTH('dbo.RoadmapLessons', 'VideoFileId') IS NULL
    ALTER TABLE dbo.RoadmapLessons ADD VideoFileId BIGINT NULL;

IF OBJECT_ID('dbo.UserLessonProgresses', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.UserLessonProgresses (
        Id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_UserLessonProgresses PRIMARY KEY,
        UserId BIGINT NOT NULL,
        LessonId BIGINT NOT NULL,
        Status NVARCHAR(30) NOT NULL CONSTRAINT DF_UserLessonProgresses_Status DEFAULT 'NotStarted',
        StartedAt DATETIME2 NULL,
        CompletedAt DATETIME2 NULL,
        LastAccessedAt DATETIME2 NULL,
        CONSTRAINT FK_UserLessonProgresses_Users_UserId FOREIGN KEY (UserId) REFERENCES dbo.Users(Id) ON DELETE CASCADE,
        CONSTRAINT FK_UserLessonProgresses_RoadmapLessons_LessonId FOREIGN KEY (LessonId) REFERENCES dbo.RoadmapLessons(Id) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_LearningTracks_Slug' AND object_id = OBJECT_ID('dbo.LearningTracks'))
    CREATE UNIQUE INDEX IX_LearningTracks_Slug ON dbo.LearningTracks(Slug);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_LearningTracks_IsPublished_IsDeleted_SortOrder' AND object_id = OBJECT_ID('dbo.LearningTracks'))
    CREATE INDEX IX_LearningTracks_IsPublished_IsDeleted_SortOrder ON dbo.LearningTracks(IsPublished, IsDeleted, SortOrder);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_RoadmapCourses_Slug' AND object_id = OBJECT_ID('dbo.RoadmapCourses'))
    CREATE UNIQUE INDEX IX_RoadmapCourses_Slug ON dbo.RoadmapCourses(Slug);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_RoadmapCourses_TrackId_IsPublished_IsDeleted_SortOrder' AND object_id = OBJECT_ID('dbo.RoadmapCourses'))
    CREATE INDEX IX_RoadmapCourses_TrackId_IsPublished_IsDeleted_SortOrder ON dbo.RoadmapCourses(TrackId, IsPublished, IsDeleted, SortOrder);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_RoadmapModules_CourseId_IsPublished_IsDeleted_SortOrder' AND object_id = OBJECT_ID('dbo.RoadmapModules'))
    CREATE INDEX IX_RoadmapModules_CourseId_IsPublished_IsDeleted_SortOrder ON dbo.RoadmapModules(CourseId, IsPublished, IsDeleted, SortOrder);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_RoadmapLessons_ModuleId_IsPublished_IsDeleted_SortOrder' AND object_id = OBJECT_ID('dbo.RoadmapLessons'))
    CREATE INDEX IX_RoadmapLessons_ModuleId_IsPublished_IsDeleted_SortOrder ON dbo.RoadmapLessons(ModuleId, IsPublished, IsDeleted, SortOrder);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_RoadmapLessons_QuizSetId' AND object_id = OBJECT_ID('dbo.RoadmapLessons'))
    CREATE INDEX IX_RoadmapLessons_QuizSetId ON dbo.RoadmapLessons(QuizSetId);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_RoadmapLessons_CodingProblemId' AND object_id = OBJECT_ID('dbo.RoadmapLessons'))
    CREATE INDEX IX_RoadmapLessons_CodingProblemId ON dbo.RoadmapLessons(CodingProblemId);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_RoadmapLessons_VideoFileId' AND object_id = OBJECT_ID('dbo.RoadmapLessons'))
    CREATE INDEX IX_RoadmapLessons_VideoFileId ON dbo.RoadmapLessons(VideoFileId);
IF OBJECT_ID('dbo.Files', 'U') IS NOT NULL
   AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_RoadmapLessons_Files_VideoFileId' AND parent_object_id = OBJECT_ID('dbo.RoadmapLessons'))
    ALTER TABLE dbo.RoadmapLessons ADD CONSTRAINT FK_RoadmapLessons_Files_VideoFileId FOREIGN KEY (VideoFileId) REFERENCES dbo.Files(Id);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_UserLessonProgresses_UserId_LessonId' AND object_id = OBJECT_ID('dbo.UserLessonProgresses'))
    CREATE UNIQUE INDEX IX_UserLessonProgresses_UserId_LessonId ON dbo.UserLessonProgresses(UserId, LessonId);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_UserLessonProgresses_Status' AND object_id = OBJECT_ID('dbo.UserLessonProgresses'))
    CREATE INDEX IX_UserLessonProgresses_Status ON dbo.UserLessonProgresses(Status);
