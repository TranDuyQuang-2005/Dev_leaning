using System.Globalization;
using System.Text;
using System.Text.Json;
using DevLearningHub.Api.Common;
using DevLearningHub.Api.Data;
using DevLearningHub.Api.DTOs;
using DevLearningHub.Api.Entities;
using Microsoft.EntityFrameworkCore;

namespace DevLearningHub.Api.Services;

public interface IRoadmapService
{
    Task<ApiResponse<List<LearningTrackResponse>>> GetTracks(long? userId, bool includeUnpublished, CancellationToken ct);
    Task<ApiResponse<LearningTrackDetailResponse>> GetTrackBySlug(string slug, long? userId, bool includeUnpublished, CancellationToken ct);
    Task<ApiResponse<RoadmapCourseDetailResponse>> GetCourseBySlug(string slug, long? userId, bool includeUnpublished, CancellationToken ct);
    Task<ApiResponse<CourseProgressResponse>> GetCourseProgress(long userId, long courseId, CancellationToken ct);
    Task<LessonAccessResult> CanStartLessonAsync(long userId, long lessonId, CancellationToken ct);
    Task<LessonAccessResult> CanCompleteLessonAsync(long userId, long lessonId, CancellationToken ct);
    Task<LessonAccessResult> CanAccessQuizLessonAsync(long userId, long lessonId, long quizSetId, CancellationToken ct);
    Task<LessonAccessResult> CanAccessCodeLessonAsync(long userId, long lessonId, long codingProblemId, CancellationToken ct);
    Task CompleteQuizLessonIfPassedAsync(long userId, long quizSetId, long quizAttemptId, decimal score, CancellationToken ct);
    Task CompleteQuizLessonIfPassedAsync(long userId, long lessonId, long quizSetId, long quizAttemptId, decimal score, CancellationToken ct);
    Task CompleteCodeLessonIfAcceptedAsync(long userId, long codingProblemId, long submissionId, CancellationToken ct);
    Task CompleteCodeLessonIfAcceptedAsync(long userId, long lessonId, long codingProblemId, long submissionId, CancellationToken ct);
    Task<ApiResponse<RoadmapLessonResponse>> StartLesson(long userId, long lessonId, CancellationToken ct);
    Task<ApiResponse<RoadmapLessonResponse>> CompleteLesson(long userId, long lessonId, CancellationToken ct);
    Task MarkQuizLessonsCompleted(long userId, long quizSetId, CancellationToken ct);
    Task MarkCodingLessonsCompleted(long userId, long codingProblemId, CancellationToken ct);
    Task<ApiResponse<ProgressOverviewResponse>> GetProgressOverview(long userId, CancellationToken ct);
    Task<ApiResponse<ProgressRoadmapResponse>> GetProgressRoadmap(long userId, CancellationToken ct);

    Task<ApiResponse<List<LearningTrackDetailResponse>>> AdminTracks(CancellationToken ct);
    Task<ApiResponse<LearningTrackDetailResponse>> AdminSaveTrack(long? id, LearningTrackRequest request, CancellationToken ct);
    Task<ApiResponse<object>> AdminDeleteTrack(long id, CancellationToken ct);
    Task<ApiResponse<List<RoadmapCourseDetailResponse>>> AdminCourses(long? trackId, CancellationToken ct);
    Task<ApiResponse<RoadmapCourseDetailResponse>> AdminCourse(long id, CancellationToken ct);
    Task<ApiResponse<RoadmapCourseDetailResponse>> AdminSaveCourse(long? id, RoadmapCourseRequest request, CancellationToken ct);
    Task<ApiResponse<object>> AdminDeleteCourse(long id, CancellationToken ct);
    Task<ApiResponse<RoadmapModuleResponse>> AdminCreateModule(long courseId, RoadmapModuleRequest request, CancellationToken ct);
    Task<ApiResponse<RoadmapModuleResponse>> AdminUpdateModule(long moduleId, RoadmapModuleRequest request, CancellationToken ct);
    Task<ApiResponse<object>> AdminDeleteModule(long moduleId, CancellationToken ct);
    Task<ApiResponse<RoadmapLessonResponse>> AdminCreateLesson(long moduleId, RoadmapLessonRequest request, CancellationToken ct);
    Task<ApiResponse<RoadmapLessonResponse>> AdminUpdateLesson(long lessonId, RoadmapLessonRequest request, CancellationToken ct);
    Task<ApiResponse<object>> AdminDeleteLesson(long lessonId, CancellationToken ct);
}

public sealed class RoadmapService : IRoadmapService
{
    private const string LessonLockedMessage = "Bài học đang bị khóa. Hãy hoàn thành bài học trước đó.";
    private const string QuizLockedMessage = "Bài quiz đang bị khóa. Hãy hoàn thành bài học trước đó.";
    private const string CodeLockedMessage = "Bài code practice đang bị khóa. Hãy hoàn thành bài học trước đó.";
    private static readonly string[] CourseLevels = { "Beginner", "Intermediate", "Advanced" };
    private static readonly string[] LessonTypes = { "Reading", "Video", "Quiz", "CodePractice", "Assignment" };
    private static readonly JsonSerializerOptions JsonOptions = new(JsonSerializerDefaults.Web);

    private readonly DevLearningHubDbContext _db;

    public RoadmapService(DevLearningHubDbContext db) => _db = db;

    public async Task<ApiResponse<List<LearningTrackResponse>>> GetTracks(long? userId, bool includeUnpublished, CancellationToken ct)
    {
        var tracks = await TrackQuery(includeUnpublished)
            .Include(x => x.Courses).ThenInclude(x => x.Modules).ThenInclude(x => x.Lessons)
            .OrderBy(x => x.SortOrder).ThenBy(x => x.Id)
            .ToListAsync(ct);

        var progress = await BuildProgressLookup(userId, tracks.SelectMany(x => x.Courses), ct);
        var items = tracks.Select(track => MapTrack(track, progress, includeUnpublished)).ToList();
        return ApiResponse<List<LearningTrackResponse>>.Ok(items);
    }

    public async Task<ApiResponse<LearningTrackDetailResponse>> GetTrackBySlug(string slug, long? userId, bool includeUnpublished, CancellationToken ct)
    {
        var normalized = NormalizeSlug(slug);
        var track = await TrackQuery(includeUnpublished)
            .Include(x => x.Courses).ThenInclude(x => x.Modules).ThenInclude(x => x.Lessons)
            .FirstOrDefaultAsync(x => x.Slug == normalized, ct);
        if (track == null) return ApiResponse<LearningTrackDetailResponse>.Fail("Không tìm thấy lộ trình");

        var courses = OrderedCourses(track, includeUnpublished).ToList();
        var progress = await BuildProgressLookup(userId, courses, ct);
        var detail = MapTrackDetail(track, progress, includeUnpublished);
        detail.Courses = courses.Select(course => MapCourseSummary(course, courses, progress)).ToList();
        return ApiResponse<LearningTrackDetailResponse>.Ok(detail);
    }

    public async Task<ApiResponse<RoadmapCourseDetailResponse>> GetCourseBySlug(string slug, long? userId, bool includeUnpublished, CancellationToken ct)
    {
        var normalized = NormalizeSlug(slug);
        var course = await CourseQuery(includeUnpublished)
            .Include(x => x.Track).ThenInclude(x => x.Courses).ThenInclude(x => x.Modules).ThenInclude(x => x.Lessons)
            .Include(x => x.Modules).ThenInclude(x => x.Lessons)
            .FirstOrDefaultAsync(x => x.Slug == normalized, ct);
        if (course == null) return ApiResponse<RoadmapCourseDetailResponse>.Fail("Không tìm thấy khóa học");

        var trackCourses = OrderedCourses(course.Track, includeUnpublished).ToList();
        var relatedIds = ReadLongList(course.RelatedCourseIdsJson);
        var relatedCourses = relatedIds.Count == 0
            ? new List<RoadmapCourse>()
            : await CourseQuery(includeUnpublished)
                .Include(x => x.Track)
                .Include(x => x.Modules).ThenInclude(x => x.Lessons)
                .Where(x => relatedIds.Contains(x.Id))
                .OrderBy(x => x.SortOrder)
                .ToListAsync(ct);

        var progress = await BuildProgressLookup(userId, trackCourses.Concat(relatedCourses), ct);
        var detail = MapCourseDetail(course, trackCourses, relatedCourses, progress);
        return ApiResponse<RoadmapCourseDetailResponse>.Ok(detail);
    }

    public async Task<ApiResponse<CourseProgressResponse>> GetCourseProgress(long userId, long courseId, CancellationToken ct)
    {
        var course = await CourseQuery(false)
            .Include(x => x.Modules).ThenInclude(x => x.Lessons)
            .FirstOrDefaultAsync(x => x.Id == courseId, ct);
        if (course == null) return ApiResponse<CourseProgressResponse>.Fail("Không tìm thấy khóa học");

        var progress = await BuildProgressLookup(userId, new[] { course }, ct);
        return ApiResponse<CourseProgressResponse>.Ok(progress.Courses.GetValueOrDefault(course.Id) ?? EmptyCourseProgress(course.Id));
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

    public async Task<ApiResponse<RoadmapLessonResponse>> StartLesson(long userId, long lessonId, CancellationToken ct)
    {
        var lessonState = await GetLessonState(userId, lessonId, includeUnpublished: false, ct);
        if (lessonState == null) return ApiResponse<RoadmapLessonResponse>.Fail("Không tìm thấy bài học");
        if (!lessonState.CanStart)
            return ApiResponse<RoadmapLessonResponse>.Fail(lessonState.LockReason ?? "Bài học đang bị khóa. Hãy hoàn thành bài trước đó.");

        var progress = await UpsertProgress(userId, lessonId, "InProgress", ct);
        if (progress.StartedAt == null) progress.StartedAt = DateTime.UtcNow;
        progress.LastAccessedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);

        return ApiResponse<RoadmapLessonResponse>.Ok(await ReloadLessonState(userId, lessonId, ct), "Bắt đầu bài học thành công");
    }

    public async Task<ApiResponse<RoadmapLessonResponse>> CompleteLesson(long userId, long lessonId, CancellationToken ct)
    {
        var lessonState = await GetLessonState(userId, lessonId, includeUnpublished: false, ct);
        if (lessonState == null) return ApiResponse<RoadmapLessonResponse>.Fail("Không tìm thấy bài học");
        if (lessonState.IsLocked)
            return ApiResponse<RoadmapLessonResponse>.Fail(lessonState.LockReason ?? "Bài học đang bị khóa. Hãy hoàn thành bài trước đó.");
        if (!IsManualCompletable(lessonState.Type))
            return ApiResponse<RoadmapLessonResponse>.Fail(lessonState.Type == "Quiz"
                ? "Bài quiz chỉ hoàn thành khi bạn đạt điểm pass."
                : "Bài code practice chỉ hoàn thành khi submission Accepted.");
        if (!lessonState.CanComplete && lessonState.Status == "Completed")
            return ApiResponse<RoadmapLessonResponse>.Ok(lessonState, "Bài học đã hoàn thành");
        if (!lessonState.CanComplete)
            return ApiResponse<RoadmapLessonResponse>.Fail(lessonState.LockReason ?? "Bài học chưa thể hoàn thành ở trạng thái hiện tại.");

        await CompleteLessonProgress(userId, lessonId, ct);
        return ApiResponse<RoadmapLessonResponse>.Ok(await ReloadLessonState(userId, lessonId, ct), "Đã đánh dấu hoàn thành bài học");
    }

    public async Task MarkQuizLessonsCompleted(long userId, long quizSetId, CancellationToken ct)
        => await CompleteQuizLessonIfPassedAsync(userId, quizSetId, 0, 0, ct);

    public async Task MarkCodingLessonsCompleted(long userId, long codingProblemId, CancellationToken ct)
        => await CompleteCodeLessonIfAcceptedAsync(userId, codingProblemId, 0, ct);

    public async Task<ApiResponse<ProgressOverviewResponse>> GetProgressOverview(long userId, CancellationToken ct)
    {
        var courses = await CourseQuery(false)
            .Include(x => x.Track)
            .Include(x => x.Modules).ThenInclude(x => x.Lessons)
            .OrderBy(x => x.Track.SortOrder).ThenBy(x => x.SortOrder)
            .ToListAsync(ct);
        var progress = await BuildProgressLookup(userId, courses, ct);
        var weakTopics = await WeakTopics(userId, ct);
        var stats = await _db.UserStats.AsNoTracking().FirstOrDefaultAsync(x => x.UserId == userId, ct);
        var recommended = courses
            .Select(course => MapCourseSummary(course, OrderedCourses(course.Track, false).ToList(), progress))
            .Where(x => !x.IsCompleted && !x.IsLocked)
            .OrderByDescending(x => x.ProgressPercent)
            .ThenBy(x => x.SortOrder)
            .Take(5)
            .ToList();

        var allLessons = courses.SelectMany(PublishedLessons).ToList();
        var completedLessonIds = progress.Lessons.Where(x => x.Value.Status == "Completed").Select(x => x.Key).ToHashSet();
        var data = new ProgressOverviewResponse
        {
            TotalCourses = courses.Count,
            CompletedCourses = progress.Courses.Values.Count(x => x.IsCompleted),
            TotalLessons = allLessons.Count,
            CompletedLessons = allLessons.Count(x => completedLessonIds.Contains(x.Id)),
            AverageQuizScore = stats?.AverageQuizScore ?? 0,
            AcceptedCodeSubmissions = stats?.AcceptedCodeSubmissions ?? 0,
            WeakTopics = weakTopics,
            RecommendedNextCourses = recommended
        };
        return ApiResponse<ProgressOverviewResponse>.Ok(data);
    }

    public async Task<ApiResponse<ProgressRoadmapResponse>> GetProgressRoadmap(long userId, CancellationToken ct)
    {
        var courses = await CourseQuery(false)
            .Include(x => x.Track)
            .Include(x => x.Modules).ThenInclude(x => x.Lessons)
            .OrderBy(x => x.Track.SortOrder).ThenBy(x => x.SortOrder)
            .ToListAsync(ct);
        var progress = await BuildProgressLookup(userId, courses, ct);
        var weakTopics = await WeakTopics(userId, ct);
        var summaries = courses.Select(course => MapCourseSummary(course, OrderedCourses(course.Track, false).ToList(), progress)).ToList();
        var current = summaries.Where(x => x.ProgressPercent > 0 && !x.IsCompleted).OrderByDescending(x => x.ProgressPercent).Take(3).ToList();
        var recommended = current.Count > 0
            ? current
            : summaries.Where(x => !x.IsCompleted && !x.IsLocked).OrderBy(x => LevelOrder(x.Level)).ThenBy(x => x.SortOrder).Take(5).ToList();

        var nextActions = new List<ProgressRoadmapActionResponse>();
        foreach (var course in recommended.Take(3))
        {
            nextActions.Add(new ProgressRoadmapActionResponse
            {
                Type = course.ProgressPercent > 0 ? "continue_course" : "start_course",
                Title = course.ProgressPercent > 0 ? $"Tiếp tục {course.Title}" : $"Bắt đầu {course.Title}",
                LinkUrl = $"/learner/courses/{course.Slug}"
            });
        }
        if (nextActions.Count == 0)
        {
            var firstBeginner = summaries.OrderBy(x => LevelOrder(x.Level)).ThenBy(x => x.SortOrder).FirstOrDefault();
            if (firstBeginner != null)
            {
                recommended.Add(firstBeginner);
                nextActions.Add(new ProgressRoadmapActionResponse
                {
                    Type = "start_course",
                    Title = $"Bắt đầu {firstBeginner.Title}",
                    LinkUrl = $"/learner/courses/{firstBeginner.Slug}"
                });
            }
        }

        var currentLevel = current.FirstOrDefault()?.Level
            ?? summaries.FirstOrDefault(x => !x.IsCompleted)?.Level
            ?? "Beginner";

        return ApiResponse<ProgressRoadmapResponse>.Ok(new ProgressRoadmapResponse
        {
            CurrentLevel = currentLevel,
            CurrentCourses = current,
            RecommendedCourses = recommended.DistinctBy(x => x.Id).Take(5).ToList(),
            WeakTopics = weakTopics,
            NextActions = nextActions
        });
    }

    public async Task<ApiResponse<List<LearningTrackDetailResponse>>> AdminTracks(CancellationToken ct)
    {
        var tracks = await TrackQuery(true)
            .Include(x => x.Courses).ThenInclude(x => x.Modules).ThenInclude(x => x.Lessons)
            .OrderBy(x => x.SortOrder).ThenBy(x => x.Id)
            .ToListAsync(ct);
        var progress = EmptyProgressLookup();
        return ApiResponse<List<LearningTrackDetailResponse>>.Ok(tracks.Select(x => MapTrackDetail(x, progress, true)).ToList());
    }

    public async Task<ApiResponse<LearningTrackDetailResponse>> AdminSaveTrack(long? id, LearningTrackRequest request, CancellationToken ct)
    {
        var errors = ValidateTrack(request);
        if (errors.Count > 0) return ApiResponse<LearningTrackDetailResponse>.Fail("Dữ liệu lộ trình không hợp lệ", errors);
        var slug = NormalizeSlug(string.IsNullOrWhiteSpace(request.Slug) ? request.Title : request.Slug);
        if (await _db.LearningTracks.AnyAsync(x => x.Slug == slug && !x.IsDeleted && x.Id != (id ?? 0), ct))
            return ApiResponse<LearningTrackDetailResponse>.Fail("Slug lộ trình đã tồn tại");

        LearningTrack track;
        if (id.HasValue)
        {
            track = await _db.LearningTracks.Include(x => x.Courses).ThenInclude(x => x.Modules).ThenInclude(x => x.Lessons)
                .FirstOrDefaultAsync(x => x.Id == id.Value && !x.IsDeleted, ct)
                ?? throw new InvalidOperationException("Không tìm thấy lộ trình");
            track.UpdatedAt = DateTime.UtcNow;
        }
        else
        {
            track = new LearningTrack { CreatedAt = DateTime.UtcNow };
            _db.LearningTracks.Add(track);
        }

        track.Title = request.Title.Trim();
        track.Slug = slug;
        track.Description = request.Description;
        track.Level = NormalizeLevel(request.Level);
        track.EstimatedHours = Math.Max(0, request.EstimatedHours);
        track.ThumbnailUrl = request.ThumbnailUrl;
        track.SortOrder = request.SortOrder;
        track.IsPublished = request.IsPublished;
        await _db.SaveChangesAsync(ct);

        var saved = await _db.LearningTracks.Include(x => x.Courses).ThenInclude(x => x.Modules).ThenInclude(x => x.Lessons).FirstAsync(x => x.Id == track.Id, ct);
        return ApiResponse<LearningTrackDetailResponse>.Ok(MapTrackDetail(saved, EmptyProgressLookup(), true), id.HasValue ? "Cập nhật lộ trình thành công" : "Tạo lộ trình thành công");
    }

    public async Task<ApiResponse<object>> AdminDeleteTrack(long id, CancellationToken ct)
    {
        var track = await _db.LearningTracks.Include(x => x.Courses).FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, ct);
        if (track == null) return ApiResponse<object>.Fail("Không tìm thấy lộ trình");
        track.IsDeleted = true;
        track.IsPublished = false;
        track.UpdatedAt = DateTime.UtcNow;
        foreach (var course in track.Courses)
        {
            course.IsDeleted = true;
            course.IsPublished = false;
            course.UpdatedAt = DateTime.UtcNow;
        }
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { id }, "Đã xóa lộ trình");
    }

    public async Task<ApiResponse<List<RoadmapCourseDetailResponse>>> AdminCourses(long? trackId, CancellationToken ct)
    {
        IQueryable<RoadmapCourse> query = CourseQuery(true).Include(x => x.Track).ThenInclude(x => x.Courses).ThenInclude(x => x.Modules).ThenInclude(x => x.Lessons)
            .Include(x => x.Modules).ThenInclude(x => x.Lessons);
        if (trackId.HasValue) query = query.Where(x => x.TrackId == trackId.Value);
        var courses = await query.OrderBy(x => x.Track.SortOrder).ThenBy(x => x.SortOrder).ToListAsync(ct);
        var progress = EmptyProgressLookup();
        return ApiResponse<List<RoadmapCourseDetailResponse>>.Ok(courses.Select(x => MapCourseDetail(x, OrderedCourses(x.Track, true).ToList(), new List<RoadmapCourse>(), progress)).ToList());
    }

    public async Task<ApiResponse<RoadmapCourseDetailResponse>> AdminCourse(long id, CancellationToken ct)
    {
        var course = await CourseQuery(true)
            .Include(x => x.Track).ThenInclude(x => x.Courses).ThenInclude(x => x.Modules).ThenInclude(x => x.Lessons)
            .Include(x => x.Modules).ThenInclude(x => x.Lessons)
            .FirstOrDefaultAsync(x => x.Id == id, ct);
        if (course == null) return ApiResponse<RoadmapCourseDetailResponse>.Fail("Không tìm thấy khóa học");
        return ApiResponse<RoadmapCourseDetailResponse>.Ok(MapCourseDetail(course, OrderedCourses(course.Track, true).ToList(), new List<RoadmapCourse>(), EmptyProgressLookup()));
    }

    public async Task<ApiResponse<RoadmapCourseDetailResponse>> AdminSaveCourse(long? id, RoadmapCourseRequest request, CancellationToken ct)
    {
        var errors = await ValidateCourse(request, id, ct);
        if (errors.Count > 0) return ApiResponse<RoadmapCourseDetailResponse>.Fail("Dữ liệu khóa học không hợp lệ", errors);
        var slug = NormalizeSlug(string.IsNullOrWhiteSpace(request.Slug) ? request.Title : request.Slug);

        RoadmapCourse course;
        if (id.HasValue)
        {
            course = await _db.RoadmapCourses.Include(x => x.Modules).ThenInclude(x => x.Lessons)
                .FirstOrDefaultAsync(x => x.Id == id.Value && !x.IsDeleted, ct)
                ?? throw new InvalidOperationException("Không tìm thấy khóa học");
            course.UpdatedAt = DateTime.UtcNow;
        }
        else
        {
            course = new RoadmapCourse { CreatedAt = DateTime.UtcNow };
            _db.RoadmapCourses.Add(course);
        }

        ApplyCourse(course, request, slug);
        await _db.SaveChangesAsync(ct);
        await RecalculateCourseTotals(course.Id, ct);
        return await AdminCourse(course.Id, ct);
    }

    public async Task<ApiResponse<object>> AdminDeleteCourse(long id, CancellationToken ct)
    {
        var course = await _db.RoadmapCourses.Include(x => x.Modules).ThenInclude(x => x.Lessons).FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, ct);
        if (course == null) return ApiResponse<object>.Fail("Không tìm thấy khóa học");
        course.IsDeleted = true;
        course.IsPublished = false;
        course.UpdatedAt = DateTime.UtcNow;
        foreach (var module in course.Modules)
        {
            module.IsDeleted = true;
            module.IsPublished = false;
            foreach (var lesson in module.Lessons)
            {
                lesson.IsDeleted = true;
                lesson.IsPublished = false;
            }
        }
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { id }, "Đã xóa khóa học");
    }

    public async Task<ApiResponse<RoadmapModuleResponse>> AdminCreateModule(long courseId, RoadmapModuleRequest request, CancellationToken ct)
    {
        var course = await _db.RoadmapCourses.FirstOrDefaultAsync(x => x.Id == courseId && !x.IsDeleted, ct);
        if (course == null) return ApiResponse<RoadmapModuleResponse>.Fail("Không tìm thấy khóa học");
        var errors = ValidateModule(request);
        if (errors.Count > 0) return ApiResponse<RoadmapModuleResponse>.Fail("Dữ liệu chương không hợp lệ", errors);
        var module = new RoadmapModule { CourseId = courseId, CreatedAt = DateTime.UtcNow };
        ApplyModule(module, request);
        _db.RoadmapModules.Add(module);
        await _db.SaveChangesAsync(ct);
        await RecalculateCourseTotals(courseId, ct);
        return ApiResponse<RoadmapModuleResponse>.Ok(MapAdminModule(module), "Tạo chương thành công");
    }

    public async Task<ApiResponse<RoadmapModuleResponse>> AdminUpdateModule(long moduleId, RoadmapModuleRequest request, CancellationToken ct)
    {
        var module = await _db.RoadmapModules.Include(x => x.Lessons).FirstOrDefaultAsync(x => x.Id == moduleId && !x.IsDeleted, ct);
        if (module == null) return ApiResponse<RoadmapModuleResponse>.Fail("Không tìm thấy chương");
        var errors = ValidateModule(request);
        if (errors.Count > 0) return ApiResponse<RoadmapModuleResponse>.Fail("Dữ liệu chương không hợp lệ", errors);
        ApplyModule(module, request);
        module.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);
        await RecalculateCourseTotals(module.CourseId, ct);
        return ApiResponse<RoadmapModuleResponse>.Ok(MapAdminModule(module), "Cập nhật chương thành công");
    }

    public async Task<ApiResponse<object>> AdminDeleteModule(long moduleId, CancellationToken ct)
    {
        var module = await _db.RoadmapModules.Include(x => x.Lessons).FirstOrDefaultAsync(x => x.Id == moduleId && !x.IsDeleted, ct);
        if (module == null) return ApiResponse<object>.Fail("Không tìm thấy chương");
        module.IsDeleted = true;
        module.IsPublished = false;
        module.UpdatedAt = DateTime.UtcNow;
        foreach (var lesson in module.Lessons)
        {
            lesson.IsDeleted = true;
            lesson.IsPublished = false;
            lesson.UpdatedAt = DateTime.UtcNow;
        }
        await _db.SaveChangesAsync(ct);
        await RecalculateCourseTotals(module.CourseId, ct);
        return ApiResponse<object>.Ok(new { id = moduleId }, "Đã xóa chương");
    }

    public async Task<ApiResponse<RoadmapLessonResponse>> AdminCreateLesson(long moduleId, RoadmapLessonRequest request, CancellationToken ct)
    {
        var module = await _db.RoadmapModules.FirstOrDefaultAsync(x => x.Id == moduleId && !x.IsDeleted, ct);
        if (module == null) return ApiResponse<RoadmapLessonResponse>.Fail("Không tìm thấy chương");
        var errors = await ValidateLesson(request, null, ct);
        if (errors.Count > 0) return ApiResponse<RoadmapLessonResponse>.Fail("Dữ liệu bài học không hợp lệ", errors);
        var lesson = new RoadmapLesson { ModuleId = moduleId, CreatedAt = DateTime.UtcNow };
        ApplyLesson(lesson, request);
        _db.RoadmapLessons.Add(lesson);
        await _db.SaveChangesAsync(ct);
        await RecalculateCourseTotals(module.CourseId, ct);
        return ApiResponse<RoadmapLessonResponse>.Ok(MapAdminLesson(lesson), "Tạo bài học thành công");
    }

    public async Task<ApiResponse<RoadmapLessonResponse>> AdminUpdateLesson(long lessonId, RoadmapLessonRequest request, CancellationToken ct)
    {
        var lesson = await _db.RoadmapLessons.Include(x => x.Module).FirstOrDefaultAsync(x => x.Id == lessonId && !x.IsDeleted, ct);
        if (lesson == null) return ApiResponse<RoadmapLessonResponse>.Fail("Không tìm thấy bài học");
        var errors = await ValidateLesson(request, lessonId, ct);
        if (errors.Count > 0) return ApiResponse<RoadmapLessonResponse>.Fail("Dữ liệu bài học không hợp lệ", errors);
        ApplyLesson(lesson, request);
        lesson.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);
        await RecalculateCourseTotals(lesson.Module.CourseId, ct);
        return ApiResponse<RoadmapLessonResponse>.Ok(MapAdminLesson(lesson), "Cập nhật bài học thành công");
    }

    public async Task<ApiResponse<object>> AdminDeleteLesson(long lessonId, CancellationToken ct)
    {
        var lesson = await _db.RoadmapLessons.Include(x => x.Module).FirstOrDefaultAsync(x => x.Id == lessonId && !x.IsDeleted, ct);
        if (lesson == null) return ApiResponse<object>.Fail("Không tìm thấy bài học");
        lesson.IsDeleted = true;
        lesson.IsPublished = false;
        lesson.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);
        await RecalculateCourseTotals(lesson.Module.CourseId, ct);
        return ApiResponse<object>.Ok(new { id = lessonId }, "Đã xóa bài học");
    }

    private async Task CompleteSystemLessons(long userId, List<long> lessonIds, CancellationToken ct)
    {
        foreach (var lessonId in lessonIds.Distinct())
        {
            var state = await GetLessonState(userId, lessonId, includeUnpublished: false, ct);
            if (state is { IsLocked: false })
                await CompleteLessonProgress(userId, lessonId, ct);
        }
        await _db.SaveChangesAsync(ct);
    }

    private async Task<RoadmapLessonResponse?> GetLessonState(long userId, long lessonId, bool includeUnpublished, CancellationToken ct)
    {
        var lesson = await _db.RoadmapLessons.AsNoTracking()
            .Include(x => x.Module).ThenInclude(x => x.Course).ThenInclude(x => x.Track)
            .FirstOrDefaultAsync(x => x.Id == lessonId && !x.IsDeleted, ct);
        if (lesson == null) return null;

        var courseResponse = await GetCourseBySlug(lesson.Module.Course.Slug, userId, includeUnpublished, ct);
        return courseResponse.Data?.Modules.SelectMany(x => x.Lessons).FirstOrDefault(x => x.Id == lessonId);
    }

    private async Task<RoadmapLesson?> GetPublishedLessonHeader(long lessonId, CancellationToken ct)
        => await _db.RoadmapLessons.AsNoTracking()
            .Include(x => x.Module).ThenInclude(x => x.Course)
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

    private async Task<RoadmapLessonResponse> ReloadLessonState(long userId, long lessonId, CancellationToken ct)
        => await GetLessonState(userId, lessonId, includeUnpublished: false, ct) ?? new RoadmapLessonResponse { Id = lessonId };

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

    private IQueryable<LearningTrack> TrackQuery(bool includeUnpublished)
    {
        var query = _db.LearningTracks.Where(x => !x.IsDeleted);
        if (!includeUnpublished) query = query.Where(x => x.IsPublished);
        return query;
    }

    private IQueryable<RoadmapCourse> CourseQuery(bool includeUnpublished)
    {
        var query = _db.RoadmapCourses.Where(x => !x.IsDeleted);
        if (!includeUnpublished) query = query.Where(x => x.IsPublished && x.Track.IsPublished && !x.Track.IsDeleted);
        return query;
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

    private async Task<ProgressLookup> BuildProgressLookup(long? userId, IEnumerable<RoadmapCourse> courses, CancellationToken ct)
    {
        var courseList = courses.DistinctBy(x => x.Id).ToList();
        if (!userId.HasValue) return EmptyProgressLookup(courseList);

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
                .Where(x => x.UserId == userId.Value && lessonIds.Contains(x.LessonId))
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

    private static ProgressLookup EmptyProgressLookup(IEnumerable<RoadmapCourse>? courses = null)
    {
        var lookup = new ProgressLookup
        {
            Lessons = new Dictionary<long, UserLessonProgress>(),
            Courses = new Dictionary<long, CourseProgressResponse>()
        };
        foreach (var course in courses ?? Array.Empty<RoadmapCourse>())
            lookup.Courses[course.Id] = BuildCourseProgress(course, lookup.Lessons);
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

    private static CourseProgressResponse EmptyCourseProgress(long courseId) => new() { CourseId = courseId };

    private LearningTrackResponse MapTrack(LearningTrack track, ProgressLookup progress, bool includeUnpublished)
    {
        var courses = OrderedCourses(track, includeUnpublished).ToList();
        var lessons = courses.SelectMany(course => OrderedModules(course, includeUnpublished)).SelectMany(module => OrderedLessons(module, includeUnpublished)).ToList();
        var completed = lessons.Count(lesson => progress.Lessons.TryGetValue(lesson.Id, out var p) && p.Status == "Completed");
        return new LearningTrackResponse
        {
            Id = track.Id,
            Title = track.Title,
            Slug = track.Slug,
            Description = track.Description,
            Level = track.Level,
            EstimatedHours = track.EstimatedHours,
            ThumbnailUrl = track.ThumbnailUrl,
            SortOrder = track.SortOrder,
            IsPublished = track.IsPublished,
            CourseCount = courses.Count,
            TotalLessons = lessons.Count,
            ProgressPercent = Percent(completed, lessons.Count)
        };
    }

    private LearningTrackDetailResponse MapTrackDetail(LearningTrack track, ProgressLookup progress, bool includeUnpublished)
    {
        var baseTrack = MapTrack(track, progress, includeUnpublished);
        var courses = OrderedCourses(track, includeUnpublished).ToList();
        return new LearningTrackDetailResponse
        {
            Id = baseTrack.Id,
            Title = baseTrack.Title,
            Slug = baseTrack.Slug,
            Description = baseTrack.Description,
            Level = baseTrack.Level,
            EstimatedHours = baseTrack.EstimatedHours,
            ThumbnailUrl = baseTrack.ThumbnailUrl,
            SortOrder = baseTrack.SortOrder,
            IsPublished = baseTrack.IsPublished,
            CourseCount = baseTrack.CourseCount,
            TotalLessons = baseTrack.TotalLessons,
            ProgressPercent = baseTrack.ProgressPercent,
            Courses = courses.Select(course => MapCourseSummary(course, courses, progress)).ToList()
        };
    }

    private RoadmapCourseSummaryResponse MapCourseSummary(RoadmapCourse course, List<RoadmapCourse> trackCourses, ProgressLookup progress)
    {
        var courseProgress = progress.Courses.GetValueOrDefault(course.Id) ?? BuildCourseProgress(course, progress.Lessons);
        var lockState = CourseLock(course, trackCourses, progress);
        return new RoadmapCourseSummaryResponse
        {
            Id = course.Id,
            TrackId = course.TrackId,
            Title = course.Title,
            Slug = course.Slug,
            ShortDescription = course.ShortDescription,
            Description = course.Description,
            Level = course.Level,
            EstimatedHours = course.EstimatedHours,
            TotalModules = course.TotalModules > 0 ? course.TotalModules : OrderedModules(course, true).Count(),
            TotalLessons = course.TotalLessons > 0 ? course.TotalLessons : OrderedModules(course, true).SelectMany(module => OrderedLessons(module, true)).Count(),
            ThumbnailUrl = course.ThumbnailUrl,
            SortOrder = course.SortOrder,
            IsPublished = course.IsPublished,
            RequiresSequentialCompletion = course.RequiresSequentialCompletion,
            RelatedCourseIds = ReadLongList(course.RelatedCourseIdsJson),
            PrerequisiteCourseIds = ReadLongList(course.PrerequisiteCourseIdsJson),
            UnlockAfterCourseId = course.UnlockAfterCourseId,
            IsLocked = lockState.IsLocked,
            LockReason = lockState.LockReason,
            UnlockRequirements = lockState.UnlockRequirements,
            ProgressPercent = courseProgress.ProgressPercent,
            IsCompleted = courseProgress.IsCompleted,
            Status = courseProgress.IsCompleted ? "Completed" : courseProgress.ProgressPercent > 0 ? "In progress" : "Not started"
        };
    }

    private RoadmapCourseDetailResponse MapCourseDetail(RoadmapCourse course, List<RoadmapCourse> trackCourses, List<RoadmapCourse> relatedCourses, ProgressLookup progress)
    {
        var summary = MapCourseSummary(course, trackCourses, progress);
        var modules = new List<RoadmapModuleResponse>();
        var previousModuleCompleted = true;
        foreach (var module in OrderedModules(course, false))
        {
            var mapped = MapModule(module, course, summary, progress, previousModuleCompleted);
            modules.Add(mapped);
            previousModuleCompleted = mapped.IsCompleted;
        }

        var allLessons = modules.SelectMany(x => x.Lessons).ToList();
        var next = allLessons.FirstOrDefault(x => !x.IsLocked && x.Status != "Completed");
        return new RoadmapCourseDetailResponse
        {
            Id = summary.Id,
            TrackId = summary.TrackId,
            Title = summary.Title,
            Slug = summary.Slug,
            ShortDescription = summary.ShortDescription,
            Description = summary.Description,
            Level = summary.Level,
            EstimatedHours = summary.EstimatedHours,
            TotalModules = summary.TotalModules,
            TotalLessons = summary.TotalLessons,
            ThumbnailUrl = summary.ThumbnailUrl,
            SortOrder = summary.SortOrder,
            IsPublished = summary.IsPublished,
            RequiresSequentialCompletion = summary.RequiresSequentialCompletion,
            RelatedCourseIds = summary.RelatedCourseIds,
            PrerequisiteCourseIds = summary.PrerequisiteCourseIds,
            UnlockAfterCourseId = summary.UnlockAfterCourseId,
            IsLocked = summary.IsLocked,
            LockReason = summary.LockReason,
            UnlockRequirements = summary.UnlockRequirements,
            ProgressPercent = summary.ProgressPercent,
            IsCompleted = summary.IsCompleted,
            Status = summary.Status,
            TrackTitle = course.Track.Title,
            TrackSlug = course.Track.Slug,
            Requirements = ReadStringList(course.RequirementsJson),
            LearningOutcomes = ReadStringList(course.LearningOutcomesJson),
            Modules = modules,
            RelatedCourses = relatedCourses.Select(x => MapCourseSummary(x, OrderedCourses(x.Track, false).ToList(), progress)).ToList(),
            NextUnlockedLesson = next,
            LockedLessonCount = allLessons.Count(x => x.IsLocked),
            CompletedLessons = allLessons.Count(x => x.Status == "Completed")
        };
    }

    private RoadmapModuleResponse MapModule(RoadmapModule module, RoadmapCourse course, RoadmapCourseSummaryResponse courseState, ProgressLookup progress, bool previousModuleCompleted)
    {
        var lessons = OrderedLessons(module, false).ToList();
        var required = lessons.Where(x => x.IsRequired).ToList();
        var completed = lessons.Count(x => progress.Lessons.TryGetValue(x.Id, out var p) && p.Status == "Completed");
        var requiredCompleted = required.Count > 0 && required.All(x => progress.Lessons.TryGetValue(x.Id, out var p) && p.Status == "Completed");
        var moduleLock = ModuleLock(module, course, courseState, previousModuleCompleted);

        var mappedLessons = new List<RoadmapLessonResponse>();
        var previousLessonCompleted = true;
        foreach (var lesson in lessons)
        {
            var mapped = MapLesson(lesson, moduleLock, progress, previousLessonCompleted);
            mappedLessons.Add(mapped);
            previousLessonCompleted = mapped.Status == "Completed";
        }

        return new RoadmapModuleResponse
        {
            Id = module.Id,
            CourseId = module.CourseId,
            Title = module.Title,
            Description = module.Description,
            SortOrder = module.SortOrder,
            EstimatedMinutes = module.EstimatedMinutes,
            RequiresPreviousModuleCompletion = module.RequiresPreviousModuleCompletion,
            IsLockedByDefault = module.IsLockedByDefault,
            IsPublished = module.IsPublished,
            IsLocked = moduleLock.IsLocked,
            LockReason = moduleLock.LockReason,
            UnlockRequirements = moduleLock.UnlockRequirements,
            ProgressPercent = Percent(completed, lessons.Count),
            IsCompleted = requiredCompleted,
            Lessons = mappedLessons
        };
    }

    private RoadmapLessonResponse MapLesson(RoadmapLesson lesson, RoadmapLockStateResponse moduleLock, ProgressLookup progress, bool previousLessonCompleted)
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

    private async Task RecalculateCourseTotals(long courseId, CancellationToken ct)
    {
        var course = await _db.RoadmapCourses.Include(x => x.Modules).ThenInclude(x => x.Lessons).FirstOrDefaultAsync(x => x.Id == courseId, ct);
        if (course == null) return;
        var modules = course.Modules.Where(x => !x.IsDeleted).ToList();
        course.TotalModules = modules.Count;
        course.TotalLessons = modules.SelectMany(x => x.Lessons).Count(x => !x.IsDeleted);
        course.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);
    }

    private async Task<List<string>> WeakTopics(long userId, CancellationToken ct)
    {
        var attempts = await _db.QuizAttempts.AsNoTracking()
            .Include(x => x.QuizSet).ThenInclude(x => x.Category)
            .Where(x => x.UserId == userId && x.Status == 2 && x.QuizSet.Category != null)
            .Select(x => new { Topic = x.QuizSet.Category!.Name, x.Score })
            .ToListAsync(ct);

        return attempts
            .GroupBy(x => x.Topic)
            .Select(x => new { Topic = x.Key, Average = x.Average(row => row.Score) })
            .Where(x => x.Average < 6m)
            .OrderBy(x => x.Average)
            .Select(x => x.Topic)
            .Take(5)
            .ToList();
    }

    private static void ApplyCourse(RoadmapCourse course, RoadmapCourseRequest request, string slug)
    {
        course.TrackId = request.TrackId;
        course.Title = request.Title.Trim();
        course.Slug = slug;
        course.ShortDescription = request.ShortDescription;
        course.Description = request.Description;
        course.Level = NormalizeLevel(request.Level);
        course.EstimatedHours = Math.Max(0, request.EstimatedHours);
        course.RequirementsJson = WriteJson(request.Requirements);
        course.LearningOutcomesJson = WriteJson(request.LearningOutcomes);
        course.RelatedCourseIdsJson = WriteJson(request.RelatedCourseIds.Distinct().Where(x => x > 0).ToList());
        course.PrerequisiteCourseIdsJson = WriteJson(request.PrerequisiteCourseIds.Distinct().Where(x => x > 0).ToList());
        course.ThumbnailUrl = request.ThumbnailUrl;
        course.SortOrder = request.SortOrder;
        course.IsPublished = request.IsPublished;
        course.RequiresSequentialCompletion = request.RequiresSequentialCompletion;
        course.UnlockAfterCourseId = request.UnlockAfterCourseId;
    }

    private static void ApplyModule(RoadmapModule module, RoadmapModuleRequest request)
    {
        module.Title = request.Title.Trim();
        module.Description = request.Description;
        module.SortOrder = request.SortOrder;
        module.EstimatedMinutes = Math.Max(0, request.EstimatedMinutes);
        module.RequiresPreviousModuleCompletion = request.RequiresPreviousModuleCompletion;
        module.IsLockedByDefault = request.IsLockedByDefault;
        module.IsPublished = request.IsPublished;
    }

    private static void ApplyLesson(RoadmapLesson lesson, RoadmapLessonRequest request)
    {
        lesson.Title = request.Title.Trim();
        lesson.Type = NormalizeLessonType(request.Type);
        lesson.Content = request.Content;
        lesson.VideoUrl = request.VideoUrl;
        lesson.QuizSetId = lesson.Type == "Quiz" ? request.QuizSetId : null;
        lesson.CodingProblemId = lesson.Type == "CodePractice" ? request.CodingProblemId : null;
        lesson.EstimatedMinutes = Math.Max(0, request.EstimatedMinutes);
        lesson.SortOrder = request.SortOrder;
        lesson.IsPreview = request.IsPreview;
        lesson.IsPublished = request.IsPublished;
        lesson.RequiresPreviousLessonCompletion = request.RequiresPreviousLessonCompletion;
        lesson.IsRequired = request.IsRequired;
        lesson.UnlockAfterLessonId = request.UnlockAfterLessonId;
    }

    private async Task<List<ApiError>> ValidateCourse(RoadmapCourseRequest request, long? id, CancellationToken ct)
    {
        var errors = new List<ApiError>();
        if (!await _db.LearningTracks.AnyAsync(x => x.Id == request.TrackId && !x.IsDeleted, ct))
            errors.Add(new ApiError { Field = "trackId", Message = "TrackId không tồn tại" });
        if (string.IsNullOrWhiteSpace(request.Title))
            errors.Add(new ApiError { Field = "title", Message = "Title không được trống" });
        var slug = NormalizeSlug(string.IsNullOrWhiteSpace(request.Slug) ? request.Title : request.Slug);
        if (string.IsNullOrWhiteSpace(slug))
            errors.Add(new ApiError { Field = "slug", Message = "Slug không hợp lệ" });
        else if (await _db.RoadmapCourses.AnyAsync(x => x.Slug == slug && !x.IsDeleted && x.Id != (id ?? 0), ct))
            errors.Add(new ApiError { Field = "slug", Message = "Slug khóa học đã tồn tại" });
        return errors;
    }

    private async Task<List<ApiError>> ValidateLesson(RoadmapLessonRequest request, long? lessonId, CancellationToken ct)
    {
        var errors = new List<ApiError>();
        if (string.IsNullOrWhiteSpace(request.Title))
            errors.Add(new ApiError { Field = "title", Message = "Title không được trống" });
        var type = NormalizeLessonType(request.Type);
        if (!LessonTypes.Contains(type))
            errors.Add(new ApiError { Field = "type", Message = "Type không hợp lệ" });
        if (type == "Quiz")
        {
            if (!request.QuizSetId.HasValue)
                errors.Add(new ApiError { Field = "quizSetId", Message = "Quiz lesson cần QuizSetId" });
            else if (!await _db.QuizSets.AnyAsync(x => x.Id == request.QuizSetId.Value && !x.IsDeleted, ct))
                errors.Add(new ApiError { Field = "quizSetId", Message = "QuizSetId không tồn tại" });
        }
        if (type == "CodePractice")
        {
            if (!request.CodingProblemId.HasValue)
                errors.Add(new ApiError { Field = "codingProblemId", Message = "CodePractice lesson cần CodingProblemId" });
            else if (!await _db.CodingProblems.AnyAsync(x => x.Id == request.CodingProblemId.Value && !x.IsDeleted, ct))
                errors.Add(new ApiError { Field = "codingProblemId", Message = "CodingProblemId không tồn tại" });
        }
        if (request.UnlockAfterLessonId.HasValue && request.UnlockAfterLessonId.Value == lessonId)
            errors.Add(new ApiError { Field = "unlockAfterLessonId", Message = "Bài học không thể tự mở khóa chính nó" });
        return errors;
    }

    private static List<ApiError> ValidateTrack(LearningTrackRequest request)
    {
        var errors = new List<ApiError>();
        if (string.IsNullOrWhiteSpace(request.Title))
            errors.Add(new ApiError { Field = "title", Message = "Title không được trống" });
        if (string.IsNullOrWhiteSpace(NormalizeSlug(string.IsNullOrWhiteSpace(request.Slug) ? request.Title : request.Slug)))
            errors.Add(new ApiError { Field = "slug", Message = "Slug không hợp lệ" });
        return errors;
    }

    private static List<ApiError> ValidateModule(RoadmapModuleRequest request)
    {
        var errors = new List<ApiError>();
        if (string.IsNullOrWhiteSpace(request.Title))
            errors.Add(new ApiError { Field = "title", Message = "Title không được trống" });
        return errors;
    }

    private static RoadmapModuleResponse MapAdminModule(RoadmapModule module) => new()
    {
        Id = module.Id,
        CourseId = module.CourseId,
        Title = module.Title,
        Description = module.Description,
        SortOrder = module.SortOrder,
        EstimatedMinutes = module.EstimatedMinutes,
        RequiresPreviousModuleCompletion = module.RequiresPreviousModuleCompletion,
        IsLockedByDefault = module.IsLockedByDefault,
        IsPublished = module.IsPublished,
        Lessons = module.Lessons.OrderBy(x => x.SortOrder).Select(MapAdminLesson).ToList()
    };

    private static RoadmapLessonResponse MapAdminLesson(RoadmapLesson lesson) => new()
    {
        Id = lesson.Id,
        ModuleId = lesson.ModuleId,
        Title = lesson.Title,
        Type = lesson.Type,
        Content = lesson.Content,
        VideoUrl = lesson.VideoUrl,
        QuizSetId = lesson.QuizSetId,
        CodingProblemId = lesson.CodingProblemId,
        EstimatedMinutes = lesson.EstimatedMinutes,
        SortOrder = lesson.SortOrder,
        IsPreview = lesson.IsPreview,
        IsRequired = lesson.IsRequired,
        IsPublished = lesson.IsPublished,
        RequiresPreviousLessonCompletion = lesson.RequiresPreviousLessonCompletion,
        UnlockAfterLessonId = lesson.UnlockAfterLessonId,
        CanStart = true,
        CanComplete = IsManualCompletable(lesson.Type)
    };

    private static decimal Percent(int completed, int total)
        => total <= 0 ? 0 : Math.Round(completed * 100m / total, 1);

    private static int LevelOrder(string level)
        => level switch { "Beginner" => 1, "Intermediate" => 2, "Advanced" => 3, _ => 99 };

    private static string NormalizeLevel(string value)
    {
        var normalized = (value ?? string.Empty).Trim();
        return CourseLevels.FirstOrDefault(x => x.Equals(normalized, StringComparison.OrdinalIgnoreCase)) ?? "Beginner";
    }

    private static string NormalizeLessonType(string value)
    {
        var normalized = (value ?? string.Empty).Trim();
        return LessonTypes.FirstOrDefault(x => x.Equals(normalized, StringComparison.OrdinalIgnoreCase)) ?? normalized;
    }

    private static string NormalizeSlug(string value)
    {
        var normalized = (value ?? string.Empty).Trim().ToLowerInvariant().Normalize(NormalizationForm.FormD);
        var chars = normalized
            .Where(ch => CharUnicodeInfo.GetUnicodeCategory(ch) != UnicodeCategory.NonSpacingMark)
            .Select(ch => char.IsLetterOrDigit(ch) ? ch : '-')
            .ToArray();
        return string.Join('-', new string(chars).Split('-', StringSplitOptions.RemoveEmptyEntries));
    }

    private static string WriteJson<T>(T value) => JsonSerializer.Serialize(value, JsonOptions);

    private static List<string> ReadStringList(string? json)
    {
        if (string.IsNullOrWhiteSpace(json)) return new List<string>();
        try { return JsonSerializer.Deserialize<List<string>>(json, JsonOptions) ?? new List<string>(); }
        catch { return new List<string>(); }
    }

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
