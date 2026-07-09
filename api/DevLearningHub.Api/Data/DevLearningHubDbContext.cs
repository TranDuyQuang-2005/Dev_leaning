using DevLearningHub.Api.Entities;
using Microsoft.EntityFrameworkCore;

namespace DevLearningHub.Api.Data;

public sealed class DevLearningHubDbContext : DbContext
{
    public DevLearningHubDbContext(DbContextOptions<DevLearningHubDbContext> options) : base(options) {}

    public DbSet<User> Users => Set<User>();
    public DbSet<Role> Roles => Set<Role>();
    public DbSet<Permission> Permissions => Set<Permission>();
    public DbSet<PermissionGroup> PermissionGroups => Set<PermissionGroup>();
    public DbSet<PermissionGroupPermission> PermissionGroupPermissions => Set<PermissionGroupPermission>();
    public DbSet<UserRole> UserRoles => Set<UserRole>();
    public DbSet<UserPermission> UserPermissions => Set<UserPermission>();
    public DbSet<UserPermissionGroup> UserPermissionGroups => Set<UserPermissionGroup>();
    public DbSet<RolePermission> RolePermissions => Set<RolePermission>();
    public DbSet<RolePermissionGroup> RolePermissionGroups => Set<RolePermissionGroup>();
    public DbSet<RefreshToken> RefreshTokens => Set<RefreshToken>();
    public DbSet<PasswordResetToken> PasswordResetTokens => Set<PasswordResetToken>();
    public DbSet<EmailVerificationToken> EmailVerificationTokens => Set<EmailVerificationToken>();
    public DbSet<Notification> Notifications => Set<Notification>();

    public DbSet<UserProfile> UserProfiles => Set<UserProfile>();
    public DbSet<UserLearningProfile> UserLearningProfiles => Set<UserLearningProfile>();
    public DbSet<UserStat> UserStats => Set<UserStat>();
    public DbSet<UserSetting> UserSettings => Set<UserSetting>();
    public DbSet<UserDailyActivity> UserDailyActivities => Set<UserDailyActivity>();

    public DbSet<Category> Categories => Set<Category>();
    public DbSet<Question> Questions => Set<Question>();
    public DbSet<QuestionOption> QuestionOptions => Set<QuestionOption>();
    public DbSet<QuizSet> QuizSets => Set<QuizSet>();
    public DbSet<QuizSetQuestion> QuizSetQuestions => Set<QuizSetQuestion>();
    public DbSet<QuizAttempt> QuizAttempts => Set<QuizAttempt>();
    public DbSet<QuizAttemptAnswer> QuizAttemptAnswers => Set<QuizAttemptAnswer>();
    public DbSet<QuizAttemptAnswerOption> QuizAttemptAnswerOptions => Set<QuizAttemptAnswerOption>();
    public DbSet<Roadmap> Roadmaps => Set<Roadmap>();
    public DbSet<LearningTrack> LearningTracks => Set<LearningTrack>();
    public DbSet<RoadmapCourse> RoadmapCourses => Set<RoadmapCourse>();
    public DbSet<RoadmapModule> RoadmapModules => Set<RoadmapModule>();
    public DbSet<RoadmapLesson> RoadmapLessons => Set<RoadmapLesson>();
    public DbSet<UserLessonProgress> UserLessonProgresses => Set<UserLessonProgress>();

    public DbSet<AppFile> Files => Set<AppFile>();
    public DbSet<FileReference> FileReferences => Set<FileReference>();
    public DbSet<QuestionImportBatch> QuestionImportBatches => Set<QuestionImportBatch>();
    public DbSet<AuditLog> AuditLogs => Set<AuditLog>();
    public DbSet<PersonalQuestionBank> PersonalQuestionBanks => Set<PersonalQuestionBank>();
    public DbSet<PersonalQuestion> PersonalQuestions => Set<PersonalQuestion>();
    public DbSet<PersonalQuestionOption> PersonalQuestionOptions => Set<PersonalQuestionOption>();
    public DbSet<PersonalPracticeAttempt> PersonalPracticeAttempts => Set<PersonalPracticeAttempt>();
    public DbSet<PersonalPracticeAttemptAnswer> PersonalPracticeAttemptAnswers => Set<PersonalPracticeAttemptAnswer>();

    public DbSet<Tag> Tags => Set<Tag>();
    public DbSet<Post> Posts => Set<Post>();
    public DbSet<Comment> Comments => Set<Comment>();
    public DbSet<PostTag> PostTags => Set<PostTag>();
    public DbSet<PostVote> PostVotes => Set<PostVote>();
    public DbSet<CommentVote> CommentVotes => Set<CommentVote>();
    public DbSet<PostBookmark> PostBookmarks => Set<PostBookmark>();
    public DbSet<Report> Reports => Set<Report>();
    public DbSet<ModerationAction> ModerationActions => Set<ModerationAction>();

    public DbSet<CodingProblem> CodingProblems => Set<CodingProblem>();
    public DbSet<CodingTestCase> CodingTestCases => Set<CodingTestCase>();
    public DbSet<CodeSubmission> CodeSubmissions => Set<CodeSubmission>();
    public DbSet<CodeSubmissionTestCaseResult> CodeSubmissionTestCaseResults => Set<CodeSubmissionTestCaseResult>();

    protected override void OnModelCreating(ModelBuilder b)
    {
        b.Entity<User>(e => {
            e.ToTable("Users"); e.HasKey(x => x.Id);
            e.Property(x => x.FullName).HasMaxLength(150).IsRequired();
            e.Property(x => x.UserName).HasMaxLength(100).IsRequired();
            e.Property(x => x.Email).HasMaxLength(255).IsRequired();
            e.Property(x => x.PasswordHash).HasMaxLength(500);
            e.HasIndex(x => x.Email).IsUnique();
            e.HasIndex(x => x.UserName).IsUnique();
        });

        b.Entity<Role>(e => {
            e.ToTable("Roles"); e.HasKey(x => x.Id);
            e.Property(x => x.Name).HasMaxLength(50).IsRequired();
            e.Property(x => x.NormalizedName).HasMaxLength(50).IsRequired();
            e.HasIndex(x => x.Name).IsUnique();
            e.HasIndex(x => x.NormalizedName).IsUnique();
        });

        b.Entity<Permission>(e => {
            e.ToTable("Permissions"); e.HasKey(x => x.Id);
            e.Property(x => x.Code).HasMaxLength(100).IsRequired();
            e.Property(x => x.Module).HasMaxLength(100).IsRequired();
            e.HasIndex(x => x.Code).IsUnique();
        });

        b.Entity<PermissionGroup>(e => {
            e.ToTable("PermissionGroups"); e.HasKey(x => x.Id);
            e.Property(x => x.Name).HasMaxLength(150).IsRequired();
            e.Property(x => x.Code).HasMaxLength(100).IsRequired();
            e.Property(x => x.Description).HasMaxLength(500);
            e.HasIndex(x => x.Code).IsUnique();
        });

        b.Entity<PermissionGroupPermission>(e => {
            e.ToTable("PermissionGroupPermissions"); e.HasKey(x => new { x.PermissionGroupId, x.PermissionId });
            e.HasOne(x => x.PermissionGroup).WithMany(x => x.PermissionGroupPermissions).HasForeignKey(x => x.PermissionGroupId);
            e.HasOne(x => x.Permission).WithMany(x => x.PermissionGroupPermissions).HasForeignKey(x => x.PermissionId);
        });

        b.Entity<RolePermissionGroup>(e => {
            e.ToTable("RolePermissionGroups"); e.HasKey(x => new { x.RoleId, x.PermissionGroupId });
            e.HasOne(x => x.Role).WithMany(x => x.RolePermissionGroups).HasForeignKey(x => x.RoleId);
            e.HasOne(x => x.PermissionGroup).WithMany(x => x.RolePermissionGroups).HasForeignKey(x => x.PermissionGroupId);
        });

        b.Entity<UserPermissionGroup>(e => {
            e.ToTable("UserPermissionGroups"); e.HasKey(x => new { x.UserId, x.PermissionGroupId });
            e.HasOne(x => x.User).WithMany(x => x.UserPermissionGroups).HasForeignKey(x => x.UserId);
            e.HasOne(x => x.PermissionGroup).WithMany(x => x.UserPermissionGroups).HasForeignKey(x => x.PermissionGroupId);
        });

        b.Entity<UserRole>(e => {
            e.ToTable("UserRoles"); e.HasKey(x => new { x.UserId, x.RoleId });
            e.HasOne(x => x.User).WithMany(x => x.UserRoles).HasForeignKey(x => x.UserId);
            e.HasOne(x => x.Role).WithMany(x => x.UserRoles).HasForeignKey(x => x.RoleId);
        });

        b.Entity<RolePermission>(e => {
            e.ToTable("RolePermissions"); e.HasKey(x => new { x.RoleId, x.PermissionId });
            e.HasOne(x => x.Role).WithMany(x => x.RolePermissions).HasForeignKey(x => x.RoleId);
            e.HasOne(x => x.Permission).WithMany(x => x.RolePermissions).HasForeignKey(x => x.PermissionId);
        });

        b.Entity<UserPermission>(e => {
            e.ToTable("UserPermissions"); e.HasKey(x => new { x.UserId, x.PermissionId });
            e.HasOne(x => x.User).WithMany(x => x.UserPermissions).HasForeignKey(x => x.UserId);
            e.HasOne(x => x.Permission).WithMany(x => x.UserPermissions).HasForeignKey(x => x.PermissionId);
        });

        b.Entity<RefreshToken>(e => {
            e.ToTable("RefreshTokens"); e.HasKey(x => x.Id);
            e.Property(x => x.TokenHash).HasMaxLength(500).IsRequired();
            e.HasOne(x => x.User).WithMany(x => x.RefreshTokens).HasForeignKey(x => x.UserId);
        });

        b.Entity<PasswordResetToken>(e => {
            e.ToTable("PasswordResetTokens"); e.HasKey(x => x.Id);
            e.Property(x => x.TokenHash).HasMaxLength(500).IsRequired();
            e.HasIndex(x => new { x.UserId, x.TokenHash }).IsUnique();
            e.HasOne(x => x.User).WithMany().HasForeignKey(x => x.UserId);
        });

        b.Entity<EmailVerificationToken>(e => {
            e.ToTable("EmailVerificationTokens"); e.HasKey(x => x.Id);
            e.Property(x => x.TokenHash).HasMaxLength(500).IsRequired();
            e.HasIndex(x => new { x.UserId, x.TokenHash }).IsUnique();
            e.HasOne(x => x.User).WithMany().HasForeignKey(x => x.UserId);
        });

        b.Entity<Notification>(e => {
            e.ToTable("Notifications"); e.HasKey(x => x.Id);
            e.Property(x => x.Type).HasMaxLength(100).IsRequired();
            e.Property(x => x.Title).HasMaxLength(255).IsRequired();
            e.Property(x => x.Message).HasMaxLength(1000).IsRequired();
            e.Property(x => x.LinkUrl).HasMaxLength(500);
            e.HasIndex(x => x.UserId);
            e.HasIndex(x => x.IsRead);
            e.HasIndex(x => x.CreatedAt);
            e.HasIndex(x => new { x.UserId, x.IsRead, x.CreatedAt });
            e.HasOne(x => x.User).WithMany(x => x.Notifications).HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.NoAction);
        });

        b.Entity<UserProfile>(e => { e.ToTable("UserProfiles"); e.HasKey(x => x.UserId); });
        b.Entity<UserLearningProfile>(e => { e.ToTable("UserLearningProfiles"); e.HasKey(x => x.UserId); });
        b.Entity<UserStat>(e => { e.ToTable("UserStats"); e.HasKey(x => x.UserId); e.Property(x => x.AverageQuizScore).HasColumnType("decimal(5,2)"); });
        b.Entity<UserSetting>(e => { e.ToTable("UserSettings"); e.HasKey(x => x.UserId); });
        b.Entity<UserDailyActivity>(e => { e.ToTable("UserDailyActivities"); e.HasKey(x => x.Id); e.Property(x => x.ActivityDate).HasColumnType("date"); });

        b.Entity<Category>(e => {
            e.ToTable("Categories"); e.HasKey(x => x.Id);
            e.Property(x => x.Name).HasMaxLength(100).IsRequired();
            e.Property(x => x.Slug).HasMaxLength(150).IsRequired();
            e.HasOne(x => x.Parent).WithMany().HasForeignKey(x => x.ParentId);
        });

        b.Entity<Question>(e => {
            e.ToTable("Questions"); e.HasKey(x => x.Id);
            e.Property(x => x.Title).HasMaxLength(255).IsRequired();
            e.Property(x => x.Content).IsRequired();
            e.HasOne(x => x.Category).WithMany().HasForeignKey(x => x.CategoryId);
        });

        b.Entity<QuestionOption>(e => {
            e.ToTable("QuestionOptions"); e.HasKey(x => x.Id);
            e.Property(x => x.Content).IsRequired();
            e.HasOne(x => x.Question).WithMany(x => x.Options).HasForeignKey(x => x.QuestionId);
        });

        b.Entity<QuizSet>(e => {
            e.ToTable("QuizSets"); e.HasKey(x => x.Id);
            e.Property(x => x.Title).HasMaxLength(255).IsRequired();
            e.Property(x => x.Slug).HasMaxLength(255).IsRequired();
            e.Property(x => x.PassingScore).HasColumnType("decimal(5,2)");
        });

        b.Entity<QuizSetQuestion>(e => {
            e.ToTable("QuizSetQuestions"); e.HasKey(x => new { x.QuizSetId, x.QuestionId });
            e.Property(x => x.Score).HasColumnType("decimal(5,2)");
            e.HasOne(x => x.QuizSet).WithMany(x => x.QuizSetQuestions).HasForeignKey(x => x.QuizSetId);
            e.HasOne(x => x.Question).WithMany().HasForeignKey(x => x.QuestionId);
        });

        b.Entity<QuizAttempt>(e => {
            e.ToTable("QuizAttempts"); e.HasKey(x => x.Id);
            e.Property(x => x.Score).HasColumnType("decimal(6,2)");
            e.HasOne(x => x.QuizSet).WithMany().HasForeignKey(x => x.QuizSetId);
        });

        b.Entity<QuizAttemptAnswer>(e => {
            e.ToTable("QuizAttemptAnswers"); e.HasKey(x => x.Id);
            e.Property(x => x.Score).HasColumnType("decimal(5,2)");
            e.HasOne(x => x.QuizAttempt).WithMany(x => x.Answers).HasForeignKey(x => x.QuizAttemptId);
            e.HasOne(x => x.Question).WithMany().HasForeignKey(x => x.QuestionId);
        });

        b.Entity<QuizAttemptAnswerOption>(e => {
            e.ToTable("QuizAttemptAnswerOptions"); e.HasKey(x => new { x.QuizAttemptAnswerId, x.QuestionOptionId });
            e.HasOne(x => x.QuizAttemptAnswer).WithMany(x => x.SelectedOptions).HasForeignKey(x => x.QuizAttemptAnswerId);
            e.HasOne(x => x.QuestionOption).WithMany().HasForeignKey(x => x.QuestionOptionId);
        });

        b.Entity<Roadmap>(e => { e.ToTable("Roadmaps"); e.HasKey(x => x.Id); });

        b.Entity<LearningTrack>(e => {
            e.ToTable("LearningTracks"); e.HasKey(x => x.Id);
            e.Property(x => x.Title).HasMaxLength(255).IsRequired();
            e.Property(x => x.Slug).HasMaxLength(255).IsRequired();
            e.Property(x => x.Level).HasMaxLength(50).IsRequired();
            e.Property(x => x.ThumbnailUrl).HasMaxLength(500);
            e.HasIndex(x => x.Slug).IsUnique();
            e.HasIndex(x => new { x.IsPublished, x.IsDeleted, x.SortOrder });
        });

        b.Entity<RoadmapCourse>(e => {
            e.ToTable("RoadmapCourses"); e.HasKey(x => x.Id);
            e.Property(x => x.Title).HasMaxLength(255).IsRequired();
            e.Property(x => x.Slug).HasMaxLength(255).IsRequired();
            e.Property(x => x.ShortDescription).HasMaxLength(500);
            e.Property(x => x.Level).HasMaxLength(50).IsRequired();
            e.Property(x => x.ThumbnailUrl).HasMaxLength(500);
            e.HasIndex(x => x.Slug).IsUnique();
            e.HasIndex(x => new { x.TrackId, x.IsPublished, x.IsDeleted, x.SortOrder });
            e.HasOne(x => x.Track).WithMany(x => x.Courses).HasForeignKey(x => x.TrackId).OnDelete(DeleteBehavior.Restrict);
        });

        b.Entity<RoadmapModule>(e => {
            e.ToTable("RoadmapModules"); e.HasKey(x => x.Id);
            e.Property(x => x.Title).HasMaxLength(255).IsRequired();
            e.HasIndex(x => new { x.CourseId, x.IsPublished, x.IsDeleted, x.SortOrder });
            e.HasOne(x => x.Course).WithMany(x => x.Modules).HasForeignKey(x => x.CourseId).OnDelete(DeleteBehavior.Cascade);
        });

        b.Entity<RoadmapLesson>(e => {
            e.ToTable("RoadmapLessons"); e.HasKey(x => x.Id);
            e.Property(x => x.Title).HasMaxLength(255).IsRequired();
            e.Property(x => x.Type).HasMaxLength(50).IsRequired();
            e.Property(x => x.VideoUrl).HasMaxLength(500);
            e.HasIndex(x => new { x.ModuleId, x.IsPublished, x.IsDeleted, x.SortOrder });
            e.HasIndex(x => x.QuizSetId);
            e.HasIndex(x => x.CodingProblemId);
            e.HasOne(x => x.Module).WithMany(x => x.Lessons).HasForeignKey(x => x.ModuleId).OnDelete(DeleteBehavior.Cascade);
            e.HasOne<QuizSet>().WithMany().HasForeignKey(x => x.QuizSetId).OnDelete(DeleteBehavior.NoAction);
            e.HasOne<CodingProblem>().WithMany().HasForeignKey(x => x.CodingProblemId).OnDelete(DeleteBehavior.NoAction);
        });

        b.Entity<UserLessonProgress>(e => {
            e.ToTable("UserLessonProgresses"); e.HasKey(x => x.Id);
            e.Property(x => x.Status).HasMaxLength(30).IsRequired();
            e.HasIndex(x => new { x.UserId, x.LessonId }).IsUnique();
            e.HasIndex(x => x.Status);
            e.HasOne(x => x.User).WithMany().HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Cascade);
            e.HasOne(x => x.Lesson).WithMany().HasForeignKey(x => x.LessonId).OnDelete(DeleteBehavior.Cascade);
        });

        b.Entity<AppFile>(e => { e.ToTable("Files"); e.HasKey(x => x.Id); });
        b.Entity<FileReference>(e => { e.ToTable("FileReferences"); e.HasKey(x => x.Id); });
        b.Entity<QuestionImportBatch>(e => { e.ToTable("QuestionImportBatches"); e.HasKey(x => x.Id); });
        b.Entity<AuditLog>(e => { e.ToTable("AuditLogs"); e.HasKey(x => x.Id); });

        b.Entity<PersonalQuestionBank>(e => {
            e.ToTable("PersonalQuestionBanks"); e.HasKey(x => x.Id);
            e.Property(x => x.Title).HasMaxLength(255).IsRequired();
            e.Property(x => x.OriginalFileName).HasMaxLength(255).IsRequired();
            e.Property(x => x.FileStorageKey).HasMaxLength(500).IsRequired();
            e.Property(x => x.Visibility).HasMaxLength(30).IsRequired();
            e.HasIndex(x => new { x.UserId, x.IsDeleted });
            e.HasOne(x => x.User).WithMany().HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Restrict);
        });

        b.Entity<PersonalQuestion>(e => {
            e.ToTable("PersonalQuestions"); e.HasKey(x => x.Id);
            e.Property(x => x.QuestionText).IsRequired();
            e.Property(x => x.QuestionType).HasMaxLength(50).IsRequired();
            e.Property(x => x.Difficulty).HasMaxLength(30).IsRequired();
            e.Property(x => x.Tags).HasMaxLength(500);
            e.HasIndex(x => new { x.UserId, x.BankId, x.IsDeleted });
            e.HasOne(x => x.Bank).WithMany(x => x.Questions).HasForeignKey(x => x.BankId).OnDelete(DeleteBehavior.Cascade);
        });

        b.Entity<PersonalQuestionOption>(e => {
            e.ToTable("PersonalQuestionOptions"); e.HasKey(x => x.Id);
            e.Property(x => x.Label).HasMaxLength(5).IsRequired();
            e.Property(x => x.Text).IsRequired();
            e.HasOne(x => x.Question).WithMany(x => x.Options).HasForeignKey(x => x.QuestionId).OnDelete(DeleteBehavior.Cascade);
        });

        b.Entity<PersonalPracticeAttempt>(e => {
            e.ToTable("PersonalPracticeAttempts"); e.HasKey(x => x.Id);
            e.Property(x => x.Score).HasColumnType("decimal(6,2)");
            e.Property(x => x.Status).HasMaxLength(30).IsRequired();
            e.HasIndex(x => new { x.UserId, x.BankId });
            e.HasOne(x => x.Bank).WithMany(x => x.Attempts).HasForeignKey(x => x.BankId).OnDelete(DeleteBehavior.Restrict);
        });

        b.Entity<PersonalPracticeAttemptAnswer>(e => {
            e.ToTable("PersonalPracticeAttemptAnswers"); e.HasKey(x => x.Id);
            e.Property(x => x.SelectedOptionLabel).HasMaxLength(5);
            e.HasOne(x => x.Attempt).WithMany(x => x.Answers).HasForeignKey(x => x.AttemptId).OnDelete(DeleteBehavior.Cascade);
            e.HasOne(x => x.Question).WithMany().HasForeignKey(x => x.QuestionId).OnDelete(DeleteBehavior.Restrict);
        });


        b.Entity<Tag>(e => {
            e.ToTable("Tags"); e.HasKey(x => x.Id);
            e.Property(x => x.Name).HasMaxLength(100).IsRequired();
            e.Property(x => x.Slug).HasMaxLength(100).IsRequired();
            e.Property(x => x.Description).HasMaxLength(255);
        });

        b.Entity<Post>(e => {
            e.ToTable("Posts"); e.HasKey(x => x.Id);
            e.Property(x => x.Title).HasMaxLength(255).IsRequired();
            e.Property(x => x.Slug).HasMaxLength(255).IsRequired();
            e.Property(x => x.Content).IsRequired();
            e.HasOne(x => x.Author).WithMany().HasForeignKey(x => x.AuthorId).OnDelete(DeleteBehavior.Restrict);
        });

        b.Entity<Comment>(e => {
            e.ToTable("Comments"); e.HasKey(x => x.Id);
            e.Property(x => x.Content).IsRequired();
            e.HasOne(x => x.Post).WithMany(x => x.Comments).HasForeignKey(x => x.PostId).OnDelete(DeleteBehavior.Cascade);
            e.HasOne(x => x.Author).WithMany().HasForeignKey(x => x.AuthorId).OnDelete(DeleteBehavior.Restrict);
            e.HasOne(x => x.ParentComment).WithMany(x => x.Replies).HasForeignKey(x => x.ParentCommentId).OnDelete(DeleteBehavior.Restrict);
        });

        b.Entity<PostTag>(e => {
            e.ToTable("PostTags"); e.HasKey(x => new { x.PostId, x.TagId });
            e.HasOne(x => x.Post).WithMany(x => x.PostTags).HasForeignKey(x => x.PostId);
            e.HasOne(x => x.Tag).WithMany(x => x.PostTags).HasForeignKey(x => x.TagId);
        });

        b.Entity<PostVote>(e => {
            e.ToTable("PostVotes"); e.HasKey(x => x.Id);
            e.HasIndex(x => new { x.PostId, x.UserId }).IsUnique();
            e.HasOne(x => x.Post).WithMany(x => x.Votes).HasForeignKey(x => x.PostId);
            e.HasOne(x => x.User).WithMany().HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Restrict);
        });

        b.Entity<CommentVote>(e => {
            e.ToTable("CommentVotes"); e.HasKey(x => x.Id);
            e.HasIndex(x => new { x.CommentId, x.UserId }).IsUnique();
            e.HasOne(x => x.Comment).WithMany(x => x.Votes).HasForeignKey(x => x.CommentId);
            e.HasOne(x => x.User).WithMany().HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Restrict);
        });

        b.Entity<PostBookmark>(e => {
            e.ToTable("PostBookmarks"); e.HasKey(x => new { x.PostId, x.UserId });
            e.HasOne(x => x.Post).WithMany(x => x.Bookmarks).HasForeignKey(x => x.PostId);
            e.HasOne(x => x.User).WithMany().HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Restrict);
        });

        b.Entity<Report>(e => {
            e.ToTable("Reports"); e.HasKey(x => x.Id);
            e.Property(x => x.TargetType).HasMaxLength(50).IsRequired();
            e.Property(x => x.Reason).HasMaxLength(255).IsRequired();
            e.HasOne(x => x.Reporter).WithMany().HasForeignKey(x => x.ReporterId).OnDelete(DeleteBehavior.Restrict);
        });

        b.Entity<ModerationAction>(e => {
            e.ToTable("ModerationActions"); e.HasKey(x => x.Id);
            e.Property(x => x.TargetType).HasMaxLength(50).IsRequired();
            e.Property(x => x.ActionType).HasMaxLength(100).IsRequired();
        });


        b.Entity<CodingProblem>(e => {
            e.ToTable("CodingProblems"); e.HasKey(x => x.Id);
            e.Property(x => x.Title).HasMaxLength(255).IsRequired();
            e.Property(x => x.Slug).HasMaxLength(255).IsRequired();
            e.Property(x => x.Description).IsRequired();
            e.Property(x => x.Tags).HasMaxLength(500);
            e.Property(x => x.InputFormat).HasMaxLength(1000);
            e.Property(x => x.OutputFormat).HasMaxLength(1000);
            e.Property(x => x.Constraints).HasMaxLength(2000);
            e.HasOne(x => x.CreatedByUser).WithMany().HasForeignKey(x => x.CreatedByUserId).OnDelete(DeleteBehavior.Restrict);
            e.HasIndex(x => x.Slug).IsUnique();
        });

        b.Entity<CodingTestCase>(e => {
            e.ToTable("CodingTestCases"); e.HasKey(x => x.Id);
            e.Property(x => x.Input).IsRequired();
            e.Property(x => x.ExpectedOutput).IsRequired();
            e.HasOne(x => x.Problem).WithMany(x => x.TestCases).HasForeignKey(x => x.ProblemId).OnDelete(DeleteBehavior.Cascade);
        });

        b.Entity<CodeSubmission>(e => {
            e.ToTable("CodeSubmissions"); e.HasKey(x => x.Id);
            e.Property(x => x.Language).HasMaxLength(50).IsRequired();
            e.Property(x => x.SourceCode).IsRequired();
            e.Property(x => x.Status).HasMaxLength(50).IsRequired();
            e.Property(x => x.Verdict).HasMaxLength(100).IsRequired();
            e.HasOne(x => x.User).WithMany().HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Restrict);
            e.HasOne(x => x.Problem).WithMany(x => x.Submissions).HasForeignKey(x => x.ProblemId).OnDelete(DeleteBehavior.Restrict);
        });

        b.Entity<CodeSubmissionTestCaseResult>(e => {
            e.ToTable("CodeSubmissionTestCaseResults"); e.HasKey(x => x.Id);
            e.Property(x => x.Status).HasMaxLength(50).IsRequired();
            e.HasOne(x => x.Submission).WithMany(x => x.TestCaseResults).HasForeignKey(x => x.SubmissionId).OnDelete(DeleteBehavior.Cascade);
            e.HasOne(x => x.TestCase).WithMany().HasForeignKey(x => x.TestCaseId).OnDelete(DeleteBehavior.Restrict);
        });
    }
}
