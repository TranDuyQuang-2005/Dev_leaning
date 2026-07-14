namespace DevLearningHub.Api.DTOs;

public sealed class RegisterRequest
{
    public string FullName { get; set; } = string.Empty;
    public string UserName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
    public string ConfirmPassword { get; set; } = string.Empty;
}

public sealed class EmailSuggestionResponse
{
    public string SuggestedEmail { get; set; } = string.Empty;
}

public sealed class LoginRequest
{
    public string EmailOrUserName { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
}

public sealed class RefreshTokenRequest
{
    public string AccessToken { get; set; } = string.Empty;
    public string RefreshToken { get; set; } = string.Empty;
}

public sealed class LogoutRequest
{
    public string RefreshToken { get; set; } = string.Empty;
}

public sealed class ChangePasswordRequest
{
    public string CurrentPassword { get; set; } = string.Empty;
    public string NewPassword { get; set; } = string.Empty;
    public string ConfirmPassword { get; set; } = string.Empty;
}

public sealed class ForgotPasswordRequest
{
    public string Email { get; set; } = string.Empty;
}

public sealed class ResetPasswordRequest
{
    public string Email { get; set; } = string.Empty;
    public string Token { get; set; } = string.Empty;
    public string NewPassword { get; set; } = string.Empty;
    public string ConfirmPassword { get; set; } = string.Empty;
}

public sealed class ResendEmailVerificationRequest
{
    public string Email { get; set; } = string.Empty;
}

public sealed class VerifyEmailRequest
{
    public string Email { get; set; } = string.Empty;
    public string Token { get; set; } = string.Empty;
}

public sealed class CurrentUserResponse
{
    public long UserId { get; set; }
    public long Id { get; set; }
    public string FullName { get; set; } = string.Empty;
    public string UserName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string? AvatarUrl { get; set; }
    public List<string> Roles { get; set; } = new();
    public List<string> Permissions { get; set; } = new();
    public List<string> EffectivePermissions { get; set; } = new();
    public bool IsAdminPortalAllowed { get; set; }
}

public sealed class NotificationDto
{
    public long Id { get; set; }
    public long UserId { get; set; }
    public string Type { get; set; } = string.Empty;
    public string NotificationType { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
    public string Message { get; set; } = string.Empty;
    public string? LinkUrl { get; set; }
    public bool IsRead { get; set; }
    public DateTime? ReadAt { get; set; }
    public DateTime CreatedAt { get; set; }
    public string? MetadataJson { get; set; }
}

public sealed class NotificationListQuery
{
    public bool? IsRead { get; set; }
    public string? Type { get; set; }
    public int PageIndex { get; set; } = 1;
    public int PageSize { get; set; } = 20;
}

public sealed class NotificationUnreadCountDto
{
    public int UnreadCount { get; set; }
}

public sealed class CreateNotificationRequest
{
    public long UserId { get; set; }
    public string Type { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public string? Content { get; set; }
    public string Message { get; set; } = string.Empty;
    public string? LinkUrl { get; set; }
    public object? Metadata { get; set; }
}

public sealed class AuthResponse
{
    public string AccessToken { get; set; } = string.Empty;
    public string RefreshToken { get; set; } = string.Empty;
    public int ExpiresIn { get; set; }
    public CurrentUserResponse User { get; set; } = new();
}

public sealed class UserProfileRequest
{
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
}

public sealed class UserSettingsRequest
{
    public string Theme { get; set; } = "light";
    public string Language { get; set; } = "vi";
    public string CodeEditorTheme { get; set; } = "dark";
    public int CodeEditorFontSize { get; set; } = 14;
    public bool EnableEmailNotification { get; set; } = true;
    public bool EnablePushNotification { get; set; } = true;
    public bool HasCompletedOnboarding { get; set; }
}

public sealed record CategoryRequest(long? ParentId,string Name,string Slug,string? Description,string? IconUrl,int DisplayOrder,byte Status);
public sealed record CategoryResponse(long Id,long? ParentId,string Name,string Slug,string? Description,string? IconUrl,int DisplayOrder,byte Status);

public sealed class QuestionOptionRequest
{
    public string Content { get; set; } = string.Empty;
    public bool IsCorrect { get; set; }
    public string? Explanation { get; set; }
    public int DisplayOrder { get; set; }
}

public sealed class QuestionRequest
{
    public long CategoryId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
    public string? Explanation { get; set; }
    public byte Difficulty { get; set; } = 1;
    public byte QuestionType { get; set; } = 1;
    public byte Status { get; set; } = 2;
    public string? Source { get; set; }
    public List<QuestionOptionRequest> Options { get; set; } = new();
}

public sealed class QuestionOptionResponse
{
    public long Id { get; set; }
    public string Content { get; set; } = string.Empty;
    public bool IsCorrect { get; set; }
    public string? Explanation { get; set; }
    public int DisplayOrder { get; set; }
}

public sealed class QuestionResponse
{
    public long Id { get; set; }
    public long CategoryId { get; set; }
    public long CreatedByUserId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
    public string? Explanation { get; set; }
    public byte Difficulty { get; set; }
    public byte QuestionType { get; set; }
    public byte Status { get; set; }
    public List<QuestionOptionResponse> Options { get; set; } = new();
}

public sealed class QuizSetQuestionRequest
{
    public long QuestionId { get; set; }
    public int DisplayOrder { get; set; }
    public decimal Score { get; set; } = 1;
}

public sealed class QuizSetRequest
{
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
    public byte Status { get; set; } = 2;
    public List<QuizSetQuestionRequest> Questions { get; set; } = new();
}

public sealed class QuizSetResponse
{
    public long Id { get; set; }
    public long? CategoryId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Slug { get; set; } = string.Empty;
    public string? Description { get; set; }
    public byte Difficulty { get; set; }
    public byte QuizType { get; set; }
    public int? TimeLimitMinutes { get; set; }
    public decimal PassingScore { get; set; }
    public bool AllowReview { get; set; }
    public bool ShuffleQuestions { get; set; }
    public bool ShuffleOptions { get; set; }
    public int? MaxAttempts { get; set; }
    public byte Status { get; set; }
    public int QuestionCount { get; set; }
    public List<QuizSetQuestionRequest> Questions { get; set; } = new();
}

public sealed class StartQuizAttemptRequest
{
    public long QuizSetId { get; set; }
    public long? LessonId { get; set; }
    public long? RoadmapLessonId { get; set; }
}
public sealed class SubmitQuizAnswerRequest { public long QuestionId { get; set; } public List<long> SelectedOptionIds { get; set; } = new(); }
public sealed class SubmitQuizAttemptRequest
{
    public List<SubmitQuizAnswerRequest> Answers { get; set; } = new();
    public long? LessonId { get; set; }
    public long? RoadmapLessonId { get; set; }
}

public sealed class QuizOptionForTakeResponse { public long Id { get; set; } public string Content { get; set; } = string.Empty; }
public sealed class QuizQuestionForTakeResponse { public long Id { get; set; } public string Content { get; set; } = string.Empty; public byte QuestionType { get; set; } public List<QuizOptionForTakeResponse> Options { get; set; } = new(); }
public sealed class QuizAttemptResponse { public long AttemptId { get; set; } public long QuizSetId { get; set; } public string QuizTitle { get; set; } = string.Empty; public DateTime StartedAt { get; set; } public int? TimeLimitMinutes { get; set; } public decimal PassingScore { get; set; } public bool AllowReview { get; set; } public int? MaxAttempts { get; set; } public List<QuizQuestionForTakeResponse> Questions { get; set; } = new(); }
public sealed class QuizSubmitResultResponse { public long AttemptId { get; set; } public long QuizSetId { get; set; } public string QuizTitle { get; set; } = string.Empty; public int TotalQuestions { get; set; } public int CorrectAnswers { get; set; } public int WrongAnswers { get; set; } public int SkippedAnswers { get; set; } public decimal Score { get; set; } public bool IsPassed { get; set; } public int DurationSeconds { get; set; } public DateTime StartedAt { get; set; } public DateTime? SubmittedAt { get; set; } }

public sealed class QuizOptionResultResponse
{
    public long Id { get; set; }
    public string Content { get; set; } = string.Empty;
    public bool IsCorrect { get; set; }
    public bool IsSelected { get; set; }
    public string? Explanation { get; set; }
    public int DisplayOrder { get; set; }
}

public sealed class QuizQuestionResultResponse
{
    public long Id { get; set; }
    public string Content { get; set; } = string.Empty;
    public string? Explanation { get; set; }
    public bool IsCorrect { get; set; }
    public decimal Score { get; set; }
    public List<long> SelectedOptionIds { get; set; } = new();
    public List<long> CorrectOptionIds { get; set; } = new();
    public List<QuizOptionResultResponse> Options { get; set; } = new();
}

public sealed class QuizAttemptDetailResultResponse
{
    public long AttemptId { get; set; }
    public long QuizSetId { get; set; }
    public string QuizTitle { get; set; } = string.Empty;
    public int TotalQuestions { get; set; }
    public int CorrectAnswers { get; set; }
    public int WrongAnswers { get; set; }
    public int SkippedAnswers { get; set; }
    public decimal Score { get; set; }
    public bool IsPassed { get; set; }
    public int DurationSeconds { get; set; }
    public DateTime StartedAt { get; set; }
    public DateTime? SubmittedAt { get; set; }
    public List<QuizQuestionResultResponse> Questions { get; set; } = new();
}

public sealed class RoleAssignRequest { public long UserId { get; set; } public long RoleId { get; set; } }

public sealed class UpdateUserRolesRequest
{
    public List<long> RoleIds { get; set; } = new();
}

public sealed class UpdateUserPermissionsRequest
{
    public List<long> PermissionIds { get; set; } = new();
}

public class AdminRoleResponse
{
    public long Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string NormalizedName { get; set; } = string.Empty;
    public string? Description { get; set; }
    public bool IsSystemRole { get; set; }
    public List<string> Permissions { get; set; } = new();
}

public sealed class AdminUserResponse
{
    public long Id { get; set; }
    public string FullName { get; set; } = string.Empty;
    public string UserName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public byte Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public List<AdminRoleResponse> Roles { get; set; } = new();
}

public sealed class AdminUserRoleOptionResponse : AdminRoleResponse
{
    public bool Assigned { get; set; }
}

public sealed class AdminUserRolesResponse
{
    public AdminUserResponse User { get; set; } = new();
    public List<AdminUserRoleOptionResponse> Roles { get; set; } = new();
}

public sealed class AdminPermissionOptionResponse
{
    public long Id { get; set; }
    public string Code { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string Module { get; set; } = string.Empty;
    public string? Description { get; set; }
    public bool Assigned { get; set; }
    public bool InheritedFromRole { get; set; }
    public bool Effective { get; set; }
    public List<string> SourceRoles { get; set; } = new();
}

public sealed class AdminUserPermissionsResponse
{
    public AdminUserResponse User { get; set; } = new();
    public List<AdminPermissionOptionResponse> Permissions { get; set; } = new();
}

public sealed class PermissionGroupRequest
{
    public string Name { get; set; } = string.Empty;
    public string Code { get; set; } = string.Empty;
    public string? Description { get; set; }
    public List<long> PermissionIds { get; set; } = new();
}

public sealed class PermissionGroupAssignRequest
{
    public List<long> PermissionGroupIds { get; set; } = new();
}

public sealed class PermissionIdsRequest
{
    public List<long> PermissionIds { get; set; } = new();
}

public sealed class PermissionGroupResponse
{
    public long Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Code { get; set; } = string.Empty;
    public string? Description { get; set; }
    public bool IsSystem { get; set; }
    public DateTime CreatedAt { get; set; }
    public List<AdminPermissionOptionResponse> Permissions { get; set; } = new();
}

public sealed class EffectivePermissionsResponse
{
    public long UserId { get; set; }
    public List<string> DirectPermissions { get; set; } = new();
    public List<string> RolePermissions { get; set; } = new();
    public List<PermissionGroupEffectiveResponse> RolePermissionGroups { get; set; } = new();
    public List<PermissionGroupEffectiveResponse> UserPermissionGroups { get; set; } = new();
    public List<string> EffectivePermissions { get; set; } = new();
}

public sealed class PermissionGroupEffectiveResponse
{
    public long Id { get; set; }
    public string Code { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public List<string> Permissions { get; set; } = new();
}

public sealed class LockUserRequest
{
    public string? Reason { get; set; }
    public DateTime? LockUntil { get; set; }
}

public sealed class AuditLogResponse
{
    public long Id { get; set; }
    public long? ActorUserId { get; set; }
    public string Action { get; set; } = string.Empty;
    public string? TargetType { get; set; }
    public string? TargetId { get; set; }
    public string? OldValueJson { get; set; }
    public string? NewValueJson { get; set; }
    public string? IpAddress { get; set; }
    public string? UserAgent { get; set; }
    public DateTime CreatedAt { get; set; }
}

public sealed class QuizStatisticsResponse
{
    public long? QuizSetId { get; set; }
    public int TotalAttempts { get; set; }
    public int UniqueUsers { get; set; }
    public decimal AverageScore { get; set; }
    public decimal HighestScore { get; set; }
    public decimal LowestScore { get; set; }
    public int PassCount { get; set; }
    public int FailCount { get; set; }
    public decimal PassRate { get; set; }
    public double AverageDurationSeconds { get; set; }
}
public sealed class FileUploadResponse { public long FileId { get; set; } public string FileUrl { get; set; } = string.Empty; public string OriginalFileName { get; set; } = string.Empty; }
public sealed class ImportQuestionResult { public long BatchId { get; set; } public int TotalRows { get; set; } public int SuccessRows { get; set; } public int FailedRows { get; set; } public List<string> Errors { get; set; } = new(); }

public sealed class PersonalQuestionBankUploadResponse
{
    public long BankId { get; set; }
    public string Title { get; set; } = string.Empty;
    public int QuestionCount { get; set; }
    public DateTime CreatedAt { get; set; }
    public List<string> ImportWarnings { get; set; } = new();
    public List<string> ImportErrors { get; set; } = new();
}

public class PersonalQuestionBankSummaryResponse
{
    public long Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string? Description { get; set; }
    public int QuestionCount { get; set; }
    public DateTime CreatedAt { get; set; }
}

public sealed class PersonalQuestionOptionTakeResponse
{
    public long Id { get; set; }
    public string Key { get; set; } = string.Empty;
    public string Label { get; set; } = string.Empty;
    public string Text { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
}

public sealed class PersonalQuestionTakeResponse
{
    public long Id { get; set; }
    public string QuestionText { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
    public string QuestionType { get; set; } = string.Empty;
    public string Difficulty { get; set; } = string.Empty;
    public string? Topic { get; set; }
    public string? Tags { get; set; }
    public string? SelectedOptionLabel { get; set; }
    public string? SelectedAnswer { get; set; }
    public List<PersonalQuestionOptionTakeResponse> Options { get; set; } = new();
}

public sealed class PersonalQuestionBankDetailResponse : PersonalQuestionBankSummaryResponse
{
    public List<PersonalQuestionTakeResponse> Questions { get; set; } = new();
}

public sealed class StartPersonalPracticeAttemptRequest
{
    public int? NumberOfQuestions { get; set; }
    public bool ShuffleQuestions { get; set; } = true;
    public bool ShuffleOptions { get; set; } = true;
}

public sealed class PersonalPracticeAttemptResponse
{
    public long AttemptId { get; set; }
    public long BankId { get; set; }
    public string BankTitle { get; set; } = string.Empty;
    public DateTime StartedAt { get; set; }
    public List<PersonalQuestionTakeResponse> Questions { get; set; } = new();
}

public sealed class PersonalPracticeAnswerRequest
{
    public long QuestionId { get; set; }
    public string? SelectedOptionLabel { get; set; }
    public string? SelectedOption { get; set; }
    public string? SelectedOptionKey { get; set; }
    public string? SelectedAnswer { get; set; }
    public long? SelectedOptionId { get; set; }
}

public sealed class SubmitPersonalPracticeAttemptRequest
{
    public List<PersonalPracticeAnswerRequest> Answers { get; set; } = new();
}

public sealed class PersonalPracticeAnswerResultResponse
{
    public long QuestionId { get; set; }
    public string? SelectedOptionLabel { get; set; }
    public string? SelectedOption { get; set; }
    public string? SelectedOptionKey { get; set; }
    public string? CorrectOptionLabel { get; set; }
    public string? CorrectOption { get; set; }
    public string? CorrectOptionKey { get; set; }
    public string? SelectedAnswerText { get; set; }
    public string? CorrectAnswerText { get; set; }
    public bool IsCorrect { get; set; }
    public string? Explanation { get; set; }
    public string? Warning { get; set; }
    public List<PersonalPracticeOptionReviewResponse> Options { get; set; } = new();
}

public sealed class PersonalPracticeOptionReviewResponse
{
    public long Id { get; set; }
    public string Key { get; set; } = string.Empty;
    public string Label { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
    public string Text { get; set; } = string.Empty;
    public bool IsSelected { get; set; }
    public bool IsCorrect { get; set; }
}

public sealed class PersonalPracticeQuestionResultResponse
{
    public long QuestionId { get; set; }
    public long Id { get; set; }
    public string QuestionText { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
    public string QuestionType { get; set; } = string.Empty;
    public string Difficulty { get; set; } = string.Empty;
    public string? Topic { get; set; }
    public string? Tags { get; set; }
    public string? SelectedOptionLabel { get; set; }
    public string? SelectedOption { get; set; }
    public string? SelectedOptionKey { get; set; }
    public string? SelectedAnswer { get; set; }
    public string? CorrectOptionLabel { get; set; }
    public string? CorrectOption { get; set; }
    public string? CorrectOptionKey { get; set; }
    public string? CorrectAnswer { get; set; }
    public string? SelectedAnswerText { get; set; }
    public string? CorrectAnswerText { get; set; }
    public bool IsCorrect { get; set; }
    public string? Explanation { get; set; }
    public string? Warning { get; set; }
    public List<PersonalPracticeOptionReviewResponse> Options { get; set; } = new();
}

public sealed class PersonalPracticeAttemptResultResponse
{
    public long Id { get; set; }
    public long AttemptId { get; set; }
    public long BankId { get; set; }
    public string BankTitle { get; set; } = string.Empty;
    public decimal Score { get; set; }
    public int TotalQuestions { get; set; }
    public int CorrectCount { get; set; }
    public string Status { get; set; } = string.Empty;
    public DateTime StartedAt { get; set; }
    public DateTime? SubmittedAt { get; set; }
    public List<PersonalPracticeQuestionResultResponse> Questions { get; set; } = new();
    public List<PersonalPracticeAnswerResultResponse> Details { get; set; } = new();
}

public sealed class ForumTagResponse
{
    public long Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Slug { get; set; } = string.Empty;
    public string? Description { get; set; }
}

public sealed class ForumTagRequest
{
    public string Name { get; set; } = string.Empty;
    public string Slug { get; set; } = string.Empty;
    public string? Description { get; set; }
}

public sealed class ForumPostRequest
{
    public string Title { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
    public List<string> Tags { get; set; } = new();
    public List<long> AttachmentIds { get; set; } = new();
}

public sealed class ForumCommentRequest
{
    public string Content { get; set; } = string.Empty;
    public long? ParentCommentId { get; set; }
}

public sealed class ForumVoteRequest
{
    public short VoteType { get; set; } // 1 upvote, -1 downvote, same vote again cancels
}

public sealed class ForumReportRequest
{
    public string TargetType { get; set; } = string.Empty; // Post or Comment
    public long TargetId { get; set; }
    public string Reason { get; set; } = string.Empty;
    public string? Description { get; set; }
}

public sealed class ResolveReportRequest
{
    public byte Status { get; set; } = 2; // 2 resolved, 3 rejected
    public string? Reason { get; set; }
    public bool HideTarget { get; set; }
}

public sealed class ForumAttachmentResponse
{
    public long FileId { get; set; }
    public string OriginalFileName { get; set; } = string.Empty;
    public string FileUrl { get; set; } = string.Empty;
    public string MimeType { get; set; } = string.Empty;
    public long FileSizeBytes { get; set; }
    public string FileType { get; set; } = string.Empty;
    public string StorageProvider { get; set; } = string.Empty;
    public bool IsImage => FileType.Equals("Image", StringComparison.OrdinalIgnoreCase) || MimeType.StartsWith("image/", StringComparison.OrdinalIgnoreCase);
}

public sealed class ForumCommentResponse
{
    public long Id { get; set; }
    public long PostId { get; set; }
    public long AuthorId { get; set; }
    public string AuthorName { get; set; } = string.Empty;
    public string AuthorInitials { get; set; } = string.Empty;
    public long? ParentCommentId { get; set; }
    public string Content { get; set; } = string.Empty;
    public int VoteScore { get; set; }
    public int LikeCount { get; set; }
    public int DislikeCount { get; set; }
    public bool IsAcceptedAnswer { get; set; }
    public byte Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public bool CanEdit { get; set; }
    public short? MyVote { get; set; }
    public int ReplyCount { get; set; }
    public List<ForumCommentResponse> Replies { get; set; } = new();
}

public class ForumPostSummaryResponse
{
    public long Id { get; set; }
    public long AuthorId { get; set; }
    public string AuthorName { get; set; } = string.Empty;
    public string AuthorInitials { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public string Slug { get; set; } = string.Empty;
    public string ContentPreview { get; set; } = string.Empty;
    public int ViewCount { get; set; }
    public int VoteScore { get; set; }
    public int LikeCount { get; set; }
    public int DislikeCount { get; set; }
    public int CommentCount { get; set; }
    public byte Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public bool IsBookmarked { get; set; }
    public short? MyVote { get; set; }
    public List<ForumTagResponse> Tags { get; set; } = new();
    public int AttachmentCount { get; set; }
    public string? FirstImageUrl { get; set; }
    public long? AcceptedCommentId { get; set; }
    public bool IsSolved { get; set; }
}

public sealed class ForumPostDetailResponse : ForumPostSummaryResponse
{
    public string Content { get; set; } = string.Empty;
    public bool CanEdit { get; set; }
    public bool CanAcceptAnswer { get; set; }
    public List<ForumAttachmentResponse> Attachments { get; set; } = new();
    public List<ForumCommentResponse> Comments { get; set; } = new();
}

public sealed class ForumReportResponse
{
    public long Id { get; set; }
    public long ReporterId { get; set; }
    public string ReporterName { get; set; } = string.Empty;
    public string TargetType { get; set; } = string.Empty;
    public long TargetId { get; set; }
    public string Reason { get; set; } = string.Empty;
    public string? Description { get; set; }
    public byte Status { get; set; }
    public long? ResolvedByUserId { get; set; }
    public DateTime? ResolvedAt { get; set; }
    public DateTime CreatedAt { get; set; }
}

public sealed class ModerationReasonRequest
{
    public string? Reason { get; set; }
}


public sealed class SupportedLanguageResponse
{
    public string Value { get; set; } = string.Empty;
    public string Label { get; set; } = string.Empty;
    public string Runtime { get; set; } = string.Empty;
    public bool Enabled { get; set; } = true;
    public string LanguageCode { get; set; } = string.Empty;
    public string DisplayName { get; set; } = string.Empty;
    public string Version { get; set; } = string.Empty;
    public string FileExtension { get; set; } = string.Empty;
    public string DefaultTemplate { get; set; } = string.Empty;
    public string? CompileCommand { get; set; }
    public string RunCommand { get; set; } = string.Empty;
    public bool IsCompiled { get; set; }
    public bool IsActive { get; set; } = true;
    public int TimeLimitMs { get; set; }
    public int MemoryLimitKb { get; set; }
    public int SortOrder { get; set; }
    public string RequiredRuntime { get; set; } = string.Empty;
}

public sealed class CodeRunRequest
{
    public string Language { get; set; } = "javascript";
    public string SourceCode { get; set; } = string.Empty;
    public string? Stdin { get; set; }
    public int? TimeLimitMs { get; set; }
    public long? LessonId { get; set; }
    public long? RoadmapLessonId { get; set; }
    public long? CodingProblemId { get; set; }
}

public sealed class CodeRunResponse
{
    public string Status { get; set; } = string.Empty;
    public string Verdict { get; set; } = string.Empty;
    public string Output { get; set; } = string.Empty;
    public string Error { get; set; } = string.Empty;
    public string Stdout { get; set; } = string.Empty;
    public string Stderr { get; set; } = string.Empty;
    public string CompileOutput { get; set; } = string.Empty;
    public int ExecutionTimeMs { get; set; }
    public int MemoryUsedKb { get; set; }
    public string Language { get; set; } = string.Empty;
    public long? SubmissionId { get; set; }
}

public sealed class CodingTestCaseRequest
{
    public string Input { get; set; } = string.Empty;
    public string ExpectedOutput { get; set; } = string.Empty;
    public string? Explanation { get; set; }
    public bool IsHidden { get; set; }
    public int DisplayOrder { get; set; }
}

public sealed class CodingProblemRequest
{
    public string Title { get; set; } = string.Empty;
    public string Slug { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public string? InputFormat { get; set; }
    public string? OutputFormat { get; set; }
    public string? Constraints { get; set; }
    public string? ExamplesJson { get; set; }
    public string? Tags { get; set; }
    public string? StarterCodeJavaScript { get; set; }
    public string? StarterCodePython { get; set; }
    public string? StarterCodeTypeScript { get; set; }
    public string? StarterCodeJava { get; set; }
    public string? StarterCodeC { get; set; }
    public string? StarterCodeCpp { get; set; }
    public string? StarterCodeCsharp { get; set; }
    public string? StarterCodeGo { get; set; }
    public byte Difficulty { get; set; } = 1;
    public byte Status { get; set; } = 1;
    public int TimeLimitMs { get; set; } = 2000;
    public int MemoryLimitKb { get; set; } = 131072;
    public List<CodingTestCaseRequest> TestCases { get; set; } = new();
}

public sealed class CodingProblemImportRequest
{
    public string Title { get; set; } = string.Empty;
    public string Slug { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public byte Difficulty { get; set; } = 1;
    public object? Tags { get; set; }
    public string? InputFormat { get; set; }
    public string? OutputFormat { get; set; }
    public string? Constraints { get; set; }
    public string? ExamplesJson { get; set; }
    public string? StarterCodeJavaScript { get; set; }
    public string? StarterCodePython { get; set; }
    public string? StarterCodeTypeScript { get; set; }
    public string? StarterCodeJava { get; set; }
    public string? StarterCodeC { get; set; }
    public string? StarterCodeCpp { get; set; }
    public string? StarterCodeCsharp { get; set; }
    public string? StarterCodeGo { get; set; }
    public byte Status { get; set; } = 1;
    public int TimeLimitMs { get; set; } = 2000;
    public int MemoryLimitKb { get; set; } = 131072;
    public List<CodingTestCaseRequest> TestCases { get; set; } = new();
}

public sealed class CodingProblemImportResult
{
    public int Total { get; set; }
    public int Created { get; set; }
    public int Updated { get; set; }
    public int Skipped { get; set; }
    public List<string> Errors { get; set; } = new();
}

public sealed class CodingTestCaseResponse
{
    public long Id { get; set; }
    public string Input { get; set; } = string.Empty;
    public string ExpectedOutput { get; set; } = string.Empty;
    public string? Explanation { get; set; }
    public bool IsHidden { get; set; }
    public int DisplayOrder { get; set; }
}

public class CodingProblemSummaryResponse
{
    public long Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Slug { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public byte Difficulty { get; set; }
    public string? Tags { get; set; }
    public byte Status { get; set; }
    public int TimeLimitMs { get; set; }
    public int MemoryLimitKb { get; set; }
    public int TotalSubmissions { get; set; }
    public int AcceptedSubmissions { get; set; }
    public decimal AcceptanceRate { get; set; }
    public bool SolvedByCurrentUser { get; set; }
}

public sealed class CodingProblemDetailResponse : CodingProblemSummaryResponse
{
    public string? InputFormat { get; set; }
    public string? OutputFormat { get; set; }
    public string? Constraints { get; set; }
    public string? ExamplesJson { get; set; }
    public string? StarterCodeJavaScript { get; set; }
    public string? StarterCodePython { get; set; }
    public string? StarterCodeTypeScript { get; set; }
    public string? StarterCodeJava { get; set; }
    public string? StarterCodeC { get; set; }
    public string? StarterCodeCpp { get; set; }
    public string? StarterCodeCsharp { get; set; }
    public string? StarterCodeGo { get; set; }
    public List<CodingTestCaseResponse> TestCases { get; set; } = new();
}

public sealed class LearningTrackRequest
{
    public string Title { get; set; } = string.Empty;
    public string Slug { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string Level { get; set; } = "Beginner";
    public int EstimatedHours { get; set; }
    public string? ThumbnailUrl { get; set; }
    public int SortOrder { get; set; }
    public bool IsPublished { get; set; } = true;
}

public sealed class RoadmapCourseRequest
{
    public long TrackId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Slug { get; set; } = string.Empty;
    public string? ShortDescription { get; set; }
    public string? Description { get; set; }
    public string Level { get; set; } = "Beginner";
    public int EstimatedHours { get; set; }
    public List<string> Requirements { get; set; } = new();
    public List<string> LearningOutcomes { get; set; } = new();
    public List<long> RelatedCourseIds { get; set; } = new();
    public List<long> PrerequisiteCourseIds { get; set; } = new();
    public string? ThumbnailUrl { get; set; }
    public int SortOrder { get; set; }
    public bool IsPublished { get; set; } = true;
    public bool RequiresSequentialCompletion { get; set; } = true;
    public long? UnlockAfterCourseId { get; set; }
}

public sealed class RoadmapModuleRequest
{
    public string Title { get; set; } = string.Empty;
    public string? Description { get; set; }
    public int SortOrder { get; set; }
    public int EstimatedMinutes { get; set; }
    public bool RequiresPreviousModuleCompletion { get; set; } = true;
    public bool IsLockedByDefault { get; set; }
    public bool IsPublished { get; set; } = true;
}

public sealed class RoadmapLessonRequest
{
    public string Title { get; set; } = string.Empty;
    public string Type { get; set; } = "Reading";
    public string? Content { get; set; }
    public string? VideoUrl { get; set; }
    public long? VideoFileId { get; set; }
    public long? QuizSetId { get; set; }
    public long? CodingProblemId { get; set; }
    public int EstimatedMinutes { get; set; }
    public int SortOrder { get; set; }
    public bool IsPreview { get; set; }
    public bool IsPublished { get; set; } = true;
    public bool RequiresPreviousLessonCompletion { get; set; } = true;
    public bool IsRequired { get; set; } = true;
    public long? UnlockAfterLessonId { get; set; }
}

public sealed class RoadmapLockStateResponse
{
    public bool IsLocked { get; set; }
    public string? LockReason { get; set; }
    public List<string> UnlockRequirements { get; set; } = new();
    public decimal ProgressPercent { get; set; }
    public bool IsCompleted { get; set; }
}

public sealed class RoadmapLessonResponse
{
    public long Id { get; set; }
    public long ModuleId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Type { get; set; } = string.Empty;
    public string? Content { get; set; }
    public string? VideoUrl { get; set; }
    public long? VideoFileId { get; set; }
    public string? VideoFileUrl { get; set; }
    public long? QuizSetId { get; set; }
    public long? CodingProblemId { get; set; }
    public int EstimatedMinutes { get; set; }
    public int SortOrder { get; set; }
    public bool IsPreview { get; set; }
    public bool IsRequired { get; set; }
    public bool IsPublished { get; set; }
    public bool RequiresPreviousLessonCompletion { get; set; }
    public long? UnlockAfterLessonId { get; set; }
    public bool IsLocked { get; set; }
    public string? LockReason { get; set; }
    public List<string> UnlockRequirements { get; set; } = new();
    public string Status { get; set; } = "NotStarted";
    public bool CanStart { get; set; }
    public bool CanComplete { get; set; }
}

public sealed class LessonAccessResult
{
    public bool CanAccess { get; set; }
    public bool IsLocked { get; set; }
    public string? Message { get; set; }
    public long? LessonId { get; set; }
    public long? CourseId { get; set; }
}

public sealed class RoadmapModuleResponse
{
    public long Id { get; set; }
    public long CourseId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string? Description { get; set; }
    public int SortOrder { get; set; }
    public int EstimatedMinutes { get; set; }
    public bool RequiresPreviousModuleCompletion { get; set; }
    public bool IsLockedByDefault { get; set; }
    public bool IsPublished { get; set; }
    public bool IsLocked { get; set; }
    public string? LockReason { get; set; }
    public List<string> UnlockRequirements { get; set; } = new();
    public decimal ProgressPercent { get; set; }
    public bool IsCompleted { get; set; }
    public List<RoadmapLessonResponse> Lessons { get; set; } = new();
}

public class RoadmapCourseSummaryResponse
{
    public long Id { get; set; }
    public long TrackId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Slug { get; set; } = string.Empty;
    public string? ShortDescription { get; set; }
    public string? Description { get; set; }
    public string Level { get; set; } = string.Empty;
    public int EstimatedHours { get; set; }
    public int TotalModules { get; set; }
    public int TotalLessons { get; set; }
    public string? ThumbnailUrl { get; set; }
    public int SortOrder { get; set; }
    public bool IsPublished { get; set; }
    public bool RequiresSequentialCompletion { get; set; }
    public List<long> RelatedCourseIds { get; set; } = new();
    public List<long> PrerequisiteCourseIds { get; set; } = new();
    public long? UnlockAfterCourseId { get; set; }
    public bool IsLocked { get; set; }
    public string? LockReason { get; set; }
    public List<string> UnlockRequirements { get; set; } = new();
    public decimal ProgressPercent { get; set; }
    public bool IsCompleted { get; set; }
    public string Status { get; set; } = "Not started";
}

public sealed class RoadmapCourseDetailResponse : RoadmapCourseSummaryResponse
{
    public string TrackTitle { get; set; } = string.Empty;
    public string TrackSlug { get; set; } = string.Empty;
    public List<string> Requirements { get; set; } = new();
    public List<string> LearningOutcomes { get; set; } = new();
    public List<RoadmapModuleResponse> Modules { get; set; } = new();
    public List<RoadmapCourseSummaryResponse> RelatedCourses { get; set; } = new();
    public RoadmapLessonResponse? NextUnlockedLesson { get; set; }
    public int LockedLessonCount { get; set; }
    public int CompletedLessons { get; set; }
}

public class LearningTrackResponse
{
    public long Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Slug { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string Level { get; set; } = string.Empty;
    public int EstimatedHours { get; set; }
    public string? ThumbnailUrl { get; set; }
    public int SortOrder { get; set; }
    public bool IsPublished { get; set; }
    public int CourseCount { get; set; }
    public int TotalLessons { get; set; }
    public decimal ProgressPercent { get; set; }
}

public sealed class LearningTrackDetailResponse : LearningTrackResponse
{
    public List<RoadmapCourseSummaryResponse> Courses { get; set; } = new();
}

public sealed class CourseProgressResponse
{
    public long CourseId { get; set; }
    public int CompletedLessons { get; set; }
    public int TotalLessons { get; set; }
    public decimal ProgressPercent { get; set; }
    public bool IsCompleted { get; set; }
    public DateTime? LastAccessedAt { get; set; }
}

public sealed class ProgressOverviewResponse
{
    public int TotalCourses { get; set; }
    public int CompletedCourses { get; set; }
    public int CompletedLessons { get; set; }
    public int TotalLessons { get; set; }
    public decimal AverageQuizScore { get; set; }
    public int AcceptedCodeSubmissions { get; set; }
    public List<string> WeakTopics { get; set; } = new();
    public List<RoadmapCourseSummaryResponse> RecommendedNextCourses { get; set; } = new();
}

public sealed class ProgressRoadmapActionResponse
{
    public string Type { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public string LinkUrl { get; set; } = string.Empty;
}

public sealed class ProgressRoadmapResponse
{
    public string CurrentLevel { get; set; } = "Beginner";
    public List<RoadmapCourseSummaryResponse> CurrentCourses { get; set; } = new();
    public List<RoadmapCourseSummaryResponse> RecommendedCourses { get; set; } = new();
    public List<string> WeakTopics { get; set; } = new();
    public List<ProgressRoadmapActionResponse> NextActions { get; set; } = new();
}

public sealed class CodeSubmitRequest
{
    public string Language { get; set; } = "javascript";
    public string SourceCode { get; set; } = string.Empty;
    public long? LessonId { get; set; }
    public long? RoadmapLessonId { get; set; }
}

public sealed class CodeTestCaseResultResponse
{
    public long Id { get; set; }
    public long? TestCaseId { get; set; }
    public int DisplayOrder { get; set; }
    public string Input { get; set; } = string.Empty;
    public string ExpectedOutput { get; set; } = string.Empty;
    public string ActualOutput { get; set; } = string.Empty;
    public string? Error { get; set; }
    public string Status { get; set; } = string.Empty;
    public bool Passed { get; set; }
    public bool IsHidden { get; set; }
    public int ExecutionTimeMs { get; set; }
    public int RuntimeMs { get; set; }
}

public sealed class CodeSubmissionResponse
{
    public long Id { get; set; }
    public long? ProblemId { get; set; }
    public string ProblemTitle { get; set; } = string.Empty;
    public string Language { get; set; } = string.Empty;
    public string SourceCode { get; set; } = string.Empty;
    public string Code { get; set; } = string.Empty;
    public string SubmittedCode { get; set; } = string.Empty;
    public string UserCode { get; set; } = string.Empty;
    public string? Stdin { get; set; }
    public string Status { get; set; } = string.Empty;
    public string Verdict { get; set; } = string.Empty;
    public string Output { get; set; } = string.Empty;
    public string Stdout { get; set; } = string.Empty;
    public string Error { get; set; } = string.Empty;
    public string Stderr { get; set; } = string.Empty;
    public string CompileOutput { get; set; } = string.Empty;
    public decimal? Score { get; set; }
    public int ExecutionTimeMs { get; set; }
    public int RuntimeMs { get; set; }
    public int MemoryUsedKb { get; set; }
    public int MemoryKb { get; set; }
    public int PassedTestCases { get; set; }
    public int TotalTestCases { get; set; }
    public bool IsAccepted { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime SubmittedAt { get; set; }
    public List<CodeTestCaseResultResponse> TestCaseResults { get; set; } = new();
}

public sealed class CodeSubmissionListQuery
{
    public long? ProblemId { get; set; }
    public string? Verdict { get; set; }
    public string? Language { get; set; }
    public int PageIndex { get; set; } = 1;
    public int PageSize { get; set; } = 20;
}
