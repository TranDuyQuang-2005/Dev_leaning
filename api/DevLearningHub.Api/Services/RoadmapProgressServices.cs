using System.Text.Json;
using DevLearningHub.Api.Data;
using DevLearningHub.Api.DTOs;
using DevLearningHub.Api.Entities;
using Microsoft.EntityFrameworkCore;

namespace DevLearningHub.Api.Services;

public interface IRoadmapProgressService
{
    Task<LessonAccessResult> CanStartLessonAsync(long userId, long lessonId, CancellationToken ct);
    Task<LessonAccessResult> CanCompleteLessonAsync(long userId, long lessonId, CancellationToken ct);
    Task<LessonAccessResult> CanAccessQuizLessonAsync(long userId, long lessonId, long quizSetId, CancellationToken ct);
    Task<LessonAccessResult> CanAccessCodeLessonAsync(long userId, long lessonId, long codingProblemId, CancellationToken ct);
    Task<RoadmapLockStateResponse> GetLessonLockStateAsync(long userId, long lessonId, CancellationToken ct);
    Task CompleteQuizLessonIfPassedAsync(long userId, long quizSetId, long quizAttemptId, decimal score, CancellationToken ct);
    Task CompleteQuizLessonIfPassedAsync(long userId, long lessonId, long quizSetId, long quizAttemptId, decimal score, CancellationToken ct);
    Task CompleteCodeLessonIfAcceptedAsync(long userId, long codingProblemId, long submissionId, CancellationToken ct);
    Task CompleteCodeLessonIfAcceptedAsync(long userId, long lessonId, long codingProblemId, long submissionId, CancellationToken ct);
}

public sealed class RoadmapProgressService : IRoadmapProgressService
{
    private const string LessonLockedMessage = "Bài học đang bị khóa. Hãy hoàn thành bài học trước đó.";
    private const string QuizLockedMessage = "Bài quiz đang bị khóa. Hãy hoàn thành bài học trước đó.";
    private const string CodeLockedMessage = "Bài code practice đang bị khóa. Hãy hoàn thành bài học trước đó.";
    private static readonly JsonSerializerOptions JsonOptions = new(JsonSerializerDefaults.Web);

    private readonly DevLearningHubDbContext _db;

    public RoadmapProgressService(DevLearningHubDbContext db)
    {
        _db = db;
    }

    public async Task<LessonAccessResult> CanStartLessonAsync(long userId, long lessonId, CancellationToken ct)
    {
        var state = await GetLessonState(userId, lessonId, includeUnpublished: false, ct);
        if (state == null) return await MissingLessonAccess(lessonId, ct);

        var courseId = await GetLessonCourseId(lessonId, ct);
        if (!state.CanStart)
            return DenyLessonAccess(lessonId, courseId, state.IsLocked, state.LockReason ?? LessonLockedMessage);

        return AllowLessonAccess(lessonId, courseId);
    }

    public async Task<LessonAccessResult> CanCompleteLessonAsync(long userId, long lessonId, CancellationToken ct)
    {
        var state = await GetLessonState(userId, lessonId, includeUnpublished: false, ct);
        if (state == null) return await MissingLessonAccess(lessonId, ct);

        var courseId = await GetLessonCourseId(lessonId, ct);
        if (state.IsLocked)
            return DenyLessonAccess(lessonId, courseId, true, state.LockReason ?? LessonLockedMessage);
        if (!state.CanComplete && state.Status != "Completed")
            return DenyLessonAccess(lessonId, courseId, false, state.LockReason ?? "Bài học chưa thể hoàn thành ở trạng thái hiện tại.");

        return AllowLessonAccess(lessonId, courseId);
    }

    public async Task<LessonAccessResult> CanAccessQuizLessonAsync(long userId, long lessonId, long quizSetId, CancellationToken ct)
    {
        var lesson = await GetPublishedLessonHeader(lessonId, ct);
        if (lesson == null) return DenyLessonAccess(lessonId, null, false, "Không tìm thấy bài học");
        if (!lesson.Type.Equals("Quiz", StringComparison.OrdinalIgnoreCase))
            return DenyLessonAccess(lessonId, lesson.Module.CourseId, false, "Bài học không phải Quiz");
        if (lesson.QuizSetId != quizSetId)
            return DenyLessonAccess(lessonId, lesson.Module.CourseId, false, "QuizSetId không khớp với bài học roadmap");

        var access = await CanStartLessonAsync(userId, lessonId, ct);
        if (!access.CanAccess)
            access.Message = access.IsLocked ? QuizLockedMessage : access.Message;
        return access;
    }

    public async Task<LessonAccessResult> CanAccessCodeLessonAsync(long userId, long lessonId, long codingProblemId, CancellationToken ct)
    {
        var lesson = await GetPublishedLessonHeader(lessonId, ct);
        if (lesson == null) return DenyLessonAccess(lessonId, null, false, "Không tìm thấy bài học");
        if (!lesson.Type.Equals("CodePractice", StringComparison.OrdinalIgnoreCase))
            return DenyLessonAccess(lessonId, lesson.Module.CourseId, false, "Bài học không phải CodePractice");
        if (lesson.CodingProblemId != codingProblemId)
            return DenyLessonAccess(lessonId, lesson.Module.CourseId, false, "CodingProblemId không khớp với bài học roadmap");

        var access = await CanStartLessonAsync(userId, lessonId, ct);
        if (!access.CanAccess)
            access.Message = access.IsLocked ? CodeLockedMessage : access.Message;
        return access;
    }

    public async Task<RoadmapLockStateResponse> GetLessonLockStateAsync(long userId, long lessonId, CancellationToken ct)
    {
        var state = await GetLessonState(userId, lessonId, includeUnpublished: false, ct);
        if (state == null) return Locked("Không tìm thấy bài học");

        return new RoadmapLockStateResponse
        {
            IsLocked = state.IsLocked,
            LockReason = state.LockReason,
            UnlockRequirements = state.UnlockRequirements,
            IsCompleted = state.Status == "Completed"
        };
    }

    public async Task CompleteQuizLessonIfPassedAsync(long userId, long quizSetId, long quizAttemptId, decimal score, CancellationToken ct)
    {
        var lessonIds = await _db.RoadmapLessons.AsNoTracking()
            .Where(x => !x.IsDeleted && x.IsPublished && x.Type == "Quiz" && x.QuizSetId == quizSetId)
            .Select(x => x.Id)
            .ToListAsync(ct);
        await CompleteSystemLessons(userId, lessonIds, ct);
    }

    public async Task CompleteQuizLessonIfPassedAsync(long userId, long lessonId, long quizSetId, long quizAttemptId, decimal score, CancellationToken ct)
    {
        var access = await CanAccessQuizLessonAsync(userId, lessonId, quizSetId, ct);
        if (!access.CanAccess) return;
        await CompleteLessonProgress(userId, lessonId, ct);
    }

    public async Task CompleteCodeLessonIfAcceptedAsync(long userId, long codingProblemId, long submissionId, CancellationToken ct)
    {
        var lessonIds = await _db.RoadmapLessons.AsNoTracking()
            .Where(x => !x.IsDeleted && x.IsPublished && x.Type == "CodePractice" && x.CodingProblemId == codingProblemId)
            .Select(x => x.Id)
            .ToListAsync(ct);
        await CompleteSystemLessons(userId, lessonIds, ct);
    }

    public async Task CompleteCodeLessonIfAcceptedAsync(long userId, long lessonId, long codingProblemId, long submissionId, CancellationToken ct)
    {
        var access = await CanAccessCodeLessonAsync(userId, lessonId, codingProblemId, ct);
        if (!access.CanAccess) return;
        await CompleteLessonProgress(userId, lessonId, ct);
    }

    private async Task CompleteSystemLessons(long userId, List<long> lessonIds, CancellationToken ct)
    {
        foreach (var lessonId in lessonIds.Distinct())
        {
            var state = await GetLessonState(userId, lessonId, includeUnpublished: false, ct);
            if (state is { IsLocked: false })
                await CompleteLessonProgress(userId, lessonId, ct);
        }
    }

    private async Task<RoadmapLessonResponse?> GetLessonState(long userId, long lessonId, bool includeUnpublished, CancellationToken ct)
    {
        var header = await _db.RoadmapLessons.AsNoTracking()
            .Include(x => x.Module).ThenInclude(x => x.Course).ThenInclude(x => x.Track)
            .FirstOrDefaultAsync(x => x.Id == lessonId && !x.IsDeleted, ct);
        if (header == null) return null;

        if (!includeUnpublished
            && (!header.IsPublished
                || header.Module.IsDeleted
                || !header.Module.IsPublished
                || header.Module.Course.IsDeleted
                || !header.Module.Course.IsPublished
                || header.Module.Course.Track.IsDeleted
                || !header.Module.Course.Track.IsPublished))
            return null;

        var course = await _db.RoadmapCourses.AsNoTracking()
            .Include(x => x.Track).ThenInclude(x => x.Courses).ThenInclude(x => x.Modules).ThenInclude(x => x.Lessons)
            .Include(x => x.Modules).ThenInclude(x => x.Lessons)
            .FirstOrDefaultAsync(x => x.Id == header.Module.CourseId && !x.IsDeleted, ct);
        if (course == null) return null;

        var trackCourses = OrderedCourses(course.Track, includeUnpublished).ToList();
        var progress = await BuildProgressLookup(userId, trackCourses, ct);
        var courseLock = CourseLock(course, trackCourses, progress);
        var courseState = new RoadmapCourseSummaryResponse
        {
            IsLocked = courseLock.IsLocked,
            LockReason = courseLock.LockReason,
            UnlockRequirements = courseLock.UnlockRequirements
        };

        var previousModuleCompleted = true;
        foreach (var module in OrderedModules(course, includeUnpublished))
        {
            var lessons = OrderedLessons(module, includeUnpublished).ToList();
            var moduleLock = ModuleLock(module, course, courseState, previousModuleCompleted);
            var previousLessonCompleted = true;
            foreach (var lesson in lessons)
            {
                var mapped = MapLesson(lesson, moduleLock, progress, previousLessonCompleted);
                if (mapped.Id == lessonId) return mapped;
                previousLessonCompleted = mapped.Status == "Completed";
            }

            var required = lessons.Where(x => x.IsRequired).ToList();
            previousModuleCompleted = required.Count > 0
                && required.All(x => progress.Lessons.TryGetValue(x.Id, out var p) && p.Status == "Completed");
        }

        return null;
    }

    private async Task<RoadmapLesson?> GetPublishedLessonHeader(long lessonId, CancellationToken ct)
        => await _db.RoadmapLessons.AsNoTracking()
            .Include(x => x.Module).ThenInclude(x => x.Course).ThenInclude(x => x.Track)
            .FirstOrDefaultAsync(x =>
                x.Id == lessonId
                && !x.IsDeleted
                && x.IsPublished
                && !x.Module.IsDeleted
                && x.Module.IsPublished
                && !x.Module.Course.IsDeleted
                && x.Module.Course.IsPublished
                && x.Module.Course.Track.IsPublished
                && !x.Module.Course.Track.IsDeleted,
                ct);

    private async Task<long?> GetLessonCourseId(long lessonId, CancellationToken ct)
        => await _db.RoadmapLessons.AsNoTracking()
            .Where(x => x.Id == lessonId && !x.IsDeleted)
            .Select(x => (long?)x.Module.CourseId)
            .FirstOrDefaultAsync(ct);

    private async Task<LessonAccessResult> MissingLessonAccess(long lessonId, CancellationToken ct)
        => DenyLessonAccess(lessonId, await GetLessonCourseId(lessonId, ct), false, "Không tìm thấy bài học");

    private static LessonAccessResult AllowLessonAccess(long lessonId, long? courseId)
        => new()
        {
            CanAccess = true,
            IsLocked = false,
            LessonId = lessonId,
            CourseId = courseId
        };

    private static LessonAccessResult DenyLessonAccess(long lessonId, long? courseId, bool isLocked, string message)
        => new()
        {
            CanAccess = false,
            IsLocked = isLocked,
            Message = message,
            LessonId = lessonId,
            CourseId = courseId
        };

    private async Task<UserLessonProgress> UpsertProgress(long userId, long lessonId, string status, CancellationToken ct)
    {
        var progress = await _db.UserLessonProgresses.FirstOrDefaultAsync(x => x.UserId == userId && x.LessonId == lessonId, ct);
        if (progress == null)
        {
            progress = new UserLessonProgress
            {
                UserId = userId,
                LessonId = lessonId,
                Status = status,
                StartedAt = DateTime.UtcNow,
                LastAccessedAt = DateTime.UtcNow
            };
            _db.UserLessonProgresses.Add(progress);
        }
        else if (progress.Status != "Completed")
        {
            progress.Status = status;
            progress.LastAccessedAt = DateTime.UtcNow;
        }

        return progress;
    }

    private async Task CompleteLessonProgress(long userId, long lessonId, CancellationToken ct)
    {
        var progress = await UpsertProgress(userId, lessonId, "Completed", ct);
        progress.Status = "Completed";
        progress.CompletedAt ??= DateTime.UtcNow;
        progress.StartedAt ??= progress.CompletedAt;
        progress.LastAccessedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);
    }

    private async Task<ProgressLookup> BuildProgressLookup(long userId, IEnumerable<RoadmapCourse> courses, CancellationToken ct)
    {
        var courseList = courses.DistinctBy(x => x.Id).ToList();
        var lessonIds = courseList
            .SelectMany(course => course.Modules)
            .SelectMany(module => module.Lessons)
            .Where(x => !x.IsDeleted)
            .Select(x => x.Id)
            .Distinct()
            .ToList();

        var lessonProgress = lessonIds.Count == 0
            ? new List<UserLessonProgress>()
            : await _db.UserLessonProgresses.AsNoTracking()
                .Where(x => x.UserId == userId && lessonIds.Contains(x.LessonId))
                .ToListAsync(ct);

        var lookup = new ProgressLookup
        {
            Lessons = lessonProgress.ToDictionary(x => x.LessonId, x => x),
            Courses = new Dictionary<long, CourseProgressResponse>()
        };

        foreach (var course in courseList)
        {
            lookup.Courses[course.Id] = BuildCourseProgress(course, lookup.Lessons);
        }

        return lookup;
    }

    private static CourseProgressResponse BuildCourseProgress(RoadmapCourse course, Dictionary<long, UserLessonProgress> progressByLesson)
    {
        var lessons = PublishedLessons(course);
        var required = lessons.Where(x => x.IsRequired).ToList();
        var completedCount = lessons.Count(x => progressByLesson.TryGetValue(x.Id, out var p) && p.Status == "Completed");
        var requiredCompleted = required.Count > 0 && required.All(x => progressByLesson.TryGetValue(x.Id, out var p) && p.Status == "Completed");
        var lastAccessed = lessons
            .Select(x => progressByLesson.TryGetValue(x.Id, out var p) ? p.LastAccessedAt : null)
            .Where(x => x.HasValue)
            .Max();

        return new CourseProgressResponse
        {
            CourseId = course.Id,
            CompletedLessons = completedCount,
            TotalLessons = lessons.Count,
            ProgressPercent = Percent(completedCount, lessons.Count),
            IsCompleted = requiredCompleted,
            LastAccessedAt = lastAccessed
        };
    }

    private static RoadmapLessonResponse MapLesson(RoadmapLesson lesson, RoadmapLockStateResponse moduleLock, ProgressLookup progress, bool previousLessonCompleted)
    {
        progress.Lessons.TryGetValue(lesson.Id, out var lessonProgress);
        var status = lessonProgress?.Status ?? "NotStarted";
        var rawLockState = LessonLock(lesson, moduleLock, progress, previousLessonCompleted);
        var isPreviewBypass = lesson.IsPreview && rawLockState.IsLocked;
        var isLocked = rawLockState.IsLocked && !lesson.IsPreview;
        var manualCompletable = IsManualCompletable(lesson.Type);
        return new RoadmapLessonResponse
        {
            Id = lesson.Id,
            ModuleId = lesson.ModuleId,
            Title = lesson.Title,
            Type = lesson.Type,
            Content = lesson.Content,
            VideoUrl = lesson.VideoUrl,
            VideoFileId = lesson.VideoFileId,
            VideoFileUrl = lesson.VideoFileId.HasValue ? VideoFileUrl(lesson.VideoFileId.Value) : null,
            QuizSetId = lesson.QuizSetId,
            CodingProblemId = lesson.CodingProblemId,
            EstimatedMinutes = lesson.EstimatedMinutes,
            SortOrder = lesson.SortOrder,
            IsPreview = lesson.IsPreview,
            IsRequired = lesson.IsRequired,
            IsPublished = lesson.IsPublished,
            RequiresPreviousLessonCompletion = lesson.RequiresPreviousLessonCompletion,
            UnlockAfterLessonId = lesson.UnlockAfterLessonId,
            IsLocked = isLocked,
            LockReason = rawLockState.LockReason,
            UnlockRequirements = rawLockState.UnlockRequirements,
            Status = status,
            CanStart = !rawLockState.IsLocked || lesson.IsPreview,
            CanComplete = !rawLockState.IsLocked && !isPreviewBypass && manualCompletable && status != "Completed"
        };
    }

    private static RoadmapLockStateResponse CourseLock(RoadmapCourse course, List<RoadmapCourse> trackCourses, ProgressLookup progress)
    {
        var prerequisiteIds = ReadLongList(course.PrerequisiteCourseIdsJson);
        if (course.UnlockAfterCourseId.HasValue && !prerequisiteIds.Contains(course.UnlockAfterCourseId.Value))
            prerequisiteIds.Add(course.UnlockAfterCourseId.Value);

        foreach (var prerequisiteId in prerequisiteIds)
        {
            var prereq = trackCourses.FirstOrDefault(x => x.Id == prerequisiteId);
            var prereqProgress = progress.Courses.GetValueOrDefault(prerequisiteId);
            if (prereqProgress?.IsCompleted != true)
            {
                var name = prereq?.Title ?? $"khóa #{prerequisiteId}";
                return Locked($"Hoàn thành khóa {name} trước.", $"Hoàn thành khóa {name}");
            }
        }

        if (course.RequiresSequentialCompletion)
        {
            var index = trackCourses.FindIndex(x => x.Id == course.Id);
            if (index > 0)
            {
                var previous = trackCourses[index - 1];
                if (progress.Courses.GetValueOrDefault(previous.Id)?.IsCompleted != true)
                    return Locked($"Hoàn thành khóa {previous.Title} trước.", $"Hoàn thành khóa {previous.Title}");
            }
        }

        return new RoadmapLockStateResponse();
    }

    private static RoadmapLockStateResponse ModuleLock(RoadmapModule module, RoadmapCourse course, RoadmapCourseSummaryResponse courseState, bool previousModuleCompleted)
    {
        if (courseState.IsLocked)
            return Locked(courseState.LockReason ?? "Khóa học đang bị khóa.", courseState.UnlockRequirements.ToArray());
        if (module.IsLockedByDefault)
            return Locked("Chương này đang được cấu hình khóa.", "Chờ admin mở khóa chương");
        if (course.RequiresSequentialCompletion && module.RequiresPreviousModuleCompletion && module.SortOrder > 1 && !previousModuleCompleted)
            return Locked("Chương này sẽ mở sau khi bạn hoàn thành chương trước.", "Hoàn thành chương trước");
        return new RoadmapLockStateResponse();
    }

    private static RoadmapLockStateResponse LessonLock(RoadmapLesson lesson, RoadmapLockStateResponse moduleLock, ProgressLookup progress, bool previousLessonCompleted)
    {
        if (moduleLock.IsLocked && !lesson.IsPreview)
            return Locked(moduleLock.LockReason ?? "Chương đang bị khóa.", moduleLock.UnlockRequirements.ToArray());
        if (lesson.UnlockAfterLessonId.HasValue && !IsLessonCompleted(lesson.UnlockAfterLessonId.Value, progress))
            return Locked($"Bạn cần hoàn thành bài #{lesson.UnlockAfterLessonId.Value} trước.", $"Hoàn thành bài #{lesson.UnlockAfterLessonId.Value}");
        if (lesson.RequiresPreviousLessonCompletion && lesson.SortOrder > 1 && !previousLessonCompleted)
            return Locked("Bạn cần hoàn thành bài trước đó để mở khóa.", "Hoàn thành bài học trước đó");
        return new RoadmapLockStateResponse
        {
            UnlockRequirements = moduleLock.IsLocked && lesson.IsPreview ? moduleLock.UnlockRequirements : new List<string>()
        };
    }

    private static IEnumerable<RoadmapCourse> OrderedCourses(LearningTrack track, bool includeUnpublished)
        => track.Courses
            .Where(x => !x.IsDeleted && (includeUnpublished || x.IsPublished))
            .OrderBy(x => x.SortOrder).ThenBy(x => x.Id);

    private static IEnumerable<RoadmapModule> OrderedModules(RoadmapCourse course, bool includeUnpublished)
        => course.Modules
            .Where(x => !x.IsDeleted && (includeUnpublished || x.IsPublished))
            .OrderBy(x => x.SortOrder).ThenBy(x => x.Id);

    private static IEnumerable<RoadmapLesson> OrderedLessons(RoadmapModule module, bool includeUnpublished)
        => module.Lessons
            .Where(x => !x.IsDeleted && (includeUnpublished || x.IsPublished))
            .OrderBy(x => x.SortOrder).ThenBy(x => x.Id);

    private static List<RoadmapLesson> PublishedLessons(RoadmapCourse course)
        => OrderedModules(course, false).SelectMany(module => OrderedLessons(module, false)).ToList();

    private static bool IsLessonCompleted(long lessonId, ProgressLookup progress)
        => progress.Lessons.TryGetValue(lessonId, out var p) && p.Status == "Completed";

    private static RoadmapLockStateResponse Locked(string reason, params string[] requirements)
        => new()
        {
            IsLocked = true,
            LockReason = reason,
            UnlockRequirements = requirements.Where(x => !string.IsNullOrWhiteSpace(x)).Distinct().ToList()
        };

    private static bool IsManualCompletable(string type)
        => type is "Reading" or "Video" or "Assignment";

    private static decimal Percent(int completed, int total)
        => total <= 0 ? 0 : Math.Round(completed * 100m / total, 1);

    private static string VideoFileUrl(long fileId) => $"/api/v1/files/{fileId}/view";

    private static List<long> ReadLongList(string? json)
    {
        if (string.IsNullOrWhiteSpace(json)) return new List<long>();
        try { return JsonSerializer.Deserialize<List<long>>(json, JsonOptions) ?? new List<long>(); }
        catch { return new List<long>(); }
    }

    private sealed class ProgressLookup
    {
        public Dictionary<long, UserLessonProgress> Lessons { get; set; } = new();
        public Dictionary<long, CourseProgressResponse> Courses { get; set; } = new();
    }
}
