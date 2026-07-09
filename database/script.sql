USE [master]
GO
/****** Object:  Database [DevLearningHubDb]    Script Date: 09/07/2026 5:41:25 PM ******/
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
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 09/07/2026 5:41:25 PM ******/
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
/****** Object:  Table [dbo].[Achievements]    Script Date: 09/07/2026 5:41:25 PM ******/
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
/****** Object:  Table [dbo].[ApiRequestLogs]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[AuditLogs]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[Categories]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[CodeRunHistories]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[CodeSubmissions]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[CodeSubmissionTestCaseResults]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[CodingProblems]    Script Date: 09/07/2026 5:41:26 PM ******/
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
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CodingProblemTags]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[CodingTestCases]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[Comments]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[CommentVotes]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[EmailVerificationTokens]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[ExternalLogins]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[FileReferences]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[Files]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[Leaderboards]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[ModerationActions]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[Notifications]    Script Date: 09/07/2026 5:41:26 PM ******/
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
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NotificationTemplates]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[PasswordResetTokens]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[PermissionGroupPermissions]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[PermissionGroups]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[Permissions]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[PersonalPracticeAttemptAnswers]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[PersonalPracticeAttempts]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[PersonalQuestionBanks]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[PersonalQuestionOptions]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[PersonalQuestions]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[PostBookmarks]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[Posts]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[PostTags]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[PostVotes]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[ProblemSupportedLanguages]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[ProblemTags]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[ProblemTestCases]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[ProgrammingLanguages]    Script Date: 09/07/2026 5:41:26 PM ******/
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
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionImportBatches]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[QuestionOptions]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[Questions]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[QuizAttemptAnswerOptions]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[QuizAttemptAnswers]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[QuizAttempts]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[QuizSetQuestions]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[QuizSets]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[RefreshTokens]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[Reports]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[RoadmapItems]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[Roadmaps]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[RolePermissionGroups]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[RolePermissions]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[Roles]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[SubmissionTestResults]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[SystemEvents]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[Tags]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[UserAchievements]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[UserDailyActivities]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[UserDevices]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[UserGamificationProfiles]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[UserLearningProfiles]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[UserNotificationSettings]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[UserPermissionGroups]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[UserPermissions]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[UserProfiles]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[UserRoadmapProgress]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[UserRoles]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[Users]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[UserSettings]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[UserStats]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[UserTopicProgress]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[XpRules]    Script Date: 09/07/2026 5:41:26 PM ******/
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
/****** Object:  Table [dbo].[XpTransactions]    Script Date: 09/07/2026 5:41:26 PM ******/
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
SET IDENTITY_INSERT [dbo].[Categories] ON 

INSERT [dbo].[Categories] ([Id], [ParentId], [Name], [Slug], [Description], [IconUrl], [DisplayOrder], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (1, NULL, N'SQL Cơ Bản', N'sql-co-ban', N'Chủ đề học SQL từ cơ bản', NULL, 1, 1, CAST(N'2026-06-09T15:57:52.1699857' AS DateTime2), NULL, 0)
INSERT [dbo].[Categories] ([Id], [ParentId], [Name], [Slug], [Description], [IconUrl], [DisplayOrder], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (2, NULL, N'C# Cơ Bản', N'csharp-co-ban', N'Chủ đề học C# cơ bản', NULL, 2, 1, CAST(N'2026-06-09T15:57:52.1699857' AS DateTime2), NULL, 0)
INSERT [dbo].[Categories] ([Id], [ParentId], [Name], [Slug], [Description], [IconUrl], [DisplayOrder], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (3, NULL, N'Angular Cơ Bản', N'angular', N'Chủ đề học Angular cơ bản', NULL, 3, 1, CAST(N'2026-06-09T15:57:52.1699857' AS DateTime2), CAST(N'2026-06-18T14:46:31.7018324' AS DateTime2), 0)
SET IDENTITY_INSERT [dbo].[Categories] OFF
GO
SET IDENTITY_INSERT [dbo].[CodeSubmissions] ON 

INSERT [dbo].[CodeSubmissions] ([Id], [UserId], [CodingProblemId], [ProgrammingLanguageId], [SourceCode], [Status], [TotalTestCases], [PassedTestCases], [Score], [ExecutionTimeMs], [MemoryUsedKb], [ErrorMessage], [JudgeToken], [SubmittedAt], [JudgedAt], [ProblemId], [Language], [Stdin], [Output], [Error], [Verdict], [IsAccepted], [CreatedAt]) VALUES (3, 6, NULL, NULL, N'import sys

name = sys.stdin.read().strip() or ''World''
print(f''Hello, {name}!'')', N'Completed', 0, 0, CAST(0.00 AS Decimal(6, 2)), 79, 0, NULL, NULL, CAST(N'2026-07-09T09:57:47.8449551' AS DateTime2), NULL, NULL, N'python', N'DevLearningHub', N'Hello, DevLearningHub!
', N'', N'Accepted', 1, CAST(N'2026-07-09T09:57:47.6953970' AS DateTime2))
SET IDENTITY_INSERT [dbo].[CodeSubmissions] OFF
GO
SET IDENTITY_INSERT [dbo].[Comments] ON 

INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (1, 1, 5, NULL, N'mô phật gì dẫy', NULL, 2, 0, 1, CAST(N'2026-06-18T16:20:29.2503956' AS DateTime2), CAST(N'2026-07-09T09:43:34.4613035' AS DateTime2), 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (2, 1, 5, 1, N'gì là gì', NULL, 0, 0, 1, CAST(N'2026-06-18T16:20:41.4507275' AS DateTime2), CAST(N'2026-07-09T09:50:04.0369254' AS DateTime2), 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (3, 1, 5, 2, N'hả', NULL, 0, 0, 1, CAST(N'2026-06-18T16:21:04.7402525' AS DateTime2), CAST(N'2026-07-09T09:50:06.1757633' AS DateTime2), 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (4, 1, 5, 3, N'hả', NULL, 0, 0, 1, CAST(N'2026-06-18T16:21:24.0988402' AS DateTime2), CAST(N'2026-07-09T09:49:58.5218332' AS DateTime2), 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (5, 1, 5, 4, N'hả', NULL, 0, 0, 1, CAST(N'2026-06-18T16:21:36.3320841' AS DateTime2), CAST(N'2026-07-09T09:49:59.4123813' AS DateTime2), 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (6, 1, 5, 5, N'hả', NULL, 0, 0, 0, CAST(N'2026-06-18T16:21:53.4566250' AS DateTime2), CAST(N'2026-06-19T08:17:56.6088724' AS DateTime2), 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (7, 1, 5, 1, N'oke fen', NULL, 0, 0, 0, CAST(N'2026-06-18T16:22:01.6927769' AS DateTime2), CAST(N'2026-06-19T05:54:42.0916302' AS DateTime2), 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (8, 1, 6, 5, N'alo', NULL, 0, 0, 1, CAST(N'2026-07-09T08:04:00.2836749' AS DateTime2), CAST(N'2026-07-09T09:49:56.8660266' AS DateTime2), 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (9, 1, 6, 5, N'alo', NULL, 0, 0, 1, CAST(N'2026-07-09T08:04:09.2565339' AS DateTime2), NULL, 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (10, 1, 6, NULL, N'alo', NULL, 0, 0, 1, CAST(N'2026-07-09T08:27:47.6980143' AS DateTime2), NULL, 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (11, 1, 6, 10, N'gì', NULL, 0, 0, 0, CAST(N'2026-07-09T08:27:54.1213233' AS DateTime2), CAST(N'2026-07-09T09:49:10.8016279' AS DateTime2), 1)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (12, 1, 6, 11, N'hả', NULL, 0, 0, 1, CAST(N'2026-07-09T08:27:58.9818707' AS DateTime2), NULL, 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (13, 1, 6, 2, N'ok', NULL, 0, 0, 1, CAST(N'2026-07-09T09:43:40.5221536' AS DateTime2), NULL, 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (14, 1, 6, 10, N'ok''', NULL, 0, 0, 1, CAST(N'2026-07-09T09:49:23.4318142' AS DateTime2), NULL, 0)
INSERT [dbo].[Comments] ([Id], [PostId], [AuthorId], [ParentCommentId], [Content], [ContentHtml], [VoteScore], [IsAcceptedAnswer], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (15, 1, 6, 14, N'okw', NULL, 0, 0, 0, CAST(N'2026-07-09T09:49:29.8022048' AS DateTime2), CAST(N'2026-07-09T09:49:37.0574604' AS DateTime2), 1)
SET IDENTITY_INSERT [dbo].[Comments] OFF
GO
SET IDENTITY_INSERT [dbo].[CommentVotes] ON 

INSERT [dbo].[CommentVotes] ([Id], [CommentId], [UserId], [VoteType], [CreatedAt]) VALUES (4, 1, 8, 1, CAST(N'2026-06-22T09:48:05.9008452' AS DateTime2))
INSERT [dbo].[CommentVotes] ([Id], [CommentId], [UserId], [VoteType], [CreatedAt]) VALUES (6, 1, 6, 1, CAST(N'2026-07-09T08:04:21.1322082' AS DateTime2))
SET IDENTITY_INSERT [dbo].[CommentVotes] OFF
GO
SET IDENTITY_INSERT [dbo].[FileReferences] ON 

INSERT [dbo].[FileReferences] ([Id], [FileId], [OwnerService], [OwnerType], [OwnerId], [CreatedAt]) VALUES (1, 6, N'Forum', N'Post', 1, CAST(N'2026-06-18T16:14:11.6038852' AS DateTime2))
INSERT [dbo].[FileReferences] ([Id], [FileId], [OwnerService], [OwnerType], [OwnerId], [CreatedAt]) VALUES (2, 7, N'Forum', N'Post', 1, CAST(N'2026-06-18T16:14:11.6145293' AS DateTime2))
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
SET IDENTITY_INSERT [dbo].[Files] OFF
GO
SET IDENTITY_INSERT [dbo].[ModerationActions] ON 

INSERT [dbo].[ModerationActions] ([Id], [ModeratorId], [TargetType], [TargetId], [ActionType], [Reason], [CreatedAt]) VALUES (1, 7, N'Comment', 7, N'Hide', N'tế nhị', CAST(N'2026-06-19T05:53:23.4467184' AS DateTime2))
INSERT [dbo].[ModerationActions] ([Id], [ModeratorId], [TargetType], [TargetId], [ActionType], [Reason], [CreatedAt]) VALUES (2, 7, N'Comment', 7, N'Hide', N'', CAST(N'2026-06-19T05:54:42.0916394' AS DateTime2))
INSERT [dbo].[ModerationActions] ([Id], [ModeratorId], [TargetType], [TargetId], [ActionType], [Reason], [CreatedAt]) VALUES (3, 7, N'Comment', 6, N'Hide', N'', CAST(N'2026-06-19T08:17:56.6088823' AS DateTime2))
INSERT [dbo].[ModerationActions] ([Id], [ModeratorId], [TargetType], [TargetId], [ActionType], [Reason], [CreatedAt]) VALUES (4, 2, N'Post', 1, N'Hide', N'', CAST(N'2026-07-09T08:52:38.3091545' AS DateTime2))
INSERT [dbo].[ModerationActions] ([Id], [ModeratorId], [TargetType], [TargetId], [ActionType], [Reason], [CreatedAt]) VALUES (5, 2, N'Post', 1, N'Restore', N'', CAST(N'2026-07-09T08:52:44.0777341' AS DateTime2))
SET IDENTITY_INSERT [dbo].[ModerationActions] OFF
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
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (1, 5)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (2, 5)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (1, 6)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (2, 6)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (1, 7)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (1, 8)
INSERT [dbo].[PermissionGroupPermissions] ([PermissionGroupId], [PermissionId]) VALUES (4, 8)
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
GO
SET IDENTITY_INSERT [dbo].[PermissionGroups] ON 

INSERT [dbo].[PermissionGroups] ([Id], [Name], [Code], [Description], [IsSystem], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (1, N'System Admin Group', N'system_admin_group', N'All system permissions', 1, CAST(N'2026-07-09T06:25:35.5024958' AS DateTime2), NULL, 0)
INSERT [dbo].[PermissionGroups] ([Id], [Name], [Code], [Description], [IsSystem], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (2, N'Quiz Manager Group', N'quiz_manager_group', N'Quiz and question management', 1, CAST(N'2026-07-09T06:25:35.7008087' AS DateTime2), NULL, 0)
INSERT [dbo].[PermissionGroups] ([Id], [Name], [Code], [Description], [IsSystem], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (3, N'Forum Moderator Group', N'forum_moderator_group', N'Forum moderation', 1, CAST(N'2026-07-09T06:25:35.7446297' AS DateTime2), NULL, 0)
INSERT [dbo].[PermissionGroups] ([Id], [Name], [Code], [Description], [IsSystem], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (4, N'Code Judge Admin Group', N'code_judge_admin_group', N'Code judge management', 1, CAST(N'2026-07-09T06:25:35.7564375' AS DateTime2), NULL, 0)
INSERT [dbo].[PermissionGroups] ([Id], [Name], [Code], [Description], [IsSystem], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (5, N'Learner Personal Practice Group', N'learner_personal_practice_group', N'Own personal practice banks', 1, CAST(N'2026-07-09T06:25:35.7687194' AS DateTime2), NULL, 0)
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
SET IDENTITY_INSERT [dbo].[Permissions] OFF
GO
SET IDENTITY_INSERT [dbo].[Posts] ON 

INSERT [dbo].[Posts] ([Id], [AuthorId], [Title], [Slug], [Content], [ContentHtml], [ViewCount], [VoteScore], [AnswerCount], [AcceptedCommentId], [Status], [LastActivityAt], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (1, 6, N'test anh load lên minio', N'test-anh-load-len-minio', N'test 11111111111111111111111111111111111111111111111111111111111111111111111111111111111 = nội dung', NULL, 98, 0, 15, NULL, 1, CAST(N'2026-07-09T09:50:04.8951591' AS DateTime2), CAST(N'2026-06-18T16:14:11.4231593' AS DateTime2), CAST(N'2026-07-09T09:50:06.1757637' AS DateTime2), 0)
SET IDENTITY_INSERT [dbo].[Posts] OFF
GO
INSERT [dbo].[PostTags] ([PostId], [TagId]) VALUES (1, 1)
GO
SET IDENTITY_INSERT [dbo].[ProgrammingLanguages] ON 

INSERT [dbo].[ProgrammingLanguages] ([Id], [Name], [Code], [Version], [Judge0LanguageId], [DefaultTemplate], [IsActive], [CreatedAt]) VALUES (1, N'C#', N'csharp', N'.NET 9', NULL, N'using System; class Program { static void Main() { } }', 1, CAST(N'2026-06-09T15:57:52.1757861' AS DateTime2))
INSERT [dbo].[ProgrammingLanguages] ([Id], [Name], [Code], [Version], [Judge0LanguageId], [DefaultTemplate], [IsActive], [CreatedAt]) VALUES (2, N'Python', N'python', N'3.x', NULL, N'print("Hello World")', 1, CAST(N'2026-06-09T15:57:52.1757861' AS DateTime2))
INSERT [dbo].[ProgrammingLanguages] ([Id], [Name], [Code], [Version], [Judge0LanguageId], [DefaultTemplate], [IsActive], [CreatedAt]) VALUES (3, N'JavaScript', N'javascript', N'Node.js', NULL, N'console.log("Hello World");', 1, CAST(N'2026-06-09T15:57:52.1757861' AS DateTime2))
SET IDENTITY_INSERT [dbo].[ProgrammingLanguages] OFF
GO
SET IDENTITY_INSERT [dbo].[QuestionImportBatches] ON 

INSERT [dbo].[QuestionImportBatches] ([Id], [FileId], [ImportedByUserId], [TotalRows], [SuccessRows], [FailedRows], [Status], [ErrorFileUrl], [CreatedAt], [CompletedAt]) VALUES (1, 1, 2, 3, 3, 0, N'Completed', NULL, CAST(N'2026-06-14T16:39:30.5532767' AS DateTime2), CAST(N'2026-06-14T16:39:30.8135529' AS DateTime2))
INSERT [dbo].[QuestionImportBatches] ([Id], [FileId], [ImportedByUserId], [TotalRows], [SuccessRows], [FailedRows], [Status], [ErrorFileUrl], [CreatedAt], [CompletedAt]) VALUES (2, 3, 2, 5, 5, 0, N'Completed', NULL, CAST(N'2026-06-18T14:53:21.1886412' AS DateTime2), CAST(N'2026-06-18T14:53:21.2836437' AS DateTime2))
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
GO
SET IDENTITY_INSERT [dbo].[QuizSets] ON 

INSERT [dbo].[QuizSets] ([Id], [CreatedByUserId], [CategoryId], [Title], [Slug], [Description], [Difficulty], [QuizType], [TimeLimitMinutes], [PassingScore], [AllowReview], [ShuffleQuestions], [ShuffleOptions], [MaxAttempts], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (1, 2, 1, N'Bộ đề test import JSON', N'bo-de-test-import-json-20260618205125', N'Bộ đề được tạo từ các câu hỏi import JSON để test hiển thị bên User.', 1, 1, 15, CAST(5.00 AS Decimal(5, 2)), 1, 0, 0, 3, 1, CAST(N'2026-06-18T13:51:25.4335142' AS DateTime2), NULL, 0)
INSERT [dbo].[QuizSets] ([Id], [CreatedByUserId], [CategoryId], [Title], [Slug], [Description], [Difficulty], [QuizType], [TimeLimitMinutes], [PassingScore], [AllowReview], [ShuffleQuestions], [ShuffleOptions], [MaxAttempts], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (2, 2, 1, N'Bộ đề test import JSON', N'bo-de-test-import-json-20260618205313', N'Bộ đề được tạo từ các câu hỏi import JSON để test hiển thị bên User.', 1, 1, 15, CAST(5.00 AS Decimal(5, 2)), 1, 0, 0, 3, 1, CAST(N'2026-06-18T20:53:13.2100000' AS DateTime2), CAST(N'2026-06-18T20:53:13.2100000' AS DateTime2), 0)
INSERT [dbo].[QuizSets] ([Id], [CreatedByUserId], [CategoryId], [Title], [Slug], [Description], [Difficulty], [QuizType], [TimeLimitMinutes], [PassingScore], [AllowReview], [ShuffleQuestions], [ShuffleOptions], [MaxAttempts], [Status], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (3, 2, 3, N'đề test', N'angular', N'Chủ đề học Angular cơ bản 1', 1, 1, 15, CAST(5.00 AS Decimal(5, 2)), 1, 1, 1, 3, 1, CAST(N'2026-06-18T15:00:12.2500593' AS DateTime2), NULL, 0)
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
SET IDENTITY_INSERT [dbo].[RefreshTokens] OFF
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
GO
SET IDENTITY_INSERT [dbo].[Roles] ON 

INSERT [dbo].[Roles] ([Id], [Name], [NormalizedName], [Description], [IsSystemRole], [CreatedAt]) VALUES (1, N'User', N'USER', N'Người dùng hệ thống', 1, CAST(N'2026-06-09T15:57:52.1169965' AS DateTime2))
INSERT [dbo].[Roles] ([Id], [Name], [NormalizedName], [Description], [IsSystemRole], [CreatedAt]) VALUES (2, N'Moderator', N'MODERATOR', N'Người kiểm duyệt nội dung', 1, CAST(N'2026-06-09T15:57:52.1169965' AS DateTime2))
INSERT [dbo].[Roles] ([Id], [Name], [NormalizedName], [Description], [IsSystemRole], [CreatedAt]) VALUES (3, N'Admin', N'ADMIN', N'Quản trị viên hệ thống', 1, CAST(N'2026-06-09T15:57:52.1169965' AS DateTime2))
SET IDENTITY_INSERT [dbo].[Roles] OFF
GO
SET IDENTITY_INSERT [dbo].[Tags] ON 

INSERT [dbo].[Tags] ([Id], [Name], [Slug], [Description], [CreatedAt]) VALUES (1, N'DevOps', N'devops', NULL, CAST(N'2026-06-18T16:14:11.5062659' AS DateTime2))
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
GO
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (1, N'Nguyen Van A', N'user1', N'user1@example.com', N'$2a$11$4setLkxF29cQAeId7tNLTeF5lVDCvtYCkITs802.x1OluCCob18Ru', NULL, 1, 0, NULL, 0, NULL, 0, NULL, CAST(N'2026-06-09T16:07:05.1792856' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (2, N'System Admin', N'admin', N'admin@example.com', N'$2a$11$0hN6Ms9BpTGKJWkr/iJ3heMRkKdga5m3KAmiU6yTFptnWMHVUydqW', NULL, 1, 1, NULL, 0, CAST(N'2026-07-09T08:58:59.8709683' AS DateTime2), 0, NULL, CAST(N'2026-06-10T17:10:23.1037780' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (3, N'Nhân Chứng', N'nhanchung', N'nhanchung@gmail.com', N'$2a$11$XKdJn8GLSQBSvU5Rq33ZIO6HkAzIH3cSKsfmoxN9ohaljU8xXxDuS', NULL, 1, 0, NULL, 0, CAST(N'2026-06-18T14:53:54.1361372' AS DateTime2), 0, NULL, CAST(N'2026-06-10T17:18:14.3842977' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (4, N'Nhan Chung', N'nhanchung1', N'nhanchung1@gmail.com', N'$2a$11$4apVVk2JJbvnmiwn.OiD4.3GxpvAIdnGpHFVKqdvTsD0hGlO5rSG2', NULL, 1, 0, NULL, 0, CAST(N'2026-06-18T15:02:52.5375674' AS DateTime2), 0, NULL, CAST(N'2026-06-10T18:39:04.5376693' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (5, N'a b', N'abs', N'abs@gmail.com', N'$2a$11$FmdPS6AJbd2HTDZVtai9A.p3UcliA0qHbZNUB91NF9C.qlkuSpKqm', NULL, 1, 0, NULL, 0, CAST(N'2026-06-19T07:02:35.4755614' AS DateTime2), 0, NULL, CAST(N'2026-06-17T10:09:21.4402387' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (6, N'ro se', N'rose', N'rose@gmail.com', N'$2a$11$pF/wSXvI2Ty6D5INk5LyHO6Hca1B7YncSDBDEt493..lVFlzMnf0m', NULL, 1, 0, NULL, 0, CAST(N'2026-07-09T09:43:08.2226690' AS DateTime2), 0, NULL, CAST(N'2026-06-18T15:03:47.1580116' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (7, N'Forum Moderator', N'moderator', N'moderator@example.com', N'$2a$11$zTGBsnHQortEoVwRDJ2sgu8mllphTI//p/HGUhCam46Oh50wD.0E2', NULL, 1, 1, NULL, 0, CAST(N'2026-07-09T09:40:58.4251353' AS DateTime2), 0, NULL, CAST(N'2026-06-18T15:44:51.6205988' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (8, N'test test', N'test1', N'test1@gmail.com', N'$2a$11$KZmVEhrtJK.G2/92QF2DPO8EtH7cNR1toiY1/p2dJLaK1VXJoaiqG', NULL, 1, 0, NULL, 0, CAST(N'2026-06-22T09:47:20.6744531' AS DateTime2), 0, NULL, CAST(N'2026-06-22T09:47:10.9744133' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (9, N'hom nay', N'homnay', N'homnay@gmail.com', N'$2a$11$xvtDZIrLxG9WxwpFP9p/GeWvGb0Z3GqYsV7FHwM9BLjA0GCR6pq8C', NULL, 1, 0, NULL, 0, NULL, 0, NULL, CAST(N'2026-07-08T09:42:23.6729134' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (10, N'hom nay', N'homnay1', N'homnay1@gmail.com', N'$2a$11$3zJuBucxSyUygZJG9826XOxC7TjFEWqWJ0oDNEquOXlsXuucEb34.', NULL, 1, 0, NULL, 0, NULL, 0, NULL, CAST(N'2026-07-08T09:43:55.8434780' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (11, N'string', N'string', N'string@g.com', N'$2a$11$mGPTet./Yo7vxqF0k9nlAO2yLfRgRcMC1X5EkipZP3In6y9z4sYe6', NULL, 1, 0, NULL, 0, NULL, 0, NULL, CAST(N'2026-07-09T01:09:28.3598732' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (12, N'string', N'string1', N'stringg.com', N'$2a$11$53W6Kn.x9W1qjy5euotTqeEkSdgywQFNWrUgIYKrJ3exgTPNvLT9K', NULL, 1, 0, NULL, 0, NULL, 0, NULL, CAST(N'2026-07-09T01:10:11.8799576' AS DateTime2), NULL, 0, NULL)
INSERT [dbo].[Users] ([Id], [FullName], [UserName], [Email], [PasswordHash], [AvatarUrl], [Status], [EmailConfirmed], [PhoneNumber], [PhoneConfirmed], [LastLoginAt], [FailedLoginCount], [LockoutEndAt], [CreatedAt], [UpdatedAt], [IsDeleted], [DeletedAt]) VALUES (13, N'a ba', N'adminex', N'a', N'$2a$11$xI3WoLCynnm8c61Q/9sbnOciHJDGdGTqUTmiPNJ9u0U8pLh.u3ppm', NULL, 1, 0, NULL, 0, NULL, 0, NULL, CAST(N'2026-07-09T08:55:53.7196125' AS DateTime2), NULL, 0, NULL)
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
GO
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (1, 0, 0, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, 0, 0, NULL, CAST(N'2026-06-09T16:07:05.5993548' AS DateTime2))
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (2, 0, 0, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, 0, 0, NULL, CAST(N'2026-06-10T17:10:23.2584871' AS DateTime2))
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (3, 0, 0, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, 0, 0, NULL, CAST(N'2026-06-10T17:18:14.4103768' AS DateTime2))
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (4, 8, 4, CAST(2.86 AS Decimal(5, 2)), 0, 0, 0, 0, 0, 0, CAST(N'2026-06-18T15:00:43.4772304' AS DateTime2), CAST(N'2026-06-18T15:00:43.4772314' AS DateTime2))
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (5, 3, 2, CAST(2.50 AS Decimal(5, 2)), 0, 0, 0, 7, 7, 0, CAST(N'2026-06-19T07:32:27.6083475' AS DateTime2), CAST(N'2026-06-19T07:32:27.6083479' AS DateTime2))
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (6, 1, 0, CAST(0.00 AS Decimal(5, 2)), 0, 0, 1, 8, 10, 0, CAST(N'2026-07-09T09:49:29.8100873' AS DateTime2), CAST(N'2026-07-09T09:49:29.8100877' AS DateTime2))
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (7, 0, 0, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, 0, 0, NULL, CAST(N'2026-06-18T15:44:51.6669314' AS DateTime2))
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (8, 0, 0, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, 0, 0, NULL, CAST(N'2026-06-22T09:47:11.0205162' AS DateTime2))
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (9, 0, 0, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, 0, 0, NULL, CAST(N'2026-07-08T09:42:23.9550389' AS DateTime2))
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (10, 0, 0, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, 0, 0, NULL, CAST(N'2026-07-08T09:43:55.8574193' AS DateTime2))
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (11, 0, 0, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, 0, 0, NULL, CAST(N'2026-07-09T01:09:28.5885468' AS DateTime2))
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (12, 0, 0, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, 0, 0, NULL, CAST(N'2026-07-09T01:10:11.8868862' AS DateTime2))
INSERT [dbo].[UserStats] ([UserId], [TotalQuizAttempts], [TotalCorrectAnswers], [AverageQuizScore], [TotalCodeSubmissions], [AcceptedCodeSubmissions], [TotalPosts], [TotalComments], [Reputation], [StreakDays], [LastActivityAt], [UpdatedAt]) VALUES (13, 0, 0, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, 0, 0, NULL, CAST(N'2026-07-09T08:55:53.7895590' AS DateTime2))
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
/****** Object:  Index [UX_Achievements_Code]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Achievements_Code] ON [dbo].[Achievements]
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_Categories_Slug]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Categories_Slug] ON [dbo].[Categories]
(
	[Slug] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_CodeSubmissions_ProblemId]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE NONCLUSTERED INDEX [IX_CodeSubmissions_ProblemId] ON [dbo].[CodeSubmissions]
(
	[ProblemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_CodeSubmissions_UserId]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE NONCLUSTERED INDEX [IX_CodeSubmissions_UserId] ON [dbo].[CodeSubmissions]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_CodeSubmissionTestCaseResults_SubmissionId]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE NONCLUSTERED INDEX [IX_CodeSubmissionTestCaseResults_SubmissionId] ON [dbo].[CodeSubmissionTestCaseResults]
(
	[SubmissionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_CodeSubmissionTestCaseResults_TestCaseId]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE NONCLUSTERED INDEX [IX_CodeSubmissionTestCaseResults_TestCaseId] ON [dbo].[CodeSubmissionTestCaseResults]
(
	[TestCaseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_CodingProblems_Slug]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_CodingProblems_Slug] ON [dbo].[CodingProblems]
(
	[Slug] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UX_CommentVotes_Comment_User]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_CommentVotes_Comment_User] ON [dbo].[CommentVotes]
(
	[CommentId] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_ExternalLogins_Provider_UserId]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_ExternalLogins_Provider_UserId] ON [dbo].[ExternalLogins]
(
	[Provider] ASC,
	[ProviderUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_NotificationTemplates_Code]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_NotificationTemplates_Code] ON [dbo].[NotificationTemplates]
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_PermissionGroupPermissions_PermissionId]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE NONCLUSTERED INDEX [IX_PermissionGroupPermissions_PermissionId] ON [dbo].[PermissionGroupPermissions]
(
	[PermissionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_PermissionGroups_Code]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_PermissionGroups_Code] ON [dbo].[PermissionGroups]
(
	[Code] ASC
)
WHERE ([Code] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_Permissions_Code]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Permissions_Code] ON [dbo].[Permissions]
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_PersonalPracticeAttemptAnswers_AttemptId]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE NONCLUSTERED INDEX [IX_PersonalPracticeAttemptAnswers_AttemptId] ON [dbo].[PersonalPracticeAttemptAnswers]
(
	[AttemptId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_PersonalPracticeAttemptAnswers_QuestionId]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE NONCLUSTERED INDEX [IX_PersonalPracticeAttemptAnswers_QuestionId] ON [dbo].[PersonalPracticeAttemptAnswers]
(
	[QuestionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_PersonalPracticeAttempts_BankId]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE NONCLUSTERED INDEX [IX_PersonalPracticeAttempts_BankId] ON [dbo].[PersonalPracticeAttempts]
(
	[BankId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_PersonalPracticeAttempts_UserId_BankId]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE NONCLUSTERED INDEX [IX_PersonalPracticeAttempts_UserId_BankId] ON [dbo].[PersonalPracticeAttempts]
(
	[UserId] ASC,
	[BankId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_PersonalQuestionBanks_UserId_IsDeleted]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE NONCLUSTERED INDEX [IX_PersonalQuestionBanks_UserId_IsDeleted] ON [dbo].[PersonalQuestionBanks]
(
	[UserId] ASC,
	[IsDeleted] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_PersonalQuestionOptions_QuestionId]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE NONCLUSTERED INDEX [IX_PersonalQuestionOptions_QuestionId] ON [dbo].[PersonalQuestionOptions]
(
	[QuestionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_PersonalQuestions_BankId]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE NONCLUSTERED INDEX [IX_PersonalQuestions_BankId] ON [dbo].[PersonalQuestions]
(
	[BankId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_PersonalQuestions_UserId_BankId_IsDeleted]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE NONCLUSTERED INDEX [IX_PersonalQuestions_UserId_BankId_IsDeleted] ON [dbo].[PersonalQuestions]
(
	[UserId] ASC,
	[BankId] ASC,
	[IsDeleted] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_Posts_Slug]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Posts_Slug] ON [dbo].[Posts]
(
	[Slug] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UX_PostVotes_Post_User]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_PostVotes_Post_User] ON [dbo].[PostVotes]
(
	[PostId] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_ProblemTags_Slug]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_ProblemTags_Slug] ON [dbo].[ProblemTags]
(
	[Slug] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_ProgrammingLanguages_Code]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_ProgrammingLanguages_Code] ON [dbo].[ProgrammingLanguages]
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_QuizSets_Slug]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_QuizSets_Slug] ON [dbo].[QuizSets]
(
	[Slug] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_Roadmaps_Slug]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Roadmaps_Slug] ON [dbo].[Roadmaps]
(
	[Slug] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_RolePermissionGroups_PermissionGroupId]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE NONCLUSTERED INDEX [IX_RolePermissionGroups_PermissionGroupId] ON [dbo].[RolePermissionGroups]
(
	[PermissionGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_Roles_NormalizedName]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Roles_NormalizedName] ON [dbo].[Roles]
(
	[NormalizedName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_Tags_Slug]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Tags_Slug] ON [dbo].[Tags]
(
	[Slug] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UX_UserDailyActivities_User_Date]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_UserDailyActivities_User_Date] ON [dbo].[UserDailyActivities]
(
	[UserId] ASC,
	[ActivityDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_UserPermissionGroups_PermissionGroupId]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE NONCLUSTERED INDEX [IX_UserPermissionGroups_PermissionGroupId] ON [dbo].[UserPermissionGroups]
(
	[PermissionGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_Users_Email]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Users_Email] ON [dbo].[Users]
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_Users_UserName]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Users_UserName] ON [dbo].[Users]
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UX_UserTopicProgress_User_Category]    Script Date: 09/07/2026 5:41:26 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_UserTopicProgress_User_Category] ON [dbo].[UserTopicProgress]
(
	[UserId] ASC,
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_XpRules_ActionType]    Script Date: 09/07/2026 5:41:26 PM ******/
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
ALTER TABLE [dbo].[ModerationActions] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Notifications] ADD  DEFAULT ((0)) FOR [IsRead]
GO
ALTER TABLE [dbo].[Notifications] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
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
ALTER TABLE [dbo].[RoadmapItems] ADD  DEFAULT ((0)) FOR [DisplayOrder]
GO
ALTER TABLE [dbo].[RoadmapItems] ADD  DEFAULT ((1)) FOR [IsRequired]
GO
ALTER TABLE [dbo].[RoadmapItems] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[RoadmapItems] ADD  DEFAULT ((0)) FOR [IsDeleted]
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
