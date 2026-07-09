namespace DevLearningHub.Api.Entities;

public sealed class User
{
    public long Id { get; set; }
    public string FullName { get; set; } = string.Empty;
    public string UserName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string? PasswordHash { get; set; }
    public string? AvatarUrl { get; set; }
    public byte Status { get; set; } = 1;
    public bool EmailConfirmed { get; set; }
    public string? PhoneNumber { get; set; }
    public bool PhoneConfirmed { get; set; }
    public DateTime? LastLoginAt { get; set; }
    public int FailedLoginCount { get; set; }
    public DateTime? LockoutEndAt { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public bool IsDeleted { get; set; }
    public DateTime? DeletedAt { get; set; }
    public ICollection<UserRole> UserRoles { get; set; } = new List<UserRole>();
    public ICollection<UserPermission> UserPermissions { get; set; } = new List<UserPermission>();
    public ICollection<RefreshToken> RefreshTokens { get; set; } = new List<RefreshToken>();
}

public sealed class Role
{
    public long Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string NormalizedName { get; set; } = string.Empty;
    public string? Description { get; set; }
    public bool IsSystemRole { get; set; }
    public DateTime CreatedAt { get; set; }
    public ICollection<UserRole> UserRoles { get; set; } = new List<UserRole>();
    public ICollection<RolePermission> RolePermissions { get; set; } = new List<RolePermission>();
}

public sealed class Permission
{
    public long Id { get; set; }
    public string Code { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string Module { get; set; } = string.Empty;
    public string? Description { get; set; }
    public DateTime CreatedAt { get; set; }
    public ICollection<RolePermission> RolePermissions { get; set; } = new List<RolePermission>();
    public ICollection<UserPermission> UserPermissions { get; set; } = new List<UserPermission>();
}

public sealed class UserRole
{
    public long UserId { get; set; }
    public long RoleId { get; set; }
    public DateTime AssignedAt { get; set; }
    public long? AssignedBy { get; set; }
    public User User { get; set; } = null!;
    public Role Role { get; set; } = null!;
}

public sealed class RolePermission
{
    public long RoleId { get; set; }
    public long PermissionId { get; set; }
    public Role Role { get; set; } = null!;
    public Permission Permission { get; set; } = null!;
}


public sealed class UserPermission
{
    public long UserId { get; set; }
    public long PermissionId { get; set; }
    public DateTime AssignedAt { get; set; }
    public long? AssignedBy { get; set; }
    public User User { get; set; } = null!;
    public Permission Permission { get; set; } = null!;
}

public sealed class RefreshToken
{
    public long Id { get; set; }
    public long UserId { get; set; }
    public string TokenHash { get; set; } = string.Empty;
    public string? JwtId { get; set; }
    public long? DeviceId { get; set; }
    public DateTime ExpiresAt { get; set; }
    public DateTime? RevokedAt { get; set; }
    public string? ReplacedByTokenHash { get; set; }
    public string? IpAddress { get; set; }
    public string? UserAgent { get; set; }
    public DateTime CreatedAt { get; set; }
    public User User { get; set; } = null!;
}

public sealed class UserProfile
{
    public long UserId { get; set; }
    public string? FullName { get; set; }
    public string? AvatarUrl { get; set; }
    public string? Headline { get; set; }
    public string? Bio { get; set; }
    public string? Location { get; set; }
    public string? WebsiteUrl { get; set; }
    public string? GitHubUrl { get; set; }
    public string? LinkedInUrl { get; set; }
    public string? Education { get; set; }
    public string? Company { get; set; }
    public DateTime? UpdatedAt { get; set; }
}

public sealed class UserLearningProfile
{
    public long UserId { get; set; }
    public byte CurrentLevel { get; set; } = 1;
    public string? TargetRole { get; set; }
    public string? PreferredLanguage { get; set; }
    public int DailyGoalMinutes { get; set; } = 30;
    public DateTime? UpdatedAt { get; set; }
}

public sealed class UserStat
{
    public long UserId { get; set; }
    public int TotalQuizAttempts { get; set; }
    public int TotalCorrectAnswers { get; set; }
    public decimal AverageQuizScore { get; set; }
    public int TotalCodeSubmissions { get; set; }
    public int AcceptedCodeSubmissions { get; set; }
    public int TotalPosts { get; set; }
    public int TotalComments { get; set; }
    public int Reputation { get; set; }
    public int StreakDays { get; set; }
    public DateTime? LastActivityAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
}

public sealed class UserSetting
{
    public long UserId { get; set; }
    public string Theme { get; set; } = "light";
    public string Language { get; set; } = "vi";
    public string CodeEditorTheme { get; set; } = "dark";
    public int CodeEditorFontSize { get; set; } = 14;
    public bool EnableEmailNotification { get; set; } = true;
    public bool EnablePushNotification { get; set; } = true;
    public bool HasCompletedOnboarding { get; set; }
    public DateTime? UpdatedAt { get; set; }
}

public sealed class UserDailyActivity
{
    public long Id { get; set; }
    public long UserId { get; set; }
    public DateOnly ActivityDate { get; set; }
    public int QuizCompletedCount { get; set; }
    public int CodeSubmissionCount { get; set; }
    public int AcceptedCodeCount { get; set; }
    public int PostCreatedCount { get; set; }
    public int CommentCreatedCount { get; set; }
    public int StudyMinutes { get; set; }
    public int XpEarned { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
}

public sealed class Category
{
    public long Id { get; set; }
    public long? ParentId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Slug { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string? IconUrl { get; set; }
    public int DisplayOrder { get; set; }
    public byte Status { get; set; } = 1;
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public bool IsDeleted { get; set; }
    public Category? Parent { get; set; }
}

public sealed class Question
{
    public long Id { get; set; }
    public long CategoryId { get; set; }
    public long CreatedByUserId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
    public string? Explanation { get; set; }
    public byte Difficulty { get; set; } = 1;
    public byte QuestionType { get; set; } = 1;
    public byte Status { get; set; } = 1;
    public int Version { get; set; } = 1;
    public string? Source { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public bool IsDeleted { get; set; }
    public Category Category { get; set; } = null!;
    public ICollection<QuestionOption> Options { get; set; } = new List<QuestionOption>();
}

public sealed class QuestionOption
{
    public long Id { get; set; }
    public long QuestionId { get; set; }
    public string Content { get; set; } = string.Empty;
    public bool IsCorrect { get; set; }
    public string? Explanation { get; set; }
    public int DisplayOrder { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public bool IsDeleted { get; set; }
    public Question Question { get; set; } = null!;
}

public sealed class QuizSet
{
    public long Id { get; set; }
    public long CreatedByUserId { get; set; }
    public long? CategoryId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Slug { get; set; } = string.Empty;
    public string? Description { get; set; }
    public byte Difficulty { get; set; } = 1;
    public byte QuizType { get; set; } = 1;
    public int? TimeLimitMinutes { get; set; }
    public decimal PassingScore { get; set; } = 7;
    public bool AllowReview { get; set; } = true;
    public bool ShuffleQuestions { get; set; }
    public bool ShuffleOptions { get; set; }
    public int? MaxAttempts { get; set; }
    public byte Status { get; set; } = 1;
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public bool IsDeleted { get; set; }
    public Category? Category { get; set; }
    public ICollection<QuizSetQuestion> QuizSetQuestions { get; set; } = new List<QuizSetQuestion>();
}

public sealed class QuizSetQuestion
{
    public long QuizSetId { get; set; }
    public long QuestionId { get; set; }
    public int DisplayOrder { get; set; }
    public decimal Score { get; set; } = 1;
    public QuizSet QuizSet { get; set; } = null!;
    public Question Question { get; set; } = null!;
}

public sealed class QuizAttempt
{
    public long Id { get; set; }
    public long UserId { get; set; }
    public long QuizSetId { get; set; }
    public DateTime StartedAt { get; set; }
    public DateTime? SubmittedAt { get; set; }
    public int? DurationSeconds { get; set; }
    public int TotalQuestions { get; set; }
    public int CorrectAnswers { get; set; }
    public int WrongAnswers { get; set; }
    public int SkippedAnswers { get; set; }
    public decimal Score { get; set; }
    public bool IsPassed { get; set; }
    public byte Status { get; set; } = 1;
    public DateTime CreatedAt { get; set; }
    public QuizSet QuizSet { get; set; } = null!;
    public ICollection<QuizAttemptAnswer> Answers { get; set; } = new List<QuizAttemptAnswer>();
}

public sealed class QuizAttemptAnswer
{
    public long Id { get; set; }
    public long QuizAttemptId { get; set; }
    public long QuestionId { get; set; }
    public bool IsCorrect { get; set; }
    public decimal Score { get; set; }
    public DateTime? AnsweredAt { get; set; }
    public QuizAttempt QuizAttempt { get; set; } = null!;
    public Question Question { get; set; } = null!;
    public ICollection<QuizAttemptAnswerOption> SelectedOptions { get; set; } = new List<QuizAttemptAnswerOption>();
}

public sealed class QuizAttemptAnswerOption
{
    public long QuizAttemptAnswerId { get; set; }
    public long QuestionOptionId { get; set; }
    public QuizAttemptAnswer QuizAttemptAnswer { get; set; } = null!;
    public QuestionOption QuestionOption { get; set; } = null!;
}

public sealed class Roadmap
{
    public long Id { get; set; }
    public long CategoryId { get; set; }
    public long CreatedByUserId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Slug { get; set; } = string.Empty;
    public string? Description { get; set; }
    public byte TargetLevel { get; set; }
    public int? EstimatedHours { get; set; }
    public byte Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public bool IsDeleted { get; set; }
}

public sealed class AppFile
{
    public long Id { get; set; }
    public long UploadedByUserId { get; set; }
    public string OriginalFileName { get; set; } = string.Empty;
    public string StoredFileName { get; set; } = string.Empty;
    public string FileUrl { get; set; } = string.Empty;
    public string MimeType { get; set; } = string.Empty;
    public long FileSizeBytes { get; set; }
    public string StorageProvider { get; set; } = "Local";
    public string FileType { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }
    public bool IsDeleted { get; set; }
}

public sealed class FileReference
{
    public long Id { get; set; }
    public long FileId { get; set; }
    public string OwnerService { get; set; } = string.Empty;
    public string OwnerType { get; set; } = string.Empty;
    public long OwnerId { get; set; }
    public DateTime CreatedAt { get; set; }
}

public sealed class QuestionImportBatch
{
    public long Id { get; set; }
    public long? FileId { get; set; }
    public long ImportedByUserId { get; set; }
    public int TotalRows { get; set; }
    public int SuccessRows { get; set; }
    public int FailedRows { get; set; }
    public string Status { get; set; } = "Pending";
    public string? ErrorFileUrl { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? CompletedAt { get; set; }
}

public sealed class AuditLog
{
    public long Id { get; set; }
    public long? UserId { get; set; }
    public string Action { get; set; } = string.Empty;
    public string? EntityName { get; set; }
    public string? EntityId { get; set; }
    public string? OldValues { get; set; }
    public string? NewValues { get; set; }
    public string? IpAddress { get; set; }
    public string? UserAgent { get; set; }
    public DateTime CreatedAt { get; set; }
}
