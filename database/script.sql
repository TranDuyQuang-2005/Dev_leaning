USE [master]
GO
/****** Object:  Database [DevLearningHubDb]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE DATABASE [DevLearningHubDb]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DevLearningHubDb', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\DevLearningHubDb.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DevLearningHubDb_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\DevLearningHubDb_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [DevLearningHubDb] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DevLearningHubDb].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DevLearningHubDb] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DevLearningHubDb] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DevLearningHubDb] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DevLearningHubDb] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DevLearningHubDb] SET ARITHABORT OFF 
GO
ALTER DATABASE [DevLearningHubDb] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [DevLearningHubDb] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DevLearningHubDb] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DevLearningHubDb] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DevLearningHubDb] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DevLearningHubDb] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DevLearningHubDb] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DevLearningHubDb] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DevLearningHubDb] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DevLearningHubDb] SET  ENABLE_BROKER 
GO
ALTER DATABASE [DevLearningHubDb] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DevLearningHubDb] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DevLearningHubDb] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DevLearningHubDb] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DevLearningHubDb] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DevLearningHubDb] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DevLearningHubDb] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DevLearningHubDb] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [DevLearningHubDb] SET  MULTI_USER 
GO
ALTER DATABASE [DevLearningHubDb] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DevLearningHubDb] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DevLearningHubDb] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DevLearningHubDb] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [DevLearningHubDb] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [DevLearningHubDb] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [DevLearningHubDb] SET QUERY_STORE = ON
GO
ALTER DATABASE [DevLearningHubDb] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [DevLearningHubDb]
GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Achievements]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Achievements](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](100) NOT NULL,
	[Name] [nvarchar](150) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[IconUrl] [nvarchar](500) NULL,
	[RequiredActionType] [nvarchar](100) NULL,
	[RequiredValue] [int] NULL,
	[XpReward] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApiRequestLogs]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApiRequestLogs](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NULL,
	[ServiceName] [nvarchar](100) NOT NULL,
	[Method] [nvarchar](10) NOT NULL,
	[Path] [nvarchar](500) NOT NULL,
	[StatusCode] [int] NOT NULL,
	[DurationMs] [int] NOT NULL,
	[IpAddress] [nvarchar](50) NULL,
	[UserAgent] [nvarchar](500) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuditLogs]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditLogs](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NULL,
	[Action] [nvarchar](100) NOT NULL,
	[EntityName] [nvarchar](150) NULL,
	[EntityId] [nvarchar](100) NULL,
	[OldValues] [nvarchar](max) NULL,
	[NewValues] [nvarchar](max) NULL,
	[IpAddress] [nvarchar](50) NULL,
	[UserAgent] [nvarchar](500) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ParentId] [bigint] NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Slug] [nvarchar](150) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[IconUrl] [nvarchar](500) NULL,
	[DisplayOrder] [int] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CodeRunHistories]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CodeRunHistories](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[CodingProblemId] [bigint] NULL,
	[ProgrammingLanguageId] [bigint] NOT NULL,
	[SourceCode] [nvarchar](max) NOT NULL,
	[Stdin] [nvarchar](max) NULL,
	[Stdout] [nvarchar](max) NULL,
	[Stderr] [nvarchar](max) NULL,
	[Status] [nvarchar](50) NOT NULL,
	[ExecutionTimeMs] [int] NULL,
	[MemoryUsedKb] [int] NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CodeSubmissions]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CodeSubmissions](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[CodingProblemId] [bigint] NULL,
	[ProgrammingLanguageId] [bigint] NULL,
	[SourceCode] [nvarchar](max) NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[TotalTestCases] [int] NOT NULL,
	[PassedTestCases] [int] NOT NULL,
	[Score] [decimal](6, 2) NOT NULL,
	[ExecutionTimeMs] [int] NULL,
	[MemoryUsedKb] [int] NULL,
	[ErrorMessage] [nvarchar](max) NULL,
	[JudgeToken] [nvarchar](255) NULL,
	[SubmittedAt] [datetime2](7) NOT NULL,
	[JudgedAt] [datetime2](7) NULL,
	[ProblemId] [bigint] NULL,
	[Language] [nvarchar](50) NOT NULL,
	[Stdin] [nvarchar](max) NULL,
	[Output] [nvarchar](max) NULL,
	[Error] [nvarchar](max) NULL,
	[Verdict] [nvarchar](100) NOT NULL,
	[IsAccepted] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CodeSubmissionTestCaseResults]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CodeSubmissionTestCaseResults](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[SubmissionId] [bigint] NOT NULL,
	[TestCaseId] [bigint] NULL,
	[DisplayOrder] [int] NOT NULL,
	[Input] [nvarchar](max) NOT NULL,
	[ExpectedOutput] [nvarchar](max) NOT NULL,
	[ActualOutput] [nvarchar](max) NOT NULL,
	[Error] [nvarchar](max) NULL,
	[Status] [nvarchar](50) NOT NULL,
	[Passed] [bit] NOT NULL,
	[ExecutionTimeMs] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CodingProblems]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CodingProblems](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CategoryId] [bigint] NULL,
	[CreatedByUserId] [bigint] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Slug] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[InputDescription] [nvarchar](max) NULL,
	[OutputDescription] [nvarchar](max) NULL,
	[Constraints] [nvarchar](max) NULL,
	[SampleInput] [nvarchar](max) NULL,
	[SampleOutput] [nvarchar](max) NULL,
	[Difficulty] [tinyint] NOT NULL,
	[TimeLimitMs] [int] NOT NULL,
	[MemoryLimitMb] [int] NOT NULL,
	[AcceptanceRate] [decimal](5, 2) NOT NULL,
	[TotalSubmissions] [int] NOT NULL,
	[AcceptedSubmissions] [int] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[InputFormat] [nvarchar](max) NULL,
	[OutputFormat] [nvarchar](max) NULL,
	[ExamplesJson] [nvarchar](max) NULL,
	[Tags] [nvarchar](1000) NULL,
	[StarterCodePython] [nvarchar](max) NULL,
	[StarterCodeJavaScript] [nvarchar](max) NULL,
	[StarterCodeTypeScript] [nvarchar](max) NULL,
	[StarterCodeJava] [nvarchar](max) NULL,
	[StarterCodeC] [nvarchar](max) NULL,
	[StarterCodeCpp] [nvarchar](max) NULL,
	[StarterCodeCsharp] [nvarchar](max) NULL,
	[StarterCodeGo] [nvarchar](max) NULL,
	[MemoryLimitKb] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CodingProblemTags]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CodingProblemTags](
	[CodingProblemId] [bigint] NOT NULL,
	[ProblemTagId] [bigint] NOT NULL,
 CONSTRAINT [PK_CodingProblemTags] PRIMARY KEY CLUSTERED 
(
	[CodingProblemId] ASC,
	[ProblemTagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CodingTestCases]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CodingTestCases](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ProblemId] [bigint] NOT NULL,
	[Input] [nvarchar](max) NOT NULL,
	[ExpectedOutput] [nvarchar](max) NOT NULL,
	[Explanation] [nvarchar](1000) NULL,
	[IsHidden] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Comments]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Comments](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PostId] [bigint] NOT NULL,
	[AuthorId] [bigint] NOT NULL,
	[ParentCommentId] [bigint] NULL,
	[Content] [nvarchar](max) NOT NULL,
	[ContentHtml] [nvarchar](max) NULL,
	[VoteScore] [int] NOT NULL,
	[IsAcceptedAnswer] [bit] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CommentVotes]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CommentVotes](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CommentId] [bigint] NOT NULL,
	[UserId] [bigint] NOT NULL,
	[VoteType] [smallint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmailVerificationTokens]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailVerificationTokens](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[TokenHash] [nvarchar](500) NOT NULL,
	[ExpiresAt] [datetime2](7) NOT NULL,
	[UsedAt] [datetime2](7) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExternalLogins]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExternalLogins](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[Provider] [nvarchar](50) NOT NULL,
	[ProviderUserId] [nvarchar](255) NOT NULL,
	[ProviderEmail] [nvarchar](255) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FileReferences]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FileReferences](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[FileId] [bigint] NOT NULL,
	[OwnerService] [nvarchar](100) NOT NULL,
	[OwnerType] [nvarchar](100) NOT NULL,
	[OwnerId] [bigint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Files]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Files](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UploadedByUserId] [bigint] NOT NULL,
	[OriginalFileName] [nvarchar](255) NOT NULL,
	[StoredFileName] [nvarchar](255) NOT NULL,
	[FileUrl] [nvarchar](500) NOT NULL,
	[MimeType] [nvarchar](100) NOT NULL,
	[FileSizeBytes] [bigint] NOT NULL,
	[StorageProvider] [nvarchar](50) NOT NULL,
	[FileType] [nvarchar](50) NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Leaderboards]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Leaderboards](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[TotalXp] [int] NOT NULL,
	[Level] [int] NOT NULL,
	[RankPosition] [int] NOT NULL,
	[PeriodType] [nvarchar](50) NOT NULL,
	[PeriodStart] [date] NULL,
	[PeriodEnd] [date] NULL,
	[UpdatedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LearningTracks]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LearningTracks](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Slug] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Level] [nvarchar](50) NOT NULL,
	[EstimatedHours] [int] NOT NULL,
	[ThumbnailUrl] [nvarchar](500) NULL,
	[SortOrder] [int] NOT NULL,
	[IsPublished] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_LearningTracks] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ModerationActions]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ModerationActions](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ModeratorId] [bigint] NOT NULL,
	[TargetType] [nvarchar](50) NOT NULL,
	[TargetId] [bigint] NOT NULL,
	[ActionType] [nvarchar](100) NOT NULL,
	[Reason] [nvarchar](255) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Notifications]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Notifications](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Content] [nvarchar](max) NOT NULL,
	[NotificationType] [nvarchar](50) NOT NULL,
	[ReferenceType] [nvarchar](50) NULL,
	[ReferenceId] [bigint] NULL,
	[IsRead] [bit] NOT NULL,
	[ReadAt] [datetime2](7) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[Type] [nvarchar](100) NOT NULL,
	[Message] [nvarchar](1000) NOT NULL,
	[LinkUrl] [nvarchar](500) NULL,
	[MetadataJson] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NotificationTemplates]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationTemplates](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](100) NOT NULL,
	[TitleTemplate] [nvarchar](255) NOT NULL,
	[ContentTemplate] [nvarchar](max) NOT NULL,
	[NotificationType] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PasswordResetTokens]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PasswordResetTokens](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[TokenHash] [nvarchar](500) NOT NULL,
	[ExpiresAt] [datetime2](7) NOT NULL,
	[UsedAt] [datetime2](7) NULL,
	[IpAddress] [nvarchar](50) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PermissionGroupPermissions]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PermissionGroupPermissions](
	[PermissionGroupId] [bigint] NOT NULL,
	[PermissionId] [bigint] NOT NULL,
 CONSTRAINT [PK_PermissionGroupPermissions] PRIMARY KEY CLUSTERED 
(
	[PermissionGroupId] ASC,
	[PermissionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PermissionGroups]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PermissionGroups](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](150) NOT NULL,
	[Code] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[IsSystem] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_PermissionGroups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Permissions]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Permissions](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](100) NOT NULL,
	[Name] [nvarchar](150) NOT NULL,
	[Module] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](255) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PersonalPracticeAttemptAnswers]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonalPracticeAttemptAnswers](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[AttemptId] [bigint] NOT NULL,
	[QuestionId] [bigint] NOT NULL,
	[SelectedOptionLabel] [nvarchar](5) NULL,
	[IsCorrect] [bit] NOT NULL,
 CONSTRAINT [PK_PersonalPracticeAttemptAnswers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PersonalPracticeAttempts]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonalPracticeAttempts](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[BankId] [bigint] NOT NULL,
	[StartedAt] [datetime2](7) NOT NULL,
	[SubmittedAt] [datetime2](7) NULL,
	[Score] [decimal](6, 2) NOT NULL,
	[TotalQuestions] [int] NOT NULL,
	[CorrectCount] [int] NOT NULL,
	[Status] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_PersonalPracticeAttempts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PersonalQuestionBanks]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonalQuestionBanks](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[OriginalFileName] [nvarchar](255) NOT NULL,
	[FileStorageKey] [nvarchar](500) NOT NULL,
	[QuestionCount] [int] NOT NULL,
	[Visibility] [nvarchar](30) NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_PersonalQuestionBanks] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PersonalQuestionOptions]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonalQuestionOptions](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[QuestionId] [bigint] NOT NULL,
	[Label] [nvarchar](5) NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[IsCorrect] [bit] NOT NULL,
 CONSTRAINT [PK_PersonalQuestionOptions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PersonalQuestions]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonalQuestions](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[BankId] [bigint] NOT NULL,
	[UserId] [bigint] NOT NULL,
	[QuestionText] [nvarchar](max) NOT NULL,
	[QuestionType] [nvarchar](50) NOT NULL,
	[Difficulty] [nvarchar](30) NOT NULL,
	[Explanation] [nvarchar](max) NULL,
	[Tags] [nvarchar](500) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_PersonalQuestions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PostBookmarks]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PostBookmarks](
	[PostId] [bigint] NOT NULL,
	[UserId] [bigint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_PostBookmarks] PRIMARY KEY CLUSTERED 
(
	[PostId] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Posts]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Posts](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[AuthorId] [bigint] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Slug] [nvarchar](255) NOT NULL,
	[Content] [nvarchar](max) NOT NULL,
	[ContentHtml] [nvarchar](max) NULL,
	[ViewCount] [int] NOT NULL,
	[VoteScore] [int] NOT NULL,
	[AnswerCount] [int] NOT NULL,
	[AcceptedCommentId] [bigint] NULL,
	[Status] [tinyint] NOT NULL,
	[LastActivityAt] [datetime2](7) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PostTags]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PostTags](
	[PostId] [bigint] NOT NULL,
	[TagId] [bigint] NOT NULL,
 CONSTRAINT [PK_PostTags] PRIMARY KEY CLUSTERED 
(
	[PostId] ASC,
	[TagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PostVotes]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PostVotes](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PostId] [bigint] NOT NULL,
	[UserId] [bigint] NOT NULL,
	[VoteType] [smallint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProblemSupportedLanguages]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProblemSupportedLanguages](
	[CodingProblemId] [bigint] NOT NULL,
	[ProgrammingLanguageId] [bigint] NOT NULL,
 CONSTRAINT [PK_ProblemSupportedLanguages] PRIMARY KEY CLUSTERED 
(
	[CodingProblemId] ASC,
	[ProgrammingLanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProblemTags]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProblemTags](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Slug] [nvarchar](100) NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProblemTestCases]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProblemTestCases](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CodingProblemId] [bigint] NOT NULL,
	[InputData] [nvarchar](max) NULL,
	[ExpectedOutput] [nvarchar](max) NULL,
	[IsHidden] [bit] NOT NULL,
	[ScoreWeight] [decimal](5, 2) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProgrammingLanguages]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProgrammingLanguages](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[Version] [nvarchar](50) NULL,
	[Judge0LanguageId] [int] NULL,
	[DefaultTemplate] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[DisplayName] [nvarchar](100) NULL,
	[FileExtension] [nvarchar](20) NULL,
	[CompileCommand] [nvarchar](500) NULL,
	[RunCommand] [nvarchar](500) NULL,
	[IsCompiled] [bit] NOT NULL,
	[TimeLimitMs] [int] NOT NULL,
	[MemoryLimitKb] [int] NOT NULL,
	[SortOrder] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionImportBatches]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionImportBatches](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[FileId] [bigint] NULL,
	[ImportedByUserId] [bigint] NOT NULL,
	[TotalRows] [int] NOT NULL,
	[SuccessRows] [int] NOT NULL,
	[FailedRows] [int] NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[ErrorFileUrl] [nvarchar](500) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CompletedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionOptions]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionOptions](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[QuestionId] [bigint] NOT NULL,
	[Content] [nvarchar](max) NOT NULL,
	[IsCorrect] [bit] NOT NULL,
	[Explanation] [nvarchar](max) NULL,
	[DisplayOrder] [int] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Questions]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Questions](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CategoryId] [bigint] NOT NULL,
	[CreatedByUserId] [bigint] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Content] [nvarchar](max) NOT NULL,
	[Explanation] [nvarchar](max) NULL,
	[Difficulty] [tinyint] NOT NULL,
	[QuestionType] [tinyint] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[Version] [int] NOT NULL,
	[Source] [nvarchar](255) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuizAttemptAnswerOptions]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuizAttemptAnswerOptions](
	[QuizAttemptAnswerId] [bigint] NOT NULL,
	[QuestionOptionId] [bigint] NOT NULL,
 CONSTRAINT [PK_QuizAttemptAnswerOptions] PRIMARY KEY CLUSTERED 
(
	[QuizAttemptAnswerId] ASC,
	[QuestionOptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuizAttemptAnswers]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuizAttemptAnswers](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[QuizAttemptId] [bigint] NOT NULL,
	[QuestionId] [bigint] NOT NULL,
	[IsCorrect] [bit] NOT NULL,
	[Score] [decimal](5, 2) NOT NULL,
	[AnsweredAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuizAttempts]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuizAttempts](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[QuizSetId] [bigint] NOT NULL,
	[StartedAt] [datetime2](7) NOT NULL,
	[SubmittedAt] [datetime2](7) NULL,
	[DurationSeconds] [int] NULL,
	[TotalQuestions] [int] NOT NULL,
	[CorrectAnswers] [int] NOT NULL,
	[WrongAnswers] [int] NOT NULL,
	[SkippedAnswers] [int] NOT NULL,
	[Score] [decimal](6, 2) NOT NULL,
	[IsPassed] [bit] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuizSetQuestions]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuizSetQuestions](
	[QuizSetId] [bigint] NOT NULL,
	[QuestionId] [bigint] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[Score] [decimal](5, 2) NOT NULL,
 CONSTRAINT [PK_QuizSetQuestions] PRIMARY KEY CLUSTERED 
(
	[QuizSetId] ASC,
	[QuestionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuizSets]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuizSets](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CreatedByUserId] [bigint] NOT NULL,
	[CategoryId] [bigint] NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Slug] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Difficulty] [tinyint] NOT NULL,
	[QuizType] [tinyint] NOT NULL,
	[TimeLimitMinutes] [int] NULL,
	[PassingScore] [decimal](5, 2) NOT NULL,
	[AllowReview] [bit] NOT NULL,
	[ShuffleQuestions] [bit] NOT NULL,
	[ShuffleOptions] [bit] NOT NULL,
	[MaxAttempts] [int] NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RefreshTokens]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RefreshTokens](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[TokenHash] [nvarchar](500) NOT NULL,
	[JwtId] [nvarchar](100) NULL,
	[DeviceId] [bigint] NULL,
	[ExpiresAt] [datetime2](7) NOT NULL,
	[RevokedAt] [datetime2](7) NULL,
	[ReplacedByTokenHash] [nvarchar](500) NULL,
	[IpAddress] [nvarchar](50) NULL,
	[UserAgent] [nvarchar](500) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reports]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reports](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ReporterId] [bigint] NOT NULL,
	[TargetType] [nvarchar](50) NOT NULL,
	[TargetId] [bigint] NOT NULL,
	[Reason] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Status] [tinyint] NOT NULL,
	[ResolvedByUserId] [bigint] NULL,
	[ResolvedAt] [datetime2](7) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoadmapCourses]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoadmapCourses](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[TrackId] [bigint] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Slug] [nvarchar](255) NOT NULL,
	[ShortDescription] [nvarchar](500) NULL,
	[Description] [nvarchar](max) NULL,
	[Level] [nvarchar](50) NOT NULL,
	[EstimatedHours] [int] NOT NULL,
	[TotalModules] [int] NOT NULL,
	[TotalLessons] [int] NOT NULL,
	[RequirementsJson] [nvarchar](max) NULL,
	[LearningOutcomesJson] [nvarchar](max) NULL,
	[RelatedCourseIdsJson] [nvarchar](max) NULL,
	[PrerequisiteCourseIdsJson] [nvarchar](max) NULL,
	[ThumbnailUrl] [nvarchar](500) NULL,
	[SortOrder] [int] NOT NULL,
	[IsPublished] [bit] NOT NULL,
	[RequiresSequentialCompletion] [bit] NOT NULL,
	[UnlockAfterCourseId] [bigint] NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_RoadmapCourses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoadmapItems]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoadmapItems](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[RoadmapId] [bigint] NOT NULL,
	[ParentItemId] [bigint] NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ItemType] [tinyint] NOT NULL,
	[ReferenceId] [bigint] NULL,
	[ExternalUrl] [nvarchar](500) NULL,
	[DisplayOrder] [int] NOT NULL,
	[EstimatedMinutes] [int] NULL,
	[IsRequired] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoadmapLessons]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoadmapLessons](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ModuleId] [bigint] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Type] [nvarchar](50) NOT NULL,
	[Content] [nvarchar](max) NULL,
	[VideoUrl] [nvarchar](500) NULL,
	[QuizSetId] [bigint] NULL,
	[CodingProblemId] [bigint] NULL,
	[EstimatedMinutes] [int] NOT NULL,
	[SortOrder] [int] NOT NULL,
	[IsPreview] [bit] NOT NULL,
	[IsPublished] [bit] NOT NULL,
	[RequiresPreviousLessonCompletion] [bit] NOT NULL,
	[IsRequired] [bit] NOT NULL,
	[UnlockAfterLessonId] [bigint] NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[VideoFileId] [bigint] NULL,
 CONSTRAINT [PK_RoadmapLessons] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoadmapModules]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoadmapModules](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CourseId] [bigint] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[SortOrder] [int] NOT NULL,
	[EstimatedMinutes] [int] NOT NULL,
	[RequiresPreviousModuleCompletion] [bit] NOT NULL,
	[IsLockedByDefault] [bit] NOT NULL,
	[IsPublished] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_RoadmapModules] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roadmaps]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roadmaps](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CategoryId] [bigint] NOT NULL,
	[CreatedByUserId] [bigint] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Slug] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[TargetLevel] [tinyint] NOT NULL,
	[EstimatedHours] [int] NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RolePermissionGroups]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RolePermissionGroups](
	[RoleId] [bigint] NOT NULL,
	[PermissionGroupId] [bigint] NOT NULL,
	[AssignedAt] [datetime2](7) NOT NULL,
	[AssignedBy] [bigint] NULL,
 CONSTRAINT [PK_RolePermissionGroups] PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC,
	[PermissionGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RolePermissions]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RolePermissions](
	[RoleId] [bigint] NOT NULL,
	[PermissionId] [bigint] NOT NULL,
 CONSTRAINT [PK_RolePermissions] PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC,
	[PermissionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[NormalizedName] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](255) NULL,
	[IsSystemRole] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SubmissionTestResults]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubmissionTestResults](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CodeSubmissionId] [bigint] NOT NULL,
	[ProblemTestCaseId] [bigint] NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[ActualOutput] [nvarchar](max) NULL,
	[ExpectedOutput] [nvarchar](max) NULL,
	[ExecutionTimeMs] [int] NULL,
	[MemoryUsedKb] [int] NULL,
	[ErrorMessage] [nvarchar](max) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SystemEvents]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SystemEvents](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[EventName] [nvarchar](150) NOT NULL,
	[SourceService] [nvarchar](100) NOT NULL,
	[Payload] [nvarchar](max) NULL,
	[Status] [nvarchar](50) NOT NULL,
	[ErrorMessage] [nvarchar](max) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[ProcessedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tags]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tags](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Slug] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](255) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserAchievements]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserAchievements](
	[UserId] [bigint] NOT NULL,
	[AchievementId] [bigint] NOT NULL,
	[EarnedAt] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_UserAchievements] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[AchievementId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserDailyActivities]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserDailyActivities](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[ActivityDate] [date] NOT NULL,
	[QuizCompletedCount] [int] NOT NULL,
	[CodeSubmissionCount] [int] NOT NULL,
	[AcceptedCodeCount] [int] NOT NULL,
	[PostCreatedCount] [int] NOT NULL,
	[CommentCreatedCount] [int] NOT NULL,
	[StudyMinutes] [int] NOT NULL,
	[XpEarned] [int] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserDevices]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserDevices](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[DeviceName] [nvarchar](255) NULL,
	[DeviceType] [nvarchar](50) NULL,
	[Browser] [nvarchar](100) NULL,
	[OperatingSystem] [nvarchar](100) NULL,
	[IpAddress] [nvarchar](50) NULL,
	[LastUsedAt] [datetime2](7) NULL,
	[IsTrusted] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserGamificationProfiles]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserGamificationProfiles](
	[UserId] [bigint] NOT NULL,
	[TotalXp] [int] NOT NULL,
	[Level] [int] NOT NULL,
	[CurrentStreakDays] [int] NOT NULL,
	[LongestStreakDays] [int] NOT NULL,
	[LastXpEarnedAt] [datetime2](7) NULL,
	[UpdatedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserLearningProfiles]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserLearningProfiles](
	[UserId] [bigint] NOT NULL,
	[CurrentLevel] [tinyint] NOT NULL,
	[TargetRole] [nvarchar](100) NULL,
	[PreferredLanguage] [nvarchar](100) NULL,
	[DailyGoalMinutes] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserLessonProgresses]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserLessonProgresses](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[LessonId] [bigint] NOT NULL,
	[Status] [nvarchar](30) NOT NULL,
	[StartedAt] [datetime2](7) NULL,
	[CompletedAt] [datetime2](7) NULL,
	[LastAccessedAt] [datetime2](7) NULL,
 CONSTRAINT [PK_UserLessonProgresses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserNotificationSettings]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserNotificationSettings](
	[UserId] [bigint] NOT NULL,
	[ReceiveForumNotification] [bit] NOT NULL,
	[ReceiveQuizNotification] [bit] NOT NULL,
	[ReceiveCodeNotification] [bit] NOT NULL,
	[ReceiveSystemNotification] [bit] NOT NULL,
	[ReceiveXpNotification] [bit] NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserPermissionGroups]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserPermissionGroups](
	[UserId] [bigint] NOT NULL,
	[PermissionGroupId] [bigint] NOT NULL,
	[AssignedAt] [datetime2](7) NOT NULL,
	[AssignedBy] [bigint] NULL,
 CONSTRAINT [PK_UserPermissionGroups] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[PermissionGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserPermissions]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserPermissions](
	[UserId] [bigint] NOT NULL,
	[PermissionId] [bigint] NOT NULL,
	[AssignedAt] [datetime2](7) NOT NULL,
	[AssignedBy] [bigint] NULL,
 CONSTRAINT [PK_UserPermissions] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[PermissionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserProfiles]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserProfiles](
	[UserId] [bigint] NOT NULL,
	[FullName] [nvarchar](150) NULL,
	[AvatarUrl] [nvarchar](500) NULL,
	[Headline] [nvarchar](255) NULL,
	[Bio] [nvarchar](1000) NULL,
	[Location] [nvarchar](150) NULL,
	[WebsiteUrl] [nvarchar](500) NULL,
	[GitHubUrl] [nvarchar](500) NULL,
	[LinkedInUrl] [nvarchar](500) NULL,
	[Education] [nvarchar](255) NULL,
	[Company] [nvarchar](255) NULL,
	[UpdatedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRoadmapProgress]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRoadmapProgress](
	[UserId] [bigint] NOT NULL,
	[RoadmapId] [bigint] NOT NULL,
	[RoadmapItemId] [bigint] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[StartedAt] [datetime2](7) NULL,
	[CompletedAt] [datetime2](7) NULL,
	[UpdatedAt] [datetime2](7) NULL,
 CONSTRAINT [PK_UserRoadmapProgress] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoadmapItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRoles]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRoles](
	[UserId] [bigint] NOT NULL,
	[RoleId] [bigint] NOT NULL,
	[AssignedAt] [datetime2](7) NOT NULL,
	[AssignedBy] [bigint] NULL,
 CONSTRAINT [PK_UserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[FullName] [nvarchar](150) NOT NULL,
	[UserName] [nvarchar](100) NOT NULL,
	[Email] [nvarchar](255) NOT NULL,
	[PasswordHash] [nvarchar](500) NULL,
	[AvatarUrl] [nvarchar](500) NULL,
	[Status] [tinyint] NOT NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PhoneNumber] [nvarchar](20) NULL,
	[PhoneConfirmed] [bit] NOT NULL,
	[LastLoginAt] [datetime2](7) NULL,
	[FailedLoginCount] [int] NOT NULL,
	[LockoutEndAt] [datetime2](7) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[DeletedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserSettings]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserSettings](
	[UserId] [bigint] NOT NULL,
	[Theme] [nvarchar](20) NOT NULL,
	[Language] [nvarchar](20) NOT NULL,
	[CodeEditorTheme] [nvarchar](50) NOT NULL,
	[CodeEditorFontSize] [int] NOT NULL,
	[EnableEmailNotification] [bit] NOT NULL,
	[EnablePushNotification] [bit] NOT NULL,
	[HasCompletedOnboarding] [bit] NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserStats]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserStats](
	[UserId] [bigint] NOT NULL,
	[TotalQuizAttempts] [int] NOT NULL,
	[TotalCorrectAnswers] [int] NOT NULL,
	[AverageQuizScore] [decimal](5, 2) NOT NULL,
	[TotalCodeSubmissions] [int] NOT NULL,
	[AcceptedCodeSubmissions] [int] NOT NULL,
	[TotalPosts] [int] NOT NULL,
	[TotalComments] [int] NOT NULL,
	[Reputation] [int] NOT NULL,
	[StreakDays] [int] NOT NULL,
	[LastActivityAt] [datetime2](7) NULL,
	[UpdatedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserTopicProgress]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserTopicProgress](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[CategoryId] [bigint] NOT NULL,
	[TotalQuestions] [int] NOT NULL,
	[CompletedQuestions] [int] NOT NULL,
	[CorrectAnswers] [int] NOT NULL,
	[ProgressPercent] [decimal](5, 2) NOT NULL,
	[LastPracticedAt] [datetime2](7) NULL,
	[UpdatedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[XpRules]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XpRules](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ActionType] [nvarchar](100) NOT NULL,
	[Points] [int] NOT NULL,
	[Description] [nvarchar](255) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[XpTransactions]    Script Date: 10/07/2026 10:14:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XpTransactions](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[ActionType] [nvarchar](100) NOT NULL,
	[Points] [int] NOT NULL,
	[ReferenceType] [nvarchar](50) NULL,
	[ReferenceId] [bigint] NULL,
	[Description] [nvarchar](255) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20260709070000_ExistingDatabase_AddPermissionGroupsAndPersonalPractice', N'9.0.0')
GO
SET IDENTITY_INSERT [dbo].[Achievements] ON 

INSERT [dbo].[Achievements] ([Id], [Code], [Name], [Description], [IconUrl], [RequiredActionType], [RequiredValue], [XpReward], [IsActive], [CreatedAt]) VALUES (1, N'FIRST_QUIZ', N'Bài quiz đầu tiên', N'Hoàn thành bài quiz đầu tiên', NULL, N'CompleteQuiz', 1, 10, 1, CAST(N'2026-06-09T15:57:52.1821701' AS DateTime2))
INSERT [dbo].[Achievements] ([Id], [Code], [Name], [Description], [IconUrl], [RequiredActionType], [RequiredValue], [XpReward], [IsActive], [CreatedAt]) VALUES (2, N'FIRST_ACCEPTED_CODE', N'Accepted đầu tiên', N'Có bài code accepted đầu tiên', NULL, N'CodeAccepted', 1, 20, 1, CAST(N'2026-06-09T15:57:52.1821701' AS DateTime2))
INSERT [dbo].[Achievements] ([Id], [Code], [Name], [Description], [IconUrl], [RequiredActionType], [RequiredValue], [XpReward], [IsActive], [CreatedAt]) VALUES (3, N'FIRST_POST', N'Bài viết đầu tiên', N'Tạo bài viết đầu tiên', NULL, N'PostCreated', 1, 5, 1, CAST(N'2026-06-09T15:57:52.1821701' AS DateTime2))
INSERT [dbo].[Achievements] ([Id], [Code], [Name], [Description], [IconUrl], [RequiredActionType], [RequiredValue], [XpReward], [IsActive], [CreatedAt]) VALUES (4, N'SEVEN_DAY_STREAK', N'7 ngày liên tiếp', N'Học tập 7 ngày liên tiếp', NULL, N'DailyStreak', 7, 50, 1, CAST(N'2026-06-09T15:57:52.1821701' AS DateTime2))
SET IDENTITY_INSERT [dbo].[Achievements] OFF
GO
SET IDENTITY_INSERT [dbo].[AuditLogs] ON 

INSERT [dbo].[AuditLogs] ([Id], [UserId], [Action], [EntityName], [EntityId], [OldValues], [NewValues], [IpAddress], [UserAgent], [CreatedAt]) VALUES (1, 2, N'user.unlock', N'User', N'13', N'{"Status":1,"LockoutEndAt":null}', N'{"Status":1,"LockoutEndAt":null}', N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-10T02:23:08.0239186' AS DateTime2))
INSERT [dbo].[AuditLogs] ([Id], [UserId], [Action], [EntityName], [EntityId], [OldValues], [NewValues], [IpAddress], [UserAgent], [CreatedAt]) VALUES (2, 2, N'user.unlock', N'User', N'6', N'{"Status":1,"LockoutEndAt":null}', N'{"Status":1,"LockoutEndAt":null}', N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-10T02:23:16.5972122' AS DateTime2))
INSERT [dbo].[AuditLogs] ([Id], [UserId], [Action], [EntityName], [EntityId], [OldValues], [NewValues], [IpAddress], [UserAgent], [CreatedAt]) VALUES (3, 2, N'user.unlock', N'User', N'1', N'{"Status":1,"LockoutEndAt":null}', N'{"Status":1,"LockoutEndAt":null}', N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-10T02:23:18.7543005' AS DateTime2))
INSERT [dbo].[AuditLogs] ([Id], [UserId], [Action], [EntityName], [EntityId], [OldValues], [NewValues], [IpAddress], [UserAgent], [CreatedAt]) VALUES (4, 2, N'user.unlock', N'User', N'1', N'{"Status":1,"LockoutEndAt":null}', N'{"Status":1,"LockoutEndAt":null}', N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-10T02:23:19.5204858' AS DateTime2))
INSERT [dbo].[AuditLogs] ([Id], [UserId], [Action], [EntityName], [EntityId], [OldValues], [NewValues], [IpAddress], [UserAgent], [CreatedAt]) VALUES (5, 2, N'user.unlock', N'User', N'1', N'{"Status":1,"LockoutEndAt":null}', N'{"Status":1,"LockoutEndAt":null}', N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-10T02:23:19.7017606' AS DateTime2))
INSERT [dbo].[AuditLogs] ([Id], [UserId], [Action], [EntityName], [EntityId], [OldValues], [NewValues], [IpAddress], [UserAgent], [CreatedAt]) VALUES (6, 2, N'user.unlock', N'User', N'2', N'{"Status":1,"LockoutEndAt":null}', N'{"Status":1,"LockoutEndAt":null}', N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-10T02:23:21.3157500' AS DateTime2))
INSERT [dbo].[AuditLogs] ([Id], [UserId], [Action], [EntityName], [EntityId], [OldValues], [NewValues], [IpAddress], [UserAgent], [CreatedAt]) VALUES (7, 2, N'user.unlock', N'User', N'14', N'{"Status":1,"LockoutEndAt":null}', N'{"Status":1,"LockoutEndAt":null}', N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-10T02:24:33.4928643' AS DateTime2))
INSERT [dbo].[AuditLogs] ([Id], [UserId], [Action], [EntityName], [EntityId], [OldValues], [NewValues], [IpAddress], [UserAgent], [CreatedAt]) VALUES (8, 2, N'user.lock', N'User', N'14', N'{"Status":1,"LockoutEndAt":null}', N'{"Status":0,"LockoutEndAt":"2026-07-11T13:01:00","Reason":"test ch\u01B0\u0301c n\u0103ng"}', N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-10T02:25:10.0746114' AS DateTime2))
INSERT [dbo].[AuditLogs] ([Id], [UserId], [Action], [EntityName], [EntityId], [OldValues], [NewValues], [IpAddress], [UserAgent], [CreatedAt]) VALUES (9, 2, N'user.unlock', N'User', N'14', N'{"Status":0,"LockoutEndAt":"2026-07-11T13:01:00"}', N'{"Status":1,"LockoutEndAt":null}', N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-10T02:25:45.9281070' AS DateTime2))
INSERT [dbo].[AuditLogs] ([Id], [UserId], [Action], [EntityName], [EntityId], [OldValues], [NewValues], [IpAddress], [UserAgent], [CreatedAt]) VALUES (10, 2, N'user.permission_groups.assign', N'User', N'14', NULL, N'{"PermissionGroupIds":[1]}', N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-10T02:28:56.2148075' AS DateTime2))
SET IDENTITY_INSERT [dbo].[AuditLogs] OFF
GO
SET IDENTITY_INSERT [dbo].[Categories] ON 

INSERT [dbo].[Categories] ([Id], [ParentId], [Name], [Slug], [Description], [IconUrl], [DisplayOrder], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (1, NULL, N'SQL Cơ Bản', N'sql-co-ban', N'Chủ đề học SQL từ cơ bản', NULL, 1, 1, CAST(N'2026-06-09T15:57:52.1699857' AS DateTime2), NULL, 0)
INSERT [dbo].[Categories] ([Id], [ParentId], [Name], [Slug], [Description], [IconUrl], [DisplayOrder], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (2, NULL, N'C# Cơ Bản', N'csharp-co-ban', N'Chủ đề học C# cơ bản', NULL, 2, 1, CAST(N'2026-06-09T15:57:52.1699857' AS DateTime2), NULL, 0)
INSERT [dbo].[Categories] ([Id], [ParentId], [Name], [Slug], [Description], [IconUrl], [DisplayOrder], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (3, NULL, N'Angular Cơ Bản', N'angular', N'Chủ đề học Angular cơ bản', NULL, 3, 1, CAST(N'2026-06-09T15:57:52.1699857' AS DateTime2), CAST(N'2026-06-18T14:46:31.7018324' AS DateTime2), 0)
INSERT [dbo].[Categories] ([Id], [ParentId], [Name], [Slug], [Description], [IconUrl], [DisplayOrder], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (4, NULL, N'Java', N'java', N'Java learning track', NULL, 10, 1, CAST(N'2026-07-09T14:30:26.6254079' AS DateTime2), NULL, 0)
INSERT [dbo].[Categories] ([Id], [ParentId], [Name], [Slug], [Description], [IconUrl], [DisplayOrder], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (5, NULL, N'Python', N'python', N'Python learning track', NULL, 20, 1, CAST(N'2026-07-09T14:30:26.6665556' AS DateTime2), NULL, 0)
INSERT [dbo].[Categories] ([Id], [ParentId], [Name], [Slug], [Description], [IconUrl], [DisplayOrder], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (6, NULL, N'JavaScript', N'javascript', N'JavaScript learning track', NULL, 30, 1, CAST(N'2026-07-09T14:30:26.6679290' AS DateTime2), NULL, 0)
INSERT [dbo].[Categories] ([Id], [ParentId], [Name], [Slug], [Description], [IconUrl], [DisplayOrder], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (7, NULL, N'React', N'react', N'React learning track', NULL, 40, 1, CAST(N'2026-07-09T14:30:26.6689712' AS DateTime2), NULL, 0)
INSERT [dbo].[Categories] ([Id], [ParentId], [Name], [Slug], [Description], [IconUrl], [DisplayOrder], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (8, NULL, N'SQL', N'sql', N'SQL learning track', NULL, 50, 1, CAST(N'2026-07-09T14:30:26.6696926' AS DateTime2), NULL, 0)
INSERT [dbo].[Categories] ([Id], [ParentId], [Name], [Slug], [Description], [IconUrl], [DisplayOrder], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (9, NULL, N'System Design', N'system-design', N'System Design learning track', NULL, 60, 1, CAST(N'2026-07-09T14:30:26.6702275' AS DateTime2), NULL, 0)
INSERT [dbo].[Categories] ([Id], [ParentId], [Name], [Slug], [Description], [IconUrl], [DisplayOrder], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (10, NULL, N'Algorithms', N'algorithms', N'Algorithms learning track', NULL, 70, 1, CAST(N'2026-07-09T14:30:26.6707007' AS DateTime2), NULL, 0)
INSERT [dbo].[Categories] ([Id], [ParentId], [Name], [Slug], [Description], [IconUrl], [DisplayOrder], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (11, NULL, N'Cloud', N'cloud', N'Cloud learning track', NULL, 80, 1, CAST(N'2026-07-09T14:30:26.6711752' AS DateTime2), NULL, 0)
INSERT [dbo].[Categories] ([Id], [ParentId], [Name], [Slug], [Description], [IconUrl], [DisplayOrder], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (12, NULL, N'DevOps', N'devops', N'DevOps learning track', NULL, 90, 1, CAST(N'2026-07-09T14:30:26.6717311' AS DateTime2), NULL, 0)
SET IDENTITY_INSERT [dbo].[Categories] OFF
GO
SET IDENTITY_INSERT [dbo].[CodeSubmissions] ON 

INSERT [dbo].[CodeSubmissions] ([Id], [UserId], [CodingProblemId], [ProgrammingLanguageId], [SourceCode], [Status], [TotalTestCases], [PassedTestCases], [Score], [ExecutionTimeMs], [MemoryUsedKb], [ErrorMessage], [JudgeToken], [SubmittedAt], [JudgedAt], [ProblemId], [Language], [Stdin], [Output], [Error], [Verdict], [IsAccepted], [CreatedAt]) VALUES (3, 6, NULL, NULL, N'import sys

name = sys.stdin.read().strip() or ''World''
print(f''Hello, {name}!'')', N'Completed', 0, 0, CAST(0.00 AS Decimal(6, 2)), 79, 0, NULL, NULL, CAST(N'2026-07-09T09:57:47.8449551' AS DateTime2), NULL, NULL, N'python', N'DevLearningHub', N'Hello, DevLearningHub!
', N'', N'Accepted', 1, CAST(N'2026-07-09T09:57:47.6953970' AS DateTime2))
INSERT [dbo].[CodeSubmissions] ([Id], [UserId], [CodingProblemId], [ProgrammingLanguageId], [SourceCode], [Status], [TotalTestCases], [PassedTestCases], [Score], [ExecutionTimeMs], [MemoryUsedKb], [ErrorMessage], [JudgeToken], [SubmittedAt], [JudgedAt], [ProblemId], [Language], [Stdin], [Output], [Error], [Verdict], [IsAccepted], [CreatedAt]) VALUES (4, 6, NULL, NULL, N'#include <stdio.h>
int main() {
    printf("Hello, World!\n");
    return 0;
}', N'Failed', 0, 0, CAST(0.00 AS Decimal(6, 2)), 6, 0, NULL, NULL, CAST(N'2026-07-09T14:43:37.5530906' AS DateTime2), NULL, NULL, N'c', N'', N'', N'GCC runtime/compiler is not installed.', N'CompilationError', 0, CAST(N'2026-07-09T14:43:37.4972407' AS DateTime2))
INSERT [dbo].[CodeSubmissions] ([Id], [UserId], [CodingProblemId], [ProgrammingLanguageId], [SourceCode], [Status], [TotalTestCases], [PassedTestCases], [Score], [ExecutionTimeMs], [MemoryUsedKb], [ErrorMessage], [JudgeToken], [SubmittedAt], [JudgedAt], [ProblemId], [Language], [Stdin], [Output], [Error], [Verdict], [IsAccepted], [CreatedAt]) VALUES (5, 6, NULL, NULL, N'print("Hello, World!")', N'Success', 0, 0, CAST(0.00 AS Decimal(6, 2)), 194, 0, NULL, NULL, CAST(N'2026-07-09T14:43:48.3413374' AS DateTime2), NULL, NULL, N'python', N'', N'Hello, World!
', N'', N'Accepted', 1, CAST(N'2026-07-09T14:43:48.3408696' AS DateTime2))
INSERT [dbo].[CodeSubmissions] ([Id], [UserId], [CodingProblemId], [ProgrammingLanguageId], [SourceCode], [Status], [TotalTestCases], [PassedTestCases], [Score], [ExecutionTimeMs], [MemoryUsedKb], [ErrorMessage], [JudgeToken], [SubmittedAt], [JudgedAt], [ProblemId], [Language], [Stdin], [Output], [Error], [Verdict], [IsAccepted], [CreatedAt]) VALUES (6, 6, NULL, NULL, N'console.log("Hello, World!");', N'Success', 0, 0, CAST(0.00 AS Decimal(6, 2)), 117, 0, NULL, NULL, CAST(N'2026-07-09T14:43:56.5167704' AS DateTime2), NULL, NULL, N'javascript', N'', N'Hello, World!
', N'', N'Accepted', 1, CAST(N'2026-07-09T14:43:56.5147095' AS DateTime2))
INSERT [dbo].[CodeSubmissions] ([Id], [UserId], [CodingProblemId], [ProgrammingLanguageId], [SourceCode], [Status], [TotalTestCases], [PassedTestCases], [Score], [ExecutionTimeMs], [MemoryUsedKb], [ErrorMessage], [JudgeToken], [SubmittedAt], [JudgedAt], [ProblemId], [Language], [Stdin], [Output], [Error], [Verdict], [IsAccepted], [CreatedAt]) VALUES (7, 6, NULL, NULL, N'const message: string = "Hello, World!";
console.log(message);', N'Failed', 0, 0, CAST(0.00 AS Decimal(6, 2)), 333, 0, NULL, NULL, CAST(N'2026-07-09T14:44:02.2101949' AS DateTime2), NULL, NULL, N'typescript', N'', N'', N'node:internal/modules/cjs/loader:1386
  throw err;
  ^

Error: Cannot find module ''C:\Users\Lenovo\AppData\Local\Temp\DevLearningHubJudge\721882168e654c72a7cdd82beacb3b0d\node_modules\npm\bin\npm-prefix.js''
    at Function._resolveFilename (node:internal/modules/cjs/loader:1383:15)
    at defaultResolveImpl (node:internal/modules/cjs/loader:1025:19)
    at resolveForCJSWithHooks (node:internal/modules/cjs/loader:1030:22)
    at Function._load (node:internal/modules/cjs/loader:1192:37)
    at TracingChannel.traceSync (node:diagnostics_channel:322:14)
    at wrapModuleLoad (node:internal/modules/cjs/loader:237:24)
    at Function.executeUserEntryPoint [as runMain] (node:internal/modules/run_main:171:5)
    at node:internal/main/run_main_module:36:49 {
  code: ''MODULE_NOT_FOUND'',
  requireStack: []
}

Node.js v22.20.0
node:internal/modules/cjs/loader:1386
  throw err;
  ^

Error: Cannot find module ''C:\Users\Lenovo\AppData\Local\Temp\DevLearningHubJudge\721882168e654c72a7cdd82beacb3b0d\node_modules\npm\bin\npx-cli.js''
    at Function._resolveFilename (node:internal/modules/cjs/loader:1383:15)
    at defaultResolveImpl (node:internal/modules/cjs/loader:1025:19)
    at resolveForCJSWithHooks (node:internal/modules/cjs/loader:1030:22)
    at Function._load (node:internal/modules/cjs/loader:1192:37)
    at TracingChannel.traceSync (node:diagnostics_channel:322:14)
    at wrapModuleLoad (node:internal/modules/cjs/loader:237:24)
    at Function.executeUserEntryPoint [as runMain] (node:internal/modules/run_main:171:5)
    at node:internal/main/run_main_module:36:49 {
  code: ''MODULE_NOT_FOUND'',
  requireStack: []
}

Node.js v22.20.0
', N'CompilationError', 0, CAST(N'2026-07-09T14:44:02.2028063' AS DateTime2))
INSERT [dbo].[CodeSubmissions] ([Id], [UserId], [CodingProblemId], [ProgrammingLanguageId], [SourceCode], [Status], [TotalTestCases], [PassedTestCases], [Score], [ExecutionTimeMs], [MemoryUsedKb], [ErrorMessage], [JudgeToken], [SubmittedAt], [JudgedAt], [ProblemId], [Language], [Stdin], [Output], [Error], [Verdict], [IsAccepted], [CreatedAt]) VALUES (8, 6, NULL, NULL, N'public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}', N'Success', 0, 0, CAST(0.00 AS Decimal(6, 2)), 186, 0, NULL, NULL, CAST(N'2026-07-09T14:44:16.7926668' AS DateTime2), NULL, NULL, N'java', N'', N'Hello, World!
', N'', N'Accepted', 1, CAST(N'2026-07-09T14:44:16.7916116' AS DateTime2))
INSERT [dbo].[CodeSubmissions] ([Id], [UserId], [CodingProblemId], [ProgrammingLanguageId], [SourceCode], [Status], [TotalTestCases], [PassedTestCases], [Score], [ExecutionTimeMs], [MemoryUsedKb], [ErrorMessage], [JudgeToken], [SubmittedAt], [JudgedAt], [ProblemId], [Language], [Stdin], [Output], [Error], [Verdict], [IsAccepted], [CreatedAt]) VALUES (9, 6, NULL, NULL, N'using System;
public class Program {
    public static void Main() {
        Console.WriteLine("Hello, World!");
    }
}', N'Failed', 0, 0, CAST(0.00 AS Decimal(6, 2)), 4178, 0, NULL, NULL, CAST(N'2026-07-09T14:44:31.6763801' AS DateTime2), NULL, NULL, N'csharp', N'', N'', N'An issue was encountered verifying workloads. For more information, run "dotnet workload update".
C:\Program Files\dotnet\sdk\9.0.315\NuGet.targets(781,5): error : Value cannot be null. (Parameter ''path1'') [C:\Users\Lenovo\AppData\Local\Temp\DevLearningHubJudge\99e80dcee647421681b3df224d4a10f9\Main.csproj]

Build FAILED.

C:\Program Files\dotnet\sdk\9.0.315\NuGet.targets(781,5): error : Value cannot be null. (Parameter ''path1'') [C:\Users\Lenovo\AppData\Local\Temp\DevLearningHubJudge\99e80dcee647421681b3df224d4a10f9\Main.csproj]
    0 Warning(s)
    1 Error(s)

Time Elapsed 00:00:00.80
', N'CompilationError', 0, CAST(N'2026-07-09T14:44:31.6815669' AS DateTime2))
INSERT [dbo].[CodeSubmissions] ([Id], [UserId], [CodingProblemId], [ProgrammingLanguageId], [SourceCode], [Status], [TotalTestCases], [PassedTestCases], [Score], [ExecutionTimeMs], [MemoryUsedKb], [ErrorMessage], [JudgeToken], [SubmittedAt], [JudgedAt], [ProblemId], [Language], [Stdin], [Output], [Error], [Verdict], [IsAccepted], [CreatedAt]) VALUES (10, 6, NULL, NULL, N'package main
import "fmt"
func main() {
    fmt.Println("Hello, World!")
}', N'Failed', 0, 0, CAST(0.00 AS Decimal(6, 2)), 1, 0, NULL, NULL, CAST(N'2026-07-09T14:44:42.9154316' AS DateTime2), NULL, NULL, N'go', N'', N'', N'Go runtime/compiler is not installed.', N'RuntimeError', 0, CAST(N'2026-07-09T14:44:42.9140350' AS DateTime2))
INSERT [dbo].[CodeSubmissions] ([Id], [UserId], [CodingProblemId], [ProgrammingLanguageId], [SourceCode], [Status], [TotalTestCases], [PassedTestCases], [Score], [ExecutionTimeMs], [MemoryUsedKb], [ErrorMessage], [JudgeToken], [SubmittedAt], [JudgedAt], [ProblemId], [Language], [Stdin], [Output], [Error], [Verdict], [IsAccepted], [CreatedAt]) VALUES (11, 6, NULL, NULL, N'print("Hello, World!")', N'Completed', 1, 1, CAST(0.00 AS Decimal(6, 2)), 72, 0, NULL, NULL, CAST(N'2026-07-09T14:48:40.5093663' AS DateTime2), NULL, 1, N'python', NULL, N'', N'', N'Accepted', 1, CAST(N'2026-07-09T14:48:40.3415957' AS DateTime2))
INSERT [dbo].[CodeSubmissions] ([Id], [UserId], [CodingProblemId], [ProgrammingLanguageId], [SourceCode], [Status], [TotalTestCases], [PassedTestCases], [Score], [ExecutionTimeMs], [MemoryUsedKb], [ErrorMessage], [JudgeToken], [SubmittedAt], [JudgedAt], [ProblemId], [Language], [Stdin], [Output], [Error], [Verdict], [IsAccepted], [CreatedAt]) VALUES (12, 6, NULL, NULL, N'print("Hello")', N'Completed', 1, 0, CAST(0.00 AS Decimal(6, 2)), 72, 0, NULL, NULL, CAST(N'2026-07-09T14:49:11.0644467' AS DateTime2), NULL, 1, N'python', NULL, N'Hello
', N'', N'WrongAnswer', 0, CAST(N'2026-07-09T14:49:11.0622326' AS DateTime2))
INSERT [dbo].[CodeSubmissions] ([Id], [UserId], [CodingProblemId], [ProgrammingLanguageId], [SourceCode], [Status], [TotalTestCases], [PassedTestCases], [Score], [ExecutionTimeMs], [MemoryUsedKb], [ErrorMessage], [JudgeToken], [SubmittedAt], [JudgedAt], [ProblemId], [Language], [Stdin], [Output], [Error], [Verdict], [IsAccepted], [CreatedAt]) VALUES (13, 6, NULL, NULL, N'prinft("Hello, World!")', N'Completed', 1, 0, CAST(0.00 AS Decimal(6, 2)), 83, 0, NULL, NULL, CAST(N'2026-07-09T14:49:27.9243495' AS DateTime2), NULL, 1, N'python', NULL, N'', N'Traceback (most recent call last):
  File "C:\Users\Lenovo\AppData\Local\Temp\DevLearningHubJudge\83add0b6f73a42f0b141f2fab0323de5\main.py", line 1, in <module>
    prinft("Hello, World!")
NameError: name ''prinft'' is not defined. Did you mean: ''print''?
', N'RuntimeError', 0, CAST(N'2026-07-09T14:49:27.9156897' AS DateTime2))
INSERT [dbo].[CodeSubmissions] ([Id], [UserId], [CodingProblemId], [ProgrammingLanguageId], [SourceCode], [Status], [TotalTestCases], [PassedTestCases], [Score], [ExecutionTimeMs], [MemoryUsedKb], [ErrorMessage], [JudgeToken], [SubmittedAt], [JudgedAt], [ProblemId], [Language], [Stdin], [Output], [Error], [Verdict], [IsAccepted], [CreatedAt]) VALUES (14, 6, NULL, NULL, N'print("Hello, World!")', N'Success', 0, 0, CAST(0.00 AS Decimal(6, 2)), 131, 0, NULL, NULL, CAST(N'2026-07-09T17:04:52.4429888' AS DateTime2), NULL, NULL, N'python', N'', N'Hello, World!
', N'', N'Accepted', 1, CAST(N'2026-07-09T17:04:52.3970675' AS DateTime2))
INSERT [dbo].[CodeSubmissions] ([Id], [UserId], [CodingProblemId], [ProgrammingLanguageId], [SourceCode], [Status], [TotalTestCases], [PassedTestCases], [Score], [ExecutionTimeMs], [MemoryUsedKb], [ErrorMessage], [JudgeToken], [SubmittedAt], [JudgedAt], [ProblemId], [Language], [Stdin], [Output], [Error], [Verdict], [IsAccepted], [CreatedAt]) VALUES (15, 6, NULL, NULL, N'console.log("Hello, World!");', N'Success', 0, 0, CAST(0.00 AS Decimal(6, 2)), 107, 0, NULL, NULL, CAST(N'2026-07-09T17:04:57.9657119' AS DateTime2), NULL, NULL, N'javascript', N'', N'Hello, World!
', N'', N'Accepted', 1, CAST(N'2026-07-09T17:04:57.9633823' AS DateTime2))
INSERT [dbo].[CodeSubmissions] ([Id], [UserId], [CodingProblemId], [ProgrammingLanguageId], [SourceCode], [Status], [TotalTestCases], [PassedTestCases], [Score], [ExecutionTimeMs], [MemoryUsedKb], [ErrorMessage], [JudgeToken], [SubmittedAt], [JudgedAt], [ProblemId], [Language], [Stdin], [Output], [Error], [Verdict], [IsAccepted], [CreatedAt]) VALUES (16, 6, NULL, NULL, N'const message: string = "Hello, World!";
console.log(message);', N'Failed', 0, 0, CAST(0.00 AS Decimal(6, 2)), 315, 0, NULL, NULL, CAST(N'2026-07-09T17:05:04.1096227' AS DateTime2), NULL, NULL, N'typescript', N'', N'', N'node:internal/modules/cjs/loader:1386
  throw err;
  ^

Error: Cannot find module ''C:\Users\Lenovo\AppData\Local\Temp\DevLearningHubJudge\1a07adbf35e045e3b79d2026b09029ff\node_modules\npm\bin\npm-prefix.js''
    at Function._resolveFilename (node:internal/modules/cjs/loader:1383:15)
    at defaultResolveImpl (node:internal/modules/cjs/loader:1025:19)
    at resolveForCJSWithHooks (node:internal/modules/cjs/loader:1030:22)
    at Function._load (node:internal/modules/cjs/loader:1192:37)
    at TracingChannel.traceSync (node:diagnostics_channel:322:14)
    at wrapModuleLoad (node:internal/modules/cjs/loader:237:24)
    at Function.executeUserEntryPoint [as runMain] (node:internal/modules/run_main:171:5)
    at node:internal/main/run_main_module:36:49 {
  code: ''MODULE_NOT_FOUND'',
  requireStack: []
}

Node.js v22.20.0
node:internal/modules/cjs/loader:1386
  throw err;
  ^

Error: Cannot find module ''C:\Users\Lenovo\AppData\Local\Temp\DevLearningHubJudge\1a07adbf35e045e3b79d2026b09029ff\node_modules\npm\bin\npx-cli.js''
    at Function._resolveFilename (node:internal/modules/cjs/loader:1383:15)
    at defaultResolveImpl (node:internal/modules/cjs/loader:1025:19)
    at resolveForCJSWithHooks (node:internal/modules/cjs/loader:1030:22)
    at Function._load (node:internal/modules/cjs/loader:1192:37)
    at TracingChannel.traceSync (node:diagnostics_channel:322:14)
    at wrapModuleLoad (node:internal/modules/cjs/loader:237:24)
    at Function.executeUserEntryPoint [as runMain] (node:internal/modules/run_main:171:5)
    at node:internal/main/run_main_module:36:49 {
  code: ''MODULE_NOT_FOUND'',
  requireStack: []
}

Node.js v22.20.0
', N'CompilationError', 0, CAST(N'2026-07-09T17:05:04.1070893' AS DateTime2))
INSERT [dbo].[CodeSubmissions] ([Id], [UserId], [CodingProblemId], [ProgrammingLanguageId], [SourceCode], [Status], [TotalTestCases], [PassedTestCases], [Score], [ExecutionTimeMs], [MemoryUsedKb], [ErrorMessage], [JudgeToken], [SubmittedAt], [JudgedAt], [ProblemId], [Language], [Stdin], [Output], [Error], [Verdict], [IsAccepted], [CreatedAt]) VALUES (17, 6, NULL, NULL, N'public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}', N'Success', 0, 0, CAST(0.00 AS Decimal(6, 2)), 111, 0, NULL, NULL, CAST(N'2026-07-09T17:05:24.1937382' AS DateTime2), NULL, NULL, N'java', N'', N'Hello, World!
', N'', N'Accepted', 1, CAST(N'2026-07-09T17:05:24.1926433' AS DateTime2))
INSERT [dbo].[CodeSubmissions] ([Id], [UserId], [CodingProblemId], [ProgrammingLanguageId], [SourceCode], [Status], [TotalTestCases], [PassedTestCases], [Score], [ExecutionTimeMs], [MemoryUsedKb], [ErrorMessage], [JudgeToken], [SubmittedAt], [JudgedAt], [ProblemId], [Language], [Stdin], [Output], [Error], [Verdict], [IsAccepted], [CreatedAt]) VALUES (18, 6, NULL, NULL, N'#include <stdio.h>
int main() {
    printf("Hello, World!\n");
    return 0;
}', N'Failed', 0, 0, CAST(0.00 AS Decimal(6, 2)), 11, 0, NULL, NULL, CAST(N'2026-07-09T17:05:34.7375625' AS DateTime2), NULL, NULL, N'c', N'', N'', N'GCC runtime/compiler is not installed.', N'CompilationError', 0, CAST(N'2026-07-09T17:05:34.7372789' AS DateTime2))
INSERT [dbo].[CodeSubmissions] ([Id], [UserId], [CodingProblemId], [ProgrammingLanguageId], [SourceCode], [Status], [TotalTestCases], [PassedTestCases], [Score], [ExecutionTimeMs], [MemoryUsedKb], [ErrorMessage], [JudgeToken], [SubmittedAt], [JudgedAt], [ProblemId], [Language], [Stdin], [Output], [Error], [Verdict], [IsAccepted], [CreatedAt]) VALUES (19, 6, NULL, NULL, N'#include <bits/stdc++.h>
using namespace std;
int main() {
    cout << "Hello, World!" << endl;
    return 0;
}', N'Failed', 0, 0, CAST(0.00 AS Decimal(6, 2)), 4, 0, NULL, NULL, CAST(N'2026-07-09T17:05:42.4660525' AS DateTime2), NULL, NULL, N'cpp', N'', N'', N'G++ runtime/compiler is not installed.', N'CompilationError', 0, CAST(N'2026-07-09T17:05:42.4643981' AS DateTime2))
INSERT [dbo].[CodeSubmissions] ([Id], [UserId], [CodingProblemId], [ProgrammingLanguageId], [SourceCode], [Status], [TotalTestCases], [PassedTestCases], [Score], [ExecutionTimeMs], [MemoryUsedKb], [ErrorMessage], [JudgeToken], [SubmittedAt], [JudgedAt], [ProblemId], [Language], [Stdin], [Output], [Error], [Verdict], [IsAccepted], [CreatedAt]) VALUES (20, 6, NULL, NULL, N'using System;
public class Program {
    public static void Main() {
        Console.WriteLine("Hello, World!");
    }
}', N'Failed', 0, 0, CAST(0.00 AS Decimal(6, 2)), 3408, 0, NULL, NULL, CAST(N'2026-07-09T17:05:50.8728428' AS DateTime2), NULL, NULL, N'csharp', N'', N'', N'An issue was encountered verifying workloads. For more information, run "dotnet workload update".
C:\Program Files\dotnet\sdk\9.0.315\NuGet.targets(781,5): error : Value cannot be null. (Parameter ''path1'') [C:\Users\Lenovo\AppData\Local\Temp\DevLearningHubJudge\b551cafc209944acb8a155537c192974\Main.csproj]

Build FAILED.

C:\Program Files\dotnet\sdk\9.0.315\NuGet.targets(781,5): error : Value cannot be null. (Parameter ''path1'') [C:\Users\Lenovo\AppData\Local\Temp\DevLearningHubJudge\b551cafc209944acb8a155537c192974\Main.csproj]
    0 Warning(s)
    1 Error(s)

Time Elapsed 00:00:00.51
', N'CompilationError', 0, CAST(N'2026-07-09T17:05:50.8640372' AS DateTime2))
INSERT [dbo].[CodeSubmissions] ([Id], [UserId], [CodingProblemId], [ProgrammingLanguageId], [SourceCode], [Status], [TotalTestCases], [PassedTestCases], [Score], [ExecutionTimeMs], [MemoryUsedKb], [ErrorMessage], [JudgeToken], [SubmittedAt], [JudgedAt], [ProblemId], [Language], [Stdin], [Output], [Error], [Verdict], [IsAccepted], [CreatedAt]) VALUES (21, 6, NULL, NULL, N'package main
import "fmt"
func main() {
    fmt.Println("Hello, World!")
}', N'Failed', 0, 0, CAST(0.00 AS Decimal(6, 2)), 4, 0, NULL, NULL, CAST(N'2026-07-09T17:05:55.0102724' AS DateTime2), NULL, NULL, N'go', N'', N'', N'Go runtime/compiler is not installed.', N'RuntimeError', 0, CAST(N'2026-07-09T17:05:55.0074048' AS DateTime2))
INSERT [dbo].[CodeSubmissions] ([Id], [UserId], [CodingProblemId], [ProgrammingLanguageId], [SourceCode], [Status], [TotalTestCases], [PassedTestCases], [Score], [ExecutionTimeMs], [MemoryUsedKb], [ErrorMessage], [JudgeToken], [SubmittedAt], [JudgedAt], [ProblemId], [Language], [Stdin], [Output], [Error], [Verdict], [IsAccepted], [CreatedAt]) VALUES (22, 14, NULL, NULL, N'print("Hello, World!")', N'Success', 0, 0, CAST(0.00 AS Decimal(6, 2)), 159, 0, NULL, NULL, CAST(N'2026-07-10T01:51:15.7312620' AS DateTime2), NULL, NULL, N'python', N'', N'Hello, World!
', N'', N'Accepted', 1, CAST(N'2026-07-10T01:51:15.6747273' AS DateTime2))
INSERT [dbo].[CodeSubmissions] ([Id], [UserId], [CodingProblemId], [ProgrammingLanguageId], [SourceCode], [Status], [TotalTestCases], [PassedTestCases], [Score], [ExecutionTimeMs], [MemoryUsedKb], [ErrorMessage], [JudgeToken], [SubmittedAt], [JudgedAt], [ProblemId], [Language], [Stdin], [Output], [Error], [Verdict], [IsAccepted], [CreatedAt]) VALUES (23, 14, NULL, NULL, N'console.log("Hello!");', N'Completed', 1, 0, CAST(0.00 AS Decimal(6, 2)), 101, 0, NULL, NULL, CAST(N'2026-07-10T01:52:03.8801047' AS DateTime2), NULL, 1, N'javascript', NULL, N'Hello!
', N'', N'WrongAnswer', 0, CAST(N'2026-07-10T01:52:03.8525502' AS DateTime2))
INSERT [dbo].[CodeSubmissions] ([Id], [UserId], [CodingProblemId], [ProgrammingLanguageId], [SourceCode], [Status], [TotalTestCases], [PassedTestCases], [Score], [ExecutionTimeMs], [MemoryUsedKb], [ErrorMessage], [JudgeToken], [SubmittedAt], [JudgedAt], [ProblemId], [Language], [Stdin], [Output], [Error], [Verdict], [IsAccepted], [CreatedAt]) VALUES (24, 14, NULL, NULL, N'console.log("Hello, World!");', N'Completed', 1, 1, CAST(0.00 AS Decimal(6, 2)), 81, 0, NULL, NULL, CAST(N'2026-07-10T01:52:24.2399300' AS DateTime2), NULL, 1, N'javascript', NULL, N'', N'', N'Accepted', 1, CAST(N'2026-07-10T01:52:24.2402755' AS DateTime2))
INSERT [dbo].[CodeSubmissions] ([Id], [UserId], [CodingProblemId], [ProgrammingLanguageId], [SourceCode], [Status], [TotalTestCases], [PassedTestCases], [Score], [ExecutionTimeMs], [MemoryUsedKb], [ErrorMessage], [JudgeToken], [SubmittedAt], [JudgedAt], [ProblemId], [Language], [Stdin], [Output], [Error], [Verdict], [IsAccepted], [CreatedAt]) VALUES (25, 14, NULL, NULL, N'print("Hello, World!")', N'Completed', 1, 1, CAST(0.00 AS Decimal(6, 2)), 71, 0, NULL, NULL, CAST(N'2026-07-10T01:52:34.7720689' AS DateTime2), NULL, 1, N'python', NULL, N'', N'', N'Accepted', 1, CAST(N'2026-07-10T01:52:34.7713829' AS DateTime2))
INSERT [dbo].[CodeSubmissions] ([Id], [UserId], [CodingProblemId], [ProgrammingLanguageId], [SourceCode], [Status], [TotalTestCases], [PassedTestCases], [Score], [ExecutionTimeMs], [MemoryUsedKb], [ErrorMessage], [JudgeToken], [SubmittedAt], [JudgedAt], [ProblemId], [Language], [Stdin], [Output], [Error], [Verdict], [IsAccepted], [CreatedAt]) VALUES (26, 15, NULL, NULL, N'console.log("Hello, World!");', N'Completed', 1, 1, CAST(0.00 AS Decimal(6, 2)), 69, 0, NULL, NULL, CAST(N'2026-07-10T02:17:13.7716188' AS DateTime2), NULL, 1, N'javascript', NULL, N'', N'', N'Accepted', 1, CAST(N'2026-07-10T02:17:13.7019970' AS DateTime2))
INSERT [dbo].[CodeSubmissions] ([Id], [UserId], [CodingProblemId], [ProgrammingLanguageId], [SourceCode], [Status], [TotalTestCases], [PassedTestCases], [Score], [ExecutionTimeMs], [MemoryUsedKb], [ErrorMessage], [JudgeToken], [SubmittedAt], [JudgedAt], [ProblemId], [Language], [Stdin], [Output], [Error], [Verdict], [IsAccepted], [CreatedAt]) VALUES (27, 15, NULL, NULL, N'console.log("Hello, DevLearningHub!");', N'Completed', 1, 1, CAST(0.00 AS Decimal(6, 2)), 93, 0, NULL, NULL, CAST(N'2026-07-10T02:41:20.3440275' AS DateTime2), NULL, 2, N'javascript', NULL, N'', N'', N'Accepted', 1, CAST(N'2026-07-10T02:41:20.3391341' AS DateTime2))
INSERT [dbo].[CodeSubmissions] ([Id], [UserId], [CodingProblemId], [ProgrammingLanguageId], [SourceCode], [Status], [TotalTestCases], [PassedTestCases], [Score], [ExecutionTimeMs], [MemoryUsedKb], [ErrorMessage], [JudgeToken], [SubmittedAt], [JudgedAt], [ProblemId], [Language], [Stdin], [Output], [Error], [Verdict], [IsAccepted], [CreatedAt]) VALUES (28, 15, NULL, NULL, N'console.log("Hello, World!");', N'Success', 0, 0, CAST(0.00 AS Decimal(6, 2)), 101, 0, NULL, NULL, CAST(N'2026-07-10T03:07:39.7122890' AS DateTime2), NULL, NULL, N'javascript', N'', N'Hello, World!
', N'', N'Accepted', 1, CAST(N'2026-07-10T03:07:39.6549773' AS DateTime2))
SET IDENTITY_INSERT [dbo].[CodeSubmissions] OFF
GO
SET IDENTITY_INSERT [dbo].[CodeSubmissionTestCaseResults] ON 

INSERT [dbo].[CodeSubmissionTestCaseResults] ([Id], [SubmissionId], [TestCaseId], [DisplayOrder], [Input], [ExpectedOutput], [ActualOutput], [Error], [Status], [Passed], [ExecutionTimeMs]) VALUES (1, 11, 1, 1, N'', N'Hello, World!', N'Hello, World!
', N'', N'Accepted', 1, 72)
INSERT [dbo].[CodeSubmissionTestCaseResults] ([Id], [SubmissionId], [TestCaseId], [DisplayOrder], [Input], [ExpectedOutput], [ActualOutput], [Error], [Status], [Passed], [ExecutionTimeMs]) VALUES (2, 12, 1, 1, N'', N'Hello, World!', N'Hello
', N'', N'WrongAnswer', 0, 72)
INSERT [dbo].[CodeSubmissionTestCaseResults] ([Id], [SubmissionId], [TestCaseId], [DisplayOrder], [Input], [ExpectedOutput], [ActualOutput], [Error], [Status], [Passed], [ExecutionTimeMs]) VALUES (3, 13, 1, 1, N'', N'Hello, World!', N'', N'Traceback (most recent call last):
  File "C:\Users\Lenovo\AppData\Local\Temp\DevLearningHubJudge\83add0b6f73a42f0b141f2fab0323de5\main.py", line 1, in <module>
    prinft("Hello, World!")
NameError: name ''prinft'' is not defined. Did you mean: ''print''?
', N'RuntimeError', 0, 83)
INSERT [dbo].[CodeSubmissionTestCaseResults] ([Id], [SubmissionId], [TestCaseId], [DisplayOrder], [Input], [ExpectedOutput], [ActualOutput], [Error], [Status], [Passed], [ExecutionTimeMs]) VALUES (4, 23, 1, 1, N'', N'Hello, World!', N'Hello!
', N'', N'WrongAnswer', 0, 101)
INSERT [dbo].[CodeSubmissionTestCaseResults] ([Id], [SubmissionId], [TestCaseId], [DisplayOrder], [Input], [ExpectedOutput], [ActualOutput], [Error], [Status], [Passed], [ExecutionTimeMs]) VALUES (5, 24, 1, 1, N'', N'Hello, World!', N'Hello, World!
', N'', N'Accepted', 1, 81)
INSERT [dbo].[CodeSubmissionTestCaseResults] ([Id], [SubmissionId], [TestCaseId], [DisplayOrder], [Input], [ExpectedOutput], [ActualOutput], [Error], [Status], [Passed], [ExecutionTimeMs]) VALUES (6, 25, 1, 1, N'', N'Hello, World!', N'Hello, World!
', N'', N'Accepted', 1, 71)
INSERT [dbo].[CodeSubmissionTestCaseResults] ([Id], [SubmissionId], [TestCaseId], [DisplayOrder], [Input], [ExpectedOutput], [ActualOutput], [Error], [Status], [Passed], [ExecutionTimeMs]) VALUES (7, 26, 1, 1, N'', N'Hello, World!', N'Hello, World!
', N'', N'Accepted', 1, 69)
INSERT [dbo].[CodeSubmissionTestCaseResults] ([Id], [SubmissionId], [TestCaseId], [DisplayOrder], [Input], [ExpectedOutput], [ActualOutput], [Error], [Status], [Passed], [ExecutionTimeMs]) VALUES (8, 27, 2, 1, N'', N'Hello, DevLearningHub!', N'Hello, DevLearningHub!
', N'', N'Accepted', 1, 93)
SET IDENTITY_INSERT [dbo].[CodeSubmissionTestCaseResults] OFF
GO
SET IDENTITY_INSERT [dbo].[CodingProblems] ON 

INSERT [dbo].[CodingProblems] ([Id], [CategoryId], [CreatedByUserId], [Title], [Slug], [Description], [InputDescription], [OutputDescription], [Constraints], [SampleInput], [SampleOutput], [Difficulty], [TimeLimitMs], [MemoryLimitMb], [AcceptanceRate], [TotalSubmissions], [AcceptedSubmissions], [Status], [CreatedAt], [UpdatedAt], [IsDeleted], [InputFormat], [OutputFormat], [ExamplesJson], [Tags], [StarterCodePython], [StarterCodeJavaScript], [StarterCodeTypeScript], [StarterCodeJava], [StarterCodeC], [StarterCodeCpp], [StarterCodeCsharp], [StarterCodeGo], [MemoryLimitKb]) VALUES (1, NULL, 1, N'Hello World', N'hello-world', N'Viết chương trình in ra dòng chữ Hello, World!.', NULL, NULL, N'Chương trình phải chạy trong giới hạn thời gian.', NULL, NULL, 1, 2000, 128, CAST(0.00 AS Decimal(5, 2)), 7, 4, 1, CAST(N'2026-07-09T14:47:31.1650812' AS DateTime2), NULL, 0, N'Không có input.', N'In ra đúng dòng: Hello, World!', N'[{"input":"","output":"Hello, World!","explanation":"In ra chuỗi yêu cầu."}]', N'beginner,output,basic', N'print("Hello, World!")', N'console.log("Hello, World!");', N'const message: string = "Hello, World!";
console.log(message);', N'public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}', N'#include <stdio.h>
int main() {
    printf("Hello, World!\n");
    return 0;
}', N'#include <bits/stdc++.h>
using namespace std;

int main() {
    cout << "Hello, World!" << endl;
    return 0;
}', N'using System;

public class Program {
    public static void Main() {
        Console.WriteLine("Hello, World!");
    }
}', N'package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}', 131072)
INSERT [dbo].[CodingProblems] ([Id], [CategoryId], [CreatedByUserId], [Title], [Slug], [Description], [InputDescription], [OutputDescription], [Constraints], [SampleInput], [SampleOutput], [Difficulty], [TimeLimitMs], [MemoryLimitMb], [AcceptanceRate], [TotalSubmissions], [AcceptedSubmissions], [Status], [CreatedAt], [UpdatedAt], [IsDeleted], [InputFormat], [OutputFormat], [ExamplesJson], [Tags], [StarterCodePython], [StarterCodeJavaScript], [StarterCodeTypeScript], [StarterCodeJava], [StarterCodeC], [StarterCodeCpp], [StarterCodeCsharp], [StarterCodeGo], [MemoryLimitKb]) VALUES (2, NULL, 2, N'Hello DevLearningHub', N'hello-devlearninghub', N'Viết chương trình in ra đúng dòng: Hello, DevLearningHub!', NULL, NULL, N'Chạy trong giới hạn thời gian.', NULL, NULL, 1, 2000, 128, CAST(0.00 AS Decimal(5, 2)), 1, 1, 1, CAST(N'2026-07-10T02:41:01.4318447' AS DateTime2), NULL, 0, N'Không có input.', N'In ra dòng Hello, DevLearningHub!', NULL, N'basic, output, demo', N'print("Hello, DevLearningHub!")', N'console.log("Hello, DevLearningHub!");', NULL, NULL, NULL, N'#include <bits/stdc++.h>
using namespace std;
int main(){ cout << "Hello, DevLearningHub!" << endl; return 0; }', NULL, NULL, 131072)
INSERT [dbo].[CodingProblems] ([Id], [CategoryId], [CreatedByUserId], [Title], [Slug], [Description], [InputDescription], [OutputDescription], [Constraints], [SampleInput], [SampleOutput], [Difficulty], [TimeLimitMs], [MemoryLimitMb], [AcceptanceRate], [TotalSubmissions], [AcceptedSubmissions], [Status], [CreatedAt], [UpdatedAt], [IsDeleted], [InputFormat], [OutputFormat], [ExamplesJson], [Tags], [StarterCodePython], [StarterCodeJavaScript], [StarterCodeTypeScript], [StarterCodeJava], [StarterCodeC], [StarterCodeCpp], [StarterCodeCsharp], [StarterCodeGo], [MemoryLimitKb]) VALUES (3, NULL, 2, N'Tổng hai số', N'tong-hai-so-demo', N'Cho hai số nguyên a và b. Hãy in ra tổng a + b.', NULL, NULL, N'-10^9 <= a,b <= 10^9', NULL, NULL, 1, 2000, 128, CAST(0.00 AS Decimal(5, 2)), 0, 0, 1, CAST(N'2026-07-10T02:41:01.4580984' AS DateTime2), NULL, 0, N'Một dòng gồm hai số nguyên a và b.', N'In ra tổng của a và b.', NULL, N'basic, math', N'a,b=map(int,input().split())
print(a+b)', N'const fs=require("fs");
const [a,b]=fs.readFileSync(0,"utf8").trim().split(/\s+/).map(Number);
console.log(a+b);', NULL, NULL, NULL, N'#include <bits/stdc++.h>
using namespace std;
int main(){ long long a,b; cin>>a>>b; cout<<a+b; }', NULL, NULL, 131072)
SET IDENTITY_INSERT [dbo].[CodingProblems] OFF
GO
SET IDENTITY_INSERT [dbo].[CodingTestCases] ON 

INSERT [dbo].[CodingTestCases] ([Id], [ProblemId], [Input], [ExpectedOutput], [Explanation], [IsHidden], [DisplayOrder], [CreatedAt]) VALUES (1, 1, N'', N'Hello, World!', N'Output phải đúng chuỗi Hello, World!', 0, 1, CAST(N'2026-07-09T14:47:31.1784192' AS DateTime2))
INSERT [dbo].[CodingTestCases] ([Id], [ProblemId], [Input], [ExpectedOutput], [Explanation], [IsHidden], [DisplayOrder], [CreatedAt]) VALUES (2, 2, N'', N'Hello, DevLearningHub!', NULL, 0, 1, CAST(N'2026-07-10T02:41:01.4354871' AS DateTime2))
INSERT [dbo].[CodingTestCases] ([Id], [ProblemId], [Input], [ExpectedOutput], [Explanation], [IsHidden], [DisplayOrder], [CreatedAt]) VALUES (3, 3, N'2 3', N'5', NULL, 0, 1, CAST(N'2026-07-10T02:41:01.4582780' AS DateTime2))
INSERT [dbo].[CodingTestCases] ([Id], [ProblemId], [Input], [ExpectedOutput], [Explanation], [IsHidden], [DisplayOrder], [CreatedAt]) VALUES (4, 3, N'-5 8', N'3', NULL, 1, 2, CAST(N'2026-07-10T02:41:01.4582790' AS DateTime2))
SET IDENTITY_INSERT [dbo].[CodingTestCases] OFF
GO
SET IDENTITY_INSERT [dbo].[Comments] ON 

INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (1, 1, 5, NULL, N'mô phật gì dẫy', NULL, 2, 0, 1, CAST(N'2026-06-18T16:20:29.2503956' AS DateTime2), CAST(N'2026-07-09T17:16:58.0400856' AS DateTime2), 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (2, 1, 5, 1, N'gì là gì', NULL, 0, 0, 1, CAST(N'2026-06-18T16:20:41.4507275' AS DateTime2), CAST(N'2026-07-09T17:17:08.6983658' AS DateTime2), 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (3, 1, 5, 2, N'hả', NULL, 0, 0, 1, CAST(N'2026-06-18T16:21:04.7402525' AS DateTime2), CAST(N'2026-07-09T14:41:27.3844244' AS DateTime2), 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (4, 1, 5, 3, N'hả', NULL, 0, 0, 1, CAST(N'2026-06-18T16:21:24.0988402' AS DateTime2), CAST(N'2026-07-09T09:49:58.5218332' AS DateTime2), 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (5, 1, 5, 4, N'hả', NULL, 0, 0, 1, CAST(N'2026-06-18T16:21:36.3320841' AS DateTime2), CAST(N'2026-07-09T09:49:59.4123813' AS DateTime2), 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (6, 1, 5, 5, N'hả', NULL, 0, 0, 0, CAST(N'2026-06-18T16:21:53.4566250' AS DateTime2), CAST(N'2026-06-19T08:17:56.6088724' AS DateTime2), 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (7, 1, 5, 1, N'oke fen', NULL, 0, 0, 0, CAST(N'2026-06-18T16:22:01.6927769' AS DateTime2), CAST(N'2026-06-19T05:54:42.0916302' AS DateTime2), 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (8, 1, 6, 5, N'alo', NULL, 0, 0, 1, CAST(N'2026-07-09T08:04:00.2836749' AS DateTime2), CAST(N'2026-07-09T09:49:56.8660266' AS DateTime2), 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (9, 1, 6, 5, N'alo', NULL, 0, 0, 1, CAST(N'2026-07-09T08:04:09.2565339' AS DateTime2), NULL, 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (10, 1, 6, NULL, N'alo', NULL, 0, 1, 1, CAST(N'2026-07-09T08:27:47.6980143' AS DateTime2), CAST(N'2026-07-09T17:18:25.3375456' AS DateTime2), 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (11, 1, 6, 10, N'gì', NULL, 0, 0, 0, CAST(N'2026-07-09T08:27:54.1213233' AS DateTime2), CAST(N'2026-07-09T09:49:10.8016279' AS DateTime2), 1)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (12, 1, 6, 11, N'hả', NULL, 0, 0, 1, CAST(N'2026-07-09T08:27:58.9818707' AS DateTime2), NULL, 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (13, 1, 6, 2, N'ok', NULL, 0, 0, 1, CAST(N'2026-07-09T09:43:40.5221536' AS DateTime2), NULL, 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (14, 1, 6, 10, N'ok''', NULL, 0, 0, 1, CAST(N'2026-07-09T09:49:23.4318142' AS DateTime2), NULL, 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (15, 1, 6, 14, N'okw', NULL, 0, 0, 0, CAST(N'2026-07-09T09:49:29.8022048' AS DateTime2), CAST(N'2026-07-09T09:49:37.0574604' AS DateTime2), 1)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (16, 1, 6, 14, N'alo', NULL, 0, 0, 1, CAST(N'2026-07-09T15:04:08.8771737' AS DateTime2), NULL, 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (17, 1, 6, NULL, N'alo', NULL, 0, 0, 1, CAST(N'2026-07-09T17:17:51.3436429' AS DateTime2), CAST(N'2026-07-09T17:18:09.8919892' AS DateTime2), 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (18, 2, 15, NULL, N'ĐÃ hiện ảnh', NULL, 0, 1, 1, CAST(N'2026-07-10T02:01:16.9835640' AS DateTime2), CAST(N'2026-07-10T02:16:43.2357478' AS DateTime2), 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (19, 2, 15, NULL, N'ĐÃ hiện ảnh', NULL, 0, 0, 1, CAST(N'2026-07-10T02:01:21.4874693' AS DateTime2), NULL, 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (20, 2, 15, 18, N'ok', NULL, 2, 0, 1, CAST(N'2026-07-10T02:16:21.6462770' AS DateTime2), CAST(N'2026-07-10T02:16:41.7115138' AS DateTime2), 0)
SET IDENTITY_INSERT [dbo].[Comments] OFF
GO
SET IDENTITY_INSERT [dbo].[CommentVotes] ON 

INSERT [dbo].[CommentVotes] ([Id], [CommentId], [UserId], [VoteType], [CreatedAt]) VALUES (4, 1, 8, 1, CAST(N'2026-06-22T09:48:05.9008452' AS DateTime2))
INSERT [dbo].[CommentVotes] ([Id], [CommentId], [UserId], [VoteType], [CreatedAt]) VALUES (6, 1, 6, 1, CAST(N'2026-07-09T08:04:21.1322082' AS DateTime2))
INSERT [dbo].[CommentVotes] ([Id], [CommentId], [UserId], [VoteType], [CreatedAt]) VALUES (7, 20, 15, 1, CAST(N'2026-07-10T02:18:15.5070433' AS DateTime2))
INSERT [dbo].[CommentVotes] ([Id], [CommentId], [UserId], [VoteType], [CreatedAt]) VALUES (8, 20, 14, 1, CAST(N'2026-07-10T02:18:36.1643308' AS DateTime2))
SET IDENTITY_INSERT [dbo].[CommentVotes] OFF
GO
SET IDENTITY_INSERT [dbo].[FileReferences] ON 

INSERT [dbo].[FileReferences] ([Id], [FileId], [OwnerService], [OwnerType], [OwnerId], [CreatedAt]) VALUES (1, 6, N'Forum', N'Post', 1, CAST(N'2026-06-18T16:14:11.6038852' AS DateTime2))
INSERT [dbo].[FileReferences] ([Id], [FileId], [OwnerService], [OwnerType], [OwnerId], [CreatedAt]) VALUES (2, 7, N'Forum', N'Post', 1, CAST(N'2026-06-18T16:14:11.6145293' AS DateTime2))
INSERT [dbo].[FileReferences] ([Id], [FileId], [OwnerService], [OwnerType], [OwnerId], [CreatedAt]) VALUES (3, 10, N'Forum', N'Post', 2, CAST(N'2026-07-10T02:00:31.5774272' AS DateTime2))
SET IDENTITY_INSERT [dbo].[FileReferences] OFF
GO
SET IDENTITY_INSERT [dbo].[Files] ON 

INSERT [dbo].[Files] ([Id], [UploadedByUserId], [OriginalFileName], [StoredFileName], [FileUrl], [MimeType], [FileSizeBytes], [StorageProvider], [FileType], [CreatedAt], [IsDeleted]) VALUES (1, 2, N'import_questions_test_category_1.json', N'033fd2831350440495369cd3e7385c3e.json', N'/uploads/question-imports/033fd2831350440495369cd3e7385c3e.json', N'application/json', 3293, N'Local', N'question-imports', CAST(N'2026-06-14T16:39:30.4004074' AS DateTime2), 0)
INSERT [dbo].[Files] ([Id], [UploadedByUserId], [OriginalFileName], [StoredFileName], [FileUrl], [MimeType], [FileSizeBytes], [StorageProvider], [FileType], [CreatedAt], [IsDeleted]) VALUES (2, 2, N'devlearninghub_questions_test_import.csv', N'0bbfc59f0e194d7884ce391068a3c234.csv', N'/uploads/question-imports/0bbfc59f0e194d7884ce391068a3c234.csv', N'text/csv', 3677, N'Local', N'question-imports', CAST(N'2026-06-18T14:45:20.1200692' AS DateTime2), 0)
INSERT [dbo].[Files] ([Id], [UploadedByUserId], [OriginalFileName], [StoredFileName], [FileUrl], [MimeType], [FileSizeBytes], [StorageProvider], [FileType], [CreatedAt], [IsDeleted]) VALUES (3, 2, N'devlearninghub_questions_test_import (1).csv', N'7e1254c094d94b80ab846a56cc9b4367.csv', N'/uploads/question-imports/7e1254c094d94b80ab846a56cc9b4367.csv', N'text/csv', 3012, N'Local', N'question-imports', CAST(N'2026-06-18T14:53:21.1503628' AS DateTime2), 0)
INSERT [dbo].[Files] ([Id], [UploadedByUserId], [OriginalFileName], [StoredFileName], [FileUrl], [MimeType], [FileSizeBytes], [StorageProvider], [FileType], [CreatedAt], [IsDeleted]) VALUES (4, 6, N'test.png', N'forum/2026/06/a99e512ceb9543cb90726d5ad875498a.png', N'http://localhost:9000/devlearninghub/forum/2026/06/a99e512ceb9543cb90726d5ad875498a.png', N'image/png', 140565, N'MinIO', N'Image', CAST(N'2026-06-18T16:07:24.8607054' AS DateTime2), 0)
INSERT [dbo].[Files] ([Id], [UploadedByUserId], [OriginalFileName], [StoredFileName], [FileUrl], [MimeType], [FileSizeBytes], [StorageProvider], [FileType], [CreatedAt], [IsDeleted]) VALUES (5, 6, N'test.png', N'forum/2026/06/3ac43eb189ca4a1a8626573c6030ce20.png', N'http://localhost:9000/devlearninghub/forum/2026/06/3ac43eb189ca4a1a8626573c6030ce20.png', N'image/png', 140565, N'MinIO', N'Image', CAST(N'2026-06-18T16:07:35.9423746' AS DateTime2), 0)
INSERT [dbo].[Files] ([Id], [UploadedByUserId], [OriginalFileName], [StoredFileName], [FileUrl], [MimeType], [FileSizeBytes], [StorageProvider], [FileType], [CreatedAt], [IsDeleted]) VALUES (6, 6, N'test.png', N'forum/2026/06/95cf0bdbe2684a5d9f2ec9a475934f59.png', N'http://localhost:9000/devlearninghub/forum/2026/06/95cf0bdbe2684a5d9f2ec9a475934f59.png', N'image/png', 140565, N'MinIO', N'Image', CAST(N'2026-06-18T16:08:37.2015384' AS DateTime2), 0)
INSERT [dbo].[Files] ([Id], [UploadedByUserId], [OriginalFileName], [StoredFileName], [FileUrl], [MimeType], [FileSizeBytes], [StorageProvider], [FileType], [CreatedAt], [IsDeleted]) VALUES (7, 6, N'29_2001230709_TranDuyQuang.jpg', N'forum/2026/06/ef85280bd1f14dd49f78b89f784fb460.jpg', N'http://localhost:9000/devlearninghub/forum/2026/06/ef85280bd1f14dd49f78b89f784fb460.jpg', N'image/jpeg', 4259477, N'MinIO', N'Image', CAST(N'2026-06-18T16:08:37.3083763' AS DateTime2), 0)
INSERT [dbo].[Files] ([Id], [UploadedByUserId], [OriginalFileName], [StoredFileName], [FileUrl], [MimeType], [FileSizeBytes], [StorageProvider], [FileType], [CreatedAt], [IsDeleted]) VALUES (8, 2, N'demo_quiz_import_react.csv', N'6574ff61a5bf4d0297a419d620dda5ba.csv', N'/uploads/question-imports/6574ff61a5bf4d0297a419d620dda5ba.csv', N'text/csv', 930, N'Local', N'question-imports', CAST(N'2026-07-09T16:52:29.4615786' AS DateTime2), 0)
INSERT [dbo].[Files] ([Id], [UploadedByUserId], [OriginalFileName], [StoredFileName], [FileUrl], [MimeType], [FileSizeBytes], [StorageProvider], [FileType], [CreatedAt], [IsDeleted]) VALUES (9, 2, N'demo_quiz_import_template_chuan.csv', N'f5e57d095c954dc49846f7afe3871113.csv', N'/uploads/question-imports/f5e57d095c954dc49846f7afe3871113.csv', N'text/csv', 6945, N'Local', N'question-imports', CAST(N'2026-07-09T16:55:18.1354861' AS DateTime2), 0)
INSERT [dbo].[Files] ([Id], [UploadedByUserId], [OriginalFileName], [StoredFileName], [FileUrl], [MimeType], [FileSizeBytes], [StorageProvider], [FileType], [CreatedAt], [IsDeleted]) VALUES (10, 14, N'Screenshot 2026-07-10 085908.png', N'forum/2026/07/f5eb5782a32544edb37481718d8443cb.png', N'/uploads/forum/2026/07/f5eb5782a32544edb37481718d8443cb.png', N'image/png', 28224, N'Local', N'Image', CAST(N'2026-07-10T01:59:46.4793310' AS DateTime2), 0)
SET IDENTITY_INSERT [dbo].[Files] OFF
GO
SET IDENTITY_INSERT [dbo].[LearningTracks] ON 

INSERT [dbo].[LearningTracks] ([Id], [Title], [Slug], [Description], [Level], [EstimatedHours], [ThumbnailUrl], [SortOrder], [IsPublished], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (1, N'Frontend Developer', N'frontend-developer', N'Lộ trình xây dựng giao diện web hiện đại từ nền tảng đến triển khai.', N'Beginner', 180, NULL, 10, 1, CAST(N'2026-07-09T16:49:20.9848449' AS DateTime2), NULL, 0)
INSERT [dbo].[LearningTracks] ([Id], [Title], [Slug], [Description], [Level], [EstimatedHours], [ThumbnailUrl], [SortOrder], [IsPublished], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (2, N'Backend Developer', N'backend-developer', N'Lộ trình API, database, security và vận hành backend.', N'Beginner', 200, NULL, 20, 1, CAST(N'2026-07-09T16:49:20.9848602' AS DateTime2), NULL, 0)
INSERT [dbo].[LearningTracks] ([Id], [Title], [Slug], [Description], [Level], [EstimatedHours], [ThumbnailUrl], [SortOrder], [IsPublished], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (3, N'Fullstack Developer', N'fullstack-developer', N'Kết hợp frontend, backend và triển khai sản phẩm hoàn chỉnh.', N'Intermediate', 260, NULL, 30, 1, CAST(N'2026-07-09T16:49:20.9848604' AS DateTime2), NULL, 0)
INSERT [dbo].[LearningTracks] ([Id], [Title], [Slug], [Description], [Level], [EstimatedHours], [ThumbnailUrl], [SortOrder], [IsPublished], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (4, N'Algorithms & Problem Solving', N'algorithms-problem-solving', N'Rèn tư duy thuật toán, cấu trúc dữ liệu và luyện giải bài.', N'Beginner', 150, NULL, 40, 1, CAST(N'2026-07-09T16:49:20.9848605' AS DateTime2), NULL, 0)
INSERT [dbo].[LearningTracks] ([Id], [Title], [Slug], [Description], [Level], [EstimatedHours], [ThumbnailUrl], [SortOrder], [IsPublished], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (5, N'DevOps / Cloud', N'devops-cloud', N'Nắm CI/CD, container, cloud basics và observability.', N'Intermediate', 160, NULL, 50, 1, CAST(N'2026-07-09T16:49:20.9848606' AS DateTime2), NULL, 0)
SET IDENTITY_INSERT [dbo].[LearningTracks] OFF
GO
SET IDENTITY_INSERT [dbo].[ModerationActions] ON 

INSERT [dbo].[ModerationActions] ([Id], [ModeratorId], [TargetType], [TargetId], [ActionType], [Reason], [CreatedAt]) VALUES (1, 7, N'Comment', 7, N'Hide', N'tế nhị', CAST(N'2026-06-19T05:53:23.4467184' AS DateTime2))
INSERT [dbo].[ModerationActions] ([Id], [ModeratorId], [TargetType], [TargetId], [ActionType], [Reason], [CreatedAt]) VALUES (2, 7, N'Comment', 7, N'Hide', N'', CAST(N'2026-06-19T05:54:42.0916394' AS DateTime2))
INSERT [dbo].[ModerationActions] ([Id], [ModeratorId], [TargetType], [TargetId], [ActionType], [Reason], [CreatedAt]) VALUES (3, 7, N'Comment', 6, N'Hide', N'', CAST(N'2026-06-19T08:17:56.6088823' AS DateTime2))
INSERT [dbo].[ModerationActions] ([Id], [ModeratorId], [TargetType], [TargetId], [ActionType], [Reason], [CreatedAt]) VALUES (4, 2, N'Post', 1, N'Hide', N'', CAST(N'2026-07-09T08:52:38.3091545' AS DateTime2))
INSERT [dbo].[ModerationActions] ([Id], [ModeratorId], [TargetType], [TargetId], [ActionType], [Reason], [CreatedAt]) VALUES (5, 2, N'Post', 1, N'Restore', N'', CAST(N'2026-07-09T08:52:44.0777341' AS DateTime2))
SET IDENTITY_INSERT [dbo].[ModerationActions] OFF
GO
SET IDENTITY_INSERT [dbo].[Notifications] ON 

INSERT [dbo].[Notifications] ([Id], [UserId], [Title], [Content], [NotificationType], [ReferenceType], [ReferenceId], [IsRead], [ReadAt], [CreatedAt], [Type], [Message], [LinkUrl], [MetadataJson]) VALUES (12, 15, N'Câu trả lời được chấp nhận', N'Câu trả lời của bạn đã được đánh dấu là Accepted Answer.', N'forum.accepted_answer', NULL, NULL, 1, CAST(N'2026-07-10T02:17:49.6089690' AS DateTime2), CAST(N'2026-07-10T02:16:40.0593218' AS DateTime2), N'system', N'', N'/learner/forum-post/2', N'{"eventKey":"forum.accepted_answer:2:18","postId":2,"commentId":18,"actorUserId":14}')
INSERT [dbo].[Notifications] ([Id], [UserId], [Title], [Content], [NotificationType], [ReferenceType], [ReferenceId], [IsRead], [ReadAt], [CreatedAt], [Type], [Message], [LinkUrl], [MetadataJson]) VALUES (13, 15, N'Câu trả lời được chấp nhận', N'Câu trả lời của bạn đã được đánh dấu là Accepted Answer.', N'forum.accepted_answer', NULL, NULL, 1, CAST(N'2026-07-10T02:17:49.6089690' AS DateTime2), CAST(N'2026-07-10T02:16:41.7280943' AS DateTime2), N'system', N'', N'/learner/forum-post/2', N'{"eventKey":"forum.accepted_answer:2:20","postId":2,"commentId":20,"actorUserId":14}')
INSERT [dbo].[Notifications] ([Id], [UserId], [Title], [Content], [NotificationType], [ReferenceType], [ReferenceId], [IsRead], [ReadAt], [CreatedAt], [Type], [Message], [LinkUrl], [MetadataJson]) VALUES (14, 15, N'Bài nộp được chấp nhận', N'Bài nộp của bạn cho Hello World đã Accepted.', N'code.accepted', NULL, NULL, 1, CAST(N'2026-07-10T02:17:40.1595576' AS DateTime2), CAST(N'2026-07-10T02:17:13.9450891' AS DateTime2), N'system', N'', N'/learner/submissions/26', N'{"eventKey":"code.accepted:26","submissionId":26,"problemId":1}')
INSERT [dbo].[Notifications] ([Id], [UserId], [Title], [Content], [NotificationType], [ReferenceType], [ReferenceId], [IsRead], [ReadAt], [CreatedAt], [Type], [Message], [LinkUrl], [MetadataJson]) VALUES (15, 13, N'Tài khoản đã được mở khóa', N'Tài khoản của bạn đã được mở khóa. Bạn có thể đăng nhập và tiếp tục học tập.', N'account.unlocked', NULL, NULL, 0, NULL, CAST(N'2026-07-10T02:23:08.0719155' AS DateTime2), N'system', N'', N'/login', N'{"eventKey":"account.unlocked:13:20260710022308","targetUserId":13,"actorUserId":2}')
INSERT [dbo].[Notifications] ([Id], [UserId], [Title], [Content], [NotificationType], [ReferenceType], [ReferenceId], [IsRead], [ReadAt], [CreatedAt], [Type], [Message], [LinkUrl], [MetadataJson]) VALUES (16, 6, N'Tài khoản đã được mở khóa', N'Tài khoản của bạn đã được mở khóa. Bạn có thể đăng nhập và tiếp tục học tập.', N'account.unlocked', NULL, NULL, 0, NULL, CAST(N'2026-07-10T02:23:16.6061539' AS DateTime2), N'system', N'', N'/login', N'{"eventKey":"account.unlocked:6:20260710022316","targetUserId":6,"actorUserId":2}')
INSERT [dbo].[Notifications] ([Id], [UserId], [Title], [Content], [NotificationType], [ReferenceType], [ReferenceId], [IsRead], [ReadAt], [CreatedAt], [Type], [Message], [LinkUrl], [MetadataJson]) VALUES (17, 1, N'Tài khoản đã được mở khóa', N'Tài khoản của bạn đã được mở khóa. Bạn có thể đăng nhập và tiếp tục học tập.', N'account.unlocked', NULL, NULL, 0, NULL, CAST(N'2026-07-10T02:23:18.7575978' AS DateTime2), N'system', N'', N'/login', N'{"eventKey":"account.unlocked:1:20260710022318","targetUserId":1,"actorUserId":2}')
INSERT [dbo].[Notifications] ([Id], [UserId], [Title], [Content], [NotificationType], [ReferenceType], [ReferenceId], [IsRead], [ReadAt], [CreatedAt], [Type], [Message], [LinkUrl], [MetadataJson]) VALUES (18, 1, N'Tài khoản đã được mở khóa', N'Tài khoản của bạn đã được mở khóa. Bạn có thể đăng nhập và tiếp tục học tập.', N'account.unlocked', NULL, NULL, 0, NULL, CAST(N'2026-07-10T02:23:19.5293909' AS DateTime2), N'system', N'', N'/login', N'{"eventKey":"account.unlocked:1:20260710022319","targetUserId":1,"actorUserId":2}')
INSERT [dbo].[Notifications] ([Id], [UserId], [Title], [Content], [NotificationType], [ReferenceType], [ReferenceId], [IsRead], [ReadAt], [CreatedAt], [Type], [Message], [LinkUrl], [MetadataJson]) VALUES (19, 2, N'Tài khoản đã được mở khóa', N'Tài khoản của bạn đã được mở khóa. Bạn có thể đăng nhập và tiếp tục học tập.', N'account.unlocked', NULL, NULL, 0, NULL, CAST(N'2026-07-10T02:23:21.3187780' AS DateTime2), N'system', N'', N'/login', N'{"eventKey":"account.unlocked:2:20260710022321","targetUserId":2,"actorUserId":2}')
INSERT [dbo].[Notifications] ([Id], [UserId], [Title], [Content], [NotificationType], [ReferenceType], [ReferenceId], [IsRead], [ReadAt], [CreatedAt], [Type], [Message], [LinkUrl], [MetadataJson]) VALUES (20, 14, N'Tài khoản đã được mở khóa', N'Tài khoản của bạn đã được mở khóa. Bạn có thể đăng nhập và tiếp tục học tập.', N'account.unlocked', NULL, NULL, 1, CAST(N'2026-07-10T02:30:09.2097284' AS DateTime2), CAST(N'2026-07-10T02:24:33.5105787' AS DateTime2), N'system', N'', N'/login', N'{"eventKey":"account.unlocked:14:20260710022433","targetUserId":14,"actorUserId":2}')
INSERT [dbo].[Notifications] ([Id], [UserId], [Title], [Content], [NotificationType], [ReferenceType], [ReferenceId], [IsRead], [ReadAt], [CreatedAt], [Type], [Message], [LinkUrl], [MetadataJson]) VALUES (21, 14, N'Tài khoản đã bị khóa', N'Tài khoản của bạn đã tạm thời bị khóa. Vui lòng liên hệ quản trị viên nếu bạn cần hỗ trợ.', N'account.locked', NULL, NULL, 1, CAST(N'2026-07-10T02:30:09.2097284' AS DateTime2), CAST(N'2026-07-10T02:25:10.0873134' AS DateTime2), N'system', N'', N'/login', N'{"eventKey":"account.locked:14:2026-07-11T13:01:00.0000000","targetUserId":14,"actorUserId":2}')
INSERT [dbo].[Notifications] ([Id], [UserId], [Title], [Content], [NotificationType], [ReferenceType], [ReferenceId], [IsRead], [ReadAt], [CreatedAt], [Type], [Message], [LinkUrl], [MetadataJson]) VALUES (22, 14, N'Tài khoản đã được mở khóa', N'Tài khoản của bạn đã được mở khóa. Bạn có thể đăng nhập và tiếp tục học tập.', N'account.unlocked', NULL, NULL, 1, CAST(N'2026-07-10T02:30:09.2097284' AS DateTime2), CAST(N'2026-07-10T02:25:45.9365551' AS DateTime2), N'system', N'', N'/login', N'{"eventKey":"account.unlocked:14:20260710022545","targetUserId":14,"actorUserId":2}')
INSERT [dbo].[Notifications] ([Id], [UserId], [Title], [Content], [NotificationType], [ReferenceType], [ReferenceId], [IsRead], [ReadAt], [CreatedAt], [Type], [Message], [LinkUrl], [MetadataJson]) VALUES (23, 15, N'Bài nộp được chấp nhận', N'Bài nộp của bạn cho Hello DevLearningHub đã Accepted.', N'code.accepted', NULL, NULL, 1, CAST(N'2026-07-10T02:42:10.1803197' AS DateTime2), CAST(N'2026-07-10T02:41:20.4747917' AS DateTime2), N'system', N'', N'/learner/submissions/27', N'{"eventKey":"code.accepted:27","submissionId":27,"problemId":2}')
SET IDENTITY_INSERT [dbo].[Notifications] OFF
GO
SET IDENTITY_INSERT [dbo].[NotificationTemplates] ON 

INSERT [dbo].[NotificationTemplates] ([Id], [Code], [TitleTemplate], [ContentTemplate], [NotificationType], [IsActive], [CreatedAt]) VALUES (1, N'COMMENT_CREATED', N'Có bình luận mới', N'Bài viết của bạn có bình luận mới.', N'Forum', 1, CAST(N'2026-06-09T15:57:52.1907948' AS DateTime2))
INSERT [dbo].[NotificationTemplates] ([Id], [Code], [TitleTemplate], [ContentTemplate], [NotificationType], [IsActive], [CreatedAt]) VALUES (2, N'QUIZ_COMPLETED', N'Hoàn thành quiz', N'Bạn đã hoàn thành một bài quiz.', N'Quiz', 1, CAST(N'2026-06-09T15:57:52.1907948' AS DateTime2))
INSERT [dbo].[NotificationTemplates] ([Id], [Code], [TitleTemplate], [ContentTemplate], [NotificationType], [IsActive], [CreatedAt]) VALUES (3, N'CODE_ACCEPTED', N'Bài code Accepted', N'Bài code của bạn đã được chấp nhận.', N'Code', 1, CAST(N'2026-06-09T15:57:52.1907948' AS DateTime2))
INSERT [dbo].[NotificationTemplates] ([Id], [Code], [TitleTemplate], [ContentTemplate], [NotificationType], [IsActive], [CreatedAt]) VALUES (4, N'XP_MILESTONE', N'Cột mốc XP', N'Bạn vừa đạt một cột mốc XP mới.', N'XP', 1, CAST(N'2026-06-09T15:57:52.1907948' AS DateTime2))
SET IDENTITY_INSERT [dbo].[NotificationTemplates] OFF
GO
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (1, 1)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (1, 2)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (1, 3)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (1, 4)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (2, 4)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (6, 4)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (1, 5)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (2, 5)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (1, 6)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (2, 6)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (6, 6)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (1, 7)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (6, 7)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (1, 8)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (4, 8)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (6, 8)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (1, 9)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (1, 10)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (1, 11)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (1, 12)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (3, 12)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (1, 13)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (3, 13)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (1, 14)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (4, 14)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (5, 14)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (1, 15)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (4, 15)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (5, 15)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (1, 16)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (1, 17)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (5, 17)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (1, 18)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (2, 18)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (3, 18)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (4, 18)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (6, 18)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (7, 18)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (1, 19)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (2, 19)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (3, 19)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (4, 19)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (6, 19)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (7, 19)
GO
SET IDENTITY_INSERT [dbo].[PermissionGroups] ON 

INSERT [dbo].[PermissionGroups] ([Id], [Name], [Code], [Description], [IsSystem], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (1, N'System Admin Group', N'system_admin_group', N'All system permissions', 1, CAST(N'2026-07-09T06:25:35.5024958' AS DateTime2), NULL, 0)
INSERT [dbo].[PermissionGroups] ([Id], [Name], [Code], [Description], [IsSystem], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (2, N'Quiz Manager Group', N'quiz_manager_group', N'Quiz and question management', 1, CAST(N'2026-07-09T06:25:35.7008087' AS DateTime2), NULL, 0)
INSERT [dbo].[PermissionGroups] ([Id], [Name], [Code], [Description], [IsSystem], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (3, N'Forum Moderator Group', N'forum_moderator_group', N'Forum moderation', 1, CAST(N'2026-07-09T06:25:35.7446297' AS DateTime2), NULL, 0)
INSERT [dbo].[PermissionGroups] ([Id], [Name], [Code], [Description], [IsSystem], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (4, N'Code Judge Admin Group', N'code_judge_admin_group', N'Code judge management', 1, CAST(N'2026-07-09T06:25:35.7564375' AS DateTime2), NULL, 0)
INSERT [dbo].[PermissionGroups] ([Id], [Name], [Code], [Description], [IsSystem], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (5, N'Learner Personal Practice Group', N'learner_personal_practice_group', N'Own personal practice banks', 1, CAST(N'2026-07-09T06:25:35.7687194' AS DateTime2), NULL, 0)
INSERT [dbo].[PermissionGroups] ([Id], [Name], [Code], [Description], [IsSystem], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (6, N'Roadmap Manager Group', N'roadmap_manager_group', N'Roadmap and course management', 1, CAST(N'2026-07-09T16:43:38.1429342' AS DateTime2), NULL, 0)
INSERT [dbo].[PermissionGroups] ([Id], [Name], [Code], [Description], [IsSystem], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (7, N'Admin Portal Basic', N'admin_portal_basic', N'Basic admin portal access', 1, CAST(N'2026-07-10T03:06:11.4842617' AS DateTime2), NULL, 0)
SET IDENTITY_INSERT [dbo].[PermissionGroups] OFF
GO
SET IDENTITY_INSERT [dbo].[Permissions] ON 

INSERT [dbo].[Permissions] ([Id], [Code], [Name], [Module], [Description], [CreatedAt]) VALUES (1, N'user.view', N'Xem người dùng', N'User', N'Cho phép xem người dùng', CAST(N'2026-06-09T15:57:52.1459535' AS DateTime2))
INSERT [dbo].[Permissions] ([Id], [Code], [Name], [Module], [Description], [CreatedAt]) VALUES (2, N'user.manage', N'Quản lý người dùng', N'User', N'Cho phép quản lý người dùng', CAST(N'2026-06-09T15:57:52.1459535' AS DateTime2))
INSERT [dbo].[Permissions] ([Id], [Code], [Name], [Module], [Description], [CreatedAt]) VALUES (3, N'role.manage', N'Quản lý vai trò', N'Auth', N'Cho phép quản lý role/permission', CAST(N'2026-06-09T15:57:52.1459535' AS DateTime2))
INSERT [dbo].[Permissions] ([Id], [Code], [Name], [Module], [Description], [CreatedAt]) VALUES (4, N'category.manage', N'Quản lý chủ đề', N'Learning', N'Cho phép quản lý category', CAST(N'2026-06-09T15:57:52.1459535' AS DateTime2))
INSERT [dbo].[Permissions] ([Id], [Code], [Name], [Module], [Description], [CreatedAt]) VALUES (5, N'question.manage', N'Quản lý câu hỏi', N'Learning', N'Cho phép quản lý question', CAST(N'2026-06-09T15:57:52.1459535' AS DateTime2))
INSERT [dbo].[Permissions] ([Id], [Code], [Name], [Module], [Description], [CreatedAt]) VALUES (6, N'quiz.manage', N'Quản lý bộ đề', N'Learning', N'Cho phép quản lý quiz set', CAST(N'2026-06-09T15:57:52.1459535' AS DateTime2))
INSERT [dbo].[Permissions] ([Id], [Code], [Name], [Module], [Description], [CreatedAt]) VALUES (7, N'roadmap.manage', N'Quản lý roadmap', N'Learning', N'Cho phép quản lý roadmap', CAST(N'2026-06-09T15:57:52.1459535' AS DateTime2))
INSERT [dbo].[Permissions] ([Id], [Code], [Name], [Module], [Description], [CreatedAt]) VALUES (8, N'code.manage', N'Quản lý bài code', N'Judge', N'Cho phép quản lý coding problems', CAST(N'2026-06-09T15:57:52.1459535' AS DateTime2))
INSERT [dbo].[Permissions] ([Id], [Code], [Name], [Module], [Description], [CreatedAt]) VALUES (9, N'post.moderate', N'Kiểm duyệt bài viết', N'Forum', N'Cho phép kiểm duyệt bài viết', CAST(N'2026-06-09T15:57:52.1459535' AS DateTime2))
INSERT [dbo].[Permissions] ([Id], [Code], [Name], [Module], [Description], [CreatedAt]) VALUES (10, N'file.manage', N'Quản lý file', N'File', N'Cho phép quản lý file', CAST(N'2026-06-09T15:57:52.1459535' AS DateTime2))
INSERT [dbo].[Permissions] ([Id], [Code], [Name], [Module], [Description], [CreatedAt]) VALUES (11, N'audit.view', N'Xem audit log', N'Audit', N'Cho phép xem audit log', CAST(N'2026-06-09T15:57:52.1459535' AS DateTime2))
INSERT [dbo].[Permissions] ([Id], [Code], [Name], [Module], [Description], [CreatedAt]) VALUES (12, N'forum.moderate', N'Kiểm duyệt diễn đàn', N'Forum', NULL, CAST(N'2026-06-18T15:44:51.1194891' AS DateTime2))
INSERT [dbo].[Permissions] ([Id], [Code], [Name], [Module], [Description], [CreatedAt]) VALUES (13, N'forum.answer.accept', N'Đánh dấu câu trả lời đúng', N'Forum', NULL, CAST(N'2026-07-03T03:30:50.4067247' AS DateTime2))
INSERT [dbo].[Permissions] ([Id], [Code], [Name], [Module], [Description], [CreatedAt]) VALUES (14, N'code.run', N'Chạy code playground', N'Code', N'Cho phép chạy code trong playground', CAST(N'2026-07-03T08:03:52.2361910' AS DateTime2))
INSERT [dbo].[Permissions] ([Id], [Code], [Name], [Module], [Description], [CreatedAt]) VALUES (15, N'code.submit', N'Nộp bài lập trình', N'Code', N'Cho phép submit bài vào judge', CAST(N'2026-07-03T08:03:52.2361910' AS DateTime2))
INSERT [dbo].[Permissions] ([Id], [Code], [Name], [Module], [Description], [CreatedAt]) VALUES (16, N'permission.manage', N'Manage permissions', N'Auth', NULL, CAST(N'2026-07-09T06:13:39.8780554' AS DateTime2))
INSERT [dbo].[Permissions] ([Id], [Code], [Name], [Module], [Description], [CreatedAt]) VALUES (17, N'personal_practice.manage_own', N'Manage own personal practice banks', N'Learning', NULL, CAST(N'2026-07-09T06:13:39.9377235' AS DateTime2))
INSERT [dbo].[Permissions] ([Id], [Code], [Name], [Module], [Description], [CreatedAt]) VALUES (18, N'admin.access', N'Access admin portal', N'Admin Portal', NULL, CAST(N'2026-07-10T03:06:10.8350329' AS DateTime2))
INSERT [dbo].[Permissions] ([Id], [Code], [Name], [Module], [Description], [CreatedAt]) VALUES (19, N'dashboard.view', N'View admin dashboard', N'Admin Portal', NULL, CAST(N'2026-07-10T03:06:10.9096618' AS DateTime2))
SET IDENTITY_INSERT [dbo].[Permissions] OFF
GO
SET IDENTITY_INSERT [dbo].[PersonalPracticeAttemptAnswers] ON 

INSERT [dbo].[PersonalPracticeAttemptAnswers] ([Id], [AttemptId], [QuestionId], [SelectedOptionLabel], [IsCorrect]) VALUES (1, 1, 2, NULL, 0)
INSERT [dbo].[PersonalPracticeAttemptAnswers] ([Id], [AttemptId], [QuestionId], [SelectedOptionLabel], [IsCorrect]) VALUES (2, 1, 4, NULL, 0)
INSERT [dbo].[PersonalPracticeAttemptAnswers] ([Id], [AttemptId], [QuestionId], [SelectedOptionLabel], [IsCorrect]) VALUES (3, 1, 1, NULL, 0)
INSERT [dbo].[PersonalPracticeAttemptAnswers] ([Id], [AttemptId], [QuestionId], [SelectedOptionLabel], [IsCorrect]) VALUES (4, 1, 3, NULL, 0)
INSERT [dbo].[PersonalPracticeAttemptAnswers] ([Id], [AttemptId], [QuestionId], [SelectedOptionLabel], [IsCorrect]) VALUES (5, 1, 5, NULL, 0)
INSERT [dbo].[PersonalPracticeAttemptAnswers] ([Id], [AttemptId], [QuestionId], [SelectedOptionLabel], [IsCorrect]) VALUES (6, 2, 3, NULL, 0)
INSERT [dbo].[PersonalPracticeAttemptAnswers] ([Id], [AttemptId], [QuestionId], [SelectedOptionLabel], [IsCorrect]) VALUES (7, 2, 1, NULL, 0)
INSERT [dbo].[PersonalPracticeAttemptAnswers] ([Id], [AttemptId], [QuestionId], [SelectedOptionLabel], [IsCorrect]) VALUES (8, 2, 5, NULL, 0)
INSERT [dbo].[PersonalPracticeAttemptAnswers] ([Id], [AttemptId], [QuestionId], [SelectedOptionLabel], [IsCorrect]) VALUES (9, 2, 4, NULL, 0)
INSERT [dbo].[PersonalPracticeAttemptAnswers] ([Id], [AttemptId], [QuestionId], [SelectedOptionLabel], [IsCorrect]) VALUES (10, 2, 2, NULL, 0)
INSERT [dbo].[PersonalPracticeAttemptAnswers] ([Id], [AttemptId], [QuestionId], [SelectedOptionLabel], [IsCorrect]) VALUES (11, 3, 9, N'D', 0)
INSERT [dbo].[PersonalPracticeAttemptAnswers] ([Id], [AttemptId], [QuestionId], [SelectedOptionLabel], [IsCorrect]) VALUES (12, 3, 6, N'C', 0)
INSERT [dbo].[PersonalPracticeAttemptAnswers] ([Id], [AttemptId], [QuestionId], [SelectedOptionLabel], [IsCorrect]) VALUES (13, 3, 7, N'D', 0)
INSERT [dbo].[PersonalPracticeAttemptAnswers] ([Id], [AttemptId], [QuestionId], [SelectedOptionLabel], [IsCorrect]) VALUES (14, 3, 8, N'A', 0)
INSERT [dbo].[PersonalPracticeAttemptAnswers] ([Id], [AttemptId], [QuestionId], [SelectedOptionLabel], [IsCorrect]) VALUES (15, 3, 10, N'A', 0)
INSERT [dbo].[PersonalPracticeAttemptAnswers] ([Id], [AttemptId], [QuestionId], [SelectedOptionLabel], [IsCorrect]) VALUES (16, 4, 7, N'B', 1)
INSERT [dbo].[PersonalPracticeAttemptAnswers] ([Id], [AttemptId], [QuestionId], [SelectedOptionLabel], [IsCorrect]) VALUES (17, 4, 10, N'A', 0)
INSERT [dbo].[PersonalPracticeAttemptAnswers] ([Id], [AttemptId], [QuestionId], [SelectedOptionLabel], [IsCorrect]) VALUES (18, 4, 6, N'D', 0)
INSERT [dbo].[PersonalPracticeAttemptAnswers] ([Id], [AttemptId], [QuestionId], [SelectedOptionLabel], [IsCorrect]) VALUES (19, 4, 9, N'C', 0)
INSERT [dbo].[PersonalPracticeAttemptAnswers] ([Id], [AttemptId], [QuestionId], [SelectedOptionLabel], [IsCorrect]) VALUES (20, 4, 8, N'B', 1)
INSERT [dbo].[PersonalPracticeAttemptAnswers] ([Id], [AttemptId], [QuestionId], [SelectedOptionLabel], [IsCorrect]) VALUES (21, 5, 10, N'A', 0)
INSERT [dbo].[PersonalPracticeAttemptAnswers] ([Id], [AttemptId], [QuestionId], [SelectedOptionLabel], [IsCorrect]) VALUES (22, 5, 6, N'A', 1)
INSERT [dbo].[PersonalPracticeAttemptAnswers] ([Id], [AttemptId], [QuestionId], [SelectedOptionLabel], [IsCorrect]) VALUES (23, 5, 8, N'A', 0)
INSERT [dbo].[PersonalPracticeAttemptAnswers] ([Id], [AttemptId], [QuestionId], [SelectedOptionLabel], [IsCorrect]) VALUES (24, 5, 7, N'B', 1)
INSERT [dbo].[PersonalPracticeAttemptAnswers] ([Id], [AttemptId], [QuestionId], [SelectedOptionLabel], [IsCorrect]) VALUES (25, 5, 9, N'A', 0)
SET IDENTITY_INSERT [dbo].[PersonalPracticeAttemptAnswers] OFF
GO
SET IDENTITY_INSERT [dbo].[PersonalPracticeAttempts] ON 

INSERT [dbo].[PersonalPracticeAttempts] ([Id], [UserId], [BankId], [StartedAt], [SubmittedAt], [Score], [TotalQuestions], [CorrectCount], [Status]) VALUES (1, 6, 1, CAST(N'2026-07-09T17:08:25.6276818' AS DateTime2), CAST(N'2026-07-09T17:08:54.8655614' AS DateTime2), CAST(0.00 AS Decimal(6, 2)), 5, 0, N'Submitted')
INSERT [dbo].[PersonalPracticeAttempts] ([Id], [UserId], [BankId], [StartedAt], [SubmittedAt], [Score], [TotalQuestions], [CorrectCount], [Status]) VALUES (2, 6, 1, CAST(N'2026-07-09T17:09:04.4870662' AS DateTime2), CAST(N'2026-07-09T17:09:11.1708913' AS DateTime2), CAST(0.00 AS Decimal(6, 2)), 5, 0, N'Submitted')
INSERT [dbo].[PersonalPracticeAttempts] ([Id], [UserId], [BankId], [StartedAt], [SubmittedAt], [Score], [TotalQuestions], [CorrectCount], [Status]) VALUES (3, 14, 2, CAST(N'2026-07-10T01:53:37.8585715' AS DateTime2), CAST(N'2026-07-10T01:53:52.2190312' AS DateTime2), CAST(0.00 AS Decimal(6, 2)), 5, 0, N'Submitted')
INSERT [dbo].[PersonalPracticeAttempts] ([Id], [UserId], [BankId], [StartedAt], [SubmittedAt], [Score], [TotalQuestions], [CorrectCount], [Status]) VALUES (4, 14, 2, CAST(N'2026-07-10T01:54:57.2255081' AS DateTime2), CAST(N'2026-07-10T01:55:14.6918026' AS DateTime2), CAST(4.00 AS Decimal(6, 2)), 5, 2, N'Submitted')
INSERT [dbo].[PersonalPracticeAttempts] ([Id], [UserId], [BankId], [StartedAt], [SubmittedAt], [Score], [TotalQuestions], [CorrectCount], [Status]) VALUES (5, 14, 2, CAST(N'2026-07-10T02:18:59.9532348' AS DateTime2), CAST(N'2026-07-10T02:19:15.1429594' AS DateTime2), CAST(4.00 AS Decimal(6, 2)), 5, 2, N'Submitted')
SET IDENTITY_INSERT [dbo].[PersonalPracticeAttempts] OFF
GO
SET IDENTITY_INSERT [dbo].[PersonalQuestionBanks] ON 

INSERT [dbo].[PersonalQuestionBanks] ([Id], [UserId], [Title], [Description], [OriginalFileName], [FileStorageKey], [QuestionCount], [Visibility], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (1, 6, N'bộ đề ROSE 1', N'không mô tả', N'demo_personal_practice_react.csv', N'18e24600bfa14fbea6e5b332f4646370.csv', 5, N'Private', CAST(N'2026-07-09T17:08:21.7865988' AS DateTime2), NULL, 0)
INSERT [dbo].[PersonalQuestionBanks] ([Id], [UserId], [Title], [Description], [OriginalFileName], [FileStorageKey], [QuestionCount], [Visibility], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (2, 14, N'test 1', NULL, N'demo_personal_practice_react.csv', N'7c06338e0d9d4c86a7f3074da6af17f5.csv', 5, N'Private', CAST(N'2026-07-10T01:53:32.5355708' AS DateTime2), NULL, 0)
SET IDENTITY_INSERT [dbo].[PersonalQuestionBanks] OFF
GO
SET IDENTITY_INSERT [dbo].[PersonalQuestionOptions] ON 

INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (1, 1, N'A', N'useState', 1)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (2, 1, N'B', N'useEffect', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (3, 1, N'C', N'useMemo', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (4, 1, N'D', N'useRef', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (5, 2, N'A', N'Một database', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (6, 2, N'B', N'Cú pháp mở rộng cho JavaScript để mô tả UI', 1)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (7, 2, N'C', N'Một trình biên dịch C++', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (8, 2, N'D', N'Một HTTP server', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (9, 3, N'A', N'Tạo class CSS', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (10, 3, N'B', N'Xử lý side effects như gọi API, subscription, cập nhật document title', 1)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (11, 3, N'C', N'Tạo biến môi trường', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (12, 3, N'D', N'Thay thế hoàn toàn props', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (13, 4, N'A', N'Chỉ được truyền từ component con lên cha', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (14, 4, N'B', N'Là dữ liệu truyền từ component cha xuống component con', 1)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (15, 4, N'C', N'Luôn thay đổi trực tiếp bên trong component con', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (16, 4, N'D', N'Chỉ dùng trong class component', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (17, 5, N'A', N'id', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (18, 5, N'B', N'name', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (19, 5, N'C', N'key', 1)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (20, 5, N'D', N'indexOnly', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (21, 6, N'A', N'useState', 1)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (22, 6, N'B', N'useEffect', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (23, 6, N'C', N'useMemo', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (24, 6, N'D', N'useRef', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (25, 7, N'A', N'Một database', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (26, 7, N'B', N'Cú pháp mở rộng cho JavaScript để mô tả UI', 1)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (27, 7, N'C', N'Một trình biên dịch C++', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (28, 7, N'D', N'Một HTTP server', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (29, 8, N'A', N'Tạo class CSS', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (30, 8, N'B', N'Xử lý side effects như gọi API, subscription, cập nhật document title', 1)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (31, 8, N'C', N'Tạo biến môi trường', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (32, 8, N'D', N'Thay thế hoàn toàn props', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (33, 9, N'A', N'Chỉ được truyền từ component con lên cha', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (34, 9, N'B', N'Là dữ liệu truyền từ component cha xuống component con', 1)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (35, 9, N'C', N'Luôn thay đổi trực tiếp bên trong component con', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (36, 9, N'D', N'Chỉ dùng trong class component', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (37, 10, N'A', N'id', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (38, 10, N'B', N'name', 0)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (39, 10, N'C', N'key', 1)
INSERT [dbo].[PersonalQuestionOptions] ([Id], [QuestionId], [Label], [Text], [IsCorrect]) VALUES (40, 10, N'D', N'indexOnly', 0)
SET IDENTITY_INSERT [dbo].[PersonalQuestionOptions] OFF
GO
SET IDENTITY_INSERT [dbo].[PersonalQuestions] ON 

INSERT [dbo].[PersonalQuestions] ([Id], [BankId], [UserId], [QuestionText], [QuestionType], [Difficulty], [Explanation], [Tags], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (1, 1, 6, N'Trong React, hook nào thường dùng để quản lý state trong function component?', N'single_choice', N'easy', N'useState dùng để khai báo và cập nhật state trong function component.', N'', CAST(N'2026-07-09T17:08:21.7798041' AS DateTime2), NULL, 0)
INSERT [dbo].[PersonalQuestions] ([Id], [BankId], [UserId], [QuestionText], [QuestionType], [Difficulty], [Explanation], [Tags], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (2, 1, 6, N'JSX trong React là gì?', N'single_choice', N'easy', N'JSX cho phép viết cấu trúc UI gần giống HTML trong JavaScript.', N'', CAST(N'2026-07-09T17:08:21.7801039' AS DateTime2), NULL, 0)
INSERT [dbo].[PersonalQuestions] ([Id], [BankId], [UserId], [QuestionText], [QuestionType], [Difficulty], [Explanation], [Tags], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (3, 1, 6, N'useEffect thường được dùng cho mục đích nào?', N'single_choice', N'medium', N'useEffect dùng để xử lý side effects sau khi component render.', N'', CAST(N'2026-07-09T17:08:21.7801078' AS DateTime2), NULL, 0)
INSERT [dbo].[PersonalQuestions] ([Id], [BankId], [UserId], [QuestionText], [QuestionType], [Difficulty], [Explanation], [Tags], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (4, 1, 6, N'Props trong React có đặc điểm nào?', N'single_choice', N'easy', N'Props là dữ liệu được truyền từ component cha xuống component con và thường không nên mutate trực tiếp.', N'', CAST(N'2026-07-09T17:08:21.7801086' AS DateTime2), NULL, 0)
INSERT [dbo].[PersonalQuestions] ([Id], [BankId], [UserId], [QuestionText], [QuestionType], [Difficulty], [Explanation], [Tags], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (5, 1, 6, N'Khi render danh sách trong React, prop nào nên được thêm vào mỗi item?', N'single_choice', N'medium', N'key giúp React xác định item nào thay đổi, thêm hoặc xóa để tối ưu render.', N'', CAST(N'2026-07-09T17:08:21.7801098' AS DateTime2), NULL, 0)
INSERT [dbo].[PersonalQuestions] ([Id], [BankId], [UserId], [QuestionText], [QuestionType], [Difficulty], [Explanation], [Tags], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (6, 2, 14, N'Trong React, hook nào thường dùng để quản lý state trong function component?', N'single_choice', N'easy', N'useState dùng để khai báo và cập nhật state trong function component.', N'', CAST(N'2026-07-10T01:53:32.5254161' AS DateTime2), NULL, 0)
INSERT [dbo].[PersonalQuestions] ([Id], [BankId], [UserId], [QuestionText], [QuestionType], [Difficulty], [Explanation], [Tags], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (7, 2, 14, N'JSX trong React là gì?', N'single_choice', N'easy', N'JSX cho phép viết cấu trúc UI gần giống HTML trong JavaScript.', N'', CAST(N'2026-07-10T01:53:32.5257840' AS DateTime2), NULL, 0)
INSERT [dbo].[PersonalQuestions] ([Id], [BankId], [UserId], [QuestionText], [QuestionType], [Difficulty], [Explanation], [Tags], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (8, 2, 14, N'useEffect thường được dùng cho mục đích nào?', N'single_choice', N'medium', N'useEffect dùng để xử lý side effects sau khi component render.', N'', CAST(N'2026-07-10T01:53:32.5257953' AS DateTime2), NULL, 0)
INSERT [dbo].[PersonalQuestions] ([Id], [BankId], [UserId], [QuestionText], [QuestionType], [Difficulty], [Explanation], [Tags], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (9, 2, 14, N'Props trong React có đặc điểm nào?', N'single_choice', N'easy', N'Props là dữ liệu được truyền từ component cha xuống component con và thường không nên mutate trực tiếp.', N'', CAST(N'2026-07-10T01:53:32.5257990' AS DateTime2), NULL, 0)
INSERT [dbo].[PersonalQuestions] ([Id], [BankId], [UserId], [QuestionText], [QuestionType], [Difficulty], [Explanation], [Tags], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (10, 2, 14, N'Khi render danh sách trong React, prop nào nên được thêm vào mỗi item?', N'single_choice', N'medium', N'key giúp React xác định item nào thay đổi, thêm hoặc xóa để tối ưu render.', N'', CAST(N'2026-07-10T01:53:32.5258028' AS DateTime2), NULL, 0)
SET IDENTITY_INSERT [dbo].[PersonalQuestions] OFF
GO
SET IDENTITY_INSERT [dbo].[Posts] ON 

INSERT [dbo].[Posts] ([Id], [AuthorId], [Title], [Slug], [Content], [ContentHtml], [ViewCount], [VoteScore], [AnswerCount], [AcceptedCommentId], [Status], [LastActivityAt], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (1, 6, N'test anh load lên minio', N'test-anh-load-len-minio', N'test 11111111111111111111111111111111111111111111111111111111111111111111111111111111111 = nội dung', NULL, 114, 0, 17, 10, 1, CAST(N'2026-07-09T17:18:25.3375498' AS DateTime2), CAST(N'2026-06-18T16:14:11.4231593' AS DateTime2), CAST(N'2026-07-09T17:18:25.3375494' AS DateTime2), 0)
INSERT [dbo].[Posts] ([Id], [AuthorId], [Title], [Slug], [Content], [ContentHtml], [ViewCount], [VoteScore], [AnswerCount], [AcceptedCommentId], [Status], [LastActivityAt], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (2, 14, N'Bài viết test FORUM', N'bai-viet-test-forum', N'TEST CMT, ẢNH! GIAO DIỆN DÙNG ANGULAR', NULL, 16, 1, 3, 18, 1, CAST(N'2026-07-10T02:16:43.2357488' AS DateTime2), CAST(N'2026-07-10T02:00:31.4339101' AS DateTime2), CAST(N'2026-07-10T02:16:43.2357487' AS DateTime2), 0)
SET IDENTITY_INSERT [dbo].[Posts] OFF
GO
INSERT [dbo].[PostTags] ([PostId], [TagId]) VALUES (1, 1)
INSERT [dbo].[PostTags] ([PostId], [TagId]) VALUES (2, 2)
GO
SET IDENTITY_INSERT [dbo].[PostVotes] ON 

INSERT [dbo].[PostVotes] ([Id], [PostId], [UserId], [VoteType], [CreatedAt]) VALUES (3, 2, 15, 1, CAST(N'2026-07-10T02:00:49.8934531' AS DateTime2))
SET IDENTITY_INSERT [dbo].[PostVotes] OFF
GO
SET IDENTITY_INSERT [dbo].[ProgrammingLanguages] ON 

INSERT [dbo].[ProgrammingLanguages] ([Id], [Name], [Code], [Version], [Judge0LanguageId], [DefaultTemplate], [IsActive], [CreatedAt], [DisplayName], [FileExtension], [CompileCommand], [RunCommand], [IsCompiled], [TimeLimitMs], [MemoryLimitKb], [SortOrder]) VALUES (1, N'C#', N'csharp', N'.NET', NULL, N'using System;
public class Program {
    public static void Main() {
        Console.WriteLine("Hello, World!");
    }
}', 1, CAST(N'2026-06-09T15:57:52.1757861' AS DateTime2), N'C#', N'cs', N'dotnet build Main.csproj --nologo -v quiet', N'dotnet bin/Debug/net9.0/Main.dll', 1, 5000, 262144, 7)
INSERT [dbo].[ProgrammingLanguages] ([Id], [Name], [Code], [Version], [Judge0LanguageId], [DefaultTemplate], [IsActive], [CreatedAt], [DisplayName], [FileExtension], [CompileCommand], [RunCommand], [IsCompiled], [TimeLimitMs], [MemoryLimitKb], [SortOrder]) VALUES (2, N'Python', N'python', N'3.x', NULL, N'print("Hello, World!")', 1, CAST(N'2026-06-09T15:57:52.1757861' AS DateTime2), N'Python', N'py', NULL, N'python main.py', 0, 5000, 262144, 1)
INSERT [dbo].[ProgrammingLanguages] ([Id], [Name], [Code], [Version], [Judge0LanguageId], [DefaultTemplate], [IsActive], [CreatedAt], [DisplayName], [FileExtension], [CompileCommand], [RunCommand], [IsCompiled], [TimeLimitMs], [MemoryLimitKb], [SortOrder]) VALUES (3, N'JavaScript', N'javascript', N'Node.js', NULL, N'console.log("Hello, World!");', 1, CAST(N'2026-06-09T15:57:52.1757861' AS DateTime2), N'JavaScript', N'js', NULL, N'node main.js', 0, 5000, 262144, 2)
INSERT [dbo].[ProgrammingLanguages] ([Id], [Name], [Code], [Version], [Judge0LanguageId], [DefaultTemplate], [IsActive], [CreatedAt], [DisplayName], [FileExtension], [CompileCommand], [RunCommand], [IsCompiled], [TimeLimitMs], [MemoryLimitKb], [SortOrder]) VALUES (4, N'C', N'c', N'C11', NULL, N'#include <stdio.h>
int main() {
    printf("Hello, World!\n");
    return 0;
}', 1, CAST(N'2026-07-09T14:30:36.2332927' AS DateTime2), N'C', N'c', N'gcc main.c -O2 -o main.exe', N'main.exe', 1, 5000, 262144, 5)
INSERT [dbo].[ProgrammingLanguages] ([Id], [Name], [Code], [Version], [Judge0LanguageId], [DefaultTemplate], [IsActive], [CreatedAt], [DisplayName], [FileExtension], [CompileCommand], [RunCommand], [IsCompiled], [TimeLimitMs], [MemoryLimitKb], [SortOrder]) VALUES (5, N'C++17', N'cpp', N'C++17', NULL, N'#include <bits/stdc++.h>
using namespace std;
int main() {
    cout << "Hello, World!" << endl;
    return 0;
}', 1, CAST(N'2026-07-09T14:30:36.2332927' AS DateTime2), N'C++17', N'cpp', N'g++ main.cpp -std=c++17 -O2 -o main.exe', N'main.exe', 1, 5000, 262144, 6)
INSERT [dbo].[ProgrammingLanguages] ([Id], [Name], [Code], [Version], [Judge0LanguageId], [DefaultTemplate], [IsActive], [CreatedAt], [DisplayName], [FileExtension], [CompileCommand], [RunCommand], [IsCompiled], [TimeLimitMs], [MemoryLimitKb], [SortOrder]) VALUES (6, N'Go', N'go', N'1.x', NULL, N'package main
import "fmt"
func main() {
    fmt.Println("Hello, World!")
}', 1, CAST(N'2026-07-09T14:30:36.2332927' AS DateTime2), N'Go', N'go', NULL, N'go run main.go', 0, 5000, 262144, 8)
INSERT [dbo].[ProgrammingLanguages] ([Id], [Name], [Code], [Version], [Judge0LanguageId], [DefaultTemplate], [IsActive], [CreatedAt], [DisplayName], [FileExtension], [CompileCommand], [RunCommand], [IsCompiled], [TimeLimitMs], [MemoryLimitKb], [SortOrder]) VALUES (7, N'Java', N'java', N'JDK', NULL, N'public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}', 1, CAST(N'2026-07-09T14:30:36.2332927' AS DateTime2), N'Java', N'java', N'javac Main.java', N'java Main', 1, 5000, 262144, 4)
INSERT [dbo].[ProgrammingLanguages] ([Id], [Name], [Code], [Version], [Judge0LanguageId], [DefaultTemplate], [IsActive], [CreatedAt], [DisplayName], [FileExtension], [CompileCommand], [RunCommand], [IsCompiled], [TimeLimitMs], [MemoryLimitKb], [SortOrder]) VALUES (8, N'TypeScript', N'typescript', N'ES2020', NULL, N'const message: string = "Hello, World!";
console.log(message);', 1, CAST(N'2026-07-09T14:30:36.2332927' AS DateTime2), N'TypeScript', N'ts', N'npx tsc main.ts --target ES2020 --module commonjs --outDir out', N'node out/main.js', 1, 5000, 262144, 3)
SET IDENTITY_INSERT [dbo].[ProgrammingLanguages] OFF
GO
SET IDENTITY_INSERT [dbo].[QuestionImportBatches] ON 

INSERT [dbo].[QuestionImportBatches] ([Id], [FileId], [ImportedByUserId], [TotalRows], [SuccessRows], [FailedRows], [Status], [ErrorFileUrl], [CreatedAt], [CompletedAt]) VALUES (1, 1, 2, 3, 3, 0, N'Completed', NULL, CAST(N'2026-06-14T16:39:30.5532767' AS DateTime2), CAST(N'2026-06-14T16:39:30.8135529' AS DateTime2))
INSERT [dbo].[QuestionImportBatches] ([Id], [FileId], [ImportedByUserId], [TotalRows], [SuccessRows], [FailedRows], [Status], [ErrorFileUrl], [CreatedAt], [CompletedAt]) VALUES (2, 3, 2, 5, 5, 0, N'Completed', NULL, CAST(N'2026-06-18T14:53:21.1886412' AS DateTime2), CAST(N'2026-06-18T14:53:21.2836437' AS DateTime2))
INSERT [dbo].[QuestionImportBatches] ([Id], [FileId], [ImportedByUserId], [TotalRows], [SuccessRows], [FailedRows], [Status], [ErrorFileUrl], [CreatedAt], [CompletedAt]) VALUES (3, 9, 2, 12, 12, 0, N'Completed', NULL, CAST(N'2026-07-09T16:55:18.1647888' AS DateTime2), CAST(N'2026-07-09T16:55:18.4115607' AS DateTime2))
SET IDENTITY_INSERT [dbo].[QuestionImportBatches] OFF
GO
SET IDENTITY_INSERT [dbo].[QuestionOptions] ON 

INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (1, 1, N'Tạo và quản lý một phần giao diện của ứng dụng', 1, N'Đúng, component đại diện cho một phần UI.', 1, CAST(N'2026-06-14T16:39:30.6142493' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (2, 1, N'Chỉ dùng để lưu dữ liệu trong SQL Server', 0, N'', 2, CAST(N'2026-06-14T16:39:30.6144206' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (3, 1, N'Chỉ dùng để cấu hình firewall', 0, N'', 3, CAST(N'2026-06-14T16:39:30.6144211' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (4, 1, N'Chỉ dùng để chạy câu lệnh npm install', 0, N'', 4, CAST(N'2026-06-14T16:39:30.6144217' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (5, 2, N'Kết nối frontend với backend để trao đổi dữ liệu', 1, N'Đúng, frontend gọi API để lấy hoặc gửi dữ liệu.', 1, CAST(N'2026-06-14T16:39:30.8015117' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (6, 2, N'Chỉ dùng để thiết kế màu sắc giao diện', 0, N'', 2, CAST(N'2026-06-14T16:39:30.8015126' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (7, 2, N'Chỉ dùng để tạo ảnh nền', 0, N'', 3, CAST(N'2026-06-14T16:39:30.8015131' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (8, 2, N'Chỉ dùng để gõ văn bản Word', 0, N'', 4, CAST(N'2026-06-14T16:39:30.8015136' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (9, 3, N'Xác thực request sau khi người dùng đăng nhập', 1, N'Đúng, token JWT thường được gửi trong Authorization header.', 1, CAST(N'2026-06-14T16:39:30.8087592' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (10, 3, N'Tạo database mới', 0, N'', 2, CAST(N'2026-06-14T16:39:30.8087598' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (11, 3, N'Tự động viết giao diện HTML', 0, N'', 3, CAST(N'2026-06-14T16:39:30.8087601' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (12, 3, N'Chạy Angular thay cho npm start', 0, N'', 4, CAST(N'2026-06-14T16:39:30.8087606' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (13, 4, N'T?o v� qu?n l� m?t ph?n giao di?n c?a ?ng d?ng', 1, N'��ng. Component d?i di?n cho m?t ph?n UI v� x? l� logic li�n quan.', 1, CAST(N'2026-06-18T14:53:21.2339114' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (14, 4, N'Ch? d�ng d? luu d? li?u trong SQL Server', 0, N'Sai. Luu d? li?u l� nhi?m v? c?a database/backend.', 2, CAST(N'2026-06-18T14:53:21.2339583' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (15, 4, N'Ch? d�ng d? c?u h�nh firewall', 0, N'Sai. Firewall kh�ng li�n quan d?n Angular Component.', 3, CAST(N'2026-06-18T14:53:21.2339588' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (16, 4, N'Ch? d�ng d? ch?y c�u l?nh npm install', 0, N'Sai. npm install d�ng d? c�i package.', 4, CAST(N'2026-06-18T14:53:21.2339590' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (17, 5, N'Ch? d? vi?t HTML giao di?n', 0, N'Sai. HTML giao di?n n?m trong template/component.', 1, CAST(N'2026-06-18T14:53:21.2638642' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (18, 5, N'Ch?a logic d�ng chung v� g?i API', 1, N'��ng. Service gi�p t�ch logic kh?i component v� t�i s? d?ng.', 2, CAST(N'2026-06-18T14:53:21.2638648' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (19, 5, N'Ch? d? t?o b?ng trong SQL Server', 0, N'Sai. T?o b?ng l� ph?n database.', 3, CAST(N'2026-06-18T14:53:21.2638653' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (20, 5, N'Ch? d? d?i m�u n�t b?m', 0, N'Sai. �?i m�u thu?ng x? l� b?ng CSS.', 4, CAST(N'2026-06-18T14:53:21.2638656' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (21, 6, N'Ch? d�ng d? trang tr� giao di?n', 0, N'Sai. Trang tr� giao di?n l� nhi?m v? c?a CSS/UI.', 1, CAST(N'2026-06-18T14:53:21.2698473' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (22, 6, N'Ch? d�ng d? m? tr�nh duy?t', 0, N'Sai. M? tr�nh duy?t kh�ng ph?i nhi?m v? API.', 2, CAST(N'2026-06-18T14:53:21.2698476' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (23, 6, N'K?t n?i frontend v?i backend d? trao d?i d? li?u', 1, N'��ng. Frontend g?i API d? dang nh?p, l?y quiz, n?p b�i...', 3, CAST(N'2026-06-18T14:53:21.2698477' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (24, 6, N'Ch? d�ng d? luu ?nh n?n', 0, N'Sai. Luu file c� th? qua server/storage, nhung API kh�ng ch? l�m vi?c d�.', 4, CAST(N'2026-06-18T14:53:21.2698478' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (25, 7, N'X�c th?c request sau khi ngu?i d�ng dang nh?p', 1, N'��ng. Token thu?ng du?c g?i trong header Authorization.', 1, CAST(N'2026-06-18T14:53:21.2744661' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (26, 7, N'T?o giao di?n responsive', 0, N'Sai. Responsive thu?c v? CSS/UI.', 2, CAST(N'2026-06-18T14:53:21.2744673' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (27, 7, N'T? d?ng s?a l?i database', 0, N'Sai. JWT kh�ng s?a database.', 3, CAST(N'2026-06-18T14:53:21.2744678' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (28, 7, N'Thay th? ho�n to�n m?t kh?u trong database', 0, N'Sai. JWT kh�ng thay th? vi?c luu m?t kh?u d� m� h�a.', 4, CAST(N'2026-06-18T14:53:21.2744685' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (29, 8, N'Ch? luu m�u n?n c?a giao di?n', 0, N'Sai. M�u n?n kh�ng li�n quan d?n k?t qu? quiz.', 1, CAST(N'2026-06-18T14:53:21.2790465' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (30, 8, N'Ch? luu t�n tr�nh duy?t', 0, N'Sai. T�n tr�nh duy?t kh�ng d? d? ch?m di?m.', 2, CAST(N'2026-06-18T14:53:21.2790470' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (31, 8, N'Ch? luu du?ng d?n trang web', 0, N'Sai. �u?ng d?n kh�ng ph?n �nh c�u tr? l?i.', 3, CAST(N'2026-06-18T14:53:21.2790474' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (32, 8, N'Luu attempt, c�u tr? l?i, d�p �n ch?n, di?m v� th?i gian', 1, N'��ng. ��y l� c�c d? li?u c?n thi?t d? ch?m b�i v� xem l?i k?t qu?.', 4, CAST(N'2026-06-18T14:53:21.2790479' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (33, 9, N'Kết nối frontend với backend để trao đổi dữ liệu', 1, N'Đúng, frontend gọi API để lấy hoặc gửi dữ liệu.', 1, CAST(N'2026-07-09T16:55:18.2244584' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (34, 9, N'Chỉ dùng để thiết kế màu sắc giao diện', 0, N'Sai, thiết kế giao diện thuộc frontend/CSS.', 2, CAST(N'2026-07-09T16:55:18.2244811' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (35, 9, N'Chỉ dùng để tạo ảnh nền', 0, N'Sai, API không dùng để tạo ảnh nền.', 3, CAST(N'2026-07-09T16:55:18.2244814' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (36, 9, N'Chỉ dùng để gõ văn bản Word', 0, N'Sai, đây không phải chức năng của API.', 4, CAST(N'2026-07-09T16:55:18.2244816' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (37, 10, N'Một phần giao diện có thể tái sử dụng', 1, N'Đúng, component giúp chia nhỏ UI thành các phần độc lập.', 1, CAST(N'2026-07-09T16:55:18.3256834' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (38, 10, N'Một bảng trong SQL Server', 0, N'Sai, bảng là khái niệm của cơ sở dữ liệu.', 2, CAST(N'2026-07-09T16:55:18.3256840' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (39, 10, N'Một file cấu hình Docker', 0, N'Sai, Docker không phải khái niệm component của React.', 3, CAST(N'2026-07-09T16:55:18.3256845' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (40, 10, N'Một thuật toán sắp xếp', 0, N'Sai, component không phải thuật toán.', 4, CAST(N'2026-07-09T16:55:18.3256848' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (41, 11, N'Quản lý state trong function component', 1, N'Đúng, useState là hook cơ bản để quản lý state.', 1, CAST(N'2026-07-09T16:55:18.3472997' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (42, 11, N'Tạo route cho ứng dụng', 0, N'Sai, routing thường dùng React Router.', 2, CAST(N'2026-07-09T16:55:18.3473002' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (43, 11, N'Kết nối trực tiếp SQL Server', 0, N'Sai, React không kết nối trực tiếp SQL Server.', 3, CAST(N'2026-07-09T16:55:18.3473005' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (44, 11, N'Biên dịch code C++', 0, N'Sai, đây không phải chức năng của useState.', 4, CAST(N'2026-07-09T16:55:18.3473008' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (45, 12, N'Khai báo class CSS', 0, N'Sai, CSS không phải nhiệm vụ chính của useEffect.', 1, CAST(N'2026-07-09T16:55:18.3612784' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (46, 12, N'Xử lý side effects sau khi component render', 1, N'Đúng, useEffect được dùng cho side effects.', 2, CAST(N'2026-07-09T16:55:18.3612790' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (47, 12, N'Tạo primary key cho bảng', 0, N'Sai, đây là khái niệm database.', 3, CAST(N'2026-07-09T16:55:18.3612794' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (48, 12, N'Tạo package npm mới', 0, N'Sai, useEffect không tạo package.', 4, CAST(N'2026-07-09T16:55:18.3612799' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (49, 13, N'Truyền dữ liệu từ component cha xuống component con', 1, N'Đúng, props giúp component nhận dữ liệu đầu vào.', 1, CAST(N'2026-07-09T16:55:18.3784562' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (50, 13, N'Lưu dữ liệu trong database', 0, N'Sai, props không lưu database.', 2, CAST(N'2026-07-09T16:55:18.3784567' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (51, 13, N'Tự động deploy ứng dụng', 0, N'Sai, deploy là quy trình khác.', 3, CAST(N'2026-07-09T16:55:18.3784569' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (52, 13, N'Chỉ dùng để viết CSS', 0, N'Sai, props không chỉ dùng cho CSS.', 4, CAST(N'2026-07-09T16:55:18.3784574' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (53, 14, N'Tạo màu nền cho item', 0, N'Sai, màu nền thuộc CSS.', 1, CAST(N'2026-07-09T16:55:18.3832420' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (54, 14, N'Thay thế hoàn toàn state', 0, N'Sai, key không thay thế state.', 2, CAST(N'2026-07-09T16:55:18.3832426' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (55, 14, N'Giúp React nhận diện item trong danh sách', 1, N'Đúng, key giúp React tối ưu quá trình render list.', 3, CAST(N'2026-07-09T16:55:18.3832431' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (56, 14, N'Kết nối API tự động', 0, N'Sai, key không gọi API.', 4, CAST(N'2026-07-09T16:55:18.3832437' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (57, 15, N'Một tác vụ bất đồng bộ có thể thành công hoặc thất bại', 1, N'Đúng, Promise có trạng thái pending, fulfilled hoặc rejected.', 1, CAST(N'2026-07-09T16:55:18.3882695' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (58, 15, N'Một thẻ HTML', 0, N'Sai, Promise không phải HTML.', 2, CAST(N'2026-07-09T16:55:18.3882701' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (59, 15, N'Một kiểu dữ liệu chỉ chứa số nguyên', 0, N'Sai, Promise là object xử lý async.', 3, CAST(N'2026-07-09T16:55:18.3882707' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (60, 15, N'Một câu lệnh SQL', 0, N'Sai, Promise không thuộc SQL.', 4, CAST(N'2026-07-09T16:55:18.3882713' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (61, 16, N'Tạo file ảnh', 0, N'Sai, async/await không tạo ảnh.', 1, CAST(N'2026-07-09T16:55:18.3919860' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (62, 16, N'Viết code bất đồng bộ dễ đọc hơn', 1, N'Đúng, async/await giúp xử lý Promise rõ ràng hơn.', 2, CAST(N'2026-07-09T16:55:18.3919896' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (63, 16, N'Xóa toàn bộ database', 0, N'Sai, đây không phải mục đích của async/await.', 3, CAST(N'2026-07-09T16:55:18.3919900' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (64, 16, N'Tạo CSS animation', 0, N'Sai, animation thuộc CSS/JS logic khác.', 4, CAST(N'2026-07-09T16:55:18.3919904' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (65, 17, N'Truy vấn dữ liệu từ bảng', 1, N'Đúng, SELECT dùng để lấy dữ liệu.', 1, CAST(N'2026-07-09T16:55:18.3961739' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (66, 17, N'Xóa database server', 0, N'Sai, SELECT không xóa server.', 2, CAST(N'2026-07-09T16:55:18.3961747' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (67, 17, N'Tạo giao diện web', 0, N'Sai, SQL không tạo UI web.', 3, CAST(N'2026-07-09T16:55:18.3961752' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (68, 17, N'Chạy React component', 0, N'Sai, React component chạy ở frontend.', 4, CAST(N'2026-07-09T16:55:18.3961755' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (69, 18, N'Sắp xếp kết quả tăng dần', 0, N'Sai, sắp xếp dùng ORDER BY.', 1, CAST(N'2026-07-09T16:55:18.3999608' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (70, 18, N'Lọc dữ liệu theo điều kiện', 1, N'Đúng, WHERE dùng để lọc bản ghi.', 2, CAST(N'2026-07-09T16:55:18.3999614' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (71, 18, N'Tạo khóa ngoại', 0, N'Sai, khóa ngoại dùng FOREIGN KEY.', 3, CAST(N'2026-07-09T16:55:18.3999617' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (72, 18, N'Gộp nhiều bảng luôn luôn', 0, N'Sai, gộp bảng thường dùng JOIN.', 4, CAST(N'2026-07-09T16:55:18.3999622' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (73, 19, N'Tạo giao diện nút bấm', 0, N'Sai, đây là nhiệm vụ frontend.', 1, CAST(N'2026-07-09T16:55:18.4039436' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (74, 19, N'Lưu ảnh nền', 0, N'Sai, JWT không lưu ảnh nền.', 2, CAST(N'2026-07-09T16:55:18.4039441' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (75, 19, N'Xác thực và truyền thông tin người dùng', 1, N'Đúng, JWT thường dùng trong auth.', 3, CAST(N'2026-07-09T16:55:18.4039446' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (76, 19, N'Biên dịch TypeScript', 0, N'Sai, JWT không biên dịch code.', 4, CAST(N'2026-07-09T16:55:18.4039452' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (77, 20, N'Tạo giao diện responsive', 0, N'Sai, responsive thuộc CSS/UI.', 1, CAST(N'2026-07-09T16:55:18.4079127' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (78, 20, N'Xin access token mới khi access token hết hạn', 1, N'Đúng, refresh token giúp duy trì phiên đăng nhập.', 2, CAST(N'2026-07-09T16:55:18.4079134' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (79, 20, N'Xóa tất cả user', 0, N'Sai, không phải mục đích refresh token.', 3, CAST(N'2026-07-09T16:55:18.4079138' AS DateTime2), NULL, 0)
INSERT [dbo].[QuestionOptions] ([Id], [QuestionId], [Content], [IsCorrect], [Explanation], [DisplayOrder], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (80, 20, N'Tạo câu hỏi trắc nghiệm', 0, N'Sai, đây là chức năng quiz.', 4, CAST(N'2026-07-09T16:55:18.4079140' AS DateTime2), NULL, 0)
SET IDENTITY_INSERT [dbo].[QuestionOptions] OFF
GO
SET IDENTITY_INSERT [dbo].[Questions] ON 

INSERT [dbo].[Questions] ([Id], [CategoryId], [CreatedByUserId], [Title], [Content], [Explanation], [Difficulty], [QuestionType], [Status], [Version], [Source], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (1, 3, 2, N'Angular - Component là gì?', N'Trong Angular, Component dùng để làm gì?', N'Component là khối giao diện gồm template, class xử lý logic và style.', 1, 1, 2, 1, N'Admin Import Test', CAST(N'2026-06-14T16:39:30.6130470' AS DateTime2), NULL, 0)
INSERT [dbo].[Questions] ([Id], [CategoryId], [CreatedByUserId], [Title], [Content], [Explanation], [Difficulty], [QuestionType], [Status], [Version], [Source], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (2, 1, 2, N'API là gì?', N'API trong hệ thống web thường dùng để làm gì?', N'API là lớp trung gian giúp frontend gửi yêu cầu và nhận dữ liệu từ backend.', 1, 1, 2, 1, N'Admin Import Test', CAST(N'2026-06-14T16:39:30.8015012' AS DateTime2), NULL, 0)
INSERT [dbo].[Questions] ([Id], [CategoryId], [CreatedByUserId], [Title], [Content], [Explanation], [Difficulty], [QuestionType], [Status], [Version], [Source], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (3, 1, 2, N'JWT dùng để làm gì?', N'Trong chức năng đăng nhập, JWT thường dùng để làm gì?', N'JWT lưu thông tin xác thực đã ký, giúp API biết người gọi request là ai.', 2, 1, 2, 1, N'Admin Import Test', CAST(N'2026-06-14T16:39:30.8087523' AS DateTime2), NULL, 0)
INSERT [dbo].[Questions] ([Id], [CategoryId], [CreatedByUserId], [Title], [Content], [Explanation], [Difficulty], [QuestionType], [Status], [Version], [Source], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (4, 3, 2, N'Angular Component l� g�?', N'Trong Angular, Component d�ng d? l�m g�?', N'Component l� kh?i giao di?n ch�nh trong Angular, g?m template hi?n th?, class x? l� logic v� c� th? c� style ri�ng.', 1, 1, 2, 1, N'CSV Test Import', CAST(N'2026-06-18T14:53:21.2334393' AS DateTime2), NULL, 0)
INSERT [dbo].[Questions] ([Id], [CategoryId], [CreatedByUserId], [Title], [Content], [Explanation], [Difficulty], [QuestionType], [Status], [Version], [Source], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (5, 3, 2, N'Angular Service d�ng d? l�m g�?', N'Trong Angular, Service thu?ng du?c d�ng d? l�m g�?', N'Service thu?ng d�ng d? ch?a logic d�ng chung, g?i API, x? l� d? li?u v� chia s? d? li?u gi?a c�c component.', 1, 1, 2, 1, N'CSV Test Import', CAST(N'2026-06-18T14:53:21.2638567' AS DateTime2), NULL, 0)
INSERT [dbo].[Questions] ([Id], [CategoryId], [CreatedByUserId], [Title], [Content], [Explanation], [Difficulty], [QuestionType], [Status], [Version], [Source], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (6, 3, 2, N'API d�ng d? l�m g�?', N'Trong h? th?ng web, API thu?ng c� nhi?m v? g�?', N'API l� l?p trung gian gi�p frontend g?i request v� nh?n d? li?u t? backend/database.', 1, 1, 2, 1, N'CSV Test Import', CAST(N'2026-06-18T14:53:21.2698445' AS DateTime2), NULL, 0)
INSERT [dbo].[Questions] ([Id], [CategoryId], [CreatedByUserId], [Title], [Content], [Explanation], [Difficulty], [QuestionType], [Status], [Version], [Source], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (7, 3, 2, N'JWT d�ng d? l�m g�?', N'Trong ch?c nang dang nh?p, JWT thu?ng d�ng d? l�m g�?', N'JWT luu th�ng tin x�c th?c d� k�, gi�p API ki?m tra ngu?i d�ng ? c�c request sau khi dang nh?p.', 2, 1, 2, 1, N'CSV Test Import', CAST(N'2026-06-18T14:53:21.2744568' AS DateTime2), NULL, 0)
INSERT [dbo].[Questions] ([Id], [CategoryId], [CreatedByUserId], [Title], [Content], [Explanation], [Difficulty], [QuestionType], [Status], [Version], [Source], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (8, 3, 2, N'Submit Quiz c?n luu d? li?u g�?', N'Khi ngu?i d�ng n?p b�i tr?c nghi?m, h? th?ng n�n luu d? li?u n�o?', N'H? th?ng c?n luu lu?t l�m b�i, c�u tr? l?i c?a ngu?i d�ng, d�p �n d� ch?n, di?m s? v� th?i gian n?p d? xem l?i k?t qu?.', 2, 1, 2, 1, N'CSV Test Import', CAST(N'2026-06-18T14:53:21.2790416' AS DateTime2), NULL, 0)
INSERT [dbo].[Questions] ([Id], [CategoryId], [CreatedByUserId], [Title], [Content], [Explanation], [Difficulty], [QuestionType], [Status], [Version], [Source], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (9, 1, 2, N'API dùng để làm gì?', N'API trong hệ thống web thường dùng để làm gì?', N'API là lớp trung gian giúp frontend gửi yêu cầu và nhận dữ liệu từ backend.', 1, 1, 2, 1, N'Excel/CSV Import', CAST(N'2026-07-09T16:55:18.2240748' AS DateTime2), NULL, 0)
INSERT [dbo].[Questions] ([Id], [CategoryId], [CreatedByUserId], [Title], [Content], [Explanation], [Difficulty], [QuestionType], [Status], [Version], [Source], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (10, 2, 2, N'React component là gì?', N'Trong React, component thường được hiểu là gì?', N'Component là khối giao diện độc lập, có thể tái sử dụng để xây dựng UI.', 1, 1, 2, 1, N'Excel/CSV Import', CAST(N'2026-07-09T16:55:18.3256777' AS DateTime2), NULL, 0)
INSERT [dbo].[Questions] ([Id], [CategoryId], [CreatedByUserId], [Title], [Content], [Explanation], [Difficulty], [QuestionType], [Status], [Version], [Source], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (11, 2, 2, N'useState dùng để làm gì?', N'Hook useState trong React thường dùng để làm gì?', N'useState giúp khai báo và cập nhật state trong function component.', 1, 1, 2, 1, N'Excel/CSV Import', CAST(N'2026-07-09T16:55:18.3472941' AS DateTime2), NULL, 0)
INSERT [dbo].[Questions] ([Id], [CategoryId], [CreatedByUserId], [Title], [Content], [Explanation], [Difficulty], [QuestionType], [Status], [Version], [Source], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (12, 2, 2, N'useEffect dùng khi nào?', N'useEffect trong React thường dùng cho trường hợp nào?', N'useEffect dùng để xử lý side effects như gọi API, subscription hoặc cập nhật document title.', 2, 1, 2, 1, N'Excel/CSV Import', CAST(N'2026-07-09T16:55:18.3612736' AS DateTime2), NULL, 0)
INSERT [dbo].[Questions] ([Id], [CategoryId], [CreatedByUserId], [Title], [Content], [Explanation], [Difficulty], [QuestionType], [Status], [Version], [Source], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (13, 2, 2, N'Props trong React là gì?', N'Props thường được dùng để làm gì trong React?', N'Props là dữ liệu truyền từ component cha xuống component con.', 1, 1, 2, 1, N'Excel/CSV Import', CAST(N'2026-07-09T16:55:18.3784505' AS DateTime2), NULL, 0)
INSERT [dbo].[Questions] ([Id], [CategoryId], [CreatedByUserId], [Title], [Content], [Explanation], [Difficulty], [QuestionType], [Status], [Version], [Source], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (14, 2, 2, N'Key khi render list', N'Khi render danh sách trong React, prop key có vai trò gì?', N'Key giúp React nhận diện phần tử nào thay đổi, thêm hoặc xóa để tối ưu render.', 2, 1, 2, 1, N'Excel/CSV Import', CAST(N'2026-07-09T16:55:18.3832379' AS DateTime2), NULL, 0)
INSERT [dbo].[Questions] ([Id], [CategoryId], [CreatedByUserId], [Title], [Content], [Explanation], [Difficulty], [QuestionType], [Status], [Version], [Source], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (15, 3, 2, N'Promise là gì?', N'Promise trong JavaScript dùng để biểu diễn điều gì?', N'Promise biểu diễn kết quả tương lai của một tác vụ bất đồng bộ.', 1, 1, 2, 1, N'Excel/CSV Import', CAST(N'2026-07-09T16:55:18.3882644' AS DateTime2), NULL, 0)
INSERT [dbo].[Questions] ([Id], [CategoryId], [CreatedByUserId], [Title], [Content], [Explanation], [Difficulty], [QuestionType], [Status], [Version], [Source], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (16, 3, 2, N'async/await dùng để làm gì?', N'Trong JavaScript, async/await giúp ích gì khi xử lý bất đồng bộ?', N'async/await giúp viết code bất đồng bộ theo phong cách dễ đọc hơn so với chaining Promise.', 2, 1, 2, 1, N'Excel/CSV Import', CAST(N'2026-07-09T16:55:18.3919825' AS DateTime2), NULL, 0)
INSERT [dbo].[Questions] ([Id], [CategoryId], [CreatedByUserId], [Title], [Content], [Explanation], [Difficulty], [QuestionType], [Status], [Version], [Source], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (17, 1, 2, N'SELECT dùng để làm gì?', N'Trong SQL, câu lệnh SELECT thường dùng cho mục đích nào?', N'SELECT dùng để truy vấn và lấy dữ liệu từ bảng.', 1, 1, 2, 1, N'Excel/CSV Import', CAST(N'2026-07-09T16:55:18.3961711' AS DateTime2), NULL, 0)
INSERT [dbo].[Questions] ([Id], [CategoryId], [CreatedByUserId], [Title], [Content], [Explanation], [Difficulty], [QuestionType], [Status], [Version], [Source], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (18, 1, 2, N'WHERE dùng để làm gì?', N'Trong SQL, mệnh đề WHERE có vai trò gì?', N'WHERE dùng để lọc các dòng dữ liệu thỏa điều kiện.', 1, 1, 2, 1, N'Excel/CSV Import', CAST(N'2026-07-09T16:55:18.3999579' AS DateTime2), NULL, 0)
INSERT [dbo].[Questions] ([Id], [CategoryId], [CreatedByUserId], [Title], [Content], [Explanation], [Difficulty], [QuestionType], [Status], [Version], [Source], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (19, 4, 2, N'JWT dùng để làm gì?', N'JWT trong hệ thống web thường được dùng cho mục đích nào?', N'JWT thường dùng để xác thực và truyền thông tin người dùng giữa client và server.', 2, 1, 2, 1, N'Excel/CSV Import', CAST(N'2026-07-09T16:55:18.4039401' AS DateTime2), NULL, 0)
INSERT [dbo].[Questions] ([Id], [CategoryId], [CreatedByUserId], [Title], [Content], [Explanation], [Difficulty], [QuestionType], [Status], [Version], [Source], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (20, 4, 2, N'Refresh Token dùng để làm gì?', N'Trong cơ chế JWT, refresh token thường dùng để làm gì?', N'Refresh token dùng để xin access token mới khi access token hết hạn.', 2, 1, 2, 1, N'Excel/CSV Import', CAST(N'2026-07-09T16:55:18.4079096' AS DateTime2), NULL, 0)
SET IDENTITY_INSERT [dbo].[Questions] OFF
GO
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (1, 5)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (2, 12)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (3, 5)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (4, 11)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (5, 11)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (6, 7)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (7, 9)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (8, 8)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (9, 10)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (10, 5)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (11, 11)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (12, 19)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (13, 21)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (14, 27)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (15, 7)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (16, 11)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (17, 5)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (18, 10)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (19, 4)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (20, 16)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (21, 20)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (22, 23)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (23, 26)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (24, 31)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (25, 6)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (26, 10)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (27, 40)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (28, 56)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (29, 37)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (30, 55)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (31, 39)
INSERT [dbo].[QuizAttemptAnswerOptions] ([QuizAttemptAnswerId], [QuestionOptionId]) VALUES (32, 54)
GO
SET IDENTITY_INSERT [dbo].[QuizAttemptAnswers] ON 

INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (1, 2, 2, 1, CAST(1.00 AS Decimal(5, 2)), CAST(N'2026-06-18T14:03:57.9925403' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (2, 2, 3, 0, CAST(0.00 AS Decimal(5, 2)), CAST(N'2026-06-18T14:03:58.0223479' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (3, 3, 2, 1, CAST(1.00 AS Decimal(5, 2)), CAST(N'2026-06-18T14:04:17.0540661' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (4, 3, 3, 0, CAST(0.00 AS Decimal(5, 2)), CAST(N'2026-06-18T14:04:17.0542483' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (5, 4, 3, 0, CAST(0.00 AS Decimal(5, 2)), CAST(N'2026-06-18T14:04:27.8503888' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (6, 5, 2, 0, CAST(0.00 AS Decimal(5, 2)), CAST(N'2026-06-18T14:12:14.9076164' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (7, 5, 3, 1, CAST(1.00 AS Decimal(5, 2)), CAST(N'2026-06-18T14:12:14.9426738' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (8, 6, 2, 0, CAST(0.00 AS Decimal(5, 2)), CAST(N'2026-06-18T14:13:51.9644168' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (9, 6, 3, 0, CAST(0.00 AS Decimal(5, 2)), CAST(N'2026-06-18T14:13:51.9646857' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (10, 8, 2, 1, CAST(1.00 AS Decimal(5, 2)), CAST(N'2026-06-18T14:43:00.5844262' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (11, 8, 3, 0, CAST(0.00 AS Decimal(5, 2)), CAST(N'2026-06-18T14:43:00.6131939' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (12, 9, 5, 0, CAST(0.00 AS Decimal(5, 2)), CAST(N'2026-06-18T15:00:43.4688851' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (13, 9, 6, 0, CAST(0.00 AS Decimal(5, 2)), CAST(N'2026-06-18T15:00:43.4691900' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (14, 9, 7, 0, CAST(0.00 AS Decimal(5, 2)), CAST(N'2026-06-18T15:00:43.4692560' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (15, 11, 2, 0, CAST(0.00 AS Decimal(5, 2)), CAST(N'2026-06-19T07:09:18.2490053' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (16, 11, 3, 0, CAST(0.00 AS Decimal(5, 2)), CAST(N'2026-06-19T07:09:18.2759794' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (17, 13, 2, 1, CAST(1.00 AS Decimal(5, 2)), CAST(N'2026-06-19T07:12:03.5946221' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (18, 13, 3, 0, CAST(0.00 AS Decimal(5, 2)), CAST(N'2026-06-19T07:12:03.5951450' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (19, 14, 1, 0, CAST(0.00 AS Decimal(5, 2)), CAST(N'2026-06-19T07:32:27.6034417' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (20, 14, 4, 0, CAST(0.00 AS Decimal(5, 2)), CAST(N'2026-06-19T07:32:27.6036455' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (21, 14, 5, 0, CAST(0.00 AS Decimal(5, 2)), CAST(N'2026-06-19T07:32:27.6038625' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (22, 14, 6, 1, CAST(1.00 AS Decimal(5, 2)), CAST(N'2026-06-19T07:32:27.6039513' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (23, 14, 7, 0, CAST(0.00 AS Decimal(5, 2)), CAST(N'2026-06-19T07:32:27.6040168' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (24, 14, 8, 0, CAST(0.00 AS Decimal(5, 2)), CAST(N'2026-06-19T07:32:27.6040667' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (25, 15, 2, 0, CAST(0.00 AS Decimal(5, 2)), CAST(N'2026-06-19T08:16:21.0859705' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (26, 15, 3, 0, CAST(0.00 AS Decimal(5, 2)), CAST(N'2026-06-19T08:16:21.0863177' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (27, 16, 10, 0, CAST(0.00 AS Decimal(5, 2)), CAST(N'2026-07-09T16:59:11.6294916' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (28, 16, 14, 0, CAST(0.00 AS Decimal(5, 2)), CAST(N'2026-07-09T16:59:11.6600537' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (29, 17, 10, 1, CAST(1.00 AS Decimal(5, 2)), CAST(N'2026-07-09T17:11:16.6044489' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (30, 17, 14, 1, CAST(1.00 AS Decimal(5, 2)), CAST(N'2026-07-09T17:11:16.6047763' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (31, 18, 10, 0, CAST(0.00 AS Decimal(5, 2)), CAST(N'2026-07-10T01:57:50.3165373' AS DateTime2))
INSERT [dbo].[QuizAttemptAnswers] ([Id], [QuizAttemptId], [QuestionId], [IsCorrect], [Score], [AnsweredAt]) VALUES (32, 18, 14, 0, CAST(0.00 AS Decimal(5, 2)), CAST(N'2026-07-10T01:57:50.3406886' AS DateTime2))
SET IDENTITY_INSERT [dbo].[QuizAttemptAnswers] OFF
GO
SET IDENTITY_INSERT [dbo].[QuizAttempts] ON 

INSERT [dbo].[QuizAttempts] ([Id], [UserId], [QuizSetId], [StartedAt], [SubmittedAt], [DurationSeconds], [TotalQuestions], [CorrectAnswers], [WrongAnswers], [SkippedAnswers], [Score], [IsPassed], [Status], [CreatedAt]) VALUES (1, 3, 2, CAST(N'2026-06-18T13:55:23.7010541' AS DateTime2), NULL, NULL, 2, 0, 0, 0, CAST(0.00 AS Decimal(6, 2)), 0, 1, CAST(N'2026-06-18T13:55:23.7010824' AS DateTime2))
INSERT [dbo].[QuizAttempts] ([Id], [UserId], [QuizSetId], [StartedAt], [SubmittedAt], [DurationSeconds], [TotalQuestions], [CorrectAnswers], [WrongAnswers], [SkippedAnswers], [Score], [IsPassed], [Status], [CreatedAt]) VALUES (2, 4, 2, CAST(N'2026-06-18T14:03:50.7531469' AS DateTime2), CAST(N'2026-06-18T14:03:58.0229654' AS DateTime2), 7, 2, 1, 1, 0, CAST(5.00 AS Decimal(6, 2)), 1, 2, CAST(N'2026-06-18T14:03:50.7531471' AS DateTime2))
INSERT [dbo].[QuizAttempts] ([Id], [UserId], [QuizSetId], [StartedAt], [SubmittedAt], [DurationSeconds], [TotalQuestions], [CorrectAnswers], [WrongAnswers], [SkippedAnswers], [Score], [IsPassed], [Status], [CreatedAt]) VALUES (3, 4, 2, CAST(N'2026-06-18T14:04:13.0005924' AS DateTime2), CAST(N'2026-06-18T14:04:17.0543167' AS DateTime2), 4, 2, 1, 1, 0, CAST(5.00 AS Decimal(6, 2)), 1, 2, CAST(N'2026-06-18T14:04:13.0005925' AS DateTime2))
INSERT [dbo].[QuizAttempts] ([Id], [UserId], [QuizSetId], [StartedAt], [SubmittedAt], [DurationSeconds], [TotalQuestions], [CorrectAnswers], [WrongAnswers], [SkippedAnswers], [Score], [IsPassed], [Status], [CreatedAt]) VALUES (4, 4, 2, CAST(N'2026-06-18T14:04:22.2538372' AS DateTime2), CAST(N'2026-06-18T14:04:27.8506841' AS DateTime2), 5, 2, 0, 1, 1, CAST(0.00 AS Decimal(6, 2)), 0, 2, CAST(N'2026-06-18T14:04:22.2538374' AS DateTime2))
INSERT [dbo].[QuizAttempts] ([Id], [UserId], [QuizSetId], [StartedAt], [SubmittedAt], [DurationSeconds], [TotalQuestions], [CorrectAnswers], [WrongAnswers], [SkippedAnswers], [Score], [IsPassed], [Status], [CreatedAt]) VALUES (5, 4, 2, CAST(N'2026-06-18T14:12:11.0669536' AS DateTime2), CAST(N'2026-06-18T14:12:14.9439160' AS DateTime2), 3, 2, 1, 1, 0, CAST(5.00 AS Decimal(6, 2)), 1, 2, CAST(N'2026-06-18T14:12:11.0670000' AS DateTime2))
INSERT [dbo].[QuizAttempts] ([Id], [UserId], [QuizSetId], [StartedAt], [SubmittedAt], [DurationSeconds], [TotalQuestions], [CorrectAnswers], [WrongAnswers], [SkippedAnswers], [Score], [IsPassed], [Status], [CreatedAt]) VALUES (6, 4, 1, CAST(N'2026-06-18T14:13:47.0254941' AS DateTime2), CAST(N'2026-06-18T14:13:51.9647823' AS DateTime2), 4, 2, 0, 2, 0, CAST(0.00 AS Decimal(6, 2)), 0, 2, CAST(N'2026-06-18T14:13:47.0254943' AS DateTime2))
INSERT [dbo].[QuizAttempts] ([Id], [UserId], [QuizSetId], [StartedAt], [SubmittedAt], [DurationSeconds], [TotalQuestions], [CorrectAnswers], [WrongAnswers], [SkippedAnswers], [Score], [IsPassed], [Status], [CreatedAt]) VALUES (7, 4, 2, CAST(N'2026-06-18T14:14:04.0207474' AS DateTime2), CAST(N'2026-06-18T14:14:06.4487750' AS DateTime2), 2, 2, 0, 0, 2, CAST(0.00 AS Decimal(6, 2)), 0, 2, CAST(N'2026-06-18T14:14:04.0207477' AS DateTime2))
INSERT [dbo].[QuizAttempts] ([Id], [UserId], [QuizSetId], [StartedAt], [SubmittedAt], [DurationSeconds], [TotalQuestions], [CorrectAnswers], [WrongAnswers], [SkippedAnswers], [Score], [IsPassed], [Status], [CreatedAt]) VALUES (8, 4, 1, CAST(N'2026-06-18T14:42:50.6563619' AS DateTime2), CAST(N'2026-06-18T14:43:00.6141479' AS DateTime2), 9, 2, 1, 1, 0, CAST(5.00 AS Decimal(6, 2)), 1, 2, CAST(N'2026-06-18T14:42:50.6564123' AS DateTime2))
INSERT [dbo].[QuizAttempts] ([Id], [UserId], [QuizSetId], [StartedAt], [SubmittedAt], [DurationSeconds], [TotalQuestions], [CorrectAnswers], [WrongAnswers], [SkippedAnswers], [Score], [IsPassed], [Status], [CreatedAt]) VALUES (9, 4, 3, CAST(N'2026-06-18T15:00:21.9389528' AS DateTime2), CAST(N'2026-06-18T15:00:43.4693248' AS DateTime2), 21, 6, 0, 3, 3, CAST(0.00 AS Decimal(6, 2)), 0, 2, CAST(N'2026-06-18T15:00:21.9389532' AS DateTime2))
INSERT [dbo].[QuizAttempts] ([Id], [UserId], [QuizSetId], [StartedAt], [SubmittedAt], [DurationSeconds], [TotalQuestions], [CorrectAnswers], [WrongAnswers], [SkippedAnswers], [Score], [IsPassed], [Status], [CreatedAt]) VALUES (10, 6, 3, CAST(N'2026-06-19T04:38:38.5317163' AS DateTime2), NULL, NULL, 6, 0, 0, 0, CAST(0.00 AS Decimal(6, 2)), 0, 1, CAST(N'2026-06-19T04:38:38.5317435' AS DateTime2))
INSERT [dbo].[QuizAttempts] ([Id], [UserId], [QuizSetId], [StartedAt], [SubmittedAt], [DurationSeconds], [TotalQuestions], [CorrectAnswers], [WrongAnswers], [SkippedAnswers], [Score], [IsPassed], [Status], [CreatedAt]) VALUES (11, 5, 2, CAST(N'2026-06-19T07:09:10.4259116' AS DateTime2), CAST(N'2026-06-19T07:09:18.2767224' AS DateTime2), 7, 2, 0, 2, 0, CAST(0.00 AS Decimal(6, 2)), 0, 2, CAST(N'2026-06-19T07:09:10.4259117' AS DateTime2))
INSERT [dbo].[QuizAttempts] ([Id], [UserId], [QuizSetId], [StartedAt], [SubmittedAt], [DurationSeconds], [TotalQuestions], [CorrectAnswers], [WrongAnswers], [SkippedAnswers], [Score], [IsPassed], [Status], [CreatedAt]) VALUES (12, 5, 1, CAST(N'2026-06-19T07:10:10.4974377' AS DateTime2), NULL, NULL, 2, 0, 0, 0, CAST(0.00 AS Decimal(6, 2)), 0, 1, CAST(N'2026-06-19T07:10:10.4974378' AS DateTime2))
INSERT [dbo].[QuizAttempts] ([Id], [UserId], [QuizSetId], [StartedAt], [SubmittedAt], [DurationSeconds], [TotalQuestions], [CorrectAnswers], [WrongAnswers], [SkippedAnswers], [Score], [IsPassed], [Status], [CreatedAt]) VALUES (13, 5, 2, CAST(N'2026-06-19T07:11:59.4126037' AS DateTime2), CAST(N'2026-06-19T07:12:03.5952496' AS DateTime2), 4, 2, 1, 1, 0, CAST(5.00 AS Decimal(6, 2)), 1, 2, CAST(N'2026-06-19T07:11:59.4126038' AS DateTime2))
INSERT [dbo].[QuizAttempts] ([Id], [UserId], [QuizSetId], [StartedAt], [SubmittedAt], [DurationSeconds], [TotalQuestions], [CorrectAnswers], [WrongAnswers], [SkippedAnswers], [Score], [IsPassed], [Status], [CreatedAt]) VALUES (14, 5, 3, CAST(N'2026-06-19T07:32:09.9891174' AS DateTime2), CAST(N'2026-06-19T07:32:27.6042018' AS DateTime2), 17, 6, 1, 5, 0, CAST(1.67 AS Decimal(6, 2)), 0, 2, CAST(N'2026-06-19T07:32:09.9891175' AS DateTime2))
INSERT [dbo].[QuizAttempts] ([Id], [UserId], [QuizSetId], [StartedAt], [SubmittedAt], [DurationSeconds], [TotalQuestions], [CorrectAnswers], [WrongAnswers], [SkippedAnswers], [Score], [IsPassed], [Status], [CreatedAt]) VALUES (15, 6, 2, CAST(N'2026-06-19T08:16:13.7510080' AS DateTime2), CAST(N'2026-06-19T08:16:21.0864516' AS DateTime2), 7, 2, 0, 2, 0, CAST(0.00 AS Decimal(6, 2)), 0, 2, CAST(N'2026-06-19T08:16:13.7510081' AS DateTime2))
INSERT [dbo].[QuizAttempts] ([Id], [UserId], [QuizSetId], [StartedAt], [SubmittedAt], [DurationSeconds], [TotalQuestions], [CorrectAnswers], [WrongAnswers], [SkippedAnswers], [Score], [IsPassed], [Status], [CreatedAt]) VALUES (16, 6, 4, CAST(N'2026-07-09T16:59:07.4288157' AS DateTime2), CAST(N'2026-07-09T16:59:11.6606218' AS DateTime2), 4, 2, 0, 2, 0, CAST(0.00 AS Decimal(6, 2)), 0, 2, CAST(N'2026-07-09T16:59:07.4288471' AS DateTime2))
INSERT [dbo].[QuizAttempts] ([Id], [UserId], [QuizSetId], [StartedAt], [SubmittedAt], [DurationSeconds], [TotalQuestions], [CorrectAnswers], [WrongAnswers], [SkippedAnswers], [Score], [IsPassed], [Status], [CreatedAt]) VALUES (17, 6, 4, CAST(N'2026-07-09T17:11:08.8274018' AS DateTime2), CAST(N'2026-07-09T17:11:16.6048743' AS DateTime2), 7, 2, 2, 0, 0, CAST(10.00 AS Decimal(6, 2)), 1, 2, CAST(N'2026-07-09T17:11:08.8274019' AS DateTime2))
INSERT [dbo].[QuizAttempts] ([Id], [UserId], [QuizSetId], [StartedAt], [SubmittedAt], [DurationSeconds], [TotalQuestions], [CorrectAnswers], [WrongAnswers], [SkippedAnswers], [Score], [IsPassed], [Status], [CreatedAt]) VALUES (18, 14, 4, CAST(N'2026-07-10T01:57:46.1320999' AS DateTime2), CAST(N'2026-07-10T01:57:50.3412018' AS DateTime2), 4, 2, 0, 2, 0, CAST(0.00 AS Decimal(6, 2)), 0, 2, CAST(N'2026-07-10T01:57:46.1321383' AS DateTime2))
SET IDENTITY_INSERT [dbo].[QuizAttempts] OFF
GO
INSERT [dbo].[QuizSetQuestions] ([QuizSetId], [QuestionId], [DisplayOrder], [Score]) VALUES (1, 2, 1, CAST(1.00 AS Decimal(5, 2)))
INSERT [dbo].[QuizSetQuestions] ([QuizSetId], [QuestionId], [DisplayOrder], [Score]) VALUES (1, 3, 2, CAST(1.00 AS Decimal(5, 2)))
INSERT [dbo].[QuizSetQuestions] ([QuizSetId], [QuestionId], [DisplayOrder], [Score]) VALUES (2, 2, 1, CAST(1.00 AS Decimal(5, 2)))
INSERT [dbo].[QuizSetQuestions] ([QuizSetId], [QuestionId], [DisplayOrder], [Score]) VALUES (2, 3, 2, CAST(1.00 AS Decimal(5, 2)))
INSERT [dbo].[QuizSetQuestions] ([QuizSetId], [QuestionId], [DisplayOrder], [Score]) VALUES (3, 1, 6, CAST(1.00 AS Decimal(5, 2)))
INSERT [dbo].[QuizSetQuestions] ([QuizSetId], [QuestionId], [DisplayOrder], [Score]) VALUES (3, 4, 1, CAST(1.00 AS Decimal(5, 2)))
INSERT [dbo].[QuizSetQuestions] ([QuizSetId], [QuestionId], [DisplayOrder], [Score]) VALUES (3, 5, 5, CAST(1.00 AS Decimal(5, 2)))
INSERT [dbo].[QuizSetQuestions] ([QuizSetId], [QuestionId], [DisplayOrder], [Score]) VALUES (3, 6, 2, CAST(1.00 AS Decimal(5, 2)))
INSERT [dbo].[QuizSetQuestions] ([QuizSetId], [QuestionId], [DisplayOrder], [Score]) VALUES (3, 7, 4, CAST(1.00 AS Decimal(5, 2)))
INSERT [dbo].[QuizSetQuestions] ([QuizSetId], [QuestionId], [DisplayOrder], [Score]) VALUES (3, 8, 3, CAST(1.00 AS Decimal(5, 2)))
INSERT [dbo].[QuizSetQuestions] ([QuizSetId], [QuestionId], [DisplayOrder], [Score]) VALUES (4, 10, 2, CAST(1.00 AS Decimal(5, 2)))
INSERT [dbo].[QuizSetQuestions] ([QuizSetId], [QuestionId], [DisplayOrder], [Score]) VALUES (4, 14, 1, CAST(1.00 AS Decimal(5, 2)))
GO
SET IDENTITY_INSERT [dbo].[QuizSets] ON 

INSERT [dbo].[QuizSets] ([Id], [CreatedByUserId], [CategoryId], [Title], [Slug], [Description], [Difficulty], [QuizType], [TimeLimitMinutes], [PassingScore], [AllowReview], [ShuffleQuestions], [ShuffleOptions], [MaxAttempts], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (1, 2, 1, N'Bộ đề test import JSON', N'bo-de-test-import-json-20260618205125', N'Bộ đề được tạo từ các câu hỏi import JSON để test hiển thị bên User.', 1, 1, 15, CAST(5.00 AS Decimal(5, 2)), 1, 0, 0, 3, 1, CAST(N'2026-06-18T13:51:25.4335142' AS DateTime2), NULL, 0)
INSERT [dbo].[QuizSets] ([Id], [CreatedByUserId], [CategoryId], [Title], [Slug], [Description], [Difficulty], [QuizType], [TimeLimitMinutes], [PassingScore], [AllowReview], [ShuffleQuestions], [ShuffleOptions], [MaxAttempts], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (2, 2, 1, N'Bộ đề test import JSON', N'bo-de-test-import-json-20260618205313', N'Bộ đề được tạo từ các câu hỏi import JSON để test hiển thị bên User.', 1, 1, 15, CAST(5.00 AS Decimal(5, 2)), 1, 0, 0, 3, 1, CAST(N'2026-06-18T20:53:13.2100000' AS DateTime2), CAST(N'2026-06-18T20:53:13.2100000' AS DateTime2), 0)
INSERT [dbo].[QuizSets] ([Id], [CreatedByUserId], [CategoryId], [Title], [Slug], [Description], [Difficulty], [QuizType], [TimeLimitMinutes], [PassingScore], [AllowReview], [ShuffleQuestions], [ShuffleOptions], [MaxAttempts], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (3, 2, 3, N'đề test', N'angular', N'Chủ đề học Angular cơ bản 1', 1, 1, 15, CAST(5.00 AS Decimal(5, 2)), 1, 1, 1, 3, 1, CAST(N'2026-06-18T15:00:12.2500593' AS DateTime2), NULL, 0)
INSERT [dbo].[QuizSets] ([Id], [CreatedByUserId], [CategoryId], [Title], [Slug], [Description], [Difficulty], [QuizType], [TimeLimitMinutes], [PassingScore], [AllowReview], [ShuffleQuestions], [ShuffleOptions], [MaxAttempts], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (4, 2, 2, N'Bộ câu C#', N'c#', N'test thôi', 1, 1, 15, CAST(9.00 AS Decimal(5, 2)), 1, 1, 1, 3, 1, CAST(N'2026-07-09T16:58:36.0262351' AS DateTime2), NULL, 0)
SET IDENTITY_INSERT [dbo].[QuizSets] OFF
GO
SET IDENTITY_INSERT [dbo].[RefreshTokens] ON 

INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (1, 2, N'DCFA15E97FC1130D4EE6732AA81AC083A991FCE472FBF63AD41909963A4FB07A', N'c02d7b2c11d9449d9d024c3544ff68d5', NULL, CAST(N'2026-06-17T17:12:12.2809304' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-10T17:12:12.2810275' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (2, 2, N'06B6936C0B3CFB4029DBEC0859574052D399FC887FADCDD96D1BAB5D9786DB69', N'74830e416f234c38b4b0b533b361f6d7', NULL, CAST(N'2026-06-17T17:12:12.4331837' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-10T17:12:12.4331850' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (3, 3, N'458339354B92C7734907995DA408FE859C6F3B0560D922D18B6345853D129F14', N'ee3020c13307461199018b47e1644c2c', NULL, CAST(N'2026-06-17T17:18:24.5475806' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-10T17:18:24.5475812' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (4, 2, N'A28813A2F938EF9CCA7818D3C9D9E68752D32E9EA729D820D61A7A9D2A1913EE', N'1e1e22e0e3724eee84a147181925edd6', NULL, CAST(N'2026-06-17T18:07:34.1145162' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-10T18:07:34.1146512' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (5, 2, N'A3ABE82AF38E552F8335A52101E4E4385C1B99857F08325BB4C1ACE4DBEDDA19', N'55895bc92f20446994e0188bf2e8b6aa', NULL, CAST(N'2026-06-17T18:07:34.1146224' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-10T18:07:34.1146628' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (6, 4, N'6FEE2FC6F8A3FBDB27D9B46704EBDEFD29765F31D8FF776CC23D98712E5F1682', N'6e84e9b5739e41c7a252cc1a8dbdf7b9', NULL, CAST(N'2026-06-17T18:39:14.0172129' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-10T18:39:14.0173165' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (7, 4, N'16F7271DF369BC8FFF0FA94E6E098AEAA12161C6C455405B2DB56D02AA2D17E1', N'073ba78b557b40dc840e87a5cc2ccef7', NULL, CAST(N'2026-06-17T18:40:04.2308389' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-10T18:40:04.2308398' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (8, 4, N'917395D885B52CC5BC19E5ACC2EBF6108C7F973C14A6B927DA812FA2F852D43A', N'fea4320d30c24677af1b68239023c82e', NULL, CAST(N'2026-06-21T06:02:19.3718475' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-14T06:02:19.3720062' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (9, 4, N'D1768557D177EFB3324AD31CF200DDF833C86BE46EA7F03DDD03886153915A55', N'e6478b5df1f146188a508141180f4d87', NULL, CAST(N'2026-06-21T16:14:40.4838956' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-14T16:14:40.4840063' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (10, 2, N'98721D2BB50F1DC29CFE9EAA569C33550075C68013081CC14D53D43701951EBC', N'cccbac0ceb6844c483ff82fe2b83e6dc', NULL, CAST(N'2026-06-21T16:15:43.8990856' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-14T16:15:43.8990867' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (11, 2, N'E0EA98AF4DB92527354651D5B5C89C72A54012EFD00E62DD021DB43C8875A5E9', N'd101070fc0ee40c481402a0d4b8d8b40', NULL, CAST(N'2026-06-21T16:20:34.6402435' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-14T16:20:34.6402443' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (12, 4, N'01C46CD81DBFD21497BDF7AA00ED4EEC032BA5C4CDB0C143AE7550A7F4502F0E', N'02911666486f45e0b4fb25e3e6d69c42', NULL, CAST(N'2026-06-21T16:55:39.6765315' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-14T16:55:39.6765858' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (13, 3, N'06169C207EBA9D090B5364AEF4CED07E2A98F01273AF688BEE08CBB87D42008D', N'dfac398ee0184bd98e3e55374ab60e99', NULL, CAST(N'2026-06-24T10:07:45.0155672' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-17T10:07:45.0156637' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (14, 5, N'EFB53AE85BBCC2034108837A190EB78F3FEE434D8BB0B9B1BD1738AB34A1B55C', N'e582387cea02453d81e271d8d2ee920c', NULL, CAST(N'2026-06-24T10:09:29.2234368' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-17T10:09:29.2234379' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (15, 2, N'B0858D8A556C4CC0ACCDD379E1D0644FDEBF24F5035E1B0AFAA73494E22B7B24', N'1e6f16c1b892488cb074de564eeecb92', NULL, CAST(N'2026-06-24T10:10:26.7146135' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-17T10:10:26.7146148' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (16, 4, N'6539CA9BA539581C88A17703F2205ECD24118AB0443A183BD584B2ECC6CD3939', N'bdf2b46f7e04419ebf584fe6142236c0', NULL, CAST(N'2026-06-25T13:54:51.9442254' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-18T13:54:51.9443207' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (17, 4, N'6877871C92E24E64692730755E833ECC10229289A2929A84E0E419DE740E57CB', N'50ea5498c9fd4eb998f036c7af965cf8', NULL, CAST(N'2026-06-25T13:55:08.3805743' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-18T13:55:08.3805752' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (18, 3, N'A8D87ACD69BDB4BBDF81B85E87807C913D88FE1761BAF583D79B89A91E3D2B4F', N'a75d0e0c19f44d13a61b49660e98c836', NULL, CAST(N'2026-06-25T13:55:20.3875162' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-18T13:55:20.3875182' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (19, 4, N'B623DE897D8E1063D8262122FC9E5F584CF85354A61B9A3BC5750BCB8066C187', N'5f0fdba3a0a648b097b24b44671cc858', NULL, CAST(N'2026-06-25T14:03:43.9381436' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-18T14:03:43.9381447' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (20, 2, N'24E7A3FA18A1214F09F856B6D9E3B7ACF916281975368958EB91E57680074957', N'01efdcfe1a6f45a0b0de4a6b224025fb', NULL, CAST(N'2026-06-25T14:39:24.6521759' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-18T14:39:24.6522738' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (21, 3, N'9712715F9286A50FB7FB08C3A22D2649874BB02D94BAE49980DE20C346F5DB1E', N'f276b42b55d14e089287eff878cabe24', NULL, CAST(N'2026-06-25T14:53:54.1366629' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-18T14:53:54.1366637' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (22, 4, N'9526CD49F252D40700DBDA0D3FB810E63092E7B00376193822E6AA7E00DBCBBF', N'd2af03e69ed847d991d0de77b3a8d7e5', NULL, CAST(N'2026-06-25T14:57:27.4507586' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-18T14:57:27.4507596' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (23, 2, N'8BF3B1AC3E40FCC9566004BA2D3A085C01C92F04325BD2C720E4DA9688DFE616', N'a00262abff944607bf054d2e7e3f21dd', NULL, CAST(N'2026-06-25T14:58:23.4007280' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-18T14:58:23.4007289' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (24, 4, N'817CD6012C98782F4C8031CDD9D311A29A4953019F63E29AD3185EBAE7AD97D4', N'7cb2685412714c98a71c67255cedb4f7', NULL, CAST(N'2026-06-25T15:02:52.5377971' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-18T15:02:52.5377979' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (25, 6, N'71E6751653B7FF62FEE01C779CFA017051EE46A2A9D22147FECD3CB6935B0EE1', N'63a48dbc82ad4a50aeadea4a2d3df57a', NULL, CAST(N'2026-06-25T15:03:54.6803981' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-18T15:03:54.6803996' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (26, 6, N'00C54E35D048623497388EAD2993924782B6E60606D525CDEB46BF9DCACEF2E5', N'4feb0085d3fd4ef581060c73c9399e72', NULL, CAST(N'2026-06-25T16:05:30.3844923' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-18T16:05:30.3845909' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (27, 5, N'12655D499A832D772E65B8FEFF14DA51A0163511B0F1590048922833DCDE822A', N'f1745957c1454c9886536f1937ea1341', NULL, CAST(N'2026-06-25T16:20:13.9144123' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-18T16:20:13.9144132' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (28, 6, N'35B397EE4F7CC373400A283AE53C97D19E76C9B50163E036A160ABD31819E429', N'ef1003641b974f088c1fe9f2e1efa782', NULL, CAST(N'2026-06-25T16:41:28.4930065' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-18T16:41:28.4931062' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (29, 6, N'F6F53EAAA3E7B3C9A3B440C712E53C443F1F2C4766CF04CAF8BC6778E669336F', N'19f47663f133452fad44092721286bf8', NULL, CAST(N'2026-06-26T04:31:12.8591308' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-19T04:31:12.8592462' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (30, 7, N'2037542F18DBB6A9D9712C3EC46095FB6AC680DF608DFDE71AF348388716E1FA', N'717bf8ae57f74b8b950b650a2a24258a', NULL, CAST(N'2026-06-26T05:49:26.0914721' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-19T05:49:26.0914734' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (31, 7, N'737FC0E302D1837962281BAFE79D54DC0C87063CEED8D8D48F1894ED065A6736', N'f65262b98706485e975b53a37dd3cbe6', NULL, CAST(N'2026-06-26T05:52:34.9449664' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-19T05:52:34.9449676' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (32, 6, N'D79EF214ADEA4250AA260359F247CFE313BA77F72E666798D0EDBEBBAA15F843', N'7e66699ee32d47e88903c1800dfa0b5c', NULL, CAST(N'2026-06-26T05:54:08.5463123' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-19T05:54:08.5463134' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (33, 5, N'53672F95E57F4FBFB55070CD4CC1054AF22B80CB9F8076F5C42AD3217863FBF2', N'02a33e6bfb0d41ba91984664e5ef5ca6', NULL, CAST(N'2026-06-26T07:02:35.4762850' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-19T07:02:35.4762864' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (34, 2, N'61CFC0525849767A704720A3FB274DB29AFAC2947AD7487BE731BDE50E905AD1', N'c32744db5343436598fa2aa195aab480', NULL, CAST(N'2026-06-26T07:04:24.3064307' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-19T07:04:24.3064317' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (35, 6, N'CEDAF0758793AB6B6E49AD9130E3D99592821E91490026C3353B486890877065', N'6c4c753ab34646f1a095f0d857f6c614', NULL, CAST(N'2026-06-26T08:06:54.9256644' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-19T08:06:54.9256658' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (36, 7, N'4B280F17FC8579F92BF13EF23AA5AC9B0E462ACEFD8DBB718D0F6DB14C4ADBB6', N'15ebaff47b994c318e2fa42e4c95d1de', NULL, CAST(N'2026-06-26T08:17:45.2035992' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-19T08:17:45.2036005' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (37, 6, N'7F6243DB7E6F872420ACA531BA0558A6C833DDBCBF383C59B8FBEB327B71BC1E', N'0525fe4c1a754e1193e0542cbb8ed20f', NULL, CAST(N'2026-06-29T09:46:08.4476938' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-22T09:46:08.4477773' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (38, 2, N'6AC8AE55B7D514C9180675022EA889C30FF13353DADA3C39F0DD758790FF0258', N'ffac4e8e6a2c41d68189c429cdb2faa0', NULL, CAST(N'2026-06-29T09:46:11.5711530' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-22T09:46:11.5711547' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (39, 8, N'B708EEC3DCB2ACCABAF078EDB697451CD60F7D4B0CFE22FE5C6337B54FCD9C09', N'39605455695944059478bf5621a41d5c', NULL, CAST(N'2026-06-29T09:47:20.6749457' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-06-22T09:47:20.6749473' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (40, 6, N'777BC60A44C9BBE5767D528DAA37E8099ADF965DF16171D5F6080B78EF450ADE', N'c67e6aca47da435293fdfbe21dddaf63', NULL, CAST(N'2026-07-10T07:02:19.4117245' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-07-03T07:02:19.4118232' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (41, 2, N'1D482F374AA8051FC5D012DF91ED613863142CC43152030E5B2F75A93DF1959D', N'184c04f1906a4ed5b3c9c5c961e13604', NULL, CAST(N'2026-07-10T07:06:19.4300152' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-07-03T07:06:19.4300163' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (42, 2, N'BD8AAD8B8F4766E3DEE2699B03E62686A48640CBFDD0C203BCF5B5797E0D042E', N'f9c54dbf3cf14e5eaea1334921a7f035', NULL, CAST(N'2026-07-10T07:10:02.6950790' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-07-03T07:10:02.6950812' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (43, 2, N'8CAD94CB0D6594BEA853358124FEF1E71F173CD471ADAC7ECA5A2461877C87C2', N'708b18d254544469ae1ea2161c073cb5', NULL, CAST(N'2026-07-10T08:02:45.0769727' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-07-03T08:02:45.0770772' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (44, 2, N'A4B2811028C0561FEF177C859D2C8A8698D5367F5DC542AC2FC8D0288B4EE5A4', N'46c98707e1c9429fbb35cc867395e0e1', NULL, CAST(N'2026-07-10T08:12:21.6465930' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-07-03T08:12:21.6468007' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (45, 6, N'F322F82F10A36A44423FEBF42B9316DBEFCD5FA1BB5E479BAA5F393B7B9007E6', N'ccbbcf61b11243cebcc7ccaf6bf4c3b6', NULL, CAST(N'2026-07-10T08:13:45.9925470' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-07-03T08:13:45.9925480' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (46, 2, N'89766DD1F7E82AF0B2E497759CC8CBCE6585DDFA9A51AA6E66E1A0DECCBFB7CE', N'14e415e81271482cadc1833fb0c93447', NULL, CAST(N'2026-07-10T08:28:34.8051674' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', CAST(N'2026-07-03T08:28:34.8053556' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (47, 6, N'F92C1C50999636C825818EDB3BFD536AC71A171B979E780CC2680518A0D5B18D', N'3cf3f47621a541959d398febbde718e8', NULL, CAST(N'2026-07-16T02:46:10.3234025' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-09T02:46:10.3235083' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (48, 6, N'8A853CFBA1648B2A4E0EC3B3C6AD888A2C42AFBA5E3B0F5919D1E03922BDA647', N'34ed3014fcae458fbff746ccd6d6b26f', NULL, CAST(N'2026-07-16T08:00:56.0113995' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-09T08:00:56.0115415' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (49, 2, N'6D5DE4163F88CA55CABA1FD2F6126B4BD7D9AE887FADFBF8DB7753248B926612', N'd778da198041480bb41aa16992eb040c', NULL, CAST(N'2026-07-16T08:04:38.3968504' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-09T08:04:38.3968516' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (50, 6, N'82D7CF89F03B0D6E175CA17EC4445F08453B0C3AF84EC966163F9932854E6A14', N'dbaa2c30f065490bb380f1898b997f47', NULL, CAST(N'2026-07-16T08:18:12.7083222' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-09T08:18:12.7084149' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (51, 7, N'BDEB74CF609DF0D405D39F7C9EDEC4480D0F0061E06B8E4DF7B4254665F795AD', N'd4a20e749a864b24a0f5c95166e16de5', NULL, CAST(N'2026-07-16T08:21:18.2438468' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-09T08:21:18.2438478' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (52, 6, N'344825576B4FEC55934482809116124B7619B5CCEC5641D50957F4B51D46F017', N'42e2995e8c4548a68310d8c84b1af93e', NULL, CAST(N'2026-07-16T08:24:54.4142952' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-09T08:24:54.4144096' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (53, 6, N'F0CB958521D39A48AC9EB3CBDAB35CC4D34458C6176E1D38076A3B4EAA309EE3', N'115adc9da5774af2817d3cd7bfc37305', NULL, CAST(N'2026-07-16T08:27:35.8108509' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-09T08:27:35.8109831' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (54, 6, N'2CC700B7D8026C05EA8C783EE427E8FA9AE50D8CFA364A0CF6BA2BA692531A99', N'1edb617ca71f46d6a7f24b7a09dee3b5', NULL, CAST(N'2026-07-16T08:42:12.5364167' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-09T08:42:12.5365098' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (55, 2, N'9BF2BC154223AE9A38911B6099DBAA4F1433680A1164DFDAEF0FA83FA909713C', N'bea65a2cb93940d69994b4a2ebfe5d37', NULL, CAST(N'2026-07-16T08:47:09.2459318' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-09T08:47:09.2460143' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (56, 6, N'7F9E79761F144D4FBC1E8FA286D404FD8419EA2B75E59F10109916E1061DFDC7', N'156f59113ef1403880571cccf7e2ec3f', NULL, CAST(N'2026-07-16T08:47:58.4696708' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-09T08:47:58.4696716' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (57, 2, N'C5A66ACE616660D65F3365E21B8634505C42B94C7FB19BE077776E3BB6401E14', N'53daa69a6f844333a2cf5fc7007d3cee', NULL, CAST(N'2026-07-16T08:49:43.4169638' AS DateTime2), CAST(N'2026-07-09T08:54:30.4920214' AS DateTime2), NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-09T08:49:43.4169650' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (58, 2, N'A6A6ACD74867A8483E6010554A6496EA8D23A19534D3E21CEEB0424526E9ACDB', N'29f2fe8efc5a4ef3b129d488242d892c', NULL, CAST(N'2026-07-16T08:58:57.8703064' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-09T08:58:57.8703074' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (59, 2, N'B35AF557704D58AE432F22C922F50D2D309D840484BE8250EAB7117D0588E6B3', N'a893ea37713b43b6a336dc4fd271b632', NULL, CAST(N'2026-07-16T08:58:59.9048048' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-09T08:58:59.9048057' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (60, 6, N'44336B4F6FAEB3038E0653B057CC5966F6120CA6974E7B93C5308279377A8E6D', N'4f21341d9ce74adfa930d22b8a40acb9', NULL, CAST(N'2026-07-16T09:34:00.1848502' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-09T09:34:00.1849683' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (61, 7, N'E7AFF6A3104955A1BF6D33D8F9439D98FE0CDEB15740C6CAE3BF5E63DA89C66B', N'803cbf3881e84fd384e26e1f32eaa091', NULL, CAST(N'2026-07-16T09:40:58.4575556' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-09T09:40:58.4575563' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (62, 6, N'E3B0B4FB25B1DD4F71F7C62FFEC9793DB48C259EE4384C31C7A3DA3DA6F119A9', N'58dd958c2249406888b8569d583a8cbe', NULL, CAST(N'2026-07-16T09:43:08.2502896' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-09T09:43:08.2502905' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (63, 6, N'C1BDB50B62836096E51B221FE66EFDD7EE6853CE80F9E5FB08A0AD66151C4FA4', N'935ed8b63be34b569d7f0c53fe0a909a', NULL, CAST(N'2026-07-16T14:41:03.2689923' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-09T14:41:03.2693308' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (64, 2, N'336B1D117063818FBD92A0E39346E40AE9348B91A5B37E0F4F4027C88E673FB8', N'59eb7aa4490f4c97bb61eea50267b800', NULL, CAST(N'2026-07-16T15:02:39.8758131' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-09T15:02:39.8759287' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (65, 6, N'6BFD8B4CC4497D0A3420AD1A3EEC91717840CE1BEF4F6D45FD2F521EB6051926', N'a32c484a28c7418391b369cca6b13d8a', NULL, CAST(N'2026-07-16T15:03:42.3498119' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-09T15:03:42.3498128' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (66, 6, N'F49FEF493D34AFCD9A773CE22CD9E540DAA0E5BC824A0CF127138048F289279F', N'3d0a29e48a864f029ad0a86b95438d2d', NULL, CAST(N'2026-07-16T16:47:16.7141408' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-09T16:47:16.7142345' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (67, 2, N'E324FDB0C1C6BEC2892503E94F02C68FFDC8A83C35C6BB5042B5365E8C6754B4', N'9935ebad2d964d4f8756f92e0c48fa88', NULL, CAST(N'2026-07-16T16:51:12.6876270' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-09T16:51:12.6876971' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (68, 6, N'C6E9093CB75C4C83676A25FA8E22B3A3A543896766FA660A20C4F14A5EF79C5D', N'a4b08842a14b4459afcdf6adcef802ce', NULL, CAST(N'2026-07-16T16:58:56.4686657' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-09T16:58:56.4686666' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (69, 7, N'A9A749CE468DCE0663E88B37B18986E2A7F0BD0D1C98AF419A7C910BFBC71C59', N'4943609096d54b049d0e1719bfbb3051', NULL, CAST(N'2026-07-16T17:20:53.2118878' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-09T17:20:53.2118891' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (70, 14, N'63F6E3D6D720E65776645E1E783DD21D8B3E5159CF9E34E37EB6BC99E10A3443', N'351acd9137cd48bb94454cfa5a7d65f7', NULL, CAST(N'2026-07-17T01:43:21.5623113' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-10T01:43:21.5624251' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (71, 2, N'510112AEA136C13D36BC2CBB5D8C074A5933C912E653F87610BF14F19D027C99', N'84fbd89ee15f4f4a9d4c2bbad2078c2b', NULL, CAST(N'2026-07-17T01:43:44.8171122' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-10T01:43:44.8171135' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (72, 14, N'8D1EB8D868CAC47B1103546D5062B084F4ABA353687C2E497C33D7048103C908', N'c1d288d6a4ee41898ce3cdbceea50dd6', NULL, CAST(N'2026-07-17T01:43:57.0470865' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-10T01:43:57.0470875' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (73, 15, N'E596BCA79A58A22F459E39AA02DFFDA6703C35C2626712242399A67DFB2A1BD3', N'2f28b0581f7d4d12be071808636d7179', NULL, CAST(N'2026-07-17T01:44:55.6443153' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-10T01:44:55.6443175' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (74, 2, N'5DD79C687E2DF87890BC1E9FBED2E02AFF73602339A0ADC18B540CDE14875E9A', N'58008c147a0941a6b9e2516aef832e9b', NULL, CAST(N'2026-07-17T02:22:06.2174941' AS DateTime2), CAST(N'2026-07-10T02:26:51.6237636' AS DateTime2), NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-10T02:22:06.2175941' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (75, 14, N'1353EA17B72945C892960E065EF9FC5A49D6E05398A1C942AC45C5C72A909D69', N'0d8b0064406d4503bae3507c07e1b197', NULL, CAST(N'2026-07-17T02:25:54.4927865' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-10T02:25:54.4927874' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (76, 14, N'D69F29796F67EEC07AE0BAA9BFCC134737E0050AA39C22DB11EE165C799A1A86', N'6d78611edd6f4188ae603687d77de417', NULL, CAST(N'2026-07-17T02:27:03.3835764' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-10T02:27:03.3835779' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (77, 2, N'031EB4D7F1A38C7CA0F86C120777A1F6BB185EBCD9B509438828C204368D7940', N'2ba878a7668541b29e341924ff2fffbd', NULL, CAST(N'2026-07-17T02:27:39.8657045' AS DateTime2), CAST(N'2026-07-10T02:29:10.7121579' AS DateTime2), NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-10T02:27:39.8657055' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (78, 14, N'7852B2883F62A62B449C03CA495D3CC20FE56E6C46478A68AD944CC127A2806C', N'f47acab10c2942b5a626ca07bd8dba0c', NULL, CAST(N'2026-07-17T02:29:21.9385152' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-10T02:29:21.9385162' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (79, 2, N'57D917DB5AE3E0ACA131CC46B5C093B1837C5941C5D19E919ECC74F271897F12', N'cb5f7992c68d44ceba18c5fdab575f2b', NULL, CAST(N'2026-07-17T02:32:28.1385591' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-10T02:32:28.1385600' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (80, 15, N'67EBA5B0A9A0C4CAF45E61A98EE0004787A678B8754152DA65AD009CF7C3A768', N'c82a3f3b5c304467b4106240a8990fac', NULL, CAST(N'2026-07-17T03:07:06.2053539' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-10T03:07:06.2055211' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (81, 14, N'9567F459F763FFE2B04101B4AA331B81E88C08DD39A0B1A2F94B5537CF474348', N'c9ec8a35f0bb4fb0a44c47673c8255bd', NULL, CAST(N'2026-07-17T03:08:24.1813423' AS DateTime2), CAST(N'2026-07-10T03:09:18.4097048' AS DateTime2), NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-10T03:08:24.1813438' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (82, 15, N'FE88E91A8E57B885F8922C38BEF5F0C5CF48BD06A16D87C2A72924E3CC83CA7A', N'30f60894b28141b0b6b05148c1cbc203', NULL, CAST(N'2026-07-17T03:09:34.6856629' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-10T03:09:34.6856637' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (83, 14, N'89AD2CB717811B0ECEA85B814B3241547A8AF9B0BEA030E3F4D8E36DE316B060', N'7f8b64f40c7d41e1a90c4e240804a255', NULL, CAST(N'2026-07-17T03:09:45.0521663' AS DateTime2), CAST(N'2026-07-10T03:10:24.0244209' AS DateTime2), NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-10T03:09:45.0521669' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (84, 15, N'3FFCEAB1DACC17393BDCF350C5AE1B048934142C43C07EFC06853686164472F6', N'fdf9239a69aa4e3c998f4ceafee72f2a', NULL, CAST(N'2026-07-17T03:10:36.0551054' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-10T03:10:36.0551066' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (85, 2, N'456569E4D0774001F2F6BD46719A038E2171797EABB7F270179A9567FE47B4F1', N'818f5256a1d44123bfba9204bb78ab2c', NULL, CAST(N'2026-07-17T03:10:55.6350593' AS DateTime2), CAST(N'2026-07-10T03:11:45.6264598' AS DateTime2), NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-10T03:10:55.6350604' AS DateTime2))
INSERT [dbo].[RefreshTokens] ([Id], [UserId], [TokenHash], [JwtId], [DeviceId], [ExpiresAt], [RevokedAt], [ReplacedByTokenHash], [IpAddress], [UserAgent], [CreatedAt]) VALUES (86, 15, N'1A1320FB7C0CD643D023A5EE1809670D58E27C4B00A378CFA30AB9D3C719B6F6', N'5bff7c2142894308aee325a40c8d1c55', NULL, CAST(N'2026-07-17T03:11:55.4098319' AS DateTime2), NULL, NULL, N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', CAST(N'2026-07-10T03:11:55.4098326' AS DateTime2))
SET IDENTITY_INSERT [dbo].[RefreshTokens] OFF
GO
SET IDENTITY_INSERT [dbo].[Reports] ON 

INSERT [dbo].[Reports] ([Id], [ReporterId], [TargetType], [TargetId], [Reason], [Description], [Status], [ResolvedByUserId], [ResolvedAt], [CreatedAt]) VALUES (1, 6, N'Comment', 4, N'test report', NULL, 1, NULL, NULL, CAST(N'2026-07-09T17:20:17.6239652' AS DateTime2))
SET IDENTITY_INSERT [dbo].[Reports] OFF
GO
SET IDENTITY_INSERT [dbo].[RoadmapCourses] ON 

INSERT [dbo].[RoadmapCourses] ([Id], [TrackId], [Title], [Slug], [ShortDescription], [Description], [Level], [EstimatedHours], [TotalModules], [TotalLessons], [RequirementsJson], [LearningOutcomesJson], [RelatedCourseIdsJson], [PrerequisiteCourseIdsJson], [ThumbnailUrl], [SortOrder], [IsPublished], [RequiresSequentialCompletion], [UnlockAfterCourseId], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (1, 1, N'HTML CSS từ Zero', N'html-css-tu-zero', N'HTML CSS từ Zero giúp bạn chuẩn bị nền tảng trước khi vào các khóa chuyên sâu.', N'Khóa HTML CSS từ Zero tập trung vào kiến thức cốt lõi, bài luyện tập ngắn và ví dụ thực tế trong DevLearningHub.', N'Beginner', 32, 0, 0, N'["C\u00F3 m\u00E1y t\u00EDnh v\u00E0 tinh th\u1EA7n luy\u1EC7n t\u1EADp \u0111\u1EC1u \u0111\u1EB7n"]', N'["N\u1EAFm kh\u00E1i ni\u1EC7m n\u1EC1n t\u1EA3ng","T\u1EF1 l\u00E0m \u0111\u01B0\u1EE3c b\u00E0i t\u1EADp c\u01A1 b\u1EA3n","S\u1EB5n s\u00E0ng h\u1ECDc kh\u00F3a ti\u1EBFp theo"]', NULL, NULL, NULL, 10, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.1261055' AS DateTime2), NULL, 0)
INSERT [dbo].[RoadmapCourses] ([Id], [TrackId], [Title], [Slug], [ShortDescription], [Description], [Level], [EstimatedHours], [TotalModules], [TotalLessons], [RequirementsJson], [LearningOutcomesJson], [RelatedCourseIdsJson], [PrerequisiteCourseIdsJson], [ThumbnailUrl], [SortOrder], [IsPublished], [RequiresSequentialCompletion], [UnlockAfterCourseId], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (2, 1, N'JavaScript Cơ bản', N'javascript-co-ban', N'JavaScript Cơ bản giúp bạn chuẩn bị nền tảng trước khi vào các khóa chuyên sâu.', N'Khóa JavaScript Cơ bản tập trung vào kiến thức cốt lõi, bài luyện tập ngắn và ví dụ thực tế trong DevLearningHub.', N'Beginner', 42, 0, 0, N'["C\u00F3 m\u00E1y t\u00EDnh v\u00E0 tinh th\u1EA7n luy\u1EC7n t\u1EADp \u0111\u1EC1u \u0111\u1EB7n"]', N'["N\u1EAFm kh\u00E1i ni\u1EC7m n\u1EC1n t\u1EA3ng","T\u1EF1 l\u00E0m \u0111\u01B0\u1EE3c b\u00E0i t\u1EADp c\u01A1 b\u1EA3n","S\u1EB5n s\u00E0ng h\u1ECDc kh\u00F3a ti\u1EBFp theo"]', NULL, NULL, NULL, 20, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.1531177' AS DateTime2), NULL, 0)
INSERT [dbo].[RoadmapCourses] ([Id], [TrackId], [Title], [Slug], [ShortDescription], [Description], [Level], [EstimatedHours], [TotalModules], [TotalLessons], [RequirementsJson], [LearningOutcomesJson], [RelatedCourseIdsJson], [PrerequisiteCourseIdsJson], [ThumbnailUrl], [SortOrder], [IsPublished], [RequiresSequentialCompletion], [UnlockAfterCourseId], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (3, 1, N'JavaScript Nâng cao', N'javascript-nang-cao', N'JavaScript Nâng cao giúp bạn chuẩn bị nền tảng trước khi vào các khóa chuyên sâu.', N'Khóa JavaScript Nâng cao tập trung vào kiến thức cốt lõi, bài luyện tập ngắn và ví dụ thực tế trong DevLearningHub.', N'Intermediate', 48, 0, 0, N'["C\u00F3 m\u00E1y t\u00EDnh v\u00E0 tinh th\u1EA7n luy\u1EC7n t\u1EADp \u0111\u1EC1u \u0111\u1EB7n"]', N'["N\u1EAFm kh\u00E1i ni\u1EC7m n\u1EC1n t\u1EA3ng","T\u1EF1 l\u00E0m \u0111\u01B0\u1EE3c b\u00E0i t\u1EADp c\u01A1 b\u1EA3n","S\u1EB5n s\u00E0ng h\u1ECDc kh\u00F3a ti\u1EBFp theo"]', NULL, NULL, NULL, 30, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.1543779' AS DateTime2), NULL, 0)
INSERT [dbo].[RoadmapCourses] ([Id], [TrackId], [Title], [Slug], [ShortDescription], [Description], [Level], [EstimatedHours], [TotalModules], [TotalLessons], [RequirementsJson], [LearningOutcomesJson], [RelatedCourseIdsJson], [PrerequisiteCourseIdsJson], [ThumbnailUrl], [SortOrder], [IsPublished], [RequiresSequentialCompletion], [UnlockAfterCourseId], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (4, 2, N'SQL Cơ bản', N'sql-co-ban', N'SQL Cơ bản giúp bạn chuẩn bị nền tảng trước khi vào các khóa chuyên sâu.', N'Khóa SQL Cơ bản tập trung vào kiến thức cốt lõi, bài luyện tập ngắn và ví dụ thực tế trong DevLearningHub.', N'Beginner', 28, 0, 0, N'["C\u00F3 m\u00E1y t\u00EDnh v\u00E0 tinh th\u1EA7n luy\u1EC7n t\u1EADp \u0111\u1EC1u \u0111\u1EB7n"]', N'["N\u1EAFm kh\u00E1i ni\u1EC7m n\u1EC1n t\u1EA3ng","T\u1EF1 l\u00E0m \u0111\u01B0\u1EE3c b\u00E0i t\u1EADp c\u01A1 b\u1EA3n","S\u1EB5n s\u00E0ng h\u1ECDc kh\u00F3a ti\u1EBFp theo"]', NULL, NULL, NULL, 10, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.1551931' AS DateTime2), NULL, 0)
INSERT [dbo].[RoadmapCourses] ([Id], [TrackId], [Title], [Slug], [ShortDescription], [Description], [Level], [EstimatedHours], [TotalModules], [TotalLessons], [RequirementsJson], [LearningOutcomesJson], [RelatedCourseIdsJson], [PrerequisiteCourseIdsJson], [ThumbnailUrl], [SortOrder], [IsPublished], [RequiresSequentialCompletion], [UnlockAfterCourseId], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (5, 4, N'Algorithms Cơ bản', N'algorithms-co-ban', N'Algorithms Cơ bản giúp bạn chuẩn bị nền tảng trước khi vào các khóa chuyên sâu.', N'Khóa Algorithms Cơ bản tập trung vào kiến thức cốt lõi, bài luyện tập ngắn và ví dụ thực tế trong DevLearningHub.', N'Beginner', 36, 0, 0, N'["C\u00F3 m\u00E1y t\u00EDnh v\u00E0 tinh th\u1EA7n luy\u1EC7n t\u1EADp \u0111\u1EC1u \u0111\u1EB7n"]', N'["N\u1EAFm kh\u00E1i ni\u1EC7m n\u1EC1n t\u1EA3ng","T\u1EF1 l\u00E0m \u0111\u01B0\u1EE3c b\u00E0i t\u1EADp c\u01A1 b\u1EA3n","S\u1EB5n s\u00E0ng h\u1ECDc kh\u00F3a ti\u1EBFp theo"]', NULL, NULL, NULL, 10, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.1557887' AS DateTime2), NULL, 0)
INSERT [dbo].[RoadmapCourses] ([Id], [TrackId], [Title], [Slug], [ShortDescription], [Description], [Level], [EstimatedHours], [TotalModules], [TotalLessons], [RequirementsJson], [LearningOutcomesJson], [RelatedCourseIdsJson], [PrerequisiteCourseIdsJson], [ThumbnailUrl], [SortOrder], [IsPublished], [RequiresSequentialCompletion], [UnlockAfterCourseId], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (6, 1, N'ReactJS Cơ bản đến nâng cao', N'reactjs-co-ban-den-nang-cao', N'Học React theo lộ trình module rõ ràng, từ component đến deploy.', N'Khóa học dẫn bạn qua cách tư duy SPA, JSX, component, hooks, routing, API, state management và xây dựng dự án thực tế.', N'Intermediate', 72, 11, 43, N'["Hi\u1EC3u m\u00F4 h\u00ECnh Client-Server","N\u1EAFm HTML/CSS c\u01A1 b\u1EA3n","N\u1EAFm JavaScript c\u01A1 b\u1EA3n","Bi\u1EBFt s\u1EED d\u1EE5ng npm/node c\u01A1 b\u1EA3n"]', N'["Hi\u1EC3u SPA/MPA","Hi\u1EC3u React component, props, state","S\u1EED d\u1EE5ng hooks c\u01A1 b\u1EA3n v\u00E0 n\u00E2ng cao","L\u00E0m vi\u1EC7c v\u1EDBi RESTful API","S\u1EED d\u1EE5ng routing","Qu\u1EA3n l\u00FD state v\u1EDBi Context/Reducer ho\u1EB7c Redux","T\u1ED1i \u01B0u hi\u1EC7u n\u0103ng React app","Tri\u1EC3n khai \u1EE9ng d\u1EE5ng l\u00EAn Internet"]', N'[5,1,2,3,4]', N'[]', NULL, 5, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.2363258' AS DateTime2), CAST(N'2026-07-10T02:35:16.0902448' AS DateTime2), 0)
SET IDENTITY_INSERT [dbo].[RoadmapCourses] OFF
GO
SET IDENTITY_INSERT [dbo].[RoadmapLessons] ON 

INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (1, 1, N'ReactJS là gì?', N'Video', N'Nội dung mẫu cho bài ReactJS là gì?. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', N'https://www.youtube.com/watch?v=NclbvXqvnyA&list=PLPt6-BtUI22oD3xfWy9VI9klNNxqAnTjb', NULL, NULL, 12, 1, 1, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.2680840' AS DateTime2), CAST(N'2026-07-09T17:24:38.0427496' AS DateTime2), 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (2, 1, N'SPA/MPA là gì?', N'Reading', N'Nội dung mẫu cho bài SPA/MPA là gì?. ', NULL, NULL, NULL, 15, 2, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.2917313' AS DateTime2), CAST(N'2026-07-10T02:35:16.0383262' AS DateTime2), 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (3, 1, N'Vì sao nên học React?', N'Reading', N'Nội dung mẫu cho bài Vì sao nên học React?. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', NULL, NULL, NULL, 18, 3, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.2918051' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (4, 2, N'Arrow function', N'Video', N'Nội dung mẫu cho bài Arrow function. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', N'https://example.com/roadmap-preview-video', NULL, NULL, 12, 1, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3199084' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (5, 2, N'Destructuring / Rest / Spread', N'Reading', N'Nội dung mẫu cho bài Destructuring / Rest / Spread. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', NULL, NULL, NULL, 15, 2, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3199819' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (6, 2, N'Modules', N'Reading', N'Nội dung mẫu cho bài Modules. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', NULL, NULL, NULL, 18, 3, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3200039' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (7, 2, N'Promise / async-await', N'Video', N'Nội dung mẫu cho bài Promise / async-await. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', N'https://example.com/roadmap-preview-video', NULL, NULL, 21, 4, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3200283' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (8, 3, N'React.createElement', N'Video', N'Nội dung mẫu cho bài React.createElement. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', N'https://example.com/roadmap-preview-video', NULL, NULL, 12, 1, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3383653' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (9, 3, N'ReactDOM', N'Reading', N'Nội dung mẫu cho bài ReactDOM. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', NULL, NULL, NULL, 15, 2, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3384644' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (10, 3, N'JSX', N'Reading', N'Nội dung mẫu cho bài JSX. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', NULL, NULL, NULL, 18, 3, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3384999' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (11, 3, N'Render list', N'Video', N'Nội dung mẫu cho bài Render list. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', N'https://example.com/roadmap-preview-video', NULL, NULL, 21, 4, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3385297' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (12, 4, N'Function component', N'Video', N'Nội dung mẫu cho bài Function component. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', N'https://example.com/roadmap-preview-video', NULL, NULL, 12, 1, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3426261' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (13, 4, N'Props', N'Reading', N'Nội dung mẫu cho bài Props. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', NULL, NULL, NULL, 15, 2, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3427094' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (14, 4, N'Children props', N'Reading', N'Nội dung mẫu cho bài Children props. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', NULL, NULL, NULL, 18, 3, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3427549' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (15, 4, N'Event handling', N'Video', N'Nội dung mẫu cho bài Event handling. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', N'https://example.com/roadmap-preview-video', NULL, NULL, 21, 4, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3427882' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (16, 5, N'useState', N'Video', N'Nội dung mẫu cho bài useState. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', N'https://example.com/roadmap-preview-video', NULL, NULL, 12, 1, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3468013' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (17, 5, N'Two-way binding', N'Reading', N'Nội dung mẫu cho bài Two-way binding. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', NULL, NULL, NULL, 15, 2, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3468465' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (18, 5, N'useEffect', N'Reading', N'Nội dung mẫu cho bài useEffect. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', NULL, NULL, NULL, 18, 3, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3468740' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (19, 5, N'useRef', N'Video', N'Nội dung mẫu cho bài useRef. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', N'https://example.com/roadmap-preview-video', NULL, NULL, 21, 4, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3468922' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (20, 6, N'memo', N'Video', N'Nội dung mẫu cho bài memo. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', N'https://example.com/roadmap-preview-video', NULL, NULL, 12, 1, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3506883' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (21, 6, N'useCallback', N'Reading', N'Nội dung mẫu cho bài useCallback. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', NULL, NULL, NULL, 15, 2, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3507627' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (22, 6, N'useMemo', N'Reading', N'Nội dung mẫu cho bài useMemo. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', NULL, NULL, NULL, 18, 3, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3508299' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (23, 6, N'useReducer', N'Video', N'Nội dung mẫu cho bài useReducer. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', N'https://example.com/roadmap-preview-video', NULL, NULL, 21, 4, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3508657' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (24, 6, N'useContext', N'Reading', N'Nội dung mẫu cho bài useContext. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', NULL, NULL, NULL, 24, 5, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3508962' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (25, 7, N'CSS thường', N'Video', N'Nội dung mẫu cho bài CSS thường. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', N'https://example.com/roadmap-preview-video', NULL, NULL, 12, 1, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3696225' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (26, 7, N'CSS Modules', N'Reading', N'Nội dung mẫu cho bài CSS Modules. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', NULL, NULL, NULL, 15, 2, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3697605' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (27, 7, N'SCSS', N'Reading', N'Nội dung mẫu cho bài SCSS. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', NULL, NULL, NULL, 18, 3, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3698111' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (28, 7, N'classnames/clsx', N'Video', N'Nội dung mẫu cho bài classnames/clsx. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', N'https://example.com/roadmap-preview-video', NULL, NULL, 21, 4, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3698665' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (29, 8, N'Cài đặt router', N'Video', N'Nội dung mẫu cho bài Cài đặt router. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', N'https://example.com/roadmap-preview-video', NULL, NULL, 12, 1, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3739796' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (30, 8, N'Layout route', N'Reading', N'Nội dung mẫu cho bài Layout route. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', NULL, NULL, NULL, 15, 2, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3740402' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (31, 8, N'Protected route', N'Reading', N'Nội dung mẫu cho bài Protected route. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', NULL, NULL, NULL, 18, 3, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3740598' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (32, 9, N'RESTful API', N'Video', N'Nội dung mẫu cho bài RESTful API. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', N'https://example.com/roadmap-preview-video', NULL, NULL, 12, 1, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3774496' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (33, 9, N'Axios/fetch', N'Reading', N'Nội dung mẫu cho bài Axios/fetch. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', NULL, NULL, NULL, 15, 2, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3775336' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (34, 9, N'Loading/error state', N'Reading', N'Nội dung mẫu cho bài Loading/error state. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', NULL, NULL, NULL, 18, 3, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3775667' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (35, 9, N'Pagination/search', N'Video', N'Nội dung mẫu cho bài Pagination/search. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', N'https://example.com/roadmap-preview-video', NULL, NULL, 21, 4, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3776041' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (36, 10, N'Context + reducer', N'Video', N'Nội dung mẫu cho bài Context + reducer. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', N'https://example.com/roadmap-preview-video', NULL, NULL, 12, 1, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3822317' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (37, 10, N'Redux workflow nếu có', N'Reading', N'Nội dung mẫu cho bài Redux workflow nếu có. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', NULL, NULL, NULL, 15, 2, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3823107' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (38, 10, N'Redux thunk nếu có', N'Reading', N'Nội dung mẫu cho bài Redux thunk nếu có. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', NULL, NULL, NULL, 18, 3, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3823546' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (39, 11, N'Tạo base project', N'Video', N'Nội dung mẫu cho bài Tạo base project. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', N'https://example.com/roadmap-preview-video', NULL, NULL, 12, 1, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3973523' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (40, 11, N'Header/sidebar/layout', N'Reading', N'Nội dung mẫu cho bài Header/sidebar/layout. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', NULL, NULL, NULL, 15, 2, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3974254' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (41, 11, N'Auth UI', N'Reading', N'Nội dung mẫu cho bài Auth UI. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', NULL, NULL, NULL, 18, 3, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3974473' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (42, 11, N'CRUD dữ liệu', N'Video', N'Nội dung mẫu cho bài CRUD dữ liệu. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', N'https://example.com/roadmap-preview-video', NULL, NULL, 21, 4, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3974655' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[RoadmapLessons] ([Id], [ModuleId], [Title], [Type], [Content], [VideoUrl], [QuizSetId], [CodingProblemId], [EstimatedMinutes], [SortOrder], [IsPreview], [IsPublished], [RequiresPreviousLessonCompletion], [IsRequired], [UnlockAfterLessonId], [CreatedAt], [UpdatedAt], [IsDeleted], [VideoFileId]) VALUES (43, 11, N'Deploy', N'Reading', N'Nội dung mẫu cho bài Deploy. Admin có thể thay bằng bài viết/video thật trong Roadmap Management.', NULL, NULL, NULL, 24, 5, 0, 1, 1, 1, NULL, CAST(N'2026-07-09T16:49:21.3974873' AS DateTime2), NULL, 0, NULL)
SET IDENTITY_INSERT [dbo].[RoadmapLessons] OFF
GO
SET IDENTITY_INSERT [dbo].[RoadmapModules] ON 

INSERT [dbo].[RoadmapModules] ([Id], [CourseId], [Title], [Description], [SortOrder], [EstimatedMinutes], [RequiresPreviousModuleCompletion], [IsLockedByDefault], [IsPublished], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (1, 6, N'Giới thiệu ReactJS', N'Bức tranh tổng quan về React và cách học hiệu quả.', 1, 45, 1, 0, 1, CAST(N'2026-07-09T16:49:21.2433845' AS DateTime2), CAST(N'2026-07-09T17:24:42.9817575' AS DateTime2), 0)
INSERT [dbo].[RoadmapModules] ([Id], [CourseId], [Title], [Description], [SortOrder], [EstimatedMinutes], [RequiresPreviousModuleCompletion], [IsLockedByDefault], [IsPublished], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (2, 6, N'Ôn lại JavaScript ES6+', N'Các cú pháp JavaScript dùng hằng ngày trong React.', 2, 80, 1, 0, 1, CAST(N'2026-07-09T16:49:21.3173953' AS DateTime2), NULL, 0)
INSERT [dbo].[RoadmapModules] ([Id], [CourseId], [Title], [Description], [SortOrder], [EstimatedMinutes], [RequiresPreviousModuleCompletion], [IsLockedByDefault], [IsPublished], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (3, 6, N'React, ReactDOM và JSX', N'Tạo phần tử, render UI và viết JSX có chủ đích.', 3, 90, 1, 0, 1, CAST(N'2026-07-09T16:49:21.3366979' AS DateTime2), NULL, 0)
INSERT [dbo].[RoadmapModules] ([Id], [CourseId], [Title], [Description], [SortOrder], [EstimatedMinutes], [RequiresPreviousModuleCompletion], [IsLockedByDefault], [IsPublished], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (4, 6, N'Components và Props', N'Chia UI thành component có thể tái sử dụng.', 4, 95, 1, 0, 1, CAST(N'2026-07-09T16:49:21.3407793' AS DateTime2), NULL, 0)
INSERT [dbo].[RoadmapModules] ([Id], [CourseId], [Title], [Description], [SortOrder], [EstimatedMinutes], [RequiresPreviousModuleCompletion], [IsLockedByDefault], [IsPublished], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (5, 6, N'State và Hooks cơ bản', N'Quản lý dữ liệu thay đổi và side effects trong component.', 5, 120, 1, 0, 1, CAST(N'2026-07-09T16:49:21.3450350' AS DateTime2), NULL, 0)
INSERT [dbo].[RoadmapModules] ([Id], [CourseId], [Title], [Description], [SortOrder], [EstimatedMinutes], [RequiresPreviousModuleCompletion], [IsLockedByDefault], [IsPublished], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (6, 6, N'Hooks nâng cao', N'Tối ưu và chia sẻ logic với các hook nâng cao.', 6, 130, 1, 0, 1, CAST(N'2026-07-09T16:49:21.3487884' AS DateTime2), NULL, 0)
INSERT [dbo].[RoadmapModules] ([Id], [CourseId], [Title], [Description], [SortOrder], [EstimatedMinutes], [RequiresPreviousModuleCompletion], [IsLockedByDefault], [IsPublished], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (7, 6, N'Styling trong React', N'Tổ chức CSS phù hợp cho dự án React.', 7, 75, 1, 0, 1, CAST(N'2026-07-09T16:49:21.3674689' AS DateTime2), NULL, 0)
INSERT [dbo].[RoadmapModules] ([Id], [CourseId], [Title], [Description], [SortOrder], [EstimatedMinutes], [RequiresPreviousModuleCompletion], [IsLockedByDefault], [IsPublished], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (8, 6, N'React Router', N'Xây dựng điều hướng và bảo vệ route.', 8, 85, 1, 0, 1, CAST(N'2026-07-09T16:49:21.3722189' AS DateTime2), NULL, 0)
INSERT [dbo].[RoadmapModules] ([Id], [CourseId], [Title], [Description], [SortOrder], [EstimatedMinutes], [RequiresPreviousModuleCompletion], [IsLockedByDefault], [IsPublished], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (9, 6, N'Làm việc với API', N'Gọi API, xử lý loading/error và phân trang.', 9, 110, 1, 0, 1, CAST(N'2026-07-09T16:49:21.3759781' AS DateTime2), NULL, 0)
INSERT [dbo].[RoadmapModules] ([Id], [CourseId], [Title], [Description], [SortOrder], [EstimatedMinutes], [RequiresPreviousModuleCompletion], [IsLockedByDefault], [IsPublished], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (10, 6, N'State Management', N'Quản lý state ở cấp ứng dụng.', 10, 100, 1, 0, 1, CAST(N'2026-07-09T16:49:21.3802813' AS DateTime2), NULL, 0)
INSERT [dbo].[RoadmapModules] ([Id], [CourseId], [Title], [Description], [SortOrder], [EstimatedMinutes], [RequiresPreviousModuleCompletion], [IsLockedByDefault], [IsPublished], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (11, 6, N'Dự án thực tế', N'Hoàn thiện mini project và triển khai.', 11, 180, 1, 0, 1, CAST(N'2026-07-09T16:49:21.3850838' AS DateTime2), NULL, 0)
SET IDENTITY_INSERT [dbo].[RoadmapModules] OFF
GO
INSERT [dbo].[RolePermissionGroups] ([RoleId], [PermissionGroupId], [AssignedAt], [AssignedBy]) VALUES (1, 5, CAST(N'2026-07-09T06:25:35.8270655' AS DateTime2), NULL)
INSERT [dbo].[RolePermissionGroups] ([RoleId], [PermissionGroupId], [AssignedAt], [AssignedBy]) VALUES (2, 3, CAST(N'2026-07-09T06:25:35.8282668' AS DateTime2), NULL)
INSERT [dbo].[RolePermissionGroups] ([RoleId], [PermissionGroupId], [AssignedAt], [AssignedBy]) VALUES (3, 1, CAST(N'2026-07-09T06:25:35.8149525' AS DateTime2), NULL)
GO
INSERT [dbo].[RolePermissions] ([RoleId], [PermissionId]) VALUES (2, 9)
INSERT [dbo].[RolePermissions] ([RoleId], [PermissionId]) VALUES (2, 12)
INSERT [dbo].[RolePermissions] ([RoleId], [PermissionId]) VALUES (2, 13)
INSERT [dbo].[RolePermissions] ([RoleId], [PermissionId]) VALUES (3, 1)
INSERT [dbo].[RolePermissions] ([RoleId], [PermissionId]) VALUES (3, 2)
INSERT [dbo].[RolePermissions] ([RoleId], [PermissionId]) VALUES (3, 3)
INSERT [dbo].[RolePermissions] ([RoleId], [PermissionId]) VALUES (3, 4)
INSERT [dbo].[RolePermissions] ([RoleId], [PermissionId]) VALUES (3, 5)
INSERT [dbo].[RolePermissions] ([RoleId], [PermissionId]) VALUES (3, 6)
INSERT [dbo].[RolePermissions] ([RoleId], [PermissionId]) VALUES (3, 7)
INSERT [dbo].[RolePermissions] ([RoleId], [PermissionId]) VALUES (3, 8)
INSERT [dbo].[RolePermissions] ([RoleId], [PermissionId]) VALUES (3, 9)
INSERT [dbo].[RolePermissions] ([RoleId], [PermissionId]) VALUES (3, 10)
INSERT [dbo].[RolePermissions] ([RoleId], [PermissionId]) VALUES (3, 11)
INSERT [dbo].[RolePermissions] ([RoleId], [PermissionId]) VALUES (3, 12)
INSERT [dbo].[RolePermissions] ([RoleId], [PermissionId]) VALUES (3, 13)
INSERT [dbo].[RolePermissions] ([RoleId], [PermissionId]) VALUES (3, 14)
INSERT [dbo].[RolePermissions] ([RoleId], [PermissionId]) VALUES (3, 15)
INSERT [dbo].[RolePermissions] ([RoleId], [PermissionId]) VALUES (3, 16)
INSERT [dbo].[RolePermissions] ([RoleId], [PermissionId]) VALUES (3, 17)
INSERT [dbo].[RolePermissions] ([RoleId], [PermissionId]) VALUES (3, 18)
INSERT [dbo].[RolePermissions] ([RoleId], [PermissionId]) VALUES (3, 19)
GO
SET IDENTITY_INSERT [dbo].[Roles] ON 

INSERT [dbo].[Roles] ([Id], [Name], [NormalizedName], [Description], [IsSystemRole], [CreatedAt]) VALUES (1, N'User', N'USER', N'Người dùng hệ thống', 1, CAST(N'2026-06-09T15:57:52.1169965' AS DateTime2))
INSERT [dbo].[Roles] ([Id], [Name], [NormalizedName], [Description], [IsSystemRole], [CreatedAt]) VALUES (2, N'Moderator', N'MODERATOR', N'Người kiểm duyệt nội dung', 1, CAST(N'2026-06-09T15:57:52.1169965' AS DateTime2))
INSERT [dbo].[Roles] ([Id], [Name], [NormalizedName], [Description], [IsSystemRole], [CreatedAt]) VALUES (3, N'Admin', N'ADMIN', N'Quản trị viên hệ thống', 1, CAST(N'2026-06-09T15:57:52.1169965' AS DateTime2))
SET IDENTITY_INSERT [dbo].[Roles] OFF
GO
SET IDENTITY_INSERT [dbo].[Tags] ON 

INSERT [dbo].[Tags] ([Id], [Name], [Slug], [Description], [CreatedAt]) VALUES (1, N'DevOps', N'devops', NULL, CAST(N'2026-06-18T16:14:11.5062659' AS DateTime2))
INSERT [dbo].[Tags] ([Id], [Name], [Slug], [Description], [CreatedAt]) VALUES (2, N'Angular', N'angular', NULL, CAST(N'2026-07-10T02:00:31.5225587' AS DateTime2))
SET IDENTITY_INSERT [dbo].[Tags] OFF
GO
INSERT [dbo].[UserLearningProfiles] ([UserId], [CurrentLevel], [TargetRole], [PreferredLanguage], [DailyGoalMinutes], [UpdatedAt]) VALUES (1, 1, NULL, NULL, 30, CAST(N'2026-06-09T16:07:05.5860693' AS DateTime2))
INSERT [dbo].[UserLearningProfiles] ([UserId], [CurrentLevel], [TargetRole], [PreferredLanguage], [DailyGoalMinutes], [UpdatedAt]) VALUES (2, 1, NULL, NULL, 30, CAST(N'2026-06-10T17:10:23.2510038' AS DateTime2))
INSERT [dbo].[UserLearningProfiles] ([UserId], [CurrentLevel], [TargetRole], [PreferredLanguage], [DailyGoalMinutes], [UpdatedAt]) VALUES (3, 1, NULL, NULL, 30, CAST(N'2026-06-10T17:18:14.4103496' AS DateTime2))
INSERT [dbo].[UserLearningProfiles] ([UserId], [CurrentLevel], [TargetRole], [PreferredLanguage], [DailyGoalMinutes], [UpdatedAt]) VALUES (4, 1, NULL, NULL, 30, CAST(N'2026-06-10T18:39:04.7967812' AS DateTime2))
INSERT [dbo].[UserLearningProfiles] ([UserId], [CurrentLevel], [TargetRole], [PreferredLanguage], [DailyGoalMinutes], [UpdatedAt]) VALUES (5, 1, NULL, NULL, 30, CAST(N'2026-06-17T10:09:21.4884846' AS DateTime2))
INSERT [dbo].[UserLearningProfiles] ([UserId], [CurrentLevel], [TargetRole], [PreferredLanguage], [DailyGoalMinutes], [UpdatedAt]) VALUES (6, 1, NULL, NULL, 30, CAST(N'2026-06-18T15:03:47.1860213' AS DateTime2))
INSERT [dbo].[UserLearningProfiles] ([UserId], [CurrentLevel], [TargetRole], [PreferredLanguage], [DailyGoalMinutes], [UpdatedAt]) VALUES (7, 1, NULL, NULL, 30, CAST(N'2026-06-18T15:44:51.6593364' AS DateTime2))
INSERT [dbo].[UserLearningProfiles] ([UserId], [CurrentLevel], [TargetRole], [PreferredLanguage], [DailyGoalMinutes], [UpdatedAt]) VALUES (8, 1, NULL, NULL, 30, CAST(N'2026-06-22T09:47:11.0095026' AS DateTime2))
INSERT [dbo].[UserLearningProfiles] ([UserId], [CurrentLevel], [TargetRole], [PreferredLanguage], [DailyGoalMinutes], [UpdatedAt]) VALUES (9, 1, NULL, NULL, 30, CAST(N'2026-07-08T09:42:23.9387870' AS DateTime2))
INSERT [dbo].[UserLearningProfiles] ([UserId], [CurrentLevel], [TargetRole], [PreferredLanguage], [DailyGoalMinutes], [UpdatedAt]) VALUES (10, 1, NULL, NULL, 30, CAST(N'2026-07-08T09:43:55.8573645' AS DateTime2))
INSERT [dbo].[UserLearningProfiles] ([UserId], [CurrentLevel], [TargetRole], [PreferredLanguage], [DailyGoalMinutes], [UpdatedAt]) VALUES (11, 1, NULL, NULL, 30, CAST(N'2026-07-09T01:09:28.5750618' AS DateTime2))
INSERT [dbo].[UserLearningProfiles] ([UserId], [CurrentLevel], [TargetRole], [PreferredLanguage], [DailyGoalMinutes], [UpdatedAt]) VALUES (12, 1, NULL, NULL, 30, CAST(N'2026-07-09T01:10:11.8868414' AS DateTime2))
INSERT [dbo].[UserLearningProfiles] ([UserId], [CurrentLevel], [TargetRole], [PreferredLanguage], [DailyGoalMinutes], [UpdatedAt]) VALUES (13, 1, NULL, NULL, 30, CAST(N'2026-07-09T08:55:53.7777239' AS DateTime2))
INSERT [dbo].[UserLearningProfiles] ([UserId], [CurrentLevel], [TargetRole], [PreferredLanguage], [DailyGoalMinutes], [UpdatedAt]) VALUES (14, 1, NULL, NULL, 30, CAST(N'2026-07-10T01:42:49.7094655' AS DateTime2))
INSERT [dbo].[UserLearningProfiles] ([UserId], [CurrentLevel], [TargetRole], [PreferredLanguage], [DailyGoalMinutes], [UpdatedAt]) VALUES (15, 1, NULL, NULL, 30, CAST(N'2026-07-10T01:44:48.3184673' AS DateTime2))
GO
SET IDENTITY_INSERT [dbo].[UserLessonProgresses] ON 

INSERT [dbo].[UserLessonProgresses] ([Id], [UserId], [LessonId], [Status], [StartedAt], [CompletedAt], [LastAccessedAt]) VALUES (1, 6, 1, N'InProgress', CAST(N'2026-07-09T16:49:51.2100086' AS DateTime2), NULL, CAST(N'2026-07-09T17:25:22.4786767' AS DateTime2))
INSERT [dbo].[UserLessonProgresses] ([Id], [UserId], [LessonId], [Status], [StartedAt], [CompletedAt], [LastAccessedAt]) VALUES (2, 14, 1, N'Completed', CAST(N'2026-07-10T01:47:23.6371324' AS DateTime2), CAST(N'2026-07-10T01:47:40.0232467' AS DateTime2), CAST(N'2026-07-10T01:50:25.4870467' AS DateTime2))
INSERT [dbo].[UserLessonProgresses] ([Id], [UserId], [LessonId], [Status], [StartedAt], [CompletedAt], [LastAccessedAt]) VALUES (3, 15, 1, N'Completed', CAST(N'2026-07-10T02:35:30.4626181' AS DateTime2), CAST(N'2026-07-10T02:35:33.4324191' AS DateTime2), CAST(N'2026-07-10T02:35:55.3047209' AS DateTime2))
INSERT [dbo].[UserLessonProgresses] ([Id], [UserId], [LessonId], [Status], [StartedAt], [CompletedAt], [LastAccessedAt]) VALUES (4, 15, 2, N'Completed', CAST(N'2026-07-10T02:35:40.0502592' AS DateTime2), CAST(N'2026-07-10T02:35:42.9411748' AS DateTime2), CAST(N'2026-07-10T02:35:42.9411752' AS DateTime2))
SET IDENTITY_INSERT [dbo].[UserLessonProgresses] OFF
GO
INSERT [dbo].[UserPermissionGroups] ([UserId], [PermissionGroupId], [AssignedAt], [AssignedBy]) VALUES (14, 1, CAST(N'2026-07-10T02:28:56.1974302' AS DateTime2), 2)
GO
INSERT [dbo].[UserPermissions] ([UserId], [PermissionId], [AssignedAt], [AssignedBy]) VALUES (14, 11, CAST(N'2026-07-10T02:26:32.6697102' AS DateTime2), 2)
INSERT [dbo].[UserPermissions] ([UserId], [PermissionId], [AssignedAt], [AssignedBy]) VALUES (15, 11, CAST(N'2026-07-10T03:11:25.4458008' AS DateTime2), 2)
INSERT [dbo].[UserPermissions] ([UserId], [PermissionId], [AssignedAt], [AssignedBy]) VALUES (15, 18, CAST(N'2026-07-10T03:11:25.4455071' AS DateTime2), 2)
INSERT [dbo].[UserPermissions] ([UserId], [PermissionId], [AssignedAt], [AssignedBy]) VALUES (15, 19, CAST(N'2026-07-10T03:11:25.4456418' AS DateTime2), 2)
GO
INSERT [dbo].[UserProfiles] ([UserId], [FullName], [AvatarUrl], [Headline], [Bio], [Location], [WebsiteUrl], [GitHubUrl], [LinkedInUrl], [Education], [Company], [UpdatedAt]) VALUES (1, N'Nguyen Van A', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(N'2026-06-09T16:07:05.5615102' AS DateTime2))
INSERT [dbo].[UserProfiles] ([UserId], [FullName], [AvatarUrl], [Headline], [Bio], [Location], [WebsiteUrl], [GitHubUrl], [LinkedInUrl], [Education], [Company], [UpdatedAt]) VALUES (2, N'System Admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(N'2026-06-10T17:10:23.2339842' AS DateTime2))
INSERT [dbo].[UserProfiles] ([UserId], [FullName], [AvatarUrl], [Headline], [Bio], [Location], [WebsiteUrl], [GitHubUrl], [LinkedInUrl], [Education], [Company], [UpdatedAt]) VALUES (3, N'Nhân Chứng', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(N'2026-06-10T17:18:14.4102828' AS DateTime2))
INSERT [dbo].[UserProfiles] ([UserId], [FullName], [AvatarUrl], [Headline], [Bio], [Location], [WebsiteUrl], [GitHubUrl], [LinkedInUrl], [Education], [Company], [UpdatedAt]) VALUES (4, N'Nhan Chung', NULL, N'yahu', N'hello', NULL, NULL, NULL, NULL, NULL, NULL, CAST(N'2026-06-18T14:15:58.4163621' AS DateTime2))
INSERT [dbo].[UserProfiles] ([UserId], [FullName], [AvatarUrl], [Headline], [Bio], [Location], [WebsiteUrl], [GitHubUrl], [LinkedInUrl], [Education], [Company], [UpdatedAt]) VALUES (5, N'a b', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(N'2026-06-17T10:09:21.4683338' AS DateTime2))
INSERT [dbo].[UserProfiles] ([UserId], [FullName], [AvatarUrl], [Headline], [Bio], [Location], [WebsiteUrl], [GitHubUrl], [LinkedInUrl], [Education], [Company], [UpdatedAt]) VALUES (6, N'ro se', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(N'2026-06-18T15:03:47.1848558' AS DateTime2))
INSERT [dbo].[UserProfiles] ([UserId], [FullName], [AvatarUrl], [Headline], [Bio], [Location], [WebsiteUrl], [GitHubUrl], [LinkedInUrl], [Education], [Company], [UpdatedAt]) VALUES (7, N'Forum Moderator', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(N'2026-06-18T15:44:51.6453216' AS DateTime2))
INSERT [dbo].[UserProfiles] ([UserId], [FullName], [AvatarUrl], [Headline], [Bio], [Location], [WebsiteUrl], [GitHubUrl], [LinkedInUrl], [Education], [Company], [UpdatedAt]) VALUES (8, N'test test', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(N'2026-06-22T09:47:11.0086185' AS DateTime2))
INSERT [dbo].[UserProfiles] ([UserId], [FullName], [AvatarUrl], [Headline], [Bio], [Location], [WebsiteUrl], [GitHubUrl], [LinkedInUrl], [Education], [Company], [UpdatedAt]) VALUES (9, N'hom nay', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(N'2026-07-08T09:42:23.9068061' AS DateTime2))
INSERT [dbo].[UserProfiles] ([UserId], [FullName], [AvatarUrl], [Headline], [Bio], [Location], [WebsiteUrl], [GitHubUrl], [LinkedInUrl], [Education], [Company], [UpdatedAt]) VALUES (10, N'hom nay', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(N'2026-07-08T09:43:55.8572190' AS DateTime2))
INSERT [dbo].[UserProfiles] ([UserId], [FullName], [AvatarUrl], [Headline], [Bio], [Location], [WebsiteUrl], [GitHubUrl], [LinkedInUrl], [Education], [Company], [UpdatedAt]) VALUES (11, N'string', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(N'2026-07-09T01:09:28.5497904' AS DateTime2))
INSERT [dbo].[UserProfiles] ([UserId], [FullName], [AvatarUrl], [Headline], [Bio], [Location], [WebsiteUrl], [GitHubUrl], [LinkedInUrl], [Education], [Company], [UpdatedAt]) VALUES (12, N'string', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(N'2026-07-09T01:10:11.8867721' AS DateTime2))
INSERT [dbo].[UserProfiles] ([UserId], [FullName], [AvatarUrl], [Headline], [Bio], [Location], [WebsiteUrl], [GitHubUrl], [LinkedInUrl], [Education], [Company], [UpdatedAt]) VALUES (13, N'a ba', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(N'2026-07-09T08:55:53.7535782' AS DateTime2))
INSERT [dbo].[UserProfiles] ([UserId], [FullName], [AvatarUrl], [Headline], [Bio], [Location], [WebsiteUrl], [GitHubUrl], [LinkedInUrl], [Education], [Company], [UpdatedAt]) VALUES (14, N'Trần A', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(N'2026-07-10T01:42:49.6856324' AS DateTime2))
INSERT [dbo].[UserProfiles] ([UserId], [FullName], [AvatarUrl], [Headline], [Bio], [Location], [WebsiteUrl], [GitHubUrl], [LinkedInUrl], [Education], [Company], [UpdatedAt]) VALUES (15, N'ba  B', NULL, N'chào', N'trân trọng xin chào', NULL, NULL, NULL, NULL, NULL, NULL, CAST(N'2026-07-10T02:36:34.1274907' AS DateTime2))
GO
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt], [AssignedBy]) VALUES (1, 1, CAST(N'2026-06-09T16:07:05.5313455' AS DateTime2), NULL)
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt], [AssignedBy]) VALUES (2, 3, CAST(N'2026-06-10T17:10:23.3497774' AS DateTime2), NULL)
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt], [AssignedBy]) VALUES (3, 1, CAST(N'2026-06-10T17:18:14.4099639' AS DateTime2), NULL)
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt], [AssignedBy]) VALUES (4, 1, CAST(N'2026-06-10T18:39:04.7292152' AS DateTime2), NULL)
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt], [AssignedBy]) VALUES (5, 1, CAST(N'2026-06-17T10:09:21.4668169' AS DateTime2), NULL)
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt], [AssignedBy]) VALUES (6, 1, CAST(N'2026-06-18T15:03:47.1838127' AS DateTime2), NULL)
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt], [AssignedBy]) VALUES (7, 2, CAST(N'2026-06-18T15:44:51.7428008' AS DateTime2), NULL)
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt], [AssignedBy]) VALUES (8, 1, CAST(N'2026-06-22T09:47:11.0068760' AS DateTime2), NULL)
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt], [AssignedBy]) VALUES (9, 1, CAST(N'2026-07-08T09:42:23.8652107' AS DateTime2), NULL)
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt], [AssignedBy]) VALUES (10, 1, CAST(N'2026-07-08T09:43:55.8563477' AS DateTime2), NULL)
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt], [AssignedBy]) VALUES (11, 1, CAST(N'2026-07-09T01:09:28.5176376' AS DateTime2), NULL)
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt], [AssignedBy]) VALUES (12, 1, CAST(N'2026-07-09T01:10:11.8864538' AS DateTime2), NULL)
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt], [AssignedBy]) VALUES (13, 1, CAST(N'2026-07-09T08:55:53.7520020' AS DateTime2), NULL)
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt], [AssignedBy]) VALUES (14, 1, CAST(N'2026-07-10T01:42:49.6706188' AS DateTime2), NULL)
INSERT [dbo].[UserRoles] ([UserId], [RoleId], [AssignedAt], [AssignedBy]) VALUES (15, 1, CAST(N'2026-07-10T01:44:48.3181266' AS DateTime2), NULL)
GO
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (1, N'Nguyen Van A', N'user1', N'user1@example.com', N'$2a$11$4setLkxF29cQAeId7tNLTeF5lVDCvtYCkITs802.x1OluCCob18Ru', NULL, 1, 0, NULL, 0, NULL, 0, NULL, CAST(N'2026-06-09T16:07:05.1792856' AS DateTime2), CAST(N'2026-07-10T02:23:19.7016634' AS DateTime2), 0, NULL)
INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (2, N'System Admin', N'admin', N'admin@example.com', N'$2a$11$0hN6Ms9BpTGKJWkr/iJ3heMRkKdga5m3KAmiU6yTFptnWMHVUydqW', NULL, 1, 1, NULL, 0, CAST(N'2026-07-10T03:10:55.6286576' AS DateTime2), 0, NULL, CAST(N'2026-06-10T17:10:23.1037780' AS DateTime2), CAST(N'2026-07-10T02:23:21.3156958' AS DateTime2), 0, NULL)
INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (3, N'Nhân Chứng', N'nhanchung', N'nhanchung@gmail.com', N'$2a$11$XKdJn8GLSQBSvU5Rq33ZIO6HkAzIH3cSKsfmoxN9ohaljU8xXxDuS', NULL, 1, 0, NULL, 0, CAST(N'2026-06-18T14:53:54.1361372' AS DateTime2), 0, NULL, CAST(N'2026-06-10T17:18:14.3842977' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (4, N'Nhan Chung', N'nhanchung1', N'nhanchung1@gmail.com', N'$2a$11$4apVVk2JJbvnmiwn.OiD4.3GxpvAIdnGpHFVKqdvTsD0hGlO5rSG2', NULL, 1, 0, NULL, 0, CAST(N'2026-06-18T15:02:52.5375674' AS DateTime2), 0, NULL, CAST(N'2026-06-10T18:39:04.5376693' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (5, N'a b', N'abs', N'abs@gmail.com', N'$2a$11$FmdPS6AJbd2HTDZVtai9A.p3UcliA0qHbZNUB91NF9C.qlkuSpKqm', NULL, 1, 0, NULL, 0, CAST(N'2026-06-19T07:02:35.4755614' AS DateTime2), 0, NULL, CAST(N'2026-06-17T10:09:21.4402387' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (6, N'ro se', N'rose', N'rose@gmail.com', N'$2a$11$pF/wSXvI2Ty6D5INk5LyHO6Hca1B7YncSDBDEt493..lVFlzMnf0m', NULL, 1, 0, NULL, 0, CAST(N'2026-07-09T16:58:56.4223780' AS DateTime2), 0, NULL, CAST(N'2026-06-18T15:03:47.1580116' AS DateTime2), CAST(N'2026-07-10T02:23:16.5971487' AS DateTime2), 0, NULL)
INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (7, N'Forum Moderator', N'moderator', N'moderator@example.com', N'$2a$11$zTGBsnHQortEoVwRDJ2sgu8mllphTI//p/HGUhCam46Oh50wD.0E2', NULL, 1, 1, NULL, 0, CAST(N'2026-07-09T17:20:53.1811921' AS DateTime2), 0, NULL, CAST(N'2026-06-18T15:44:51.6205988' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (8, N'test test', N'test1', N'test1@gmail.com', N'$2a$11$KZmVEhrtJK.G2/92QF2DPO8EtH7cNR1toiY1/p2dJLaK1VXJoaiqG', NULL, 1, 0, NULL, 0, CAST(N'2026-06-22T09:47:20.6744531' AS DateTime2), 0, NULL, CAST(N'2026-06-22T09:47:10.9744133' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (9, N'hom nay', N'homnay', N'homnay@gmail.com', N'$2a$11$xvtDZIrLxG9WxwpFP9p/GeWvGb0Z3GqYsV7FHwM9BLjA0GCR6pq8C', NULL, 1, 0, NULL, 0, NULL, 0, NULL, CAST(N'2026-07-08T09:42:23.6729134' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (10, N'hom nay', N'homnay1', N'homnay1@gmail.com', N'$2a$11$3zJuBucxSyUygZJG9826XOxC7TjFEWqWJ0oDNEquOXlsXuucEb34.', NULL, 1, 0, NULL, 0, NULL, 0, NULL, CAST(N'2026-07-08T09:43:55.8434780' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (11, N'string', N'string', N'string@g.com', N'$2a$11$mGPTet./Yo7vxqF0k9nlAO2yLfRgRcMC1X5EkipZP3In6y9z4sYe6', NULL, 1, 0, NULL, 0, NULL, 0, NULL, CAST(N'2026-07-09T01:09:28.3598732' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (12, N'string', N'string1', N'stringg.com', N'$2a$11$53W6Kn.x9W1qjy5euotTqeEkSdgywQFNWrUgIYKrJ3exgTPNvLT9K', NULL, 1, 0, NULL, 0, NULL, 0, NULL, CAST(N'2026-07-09T01:10:11.8799576' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (13, N'a ba', N'adminex', N'a', N'$2a$11$xI3WoLCynnm8c61Q/9sbnOciHJDGdGTqUTmiPNJ9u0U8pLh.u3ppm', NULL, 1, 0, NULL, 0, NULL, 0, NULL, CAST(N'2026-07-09T08:55:53.7196125' AS DateTime2), CAST(N'2026-07-10T02:23:08.0197796' AS DateTime2), 0, NULL)
INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (14, N'Trần A', N'tran', N'nguyenthuyvi2k5@', N'$2a$11$gNb8m/KrLu0zkiy6HIk3ieQFGcNP4JEZGNUQsPiEDrtsaT2OZLFq6', NULL, 1, 0, NULL, 0, CAST(N'2026-07-10T03:09:45.0464420' AS DateTime2), 0, NULL, CAST(N'2026-07-10T01:42:49.5324848' AS DateTime2), CAST(N'2026-07-10T02:26:32.6775241' AS DateTime2), 0, NULL)
INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (15, N'ba  B', N'baB', N'bab@gmail.com', N'$2a$11$xIo.1rCtBkNaIHR1oKQ/3uU1vDDP7TLGMQlS/k8dvBgObBa30GZnu', NULL, 1, 0, NULL, 0, CAST(N'2026-07-10T03:11:55.3509430' AS DateTime2), 0, NULL, CAST(N'2026-07-10T01:44:48.3130478' AS DateTime2), CAST(N'2026-07-10T03:11:25.4458464' AS DateTime2), 0, NULL)
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
INSERT [dbo].[UserSettings] ([UserId], [Theme], [Language], [CodeEditorTheme], [CodeEditorFontSize], [EnableEmailNotification], [EnablePushNotification], [HasCompletedOnboarding], [UpdatedAt]) VALUES (1, N'light', N'vi', N'dark', 14, 1, 1, 0, CAST(N'2026-06-09T16:07:05.6218274' AS DateTime2))
INSERT [dbo].[UserSettings] ([UserId], [Theme], [Language], [CodeEditorTheme], [CodeEditorFontSize], [EnableEmailNotification], [EnablePushNotification], [HasCompletedOnboarding], [UpdatedAt]) VALUES (2, N'light', N'vi', N'dark', 14, 1, 1, 0, CAST(N'2026-06-10T17:10:23.2722565' AS DateTime2))
INSERT [dbo].[UserSettings] ([UserId], [Theme], [Language], [CodeEditorTheme], [CodeEditorFontSize], [EnableEmailNotification], [EnablePushNotification], [HasCompletedOnboarding], [UpdatedAt]) VALUES (3, N'light', N'vi', N'dark', 14, 1, 1, 0, CAST(N'2026-06-10T17:18:14.4104038' AS DateTime2))
INSERT [dbo].[UserSettings] ([UserId], [Theme], [Language], [CodeEditorTheme], [CodeEditorFontSize], [EnableEmailNotification], [EnablePushNotification], [HasCompletedOnboarding], [UpdatedAt]) VALUES (4, N'light', N'vi', N'dark', 14, 1, 1, 0, CAST(N'2026-06-10T18:39:04.8332260' AS DateTime2))
INSERT [dbo].[UserSettings] ([UserId], [Theme], [Language], [CodeEditorTheme], [CodeEditorFontSize], [EnableEmailNotification], [EnablePushNotification], [HasCompletedOnboarding], [UpdatedAt]) VALUES (5, N'light', N'vi', N'dark', 14, 1, 1, 0, CAST(N'2026-06-17T10:09:21.4993564' AS DateTime2))
INSERT [dbo].[UserSettings] ([UserId], [Theme], [Language], [CodeEditorTheme], [CodeEditorFontSize], [EnableEmailNotification], [EnablePushNotification], [HasCompletedOnboarding], [UpdatedAt]) VALUES (6, N'light', N'vi', N'dark', 14, 1, 1, 0, CAST(N'2026-06-18T15:03:47.1984770' AS DateTime2))
INSERT [dbo].[UserSettings] ([UserId], [Theme], [Language], [CodeEditorTheme], [CodeEditorFontSize], [EnableEmailNotification], [EnablePushNotification], [HasCompletedOnboarding], [UpdatedAt]) VALUES (7, N'light', N'vi', N'dark', 14, 1, 1, 0, CAST(N'2026-06-18T15:44:51.6804071' AS DateTime2))
INSERT [dbo].[UserSettings] ([UserId], [Theme], [Language], [CodeEditorTheme], [CodeEditorFontSize], [EnableEmailNotification], [EnablePushNotification], [HasCompletedOnboarding], [UpdatedAt]) VALUES (8, N'light', N'vi', N'dark', 14, 1, 1, 0, CAST(N'2026-06-22T09:47:11.0220351' AS DateTime2))
INSERT [dbo].[UserSettings] ([UserId], [Theme], [Language], [CodeEditorTheme], [CodeEditorFontSize], [EnableEmailNotification], [EnablePushNotification], [HasCompletedOnboarding], [UpdatedAt]) VALUES (9, N'light', N'vi', N'dark', 14, 1, 1, 0, CAST(N'2026-07-08T09:42:23.9855160' AS DateTime2))
INSERT [dbo].[UserSettings] ([UserId], [Theme], [Language], [CodeEditorTheme], [CodeEditorFontSize], [EnableEmailNotification], [EnablePushNotification], [HasCompletedOnboarding], [UpdatedAt]) VALUES (10, N'light', N'vi', N'dark', 14, 1, 1, 0, CAST(N'2026-07-08T09:43:55.8574737' AS DateTime2))
INSERT [dbo].[UserSettings] ([UserId], [Theme], [Language], [CodeEditorTheme], [CodeEditorFontSize], [EnableEmailNotification], [EnablePushNotification], [HasCompletedOnboarding], [UpdatedAt]) VALUES (11, N'light', N'vi', N'dark', 14, 1, 1, 0, CAST(N'2026-07-09T01:09:28.6117528' AS DateTime2))
INSERT [dbo].[UserSettings] ([UserId], [Theme], [Language], [CodeEditorTheme], [CodeEditorFontSize], [EnableEmailNotification], [EnablePushNotification], [HasCompletedOnboarding], [UpdatedAt]) VALUES (12, N'light', N'vi', N'dark', 14, 1, 1, 0, CAST(N'2026-07-09T01:10:11.8869317' AS DateTime2))
INSERT [dbo].[UserSettings] ([UserId], [Theme], [Language], [CodeEditorTheme], [CodeEditorFontSize], [EnableEmailNotification], [EnablePushNotification], [HasCompletedOnboarding], [UpdatedAt]) VALUES (13, N'light', N'vi', N'dark', 14, 1, 1, 0, CAST(N'2026-07-09T08:55:53.7905945' AS DateTime2))
INSERT [dbo].[UserSettings] ([UserId], [Theme], [Language], [CodeEditorTheme], [CodeEditorFontSize], [EnableEmailNotification], [EnablePushNotification], [HasCompletedOnboarding], [UpdatedAt]) VALUES (14, N'light', N'vi', N'dark', 14, 1, 1, 0, CAST(N'2026-07-10T01:42:49.7468682' AS DateTime2))
INSERT [dbo].[UserSettings] ([UserId], [Theme], [Language], [CodeEditorTheme], [CodeEditorFontSize], [EnableEmailNotification], [EnablePushNotification], [HasCompletedOnboarding], [UpdatedAt]) VALUES (15, N'light', N'vi', N'dark', 14, 1, 1, 0, CAST(N'2026-07-10T01:44:48.3185599' AS DateTime2))
GO
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (1, 0, 0, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, 0, 0, NULL, CAST(N'2026-06-09T16:07:05.5993548' AS DateTime2))
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (2, 0, 0, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, 0, 0, NULL, CAST(N'2026-06-10T17:10:23.2584871' AS DateTime2))
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (3, 0, 0, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, 0, 0, NULL, CAST(N'2026-06-10T17:18:14.4103768' AS DateTime2))
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (4, 8, 4, CAST(2.86 AS Decimal(5, 2)), 0, 0, 0, 0, 0, 0, CAST(N'2026-06-18T15:00:43.4772304' AS DateTime2), CAST(N'2026-06-18T15:00:43.4772314' AS DateTime2))
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (5, 3, 2, CAST(2.50 AS Decimal(5, 2)), 0, 0, 0, 7, 7, 0, CAST(N'2026-06-19T07:32:27.6083475' AS DateTime2), CAST(N'2026-06-19T07:32:27.6083479' AS DateTime2))
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (6, 3, 2, CAST(0.00 AS Decimal(5, 2)), 3, 1, 1, 10, 22, 0, CAST(N'2026-07-09T17:17:51.3639241' AS DateTime2), CAST(N'2026-07-09T17:17:51.3639254' AS DateTime2))
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (7, 0, 0, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, 0, 0, NULL, CAST(N'2026-06-18T15:44:51.6669314' AS DateTime2))
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (8, 0, 0, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, 0, 0, NULL, CAST(N'2026-06-22T09:47:11.0205162' AS DateTime2))
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (9, 0, 0, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, 0, 0, NULL, CAST(N'2026-07-08T09:42:23.9550389' AS DateTime2))
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (10, 0, 0, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, 0, 0, NULL, CAST(N'2026-07-08T09:43:55.8574193' AS DateTime2))
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (11, 0, 0, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, 0, 0, NULL, CAST(N'2026-07-09T01:09:28.5885468' AS DateTime2))
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (12, 0, 0, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, 0, 0, NULL, CAST(N'2026-07-09T01:10:11.8868862' AS DateTime2))
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (13, 0, 0, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, 0, 0, NULL, CAST(N'2026-07-09T08:55:53.7895590' AS DateTime2))
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (14, 1, 0, CAST(0.00 AS Decimal(5, 2)), 3, 2, 1, 0, 22, 0, CAST(N'2026-07-10T02:00:31.6047379' AS DateTime2), CAST(N'2026-07-10T02:00:31.6047387' AS DateTime2))
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (15, 0, 0, CAST(0.00 AS Decimal(5, 2)), 2, 2, 0, 3, 23, 0, CAST(N'2026-07-10T02:41:20.4521887' AS DateTime2), CAST(N'2026-07-10T02:41:20.4521897' AS DateTime2))
GO
SET IDENTITY_INSERT [dbo].[XpRules] ON 

INSERT [dbo].[XpRules] ([Id], [ActionType], [Points], [Description], [IsActive], [CreatedAt]) VALUES (1, N'CompleteQuiz', 10, N'Hoàn thành một bài quiz', 1, CAST(N'2026-06-09T15:57:52.1821701' AS DateTime2))
INSERT [dbo].[XpRules] ([Id], [ActionType], [Points], [Description], [IsActive], [CreatedAt]) VALUES (2, N'QuizPassed', 15, N'Đạt điểm qua bài quiz', 1, CAST(N'2026-06-09T15:57:52.1821701' AS DateTime2))
INSERT [dbo].[XpRules] ([Id], [ActionType], [Points], [Description], [IsActive], [CreatedAt]) VALUES (3, N'CodeAccepted', 30, N'Bài code được accepted', 1, CAST(N'2026-06-09T15:57:52.1821701' AS DateTime2))
INSERT [dbo].[XpRules] ([Id], [ActionType], [Points], [Description], [IsActive], [CreatedAt]) VALUES (4, N'PostCreated', 5, N'Tạo bài viết forum', 1, CAST(N'2026-06-09T15:57:52.1821701' AS DateTime2))
INSERT [dbo].[XpRules] ([Id], [ActionType], [Points], [Description], [IsActive], [CreatedAt]) VALUES (5, N'CommentAccepted', 20, N'Câu trả lời được chấp nhận', 1, CAST(N'2026-06-09T15:57:52.1821701' AS DateTime2))
INSERT [dbo].[XpRules] ([Id], [ActionType], [Points], [Description], [IsActive], [CreatedAt]) VALUES (6, N'DailyStreak', 10, N'Duy trì streak hằng ngày', 1, CAST(N'2026-06-09T15:57:52.1821701' AS DateTime2))
SET IDENTITY_INSERT [dbo].[XpRules] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_Achievements_Code]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Achievements_Code] ON [dbo].[Achievements]
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_Categories_Slug]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Categories_Slug] ON [dbo].[Categories]
(
	[Slug] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_CodeSubmissions_ProblemId]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_CodeSubmissions_ProblemId] ON [dbo].[CodeSubmissions]
(
	[ProblemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_CodeSubmissions_UserId]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_CodeSubmissions_UserId] ON [dbo].[CodeSubmissions]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_CodeSubmissions_UserId_CreatedAt]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_CodeSubmissions_UserId_CreatedAt] ON [dbo].[CodeSubmissions]
(
	[UserId] ASC,
	[CreatedAt] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_CodeSubmissionTestCaseResults_SubmissionId]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_CodeSubmissionTestCaseResults_SubmissionId] ON [dbo].[CodeSubmissionTestCaseResults]
(
	[SubmissionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_CodeSubmissionTestCaseResults_TestCaseId]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_CodeSubmissionTestCaseResults_TestCaseId] ON [dbo].[CodeSubmissionTestCaseResults]
(
	[TestCaseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_CodingProblems_Difficulty]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_CodingProblems_Difficulty] ON [dbo].[CodingProblems]
(
	[Difficulty] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_CodingProblems_Slug]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_CodingProblems_Slug] ON [dbo].[CodingProblems]
(
	[Slug] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_CodingProblems_Status]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_CodingProblems_Status] ON [dbo].[CodingProblems]
(
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_CodingProblems_Slug]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_CodingProblems_Slug] ON [dbo].[CodingProblems]
(
	[Slug] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UX_CommentVotes_Comment_User]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_CommentVotes_Comment_User] ON [dbo].[CommentVotes]
(
	[CommentId] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_ExternalLogins_Provider_UserId]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_ExternalLogins_Provider_UserId] ON [dbo].[ExternalLogins]
(
	[Provider] ASC,
	[ProviderUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_LearningTracks_IsPublished_IsDeleted_SortOrder]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_LearningTracks_IsPublished_IsDeleted_SortOrder] ON [dbo].[LearningTracks]
(
	[IsPublished] ASC,
	[IsDeleted] ASC,
	[SortOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_LearningTracks_Slug]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_LearningTracks_Slug] ON [dbo].[LearningTracks]
(
	[Slug] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Notifications_CreatedAt]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_Notifications_CreatedAt] ON [dbo].[Notifications]
(
	[CreatedAt] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Notifications_IsRead]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_Notifications_IsRead] ON [dbo].[Notifications]
(
	[IsRead] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Notifications_UserId]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_Notifications_UserId] ON [dbo].[Notifications]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Notifications_UserId_IsRead_CreatedAt]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_Notifications_UserId_IsRead_CreatedAt] ON [dbo].[Notifications]
(
	[UserId] ASC,
	[IsRead] ASC,
	[CreatedAt] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_NotificationTemplates_Code]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_NotificationTemplates_Code] ON [dbo].[NotificationTemplates]
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_PermissionGroupPermissions_PermissionId]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_PermissionGroupPermissions_PermissionId] ON [dbo].[PermissionGroupPermissions]
(
	[PermissionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_PermissionGroups_Code]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_PermissionGroups_Code] ON [dbo].[PermissionGroups]
(
	[Code] ASC
)
WHERE ([Code] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_Permissions_Code]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Permissions_Code] ON [dbo].[Permissions]
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_PersonalPracticeAttemptAnswers_AttemptId]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_PersonalPracticeAttemptAnswers_AttemptId] ON [dbo].[PersonalPracticeAttemptAnswers]
(
	[AttemptId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_PersonalPracticeAttemptAnswers_QuestionId]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_PersonalPracticeAttemptAnswers_QuestionId] ON [dbo].[PersonalPracticeAttemptAnswers]
(
	[QuestionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_PersonalPracticeAttempts_BankId]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_PersonalPracticeAttempts_BankId] ON [dbo].[PersonalPracticeAttempts]
(
	[BankId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_PersonalPracticeAttempts_UserId_BankId]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_PersonalPracticeAttempts_UserId_BankId] ON [dbo].[PersonalPracticeAttempts]
(
	[UserId] ASC,
	[BankId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_PersonalQuestionBanks_UserId_IsDeleted]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_PersonalQuestionBanks_UserId_IsDeleted] ON [dbo].[PersonalQuestionBanks]
(
	[UserId] ASC,
	[IsDeleted] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_PersonalQuestionOptions_QuestionId]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_PersonalQuestionOptions_QuestionId] ON [dbo].[PersonalQuestionOptions]
(
	[QuestionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_PersonalQuestions_BankId]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_PersonalQuestions_BankId] ON [dbo].[PersonalQuestions]
(
	[BankId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_PersonalQuestions_UserId_BankId_IsDeleted]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_PersonalQuestions_UserId_BankId_IsDeleted] ON [dbo].[PersonalQuestions]
(
	[UserId] ASC,
	[BankId] ASC,
	[IsDeleted] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_Posts_Slug]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Posts_Slug] ON [dbo].[Posts]
(
	[Slug] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UX_PostVotes_Post_User]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_PostVotes_Post_User] ON [dbo].[PostVotes]
(
	[PostId] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_ProblemTags_Slug]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_ProblemTags_Slug] ON [dbo].[ProblemTags]
(
	[Slug] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_ProgrammingLanguages_Code]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_ProgrammingLanguages_Code] ON [dbo].[ProgrammingLanguages]
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_QuizSets_Slug]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_QuizSets_Slug] ON [dbo].[QuizSets]
(
	[Slug] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_RoadmapCourses_Slug]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_RoadmapCourses_Slug] ON [dbo].[RoadmapCourses]
(
	[Slug] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_RoadmapCourses_TrackId_IsPublished_IsDeleted_SortOrder]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_RoadmapCourses_TrackId_IsPublished_IsDeleted_SortOrder] ON [dbo].[RoadmapCourses]
(
	[TrackId] ASC,
	[IsPublished] ASC,
	[IsDeleted] ASC,
	[SortOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_RoadmapLessons_CodingProblemId]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_RoadmapLessons_CodingProblemId] ON [dbo].[RoadmapLessons]
(
	[CodingProblemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_RoadmapLessons_ModuleId_IsPublished_IsDeleted_SortOrder]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_RoadmapLessons_ModuleId_IsPublished_IsDeleted_SortOrder] ON [dbo].[RoadmapLessons]
(
	[ModuleId] ASC,
	[IsPublished] ASC,
	[IsDeleted] ASC,
	[SortOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_RoadmapLessons_QuizSetId]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_RoadmapLessons_QuizSetId] ON [dbo].[RoadmapLessons]
(
	[QuizSetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_RoadmapLessons_VideoFileId]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_RoadmapLessons_VideoFileId] ON [dbo].[RoadmapLessons]
(
	[VideoFileId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_RoadmapModules_CourseId_IsPublished_IsDeleted_SortOrder]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_RoadmapModules_CourseId_IsPublished_IsDeleted_SortOrder] ON [dbo].[RoadmapModules]
(
	[CourseId] ASC,
	[IsPublished] ASC,
	[IsDeleted] ASC,
	[SortOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_Roadmaps_Slug]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Roadmaps_Slug] ON [dbo].[Roadmaps]
(
	[Slug] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_RolePermissionGroups_PermissionGroupId]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_RolePermissionGroups_PermissionGroupId] ON [dbo].[RolePermissionGroups]
(
	[PermissionGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_Roles_NormalizedName]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Roles_NormalizedName] ON [dbo].[Roles]
(
	[NormalizedName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_Tags_Slug]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Tags_Slug] ON [dbo].[Tags]
(
	[Slug] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UX_UserDailyActivities_User_Date]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_UserDailyActivities_User_Date] ON [dbo].[UserDailyActivities]
(
	[UserId] ASC,
	[ActivityDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_UserLessonProgresses_Status]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_UserLessonProgresses_Status] ON [dbo].[UserLessonProgresses]
(
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_UserLessonProgresses_UserId_LessonId]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_UserLessonProgresses_UserId_LessonId] ON [dbo].[UserLessonProgresses]
(
	[UserId] ASC,
	[LessonId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_UserPermissionGroups_PermissionGroupId]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_UserPermissionGroups_PermissionGroupId] ON [dbo].[UserPermissionGroups]
(
	[PermissionGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_Users_Email]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Users_Email] ON [dbo].[Users]
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_Users_UserName]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Users_UserName] ON [dbo].[Users]
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UX_UserTopicProgress_User_Category]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_UserTopicProgress_User_Category] ON [dbo].[UserTopicProgress]
(
	[UserId] ASC,
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_XpRules_ActionType]    Script Date: 10/07/2026 10:14:41 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_XpRules_ActionType] ON [dbo].[XpRules]
(
	[ActionType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Achievements] ADD  DEFAULT ((0)) FOR [XpReward]
GO
ALTER TABLE [dbo].[Achievements] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Achievements] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[ApiRequestLogs] ADD  DEFAULT (N'DevLearningHub.Api') FOR [ServiceName]
GO
ALTER TABLE [dbo].[ApiRequestLogs] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[AuditLogs] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Categories] ADD  DEFAULT ((0)) FOR [DisplayOrder]
GO
ALTER TABLE [dbo].[Categories] ADD  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[Categories] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Categories] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[CodeRunHistories] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[CodeSubmissions] ADD  DEFAULT (N'Pending') FOR [Status]
GO
ALTER TABLE [dbo].[CodeSubmissions] ADD  DEFAULT ((0)) FOR [TotalTestCases]
GO
ALTER TABLE [dbo].[CodeSubmissions] ADD  DEFAULT ((0)) FOR [PassedTestCases]
GO
ALTER TABLE [dbo].[CodeSubmissions] ADD  DEFAULT ((0)) FOR [Score]
GO
ALTER TABLE [dbo].[CodeSubmissions] ADD  DEFAULT (sysutcdatetime()) FOR [SubmittedAt]
GO
ALTER TABLE [dbo].[CodeSubmissions] ADD  CONSTRAINT [DF_CodeSubmissions_Language]  DEFAULT (N'python') FOR [Language]
GO
ALTER TABLE [dbo].[CodeSubmissions] ADD  CONSTRAINT [DF_CodeSubmissions_Verdict]  DEFAULT (N'Pending') FOR [Verdict]
GO
ALTER TABLE [dbo].[CodeSubmissions] ADD  CONSTRAINT [DF_CodeSubmissions_IsAccepted]  DEFAULT ((0)) FOR [IsAccepted]
GO
ALTER TABLE [dbo].[CodeSubmissions] ADD  CONSTRAINT [DF_CodeSubmissions_CreatedAt]  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[CodeSubmissionTestCaseResults] ADD  DEFAULT ((1)) FOR [DisplayOrder]
GO
ALTER TABLE [dbo].[CodeSubmissionTestCaseResults] ADD  DEFAULT ('Pending') FOR [Status]
GO
ALTER TABLE [dbo].[CodeSubmissionTestCaseResults] ADD  DEFAULT ((0)) FOR [Passed]
GO
ALTER TABLE [dbo].[CodeSubmissionTestCaseResults] ADD  DEFAULT ((0)) FOR [ExecutionTimeMs]
GO
ALTER TABLE [dbo].[CodingProblems] ADD  DEFAULT ((1)) FOR [Difficulty]
GO
ALTER TABLE [dbo].[CodingProblems] ADD  DEFAULT ((1000)) FOR [TimeLimitMs]
GO
ALTER TABLE [dbo].[CodingProblems] ADD  DEFAULT ((128)) FOR [MemoryLimitMb]
GO
ALTER TABLE [dbo].[CodingProblems] ADD  DEFAULT ((0)) FOR [AcceptanceRate]
GO
ALTER TABLE [dbo].[CodingProblems] ADD  DEFAULT ((0)) FOR [TotalSubmissions]
GO
ALTER TABLE [dbo].[CodingProblems] ADD  DEFAULT ((0)) FOR [AcceptedSubmissions]
GO
ALTER TABLE [dbo].[CodingProblems] ADD  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[CodingProblems] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[CodingProblems] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[CodingProblems] ADD  CONSTRAINT [DF_CodingProblems_MemoryLimitKb]  DEFAULT ((131072)) FOR [MemoryLimitKb]
GO
ALTER TABLE [dbo].[CodingTestCases] ADD  DEFAULT ((0)) FOR [IsHidden]
GO
ALTER TABLE [dbo].[CodingTestCases] ADD  DEFAULT ((1)) FOR [DisplayOrder]
GO
ALTER TABLE [dbo].[CodingTestCases] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Comments] ADD  DEFAULT ((0)) FOR [VoteScore]
GO
ALTER TABLE [dbo].[Comments] ADD  DEFAULT ((0)) FOR [IsAcceptedAnswer]
GO
ALTER TABLE [dbo].[Comments] ADD  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[Comments] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Comments] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[CommentVotes] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[EmailVerificationTokens] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[ExternalLogins] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[FileReferences] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Files] ADD  DEFAULT (N'Local') FOR [StorageProvider]
GO
ALTER TABLE [dbo].[Files] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Files] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Leaderboards] ADD  DEFAULT ((0)) FOR [TotalXp]
GO
ALTER TABLE [dbo].[Leaderboards] ADD  DEFAULT ((1)) FOR [Level]
GO
ALTER TABLE [dbo].[LearningTracks] ADD  CONSTRAINT [DF_LearningTracks_Level]  DEFAULT ('Beginner') FOR [Level]
GO
ALTER TABLE [dbo].[LearningTracks] ADD  CONSTRAINT [DF_LearningTracks_EstimatedHours]  DEFAULT ((0)) FOR [EstimatedHours]
GO
ALTER TABLE [dbo].[LearningTracks] ADD  CONSTRAINT [DF_LearningTracks_SortOrder]  DEFAULT ((0)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[LearningTracks] ADD  CONSTRAINT [DF_LearningTracks_IsPublished]  DEFAULT ((1)) FOR [IsPublished]
GO
ALTER TABLE [dbo].[LearningTracks] ADD  CONSTRAINT [DF_LearningTracks_CreatedAt]  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[LearningTracks] ADD  CONSTRAINT [DF_LearningTracks_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[ModerationActions] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Notifications] ADD  CONSTRAINT [DF_Notifications_NotificationType]  DEFAULT (N'general') FOR [NotificationType]
GO
ALTER TABLE [dbo].[Notifications] ADD  DEFAULT ((0)) FOR [IsRead]
GO
ALTER TABLE [dbo].[Notifications] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Notifications] ADD  CONSTRAINT [DF_Notifications_Type]  DEFAULT (N'system') FOR [Type]
GO
ALTER TABLE [dbo].[Notifications] ADD  CONSTRAINT [DF_Notifications_Message]  DEFAULT (N'') FOR [Message]
GO
ALTER TABLE [dbo].[NotificationTemplates] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[NotificationTemplates] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[PasswordResetTokens] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Permissions] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[PostBookmarks] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Posts] ADD  DEFAULT ((0)) FOR [ViewCount]
GO
ALTER TABLE [dbo].[Posts] ADD  DEFAULT ((0)) FOR [VoteScore]
GO
ALTER TABLE [dbo].[Posts] ADD  DEFAULT ((0)) FOR [AnswerCount]
GO
ALTER TABLE [dbo].[Posts] ADD  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[Posts] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Posts] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[PostVotes] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[ProblemTags] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[ProblemTestCases] ADD  DEFAULT ((0)) FOR [IsHidden]
GO
ALTER TABLE [dbo].[ProblemTestCases] ADD  DEFAULT ((1)) FOR [ScoreWeight]
GO
ALTER TABLE [dbo].[ProblemTestCases] ADD  DEFAULT ((0)) FOR [DisplayOrder]
GO
ALTER TABLE [dbo].[ProblemTestCases] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[ProgrammingLanguages] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[ProgrammingLanguages] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[ProgrammingLanguages] ADD  CONSTRAINT [DF_ProgrammingLanguages_IsCompiled_Compat]  DEFAULT ((0)) FOR [IsCompiled]
GO
ALTER TABLE [dbo].[ProgrammingLanguages] ADD  CONSTRAINT [DF_ProgrammingLanguages_TimeLimitMs_Compat]  DEFAULT ((5000)) FOR [TimeLimitMs]
GO
ALTER TABLE [dbo].[ProgrammingLanguages] ADD  CONSTRAINT [DF_ProgrammingLanguages_MemoryLimitKb_Compat]  DEFAULT ((262144)) FOR [MemoryLimitKb]
GO
ALTER TABLE [dbo].[ProgrammingLanguages] ADD  CONSTRAINT [DF_ProgrammingLanguages_SortOrder_Compat]  DEFAULT ((100)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[QuestionImportBatches] ADD  DEFAULT ((0)) FOR [TotalRows]
GO
ALTER TABLE [dbo].[QuestionImportBatches] ADD  DEFAULT ((0)) FOR [SuccessRows]
GO
ALTER TABLE [dbo].[QuestionImportBatches] ADD  DEFAULT ((0)) FOR [FailedRows]
GO
ALTER TABLE [dbo].[QuestionImportBatches] ADD  DEFAULT (N'Pending') FOR [Status]
GO
ALTER TABLE [dbo].[QuestionImportBatches] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[QuestionOptions] ADD  DEFAULT ((0)) FOR [IsCorrect]
GO
ALTER TABLE [dbo].[QuestionOptions] ADD  DEFAULT ((0)) FOR [DisplayOrder]
GO
ALTER TABLE [dbo].[QuestionOptions] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[QuestionOptions] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Questions] ADD  DEFAULT ((1)) FOR [Difficulty]
GO
ALTER TABLE [dbo].[Questions] ADD  DEFAULT ((1)) FOR [QuestionType]
GO
ALTER TABLE [dbo].[Questions] ADD  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[Questions] ADD  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[Questions] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Questions] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[QuizAttemptAnswers] ADD  DEFAULT ((0)) FOR [IsCorrect]
GO
ALTER TABLE [dbo].[QuizAttemptAnswers] ADD  DEFAULT ((0)) FOR [Score]
GO
ALTER TABLE [dbo].[QuizAttempts] ADD  DEFAULT ((0)) FOR [TotalQuestions]
GO
ALTER TABLE [dbo].[QuizAttempts] ADD  DEFAULT ((0)) FOR [CorrectAnswers]
GO
ALTER TABLE [dbo].[QuizAttempts] ADD  DEFAULT ((0)) FOR [WrongAnswers]
GO
ALTER TABLE [dbo].[QuizAttempts] ADD  DEFAULT ((0)) FOR [SkippedAnswers]
GO
ALTER TABLE [dbo].[QuizAttempts] ADD  DEFAULT ((0)) FOR [Score]
GO
ALTER TABLE [dbo].[QuizAttempts] ADD  DEFAULT ((0)) FOR [IsPassed]
GO
ALTER TABLE [dbo].[QuizAttempts] ADD  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[QuizAttempts] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[QuizSetQuestions] ADD  DEFAULT ((0)) FOR [DisplayOrder]
GO
ALTER TABLE [dbo].[QuizSetQuestions] ADD  DEFAULT ((1)) FOR [Score]
GO
ALTER TABLE [dbo].[QuizSets] ADD  DEFAULT ((1)) FOR [Difficulty]
GO
ALTER TABLE [dbo].[QuizSets] ADD  DEFAULT ((1)) FOR [QuizType]
GO
ALTER TABLE [dbo].[QuizSets] ADD  DEFAULT ((7)) FOR [PassingScore]
GO
ALTER TABLE [dbo].[QuizSets] ADD  DEFAULT ((1)) FOR [AllowReview]
GO
ALTER TABLE [dbo].[QuizSets] ADD  DEFAULT ((0)) FOR [ShuffleQuestions]
GO
ALTER TABLE [dbo].[QuizSets] ADD  DEFAULT ((0)) FOR [ShuffleOptions]
GO
ALTER TABLE [dbo].[QuizSets] ADD  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[QuizSets] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[QuizSets] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[RefreshTokens] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Reports] ADD  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[Reports] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[RoadmapCourses] ADD  CONSTRAINT [DF_RoadmapCourses_Level]  DEFAULT ('Beginner') FOR [Level]
GO
ALTER TABLE [dbo].[RoadmapCourses] ADD  CONSTRAINT [DF_RoadmapCourses_EstimatedHours]  DEFAULT ((0)) FOR [EstimatedHours]
GO
ALTER TABLE [dbo].[RoadmapCourses] ADD  CONSTRAINT [DF_RoadmapCourses_TotalModules]  DEFAULT ((0)) FOR [TotalModules]
GO
ALTER TABLE [dbo].[RoadmapCourses] ADD  CONSTRAINT [DF_RoadmapCourses_TotalLessons]  DEFAULT ((0)) FOR [TotalLessons]
GO
ALTER TABLE [dbo].[RoadmapCourses] ADD  CONSTRAINT [DF_RoadmapCourses_SortOrder]  DEFAULT ((0)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[RoadmapCourses] ADD  CONSTRAINT [DF_RoadmapCourses_IsPublished]  DEFAULT ((1)) FOR [IsPublished]
GO
ALTER TABLE [dbo].[RoadmapCourses] ADD  CONSTRAINT [DF_RoadmapCourses_RequiresSequentialCompletion]  DEFAULT ((1)) FOR [RequiresSequentialCompletion]
GO
ALTER TABLE [dbo].[RoadmapCourses] ADD  CONSTRAINT [DF_RoadmapCourses_CreatedAt]  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[RoadmapCourses] ADD  CONSTRAINT [DF_RoadmapCourses_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[RoadmapItems] ADD  DEFAULT ((0)) FOR [DisplayOrder]
GO
ALTER TABLE [dbo].[RoadmapItems] ADD  DEFAULT ((1)) FOR [IsRequired]
GO
ALTER TABLE [dbo].[RoadmapItems] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[RoadmapItems] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[RoadmapLessons] ADD  CONSTRAINT [DF_RoadmapLessons_Type]  DEFAULT ('Reading') FOR [Type]
GO
ALTER TABLE [dbo].[RoadmapLessons] ADD  CONSTRAINT [DF_RoadmapLessons_EstimatedMinutes]  DEFAULT ((0)) FOR [EstimatedMinutes]
GO
ALTER TABLE [dbo].[RoadmapLessons] ADD  CONSTRAINT [DF_RoadmapLessons_SortOrder]  DEFAULT ((0)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[RoadmapLessons] ADD  CONSTRAINT [DF_RoadmapLessons_IsPreview]  DEFAULT ((0)) FOR [IsPreview]
GO
ALTER TABLE [dbo].[RoadmapLessons] ADD  CONSTRAINT [DF_RoadmapLessons_IsPublished]  DEFAULT ((1)) FOR [IsPublished]
GO
ALTER TABLE [dbo].[RoadmapLessons] ADD  CONSTRAINT [DF_RoadmapLessons_RequiresPrevious]  DEFAULT ((1)) FOR [RequiresPreviousLessonCompletion]
GO
ALTER TABLE [dbo].[RoadmapLessons] ADD  CONSTRAINT [DF_RoadmapLessons_IsRequired]  DEFAULT ((1)) FOR [IsRequired]
GO
ALTER TABLE [dbo].[RoadmapLessons] ADD  CONSTRAINT [DF_RoadmapLessons_CreatedAt]  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[RoadmapLessons] ADD  CONSTRAINT [DF_RoadmapLessons_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[RoadmapModules] ADD  CONSTRAINT [DF_RoadmapModules_SortOrder]  DEFAULT ((0)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[RoadmapModules] ADD  CONSTRAINT [DF_RoadmapModules_EstimatedMinutes]  DEFAULT ((0)) FOR [EstimatedMinutes]
GO
ALTER TABLE [dbo].[RoadmapModules] ADD  CONSTRAINT [DF_RoadmapModules_RequiresPrevious]  DEFAULT ((1)) FOR [RequiresPreviousModuleCompletion]
GO
ALTER TABLE [dbo].[RoadmapModules] ADD  CONSTRAINT [DF_RoadmapModules_IsLockedByDefault]  DEFAULT ((0)) FOR [IsLockedByDefault]
GO
ALTER TABLE [dbo].[RoadmapModules] ADD  CONSTRAINT [DF_RoadmapModules_IsPublished]  DEFAULT ((1)) FOR [IsPublished]
GO
ALTER TABLE [dbo].[RoadmapModules] ADD  CONSTRAINT [DF_RoadmapModules_CreatedAt]  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[RoadmapModules] ADD  CONSTRAINT [DF_RoadmapModules_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Roadmaps] ADD  DEFAULT ((1)) FOR [TargetLevel]
GO
ALTER TABLE [dbo].[Roadmaps] ADD  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[Roadmaps] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Roadmaps] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Roles] ADD  DEFAULT ((0)) FOR [IsSystemRole]
GO
ALTER TABLE [dbo].[Roles] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[SubmissionTestResults] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[SystemEvents] ADD  DEFAULT (N'Pending') FOR [Status]
GO
ALTER TABLE [dbo].[SystemEvents] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Tags] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[UserAchievements] ADD  DEFAULT (sysutcdatetime()) FOR [EarnedAt]
GO
ALTER TABLE [dbo].[UserDailyActivities] ADD  DEFAULT ((0)) FOR [QuizCompletedCount]
GO
ALTER TABLE [dbo].[UserDailyActivities] ADD  DEFAULT ((0)) FOR [CodeSubmissionCount]
GO
ALTER TABLE [dbo].[UserDailyActivities] ADD  DEFAULT ((0)) FOR [AcceptedCodeCount]
GO
ALTER TABLE [dbo].[UserDailyActivities] ADD  DEFAULT ((0)) FOR [PostCreatedCount]
GO
ALTER TABLE [dbo].[UserDailyActivities] ADD  DEFAULT ((0)) FOR [CommentCreatedCount]
GO
ALTER TABLE [dbo].[UserDailyActivities] ADD  DEFAULT ((0)) FOR [StudyMinutes]
GO
ALTER TABLE [dbo].[UserDailyActivities] ADD  DEFAULT ((0)) FOR [XpEarned]
GO
ALTER TABLE [dbo].[UserDailyActivities] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[UserDevices] ADD  DEFAULT ((0)) FOR [IsTrusted]
GO
ALTER TABLE [dbo].[UserDevices] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[UserGamificationProfiles] ADD  DEFAULT ((0)) FOR [TotalXp]
GO
ALTER TABLE [dbo].[UserGamificationProfiles] ADD  DEFAULT ((1)) FOR [Level]
GO
ALTER TABLE [dbo].[UserGamificationProfiles] ADD  DEFAULT ((0)) FOR [CurrentStreakDays]
GO
ALTER TABLE [dbo].[UserGamificationProfiles] ADD  DEFAULT ((0)) FOR [LongestStreakDays]
GO
ALTER TABLE [dbo].[UserLearningProfiles] ADD  DEFAULT ((1)) FOR [CurrentLevel]
GO
ALTER TABLE [dbo].[UserLearningProfiles] ADD  DEFAULT ((30)) FOR [DailyGoalMinutes]
GO
ALTER TABLE [dbo].[UserLessonProgresses] ADD  CONSTRAINT [DF_UserLessonProgresses_Status]  DEFAULT ('NotStarted') FOR [Status]
GO
ALTER TABLE [dbo].[UserNotificationSettings] ADD  DEFAULT ((1)) FOR [ReceiveForumNotification]
GO
ALTER TABLE [dbo].[UserNotificationSettings] ADD  DEFAULT ((1)) FOR [ReceiveQuizNotification]
GO
ALTER TABLE [dbo].[UserNotificationSettings] ADD  DEFAULT ((1)) FOR [ReceiveCodeNotification]
GO
ALTER TABLE [dbo].[UserNotificationSettings] ADD  DEFAULT ((1)) FOR [ReceiveSystemNotification]
GO
ALTER TABLE [dbo].[UserNotificationSettings] ADD  DEFAULT ((1)) FOR [ReceiveXpNotification]
GO
ALTER TABLE [dbo].[UserPermissions] ADD  CONSTRAINT [DF_UserPermissions_AssignedAt]  DEFAULT (sysutcdatetime()) FOR [AssignedAt]
GO
ALTER TABLE [dbo].[UserRoadmapProgress] ADD  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[UserRoles] ADD  DEFAULT (sysutcdatetime()) FOR [AssignedAt]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((0)) FOR [EmailConfirmed]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((0)) FOR [PhoneConfirmed]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((0)) FOR [FailedLoginCount]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[UserSettings] ADD  DEFAULT (N'light') FOR [Theme]
GO
ALTER TABLE [dbo].[UserSettings] ADD  DEFAULT (N'vi') FOR [Language]
GO
ALTER TABLE [dbo].[UserSettings] ADD  DEFAULT (N'dark') FOR [CodeEditorTheme]
GO
ALTER TABLE [dbo].[UserSettings] ADD  DEFAULT ((14)) FOR [CodeEditorFontSize]
GO
ALTER TABLE [dbo].[UserSettings] ADD  DEFAULT ((1)) FOR [EnableEmailNotification]
GO
ALTER TABLE [dbo].[UserSettings] ADD  DEFAULT ((1)) FOR [EnablePushNotification]
GO
ALTER TABLE [dbo].[UserSettings] ADD  DEFAULT ((0)) FOR [HasCompletedOnboarding]
GO
ALTER TABLE [dbo].[UserStats] ADD  DEFAULT ((0)) FOR [TotalQuizAttempts]
GO
ALTER TABLE [dbo].[UserStats] ADD  DEFAULT ((0)) FOR [TotalCorrectAnswers]
GO
ALTER TABLE [dbo].[UserStats] ADD  DEFAULT ((0)) FOR [AverageQuizScore]
GO
ALTER TABLE [dbo].[UserStats] ADD  DEFAULT ((0)) FOR [TotalCodeSubmissions]
GO
ALTER TABLE [dbo].[UserStats] ADD  DEFAULT ((0)) FOR [AcceptedCodeSubmissions]
GO
ALTER TABLE [dbo].[UserStats] ADD  DEFAULT ((0)) FOR [TotalPosts]
GO
ALTER TABLE [dbo].[UserStats] ADD  DEFAULT ((0)) FOR [TotalComments]
GO
ALTER TABLE [dbo].[UserStats] ADD  DEFAULT ((0)) FOR [Reputation]
GO
ALTER TABLE [dbo].[UserStats] ADD  DEFAULT ((0)) FOR [StreakDays]
GO
ALTER TABLE [dbo].[UserTopicProgress] ADD  DEFAULT ((0)) FOR [TotalQuestions]
GO
ALTER TABLE [dbo].[UserTopicProgress] ADD  DEFAULT ((0)) FOR [CompletedQuestions]
GO
ALTER TABLE [dbo].[UserTopicProgress] ADD  DEFAULT ((0)) FOR [CorrectAnswers]
GO
ALTER TABLE [dbo].[UserTopicProgress] ADD  DEFAULT ((0)) FOR [ProgressPercent]
GO
ALTER TABLE [dbo].[XpRules] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[XpRules] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[XpTransactions] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[ApiRequestLogs]  WITH CHECK ADD  CONSTRAINT [FK_ApiRequestLogs_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[ApiRequestLogs] CHECK CONSTRAINT [FK_ApiRequestLogs_Users]
GO
ALTER TABLE [dbo].[AuditLogs]  WITH CHECK ADD  CONSTRAINT [FK_AuditLogs_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[AuditLogs] CHECK CONSTRAINT [FK_AuditLogs_Users]
GO
ALTER TABLE [dbo].[Categories]  WITH CHECK ADD  CONSTRAINT [FK_Categories_Parent] FOREIGN KEY([ParentId])
REFERENCES [dbo].[Categories] ([Id])
GO
ALTER TABLE [dbo].[Categories] CHECK CONSTRAINT [FK_Categories_Parent]
GO
ALTER TABLE [dbo].[CodeRunHistories]  WITH CHECK ADD  CONSTRAINT [FK_CodeRunHistories_Languages] FOREIGN KEY([ProgrammingLanguageId])
REFERENCES [dbo].[ProgrammingLanguages] ([Id])
GO
ALTER TABLE [dbo].[CodeRunHistories] CHECK CONSTRAINT [FK_CodeRunHistories_Languages]
GO
ALTER TABLE [dbo].[CodeRunHistories]  WITH CHECK ADD  CONSTRAINT [FK_CodeRunHistories_Problems] FOREIGN KEY([CodingProblemId])
REFERENCES [dbo].[CodingProblems] ([Id])
GO
ALTER TABLE [dbo].[CodeRunHistories] CHECK CONSTRAINT [FK_CodeRunHistories_Problems]
GO
ALTER TABLE [dbo].[CodeRunHistories]  WITH CHECK ADD  CONSTRAINT [FK_CodeRunHistories_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[CodeRunHistories] CHECK CONSTRAINT [FK_CodeRunHistories_Users]
GO
ALTER TABLE [dbo].[CodeSubmissions]  WITH CHECK ADD  CONSTRAINT [FK_CodeSubmissions_CodingProblems_CodingProblemId] FOREIGN KEY([CodingProblemId])
REFERENCES [dbo].[CodingProblems] ([Id])
GO
ALTER TABLE [dbo].[CodeSubmissions] CHECK CONSTRAINT [FK_CodeSubmissions_CodingProblems_CodingProblemId]
GO
ALTER TABLE [dbo].[CodeSubmissions]  WITH CHECK ADD  CONSTRAINT [FK_CodeSubmissions_CodingProblems_Compat] FOREIGN KEY([ProblemId])
REFERENCES [dbo].[CodingProblems] ([Id])
GO
ALTER TABLE [dbo].[CodeSubmissions] CHECK CONSTRAINT [FK_CodeSubmissions_CodingProblems_Compat]
GO
ALTER TABLE [dbo].[CodeSubmissions]  WITH CHECK ADD  CONSTRAINT [FK_CodeSubmissions_CodingProblems_ProblemId] FOREIGN KEY([ProblemId])
REFERENCES [dbo].[CodingProblems] ([Id])
GO
ALTER TABLE [dbo].[CodeSubmissions] CHECK CONSTRAINT [FK_CodeSubmissions_CodingProblems_ProblemId]
GO
ALTER TABLE [dbo].[CodeSubmissions]  WITH CHECK ADD  CONSTRAINT [FK_CodeSubmissions_ProgrammingLanguages_ProgrammingLanguageId] FOREIGN KEY([ProgrammingLanguageId])
REFERENCES [dbo].[ProgrammingLanguages] ([Id])
GO
ALTER TABLE [dbo].[CodeSubmissions] CHECK CONSTRAINT [FK_CodeSubmissions_ProgrammingLanguages_ProgrammingLanguageId]
GO
ALTER TABLE [dbo].[CodeSubmissions]  WITH CHECK ADD  CONSTRAINT [FK_CodeSubmissions_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[CodeSubmissions] CHECK CONSTRAINT [FK_CodeSubmissions_Users]
GO
ALTER TABLE [dbo].[CodeSubmissions]  WITH CHECK ADD  CONSTRAINT [FK_CodeSubmissions_Users_Compat] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[CodeSubmissions] CHECK CONSTRAINT [FK_CodeSubmissions_Users_Compat]
GO
ALTER TABLE [dbo].[CodeSubmissionTestCaseResults]  WITH CHECK ADD  CONSTRAINT [FK_CodeSubmissionTestCaseResults_CodeSubmissions] FOREIGN KEY([SubmissionId])
REFERENCES [dbo].[CodeSubmissions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CodeSubmissionTestCaseResults] CHECK CONSTRAINT [FK_CodeSubmissionTestCaseResults_CodeSubmissions]
GO
ALTER TABLE [dbo].[CodeSubmissionTestCaseResults]  WITH CHECK ADD  CONSTRAINT [FK_CodeSubmissionTestCaseResults_CodingTestCases] FOREIGN KEY([TestCaseId])
REFERENCES [dbo].[CodingTestCases] ([Id])
GO
ALTER TABLE [dbo].[CodeSubmissionTestCaseResults] CHECK CONSTRAINT [FK_CodeSubmissionTestCaseResults_CodingTestCases]
GO
ALTER TABLE [dbo].[CodeSubmissionTestCaseResults]  WITH CHECK ADD  CONSTRAINT [FK_CSTCR_CodeSubmissions_Compat] FOREIGN KEY([SubmissionId])
REFERENCES [dbo].[CodeSubmissions] ([Id])
GO
ALTER TABLE [dbo].[CodeSubmissionTestCaseResults] CHECK CONSTRAINT [FK_CSTCR_CodeSubmissions_Compat]
GO
ALTER TABLE [dbo].[CodeSubmissionTestCaseResults]  WITH CHECK ADD  CONSTRAINT [FK_CSTCR_CodingTestCases_Compat] FOREIGN KEY([TestCaseId])
REFERENCES [dbo].[CodingTestCases] ([Id])
GO
ALTER TABLE [dbo].[CodeSubmissionTestCaseResults] CHECK CONSTRAINT [FK_CSTCR_CodingTestCases_Compat]
GO
ALTER TABLE [dbo].[CodingProblems]  WITH CHECK ADD  CONSTRAINT [FK_CodingProblems_Categories] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Categories] ([Id])
GO
ALTER TABLE [dbo].[CodingProblems] CHECK CONSTRAINT [FK_CodingProblems_Categories]
GO
ALTER TABLE [dbo].[CodingProblems]  WITH CHECK ADD  CONSTRAINT [FK_CodingProblems_Users] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[CodingProblems] CHECK CONSTRAINT [FK_CodingProblems_Users]
GO
ALTER TABLE [dbo].[CodingProblemTags]  WITH CHECK ADD  CONSTRAINT [FK_CodingProblemTags_Problems] FOREIGN KEY([CodingProblemId])
REFERENCES [dbo].[CodingProblems] ([Id])
GO
ALTER TABLE [dbo].[CodingProblemTags] CHECK CONSTRAINT [FK_CodingProblemTags_Problems]
GO
ALTER TABLE [dbo].[CodingProblemTags]  WITH CHECK ADD  CONSTRAINT [FK_CodingProblemTags_Tags] FOREIGN KEY([ProblemTagId])
REFERENCES [dbo].[ProblemTags] ([Id])
GO
ALTER TABLE [dbo].[CodingProblemTags] CHECK CONSTRAINT [FK_CodingProblemTags_Tags]
GO
ALTER TABLE [dbo].[CodingTestCases]  WITH CHECK ADD  CONSTRAINT [FK_CodingTestCases_CodingProblems] FOREIGN KEY([ProblemId])
REFERENCES [dbo].[CodingProblems] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CodingTestCases] CHECK CONSTRAINT [FK_CodingTestCases_CodingProblems]
GO
ALTER TABLE [dbo].[CodingTestCases]  WITH CHECK ADD  CONSTRAINT [FK_CodingTestCases_CodingProblems_Compat] FOREIGN KEY([ProblemId])
REFERENCES [dbo].[CodingProblems] ([Id])
GO
ALTER TABLE [dbo].[CodingTestCases] CHECK CONSTRAINT [FK_CodingTestCases_CodingProblems_Compat]
GO
ALTER TABLE [dbo].[Comments]  WITH CHECK ADD  CONSTRAINT [FK_Comments_Parent] FOREIGN KEY([ParentCommentId])
REFERENCES [dbo].[Comments] ([Id])
GO
ALTER TABLE [dbo].[Comments] CHECK CONSTRAINT [FK_Comments_Parent]
GO
ALTER TABLE [dbo].[Comments]  WITH CHECK ADD  CONSTRAINT [FK_Comments_Posts] FOREIGN KEY([PostId])
REFERENCES [dbo].[Posts] ([Id])
GO
ALTER TABLE [dbo].[Comments] CHECK CONSTRAINT [FK_Comments_Posts]
GO
ALTER TABLE [dbo].[Comments]  WITH CHECK ADD  CONSTRAINT [FK_Comments_Users] FOREIGN KEY([AuthorId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Comments] CHECK CONSTRAINT [FK_Comments_Users]
GO
ALTER TABLE [dbo].[CommentVotes]  WITH CHECK ADD  CONSTRAINT [FK_CommentVotes_Comments] FOREIGN KEY([CommentId])
REFERENCES [dbo].[Comments] ([Id])
GO
ALTER TABLE [dbo].[CommentVotes] CHECK CONSTRAINT [FK_CommentVotes_Comments]
GO
ALTER TABLE [dbo].[CommentVotes]  WITH CHECK ADD  CONSTRAINT [FK_CommentVotes_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[CommentVotes] CHECK CONSTRAINT [FK_CommentVotes_Users]
GO
ALTER TABLE [dbo].[EmailVerificationTokens]  WITH CHECK ADD  CONSTRAINT [FK_EmailVerificationTokens_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[EmailVerificationTokens] CHECK CONSTRAINT [FK_EmailVerificationTokens_Users]
GO
ALTER TABLE [dbo].[ExternalLogins]  WITH CHECK ADD  CONSTRAINT [FK_ExternalLogins_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[ExternalLogins] CHECK CONSTRAINT [FK_ExternalLogins_Users]
GO
ALTER TABLE [dbo].[FileReferences]  WITH CHECK ADD  CONSTRAINT [FK_FileReferences_Files] FOREIGN KEY([FileId])
REFERENCES [dbo].[Files] ([Id])
GO
ALTER TABLE [dbo].[FileReferences] CHECK CONSTRAINT [FK_FileReferences_Files]
GO
ALTER TABLE [dbo].[Files]  WITH CHECK ADD  CONSTRAINT [FK_Files_Users] FOREIGN KEY([UploadedByUserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Files] CHECK CONSTRAINT [FK_Files_Users]
GO
ALTER TABLE [dbo].[Leaderboards]  WITH CHECK ADD  CONSTRAINT [FK_Leaderboards_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Leaderboards] CHECK CONSTRAINT [FK_Leaderboards_Users]
GO
ALTER TABLE [dbo].[ModerationActions]  WITH CHECK ADD  CONSTRAINT [FK_ModerationActions_Users] FOREIGN KEY([ModeratorId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[ModerationActions] CHECK CONSTRAINT [FK_ModerationActions_Users]
GO
ALTER TABLE [dbo].[Notifications]  WITH CHECK ADD  CONSTRAINT [FK_Notifications_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Notifications] CHECK CONSTRAINT [FK_Notifications_Users]
GO
ALTER TABLE [dbo].[Notifications]  WITH CHECK ADD  CONSTRAINT [FK_Notifications_Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Notifications] CHECK CONSTRAINT [FK_Notifications_Users_UserId]
GO
ALTER TABLE [dbo].[PasswordResetTokens]  WITH CHECK ADD  CONSTRAINT [FK_PasswordResetTokens_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[PasswordResetTokens] CHECK CONSTRAINT [FK_PasswordResetTokens_Users]
GO
ALTER TABLE [dbo].[PermissionGroupPermissions]  WITH CHECK ADD  CONSTRAINT [FK_PermissionGroupPermissions_PermissionGroups_PermissionGroupId] FOREIGN KEY([PermissionGroupId])
REFERENCES [dbo].[PermissionGroups] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PermissionGroupPermissions] CHECK CONSTRAINT [FK_PermissionGroupPermissions_PermissionGroups_PermissionGroupId]
GO
ALTER TABLE [dbo].[PermissionGroupPermissions]  WITH CHECK ADD  CONSTRAINT [FK_PermissionGroupPermissions_Permissions_PermissionId] FOREIGN KEY([PermissionId])
REFERENCES [dbo].[Permissions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PermissionGroupPermissions] CHECK CONSTRAINT [FK_PermissionGroupPermissions_Permissions_PermissionId]
GO
ALTER TABLE [dbo].[PersonalPracticeAttemptAnswers]  WITH CHECK ADD  CONSTRAINT [FK_PersonalPracticeAttemptAnswers_PersonalPracticeAttempts_AttemptId] FOREIGN KEY([AttemptId])
REFERENCES [dbo].[PersonalPracticeAttempts] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PersonalPracticeAttemptAnswers] CHECK CONSTRAINT [FK_PersonalPracticeAttemptAnswers_PersonalPracticeAttempts_AttemptId]
GO
ALTER TABLE [dbo].[PersonalPracticeAttemptAnswers]  WITH CHECK ADD  CONSTRAINT [FK_PersonalPracticeAttemptAnswers_PersonalQuestions_QuestionId] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[PersonalQuestions] ([Id])
GO
ALTER TABLE [dbo].[PersonalPracticeAttemptAnswers] CHECK CONSTRAINT [FK_PersonalPracticeAttemptAnswers_PersonalQuestions_QuestionId]
GO
ALTER TABLE [dbo].[PersonalPracticeAttempts]  WITH CHECK ADD  CONSTRAINT [FK_PersonalPracticeAttempts_PersonalQuestionBanks_BankId] FOREIGN KEY([BankId])
REFERENCES [dbo].[PersonalQuestionBanks] ([Id])
GO
ALTER TABLE [dbo].[PersonalPracticeAttempts] CHECK CONSTRAINT [FK_PersonalPracticeAttempts_PersonalQuestionBanks_BankId]
GO
ALTER TABLE [dbo].[PersonalQuestionBanks]  WITH CHECK ADD  CONSTRAINT [FK_PersonalQuestionBanks_Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[PersonalQuestionBanks] CHECK CONSTRAINT [FK_PersonalQuestionBanks_Users_UserId]
GO
ALTER TABLE [dbo].[PersonalQuestionOptions]  WITH CHECK ADD  CONSTRAINT [FK_PersonalQuestionOptions_PersonalQuestions_QuestionId] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[PersonalQuestions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PersonalQuestionOptions] CHECK CONSTRAINT [FK_PersonalQuestionOptions_PersonalQuestions_QuestionId]
GO
ALTER TABLE [dbo].[PersonalQuestions]  WITH CHECK ADD  CONSTRAINT [FK_PersonalQuestions_PersonalQuestionBanks_BankId] FOREIGN KEY([BankId])
REFERENCES [dbo].[PersonalQuestionBanks] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PersonalQuestions] CHECK CONSTRAINT [FK_PersonalQuestions_PersonalQuestionBanks_BankId]
GO
ALTER TABLE [dbo].[PostBookmarks]  WITH CHECK ADD  CONSTRAINT [FK_PostBookmarks_Posts] FOREIGN KEY([PostId])
REFERENCES [dbo].[Posts] ([Id])
GO
ALTER TABLE [dbo].[PostBookmarks] CHECK CONSTRAINT [FK_PostBookmarks_Posts]
GO
ALTER TABLE [dbo].[PostBookmarks]  WITH CHECK ADD  CONSTRAINT [FK_PostBookmarks_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[PostBookmarks] CHECK CONSTRAINT [FK_PostBookmarks_Users]
GO
ALTER TABLE [dbo].[Posts]  WITH CHECK ADD  CONSTRAINT [FK_Posts_AcceptedComment] FOREIGN KEY([AcceptedCommentId])
REFERENCES [dbo].[Comments] ([Id])
GO
ALTER TABLE [dbo].[Posts] CHECK CONSTRAINT [FK_Posts_AcceptedComment]
GO
ALTER TABLE [dbo].[Posts]  WITH CHECK ADD  CONSTRAINT [FK_Posts_Users] FOREIGN KEY([AuthorId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Posts] CHECK CONSTRAINT [FK_Posts_Users]
GO
ALTER TABLE [dbo].[PostTags]  WITH CHECK ADD  CONSTRAINT [FK_PostTags_Posts] FOREIGN KEY([PostId])
REFERENCES [dbo].[Posts] ([Id])
GO
ALTER TABLE [dbo].[PostTags] CHECK CONSTRAINT [FK_PostTags_Posts]
GO
ALTER TABLE [dbo].[PostTags]  WITH CHECK ADD  CONSTRAINT [FK_PostTags_Tags] FOREIGN KEY([TagId])
REFERENCES [dbo].[Tags] ([Id])
GO
ALTER TABLE [dbo].[PostTags] CHECK CONSTRAINT [FK_PostTags_Tags]
GO
ALTER TABLE [dbo].[PostVotes]  WITH CHECK ADD  CONSTRAINT [FK_PostVotes_Posts] FOREIGN KEY([PostId])
REFERENCES [dbo].[Posts] ([Id])
GO
ALTER TABLE [dbo].[PostVotes] CHECK CONSTRAINT [FK_PostVotes_Posts]
GO
ALTER TABLE [dbo].[PostVotes]  WITH CHECK ADD  CONSTRAINT [FK_PostVotes_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[PostVotes] CHECK CONSTRAINT [FK_PostVotes_Users]
GO
ALTER TABLE [dbo].[ProblemSupportedLanguages]  WITH CHECK ADD  CONSTRAINT [FK_PSL_Languages] FOREIGN KEY([ProgrammingLanguageId])
REFERENCES [dbo].[ProgrammingLanguages] ([Id])
GO
ALTER TABLE [dbo].[ProblemSupportedLanguages] CHECK CONSTRAINT [FK_PSL_Languages]
GO
ALTER TABLE [dbo].[ProblemSupportedLanguages]  WITH CHECK ADD  CONSTRAINT [FK_PSL_Problems] FOREIGN KEY([CodingProblemId])
REFERENCES [dbo].[CodingProblems] ([Id])
GO
ALTER TABLE [dbo].[ProblemSupportedLanguages] CHECK CONSTRAINT [FK_PSL_Problems]
GO
ALTER TABLE [dbo].[ProblemTestCases]  WITH CHECK ADD  CONSTRAINT [FK_ProblemTestCases_Problems] FOREIGN KEY([CodingProblemId])
REFERENCES [dbo].[CodingProblems] ([Id])
GO
ALTER TABLE [dbo].[ProblemTestCases] CHECK CONSTRAINT [FK_ProblemTestCases_Problems]
GO
ALTER TABLE [dbo].[QuestionImportBatches]  WITH CHECK ADD  CONSTRAINT [FK_QuestionImportBatches_Files] FOREIGN KEY([FileId])
REFERENCES [dbo].[Files] ([Id])
GO
ALTER TABLE [dbo].[QuestionImportBatches] CHECK CONSTRAINT [FK_QuestionImportBatches_Files]
GO
ALTER TABLE [dbo].[QuestionImportBatches]  WITH CHECK ADD  CONSTRAINT [FK_QuestionImportBatches_Users] FOREIGN KEY([ImportedByUserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[QuestionImportBatches] CHECK CONSTRAINT [FK_QuestionImportBatches_Users]
GO
ALTER TABLE [dbo].[QuestionOptions]  WITH CHECK ADD  CONSTRAINT [FK_QuestionOptions_Questions] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[Questions] ([Id])
GO
ALTER TABLE [dbo].[QuestionOptions] CHECK CONSTRAINT [FK_QuestionOptions_Questions]
GO
ALTER TABLE [dbo].[Questions]  WITH CHECK ADD  CONSTRAINT [FK_Questions_Categories] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Categories] ([Id])
GO
ALTER TABLE [dbo].[Questions] CHECK CONSTRAINT [FK_Questions_Categories]
GO
ALTER TABLE [dbo].[Questions]  WITH CHECK ADD  CONSTRAINT [FK_Questions_Users] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Questions] CHECK CONSTRAINT [FK_Questions_Users]
GO
ALTER TABLE [dbo].[QuizAttemptAnswerOptions]  WITH CHECK ADD  CONSTRAINT [FK_QAAO_Answers] FOREIGN KEY([QuizAttemptAnswerId])
REFERENCES [dbo].[QuizAttemptAnswers] ([Id])
GO
ALTER TABLE [dbo].[QuizAttemptAnswerOptions] CHECK CONSTRAINT [FK_QAAO_Answers]
GO
ALTER TABLE [dbo].[QuizAttemptAnswerOptions]  WITH CHECK ADD  CONSTRAINT [FK_QAAO_Options] FOREIGN KEY([QuestionOptionId])
REFERENCES [dbo].[QuestionOptions] ([Id])
GO
ALTER TABLE [dbo].[QuizAttemptAnswerOptions] CHECK CONSTRAINT [FK_QAAO_Options]
GO
ALTER TABLE [dbo].[QuizAttemptAnswers]  WITH CHECK ADD  CONSTRAINT [FK_QuizAttemptAnswers_Questions] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[Questions] ([Id])
GO
ALTER TABLE [dbo].[QuizAttemptAnswers] CHECK CONSTRAINT [FK_QuizAttemptAnswers_Questions]
GO
ALTER TABLE [dbo].[QuizAttemptAnswers]  WITH CHECK ADD  CONSTRAINT [FK_QuizAttemptAnswers_QuizAttempts] FOREIGN KEY([QuizAttemptId])
REFERENCES [dbo].[QuizAttempts] ([Id])
GO
ALTER TABLE [dbo].[QuizAttemptAnswers] CHECK CONSTRAINT [FK_QuizAttemptAnswers_QuizAttempts]
GO
ALTER TABLE [dbo].[QuizAttempts]  WITH CHECK ADD  CONSTRAINT [FK_QuizAttempts_QuizSets] FOREIGN KEY([QuizSetId])
REFERENCES [dbo].[QuizSets] ([Id])
GO
ALTER TABLE [dbo].[QuizAttempts] CHECK CONSTRAINT [FK_QuizAttempts_QuizSets]
GO
ALTER TABLE [dbo].[QuizAttempts]  WITH CHECK ADD  CONSTRAINT [FK_QuizAttempts_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[QuizAttempts] CHECK CONSTRAINT [FK_QuizAttempts_Users]
GO
ALTER TABLE [dbo].[QuizSetQuestions]  WITH CHECK ADD  CONSTRAINT [FK_QuizSetQuestions_Questions] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[Questions] ([Id])
GO
ALTER TABLE [dbo].[QuizSetQuestions] CHECK CONSTRAINT [FK_QuizSetQuestions_Questions]
GO
ALTER TABLE [dbo].[QuizSetQuestions]  WITH CHECK ADD  CONSTRAINT [FK_QuizSetQuestions_QuizSets] FOREIGN KEY([QuizSetId])
REFERENCES [dbo].[QuizSets] ([Id])
GO
ALTER TABLE [dbo].[QuizSetQuestions] CHECK CONSTRAINT [FK_QuizSetQuestions_QuizSets]
GO
ALTER TABLE [dbo].[QuizSets]  WITH CHECK ADD  CONSTRAINT [FK_QuizSets_Categories] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Categories] ([Id])
GO
ALTER TABLE [dbo].[QuizSets] CHECK CONSTRAINT [FK_QuizSets_Categories]
GO
ALTER TABLE [dbo].[QuizSets]  WITH CHECK ADD  CONSTRAINT [FK_QuizSets_Users] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[QuizSets] CHECK CONSTRAINT [FK_QuizSets_Users]
GO
ALTER TABLE [dbo].[RefreshTokens]  WITH CHECK ADD  CONSTRAINT [FK_RefreshTokens_UserDevices] FOREIGN KEY([DeviceId])
REFERENCES [dbo].[UserDevices] ([Id])
GO
ALTER TABLE [dbo].[RefreshTokens] CHECK CONSTRAINT [FK_RefreshTokens_UserDevices]
GO
ALTER TABLE [dbo].[RefreshTokens]  WITH CHECK ADD  CONSTRAINT [FK_RefreshTokens_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[RefreshTokens] CHECK CONSTRAINT [FK_RefreshTokens_Users]
GO
ALTER TABLE [dbo].[Reports]  WITH CHECK ADD  CONSTRAINT [FK_Reports_Reporter] FOREIGN KEY([ReporterId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Reports] CHECK CONSTRAINT [FK_Reports_Reporter]
GO
ALTER TABLE [dbo].[Reports]  WITH CHECK ADD  CONSTRAINT [FK_Reports_Resolver] FOREIGN KEY([ResolvedByUserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Reports] CHECK CONSTRAINT [FK_Reports_Resolver]
GO
ALTER TABLE [dbo].[RoadmapCourses]  WITH CHECK ADD  CONSTRAINT [FK_RoadmapCourses_LearningTracks_TrackId] FOREIGN KEY([TrackId])
REFERENCES [dbo].[LearningTracks] ([Id])
GO
ALTER TABLE [dbo].[RoadmapCourses] CHECK CONSTRAINT [FK_RoadmapCourses_LearningTracks_TrackId]
GO
ALTER TABLE [dbo].[RoadmapItems]  WITH CHECK ADD  CONSTRAINT [FK_RoadmapItems_Parent] FOREIGN KEY([ParentItemId])
REFERENCES [dbo].[RoadmapItems] ([Id])
GO
ALTER TABLE [dbo].[RoadmapItems] CHECK CONSTRAINT [FK_RoadmapItems_Parent]
GO
ALTER TABLE [dbo].[RoadmapItems]  WITH CHECK ADD  CONSTRAINT [FK_RoadmapItems_Roadmaps] FOREIGN KEY([RoadmapId])
REFERENCES [dbo].[Roadmaps] ([Id])
GO
ALTER TABLE [dbo].[RoadmapItems] CHECK CONSTRAINT [FK_RoadmapItems_Roadmaps]
GO
ALTER TABLE [dbo].[RoadmapLessons]  WITH CHECK ADD  CONSTRAINT [FK_RoadmapLessons_CodingProblems_CodingProblemId] FOREIGN KEY([CodingProblemId])
REFERENCES [dbo].[CodingProblems] ([Id])
GO
ALTER TABLE [dbo].[RoadmapLessons] CHECK CONSTRAINT [FK_RoadmapLessons_CodingProblems_CodingProblemId]
GO
ALTER TABLE [dbo].[RoadmapLessons]  WITH CHECK ADD  CONSTRAINT [FK_RoadmapLessons_Files_VideoFileId] FOREIGN KEY([VideoFileId])
REFERENCES [dbo].[Files] ([Id])
GO
ALTER TABLE [dbo].[RoadmapLessons] CHECK CONSTRAINT [FK_RoadmapLessons_Files_VideoFileId]
GO
ALTER TABLE [dbo].[RoadmapLessons]  WITH CHECK ADD  CONSTRAINT [FK_RoadmapLessons_QuizSets_QuizSetId] FOREIGN KEY([QuizSetId])
REFERENCES [dbo].[QuizSets] ([Id])
GO
ALTER TABLE [dbo].[RoadmapLessons] CHECK CONSTRAINT [FK_RoadmapLessons_QuizSets_QuizSetId]
GO
ALTER TABLE [dbo].[RoadmapLessons]  WITH CHECK ADD  CONSTRAINT [FK_RoadmapLessons_RoadmapModules_ModuleId] FOREIGN KEY([ModuleId])
REFERENCES [dbo].[RoadmapModules] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RoadmapLessons] CHECK CONSTRAINT [FK_RoadmapLessons_RoadmapModules_ModuleId]
GO
ALTER TABLE [dbo].[RoadmapModules]  WITH CHECK ADD  CONSTRAINT [FK_RoadmapModules_RoadmapCourses_CourseId] FOREIGN KEY([CourseId])
REFERENCES [dbo].[RoadmapCourses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RoadmapModules] CHECK CONSTRAINT [FK_RoadmapModules_RoadmapCourses_CourseId]
GO
ALTER TABLE [dbo].[Roadmaps]  WITH CHECK ADD  CONSTRAINT [FK_Roadmaps_Categories] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Categories] ([Id])
GO
ALTER TABLE [dbo].[Roadmaps] CHECK CONSTRAINT [FK_Roadmaps_Categories]
GO
ALTER TABLE [dbo].[Roadmaps]  WITH CHECK ADD  CONSTRAINT [FK_Roadmaps_Users] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Roadmaps] CHECK CONSTRAINT [FK_Roadmaps_Users]
GO
ALTER TABLE [dbo].[RolePermissionGroups]  WITH CHECK ADD  CONSTRAINT [FK_RolePermissionGroups_PermissionGroups_PermissionGroupId] FOREIGN KEY([PermissionGroupId])
REFERENCES [dbo].[PermissionGroups] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RolePermissionGroups] CHECK CONSTRAINT [FK_RolePermissionGroups_PermissionGroups_PermissionGroupId]
GO
ALTER TABLE [dbo].[RolePermissionGroups]  WITH CHECK ADD  CONSTRAINT [FK_RolePermissionGroups_Roles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Roles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RolePermissionGroups] CHECK CONSTRAINT [FK_RolePermissionGroups_Roles_RoleId]
GO
ALTER TABLE [dbo].[RolePermissions]  WITH CHECK ADD  CONSTRAINT [FK_RolePermissions_Permissions] FOREIGN KEY([PermissionId])
REFERENCES [dbo].[Permissions] ([Id])
GO
ALTER TABLE [dbo].[RolePermissions] CHECK CONSTRAINT [FK_RolePermissions_Permissions]
GO
ALTER TABLE [dbo].[RolePermissions]  WITH CHECK ADD  CONSTRAINT [FK_RolePermissions_Roles] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Roles] ([Id])
GO
ALTER TABLE [dbo].[RolePermissions] CHECK CONSTRAINT [FK_RolePermissions_Roles]
GO
ALTER TABLE [dbo].[SubmissionTestResults]  WITH CHECK ADD  CONSTRAINT [FK_SubmissionTestResults_Submissions] FOREIGN KEY([CodeSubmissionId])
REFERENCES [dbo].[CodeSubmissions] ([Id])
GO
ALTER TABLE [dbo].[SubmissionTestResults] CHECK CONSTRAINT [FK_SubmissionTestResults_Submissions]
GO
ALTER TABLE [dbo].[SubmissionTestResults]  WITH CHECK ADD  CONSTRAINT [FK_SubmissionTestResults_TestCases] FOREIGN KEY([ProblemTestCaseId])
REFERENCES [dbo].[ProblemTestCases] ([Id])
GO
ALTER TABLE [dbo].[SubmissionTestResults] CHECK CONSTRAINT [FK_SubmissionTestResults_TestCases]
GO
ALTER TABLE [dbo].[UserAchievements]  WITH CHECK ADD  CONSTRAINT [FK_UserAchievements_Achievements] FOREIGN KEY([AchievementId])
REFERENCES [dbo].[Achievements] ([Id])
GO
ALTER TABLE [dbo].[UserAchievements] CHECK CONSTRAINT [FK_UserAchievements_Achievements]
GO
ALTER TABLE [dbo].[UserAchievements]  WITH CHECK ADD  CONSTRAINT [FK_UserAchievements_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[UserAchievements] CHECK CONSTRAINT [FK_UserAchievements_Users]
GO
ALTER TABLE [dbo].[UserDailyActivities]  WITH CHECK ADD  CONSTRAINT [FK_UserDailyActivities_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[UserDailyActivities] CHECK CONSTRAINT [FK_UserDailyActivities_Users]
GO
ALTER TABLE [dbo].[UserDevices]  WITH CHECK ADD  CONSTRAINT [FK_UserDevices_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[UserDevices] CHECK CONSTRAINT [FK_UserDevices_Users]
GO
ALTER TABLE [dbo].[UserGamificationProfiles]  WITH CHECK ADD  CONSTRAINT [FK_UserGamificationProfiles_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[UserGamificationProfiles] CHECK CONSTRAINT [FK_UserGamificationProfiles_Users]
GO
ALTER TABLE [dbo].[UserLearningProfiles]  WITH CHECK ADD  CONSTRAINT [FK_UserLearningProfiles_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[UserLearningProfiles] CHECK CONSTRAINT [FK_UserLearningProfiles_Users]
GO
ALTER TABLE [dbo].[UserLessonProgresses]  WITH CHECK ADD  CONSTRAINT [FK_UserLessonProgresses_RoadmapLessons_LessonId] FOREIGN KEY([LessonId])
REFERENCES [dbo].[RoadmapLessons] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserLessonProgresses] CHECK CONSTRAINT [FK_UserLessonProgresses_RoadmapLessons_LessonId]
GO
ALTER TABLE [dbo].[UserLessonProgresses]  WITH CHECK ADD  CONSTRAINT [FK_UserLessonProgresses_Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserLessonProgresses] CHECK CONSTRAINT [FK_UserLessonProgresses_Users_UserId]
GO
ALTER TABLE [dbo].[UserNotificationSettings]  WITH CHECK ADD  CONSTRAINT [FK_UserNotificationSettings_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[UserNotificationSettings] CHECK CONSTRAINT [FK_UserNotificationSettings_Users]
GO
ALTER TABLE [dbo].[UserPermissionGroups]  WITH CHECK ADD  CONSTRAINT [FK_UserPermissionGroups_PermissionGroups_PermissionGroupId] FOREIGN KEY([PermissionGroupId])
REFERENCES [dbo].[PermissionGroups] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserPermissionGroups] CHECK CONSTRAINT [FK_UserPermissionGroups_PermissionGroups_PermissionGroupId]
GO
ALTER TABLE [dbo].[UserPermissionGroups]  WITH CHECK ADD  CONSTRAINT [FK_UserPermissionGroups_Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserPermissionGroups] CHECK CONSTRAINT [FK_UserPermissionGroups_Users_UserId]
GO
ALTER TABLE [dbo].[UserPermissions]  WITH CHECK ADD  CONSTRAINT [FK_UserPermissions_AssignedBy_Users] FOREIGN KEY([AssignedBy])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[UserPermissions] CHECK CONSTRAINT [FK_UserPermissions_AssignedBy_Users]
GO
ALTER TABLE [dbo].[UserPermissions]  WITH CHECK ADD  CONSTRAINT [FK_UserPermissions_Permissions] FOREIGN KEY([PermissionId])
REFERENCES [dbo].[Permissions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserPermissions] CHECK CONSTRAINT [FK_UserPermissions_Permissions]
GO
ALTER TABLE [dbo].[UserPermissions]  WITH CHECK ADD  CONSTRAINT [FK_UserPermissions_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserPermissions] CHECK CONSTRAINT [FK_UserPermissions_Users]
GO
ALTER TABLE [dbo].[UserProfiles]  WITH CHECK ADD  CONSTRAINT [FK_UserProfiles_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[UserProfiles] CHECK CONSTRAINT [FK_UserProfiles_Users]
GO
ALTER TABLE [dbo].[UserRoadmapProgress]  WITH CHECK ADD  CONSTRAINT [FK_UserRoadmapProgress_Items] FOREIGN KEY([RoadmapItemId])
REFERENCES [dbo].[RoadmapItems] ([Id])
GO
ALTER TABLE [dbo].[UserRoadmapProgress] CHECK CONSTRAINT [FK_UserRoadmapProgress_Items]
GO
ALTER TABLE [dbo].[UserRoadmapProgress]  WITH CHECK ADD  CONSTRAINT [FK_UserRoadmapProgress_Roadmaps] FOREIGN KEY([RoadmapId])
REFERENCES [dbo].[Roadmaps] ([Id])
GO
ALTER TABLE [dbo].[UserRoadmapProgress] CHECK CONSTRAINT [FK_UserRoadmapProgress_Roadmaps]
GO
ALTER TABLE [dbo].[UserRoadmapProgress]  WITH CHECK ADD  CONSTRAINT [FK_UserRoadmapProgress_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[UserRoadmapProgress] CHECK CONSTRAINT [FK_UserRoadmapProgress_Users]
GO
ALTER TABLE [dbo].[UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_UserRoles_Roles] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Roles] ([Id])
GO
ALTER TABLE [dbo].[UserRoles] CHECK CONSTRAINT [FK_UserRoles_Roles]
GO
ALTER TABLE [dbo].[UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_UserRoles_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[UserRoles] CHECK CONSTRAINT [FK_UserRoles_Users]
GO
ALTER TABLE [dbo].[UserSettings]  WITH CHECK ADD  CONSTRAINT [FK_UserSettings_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[UserSettings] CHECK CONSTRAINT [FK_UserSettings_Users]
GO
ALTER TABLE [dbo].[UserStats]  WITH CHECK ADD  CONSTRAINT [FK_UserStats_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[UserStats] CHECK CONSTRAINT [FK_UserStats_Users]
GO
ALTER TABLE [dbo].[UserTopicProgress]  WITH CHECK ADD  CONSTRAINT [FK_UserTopicProgress_Categories] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Categories] ([Id])
GO
ALTER TABLE [dbo].[UserTopicProgress] CHECK CONSTRAINT [FK_UserTopicProgress_Categories]
GO
ALTER TABLE [dbo].[UserTopicProgress]  WITH CHECK ADD  CONSTRAINT [FK_UserTopicProgress_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[UserTopicProgress] CHECK CONSTRAINT [FK_UserTopicProgress_Users]
GO
ALTER TABLE [dbo].[XpTransactions]  WITH CHECK ADD  CONSTRAINT [FK_XpTransactions_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[XpTransactions] CHECK CONSTRAINT [FK_XpTransactions_Users]
GO
USE [master]
GO
ALTER DATABASE [DevLearningHubDb] SET  READ_WRITE 
GO
