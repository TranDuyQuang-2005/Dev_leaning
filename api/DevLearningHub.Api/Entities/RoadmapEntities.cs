namespace DevLearningHub.Api.Entities;

public sealed class LearningTrack
{
    public long Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Slug { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string Level { get; set; } = "Beginner";
    public int EstimatedHours { get; set; }
    public string? ThumbnailUrl { get; set; }
    public int SortOrder { get; set; }
    public bool IsPublished { get; set; } = true;
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public bool IsDeleted { get; set; }
    public ICollection<RoadmapCourse> Courses { get; set; } = new List<RoadmapCourse>();
}

public sealed class RoadmapCourse
{
    public long Id { get; set; }
    public long TrackId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Slug { get; set; } = string.Empty;
    public string? ShortDescription { get; set; }
    public string? Description { get; set; }
    public string Level { get; set; } = "Beginner";
    public int EstimatedHours { get; set; }
    public int TotalModules { get; set; }
    public int TotalLessons { get; set; }
    public string? RequirementsJson { get; set; }
    public string? LearningOutcomesJson { get; set; }
    public string? RelatedCourseIdsJson { get; set; }
    public string? PrerequisiteCourseIdsJson { get; set; }
    public string? ThumbnailUrl { get; set; }
    public int SortOrder { get; set; }
    public bool IsPublished { get; set; } = true;
    public bool RequiresSequentialCompletion { get; set; } = true;
    public long? UnlockAfterCourseId { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public bool IsDeleted { get; set; }
    public LearningTrack Track { get; set; } = null!;
    public ICollection<RoadmapModule> Modules { get; set; } = new List<RoadmapModule>();
}

public sealed class RoadmapModule
{
    public long Id { get; set; }
    public long CourseId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string? Description { get; set; }
    public int SortOrder { get; set; }
    public int EstimatedMinutes { get; set; }
    public bool RequiresPreviousModuleCompletion { get; set; } = true;
    public bool IsLockedByDefault { get; set; }
    public bool IsPublished { get; set; } = true;
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public bool IsDeleted { get; set; }
    public RoadmapCourse Course { get; set; } = null!;
    public ICollection<RoadmapLesson> Lessons { get; set; } = new List<RoadmapLesson>();
}

public sealed class RoadmapLesson
{
    public long Id { get; set; }
    public long ModuleId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Type { get; set; } = "Reading";
    public string? Content { get; set; }
    public string? VideoUrl { get; set; }
    public long? QuizSetId { get; set; }
    public long? CodingProblemId { get; set; }
    public int EstimatedMinutes { get; set; }
    public int SortOrder { get; set; }
    public bool IsPreview { get; set; }
    public bool IsPublished { get; set; } = true;
    public bool RequiresPreviousLessonCompletion { get; set; } = true;
    public bool IsRequired { get; set; } = true;
    public long? UnlockAfterLessonId { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public bool IsDeleted { get; set; }
    public RoadmapModule Module { get; set; } = null!;
}

public sealed class UserLessonProgress
{
    public long Id { get; set; }
    public long UserId { get; set; }
    public long LessonId { get; set; }
    public string Status { get; set; } = "NotStarted";
    public DateTime? StartedAt { get; set; }
    public DateTime? CompletedAt { get; set; }
    public DateTime? LastAccessedAt { get; set; }
    public User User { get; set; } = null!;
    public RoadmapLesson Lesson { get; set; } = null!;
}
