using DevLearningHub.Api.Common;
using DevLearningHub.Api.DTOs;
using DevLearningHub.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace DevLearningHub.Api.Controllers;

[ApiController]
[Route("api/v1/roadmaps")]
public sealed class RoadmapsController : BaseApiController
{
    private readonly IRoadmapService _service;
    public RoadmapsController(IRoadmapService service) => _service = service;

    [HttpGet]
    public async Task<ActionResult<ApiResponse<List<LearningTrackResponse>>>> Get(CancellationToken ct)
        => Ok(await _service.GetTracks(CurrentUserId, includeUnpublished: false, ct));

    [HttpGet("{slug}")]
    public async Task<ActionResult<ApiResponse<LearningTrackDetailResponse>>> Detail(string slug, CancellationToken ct)
        => Ok(await _service.GetTrackBySlug(slug, CurrentUserId, includeUnpublished: false, ct));
}

[ApiController]
[Route("api/v1/courses")]
public sealed class CoursesController : BaseApiController
{
    private readonly IRoadmapService _service;
    public CoursesController(IRoadmapService service) => _service = service;

    [HttpGet("{slug}")]
    public async Task<ActionResult<ApiResponse<RoadmapCourseDetailResponse>>> Detail(string slug, CancellationToken ct)
        => Ok(await _service.GetCourseBySlug(slug, CurrentUserId, includeUnpublished: false, ct));

    [HttpGet("{courseId:long}/progress")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<CourseProgressResponse>>> Progress(long courseId, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _service.GetCourseProgress(CurrentUserId.Value, courseId, ct));
    }
}

[ApiController]
[Route("api/v1/lessons")]
[Authorize]
public sealed class RoadmapLessonsController : BaseApiController
{
    private readonly IRoadmapService _service;
    public RoadmapLessonsController(IRoadmapService service) => _service = service;

    [HttpPost("{lessonId:long}/start")]
    public async Task<ActionResult<ApiResponse<RoadmapLessonResponse>>> Start(long lessonId, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        var response = await _service.StartLesson(CurrentUserId.Value, lessonId, ct);
        return response.Success ? Ok(response) : RoadmapFailure(response);
    }

    [HttpPost("{lessonId:long}/complete")]
    public async Task<ActionResult<ApiResponse<RoadmapLessonResponse>>> Complete(long lessonId, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        var response = await _service.CompleteLesson(CurrentUserId.Value, lessonId, ct);
        return response.Success ? Ok(response) : RoadmapFailure(response);
    }

    private ActionResult<ApiResponse<RoadmapLessonResponse>> RoadmapFailure(ApiResponse<RoadmapLessonResponse> response)
    {
        var locked = response.Message.Contains("khóa", StringComparison.OrdinalIgnoreCase);
        return StatusCode(locked ? StatusCodes.Status403Forbidden : StatusCodes.Status400BadRequest, response);
    }
}

[ApiController]
[Route("api/v1/admin/roadmaps")]
[Authorize(Roles = "Admin")]
public sealed class AdminRoadmapsController : ControllerBase
{
    private readonly IRoadmapService _service;
    public AdminRoadmapsController(IRoadmapService service) => _service = service;

    [HttpGet]
    public async Task<ActionResult<ApiResponse<List<LearningTrackDetailResponse>>>> Get(CancellationToken ct)
        => Ok(await _service.AdminTracks(ct));

    [HttpPost]
    public async Task<ActionResult<ApiResponse<LearningTrackDetailResponse>>> Post(LearningTrackRequest request, CancellationToken ct)
        => Ok(await _service.AdminSaveTrack(null, request, ct));

    [HttpPut("{id:long}")]
    public async Task<ActionResult<ApiResponse<LearningTrackDetailResponse>>> Put(long id, LearningTrackRequest request, CancellationToken ct)
        => Ok(await _service.AdminSaveTrack(id, request, ct));

    [HttpDelete("{id:long}")]
    public async Task<ActionResult<ApiResponse<object>>> Delete(long id, CancellationToken ct)
        => Ok(await _service.AdminDeleteTrack(id, ct));
}

[ApiController]
[Route("api/v1/admin/courses")]
[Authorize(Roles = "Admin")]
public sealed class AdminRoadmapCoursesController : ControllerBase
{
    private readonly IRoadmapService _service;
    public AdminRoadmapCoursesController(IRoadmapService service) => _service = service;

    [HttpGet]
    public async Task<ActionResult<ApiResponse<List<RoadmapCourseDetailResponse>>>> Get(long? trackId, CancellationToken ct)
        => Ok(await _service.AdminCourses(trackId, ct));

    [HttpGet("{id:long}")]
    public async Task<ActionResult<ApiResponse<RoadmapCourseDetailResponse>>> GetById(long id, CancellationToken ct)
        => Ok(await _service.AdminCourse(id, ct));

    [HttpPost]
    public async Task<ActionResult<ApiResponse<RoadmapCourseDetailResponse>>> Post(RoadmapCourseRequest request, CancellationToken ct)
        => Ok(await _service.AdminSaveCourse(null, request, ct));

    [HttpPut("{id:long}")]
    public async Task<ActionResult<ApiResponse<RoadmapCourseDetailResponse>>> Put(long id, RoadmapCourseRequest request, CancellationToken ct)
        => Ok(await _service.AdminSaveCourse(id, request, ct));

    [HttpDelete("{id:long}")]
    public async Task<ActionResult<ApiResponse<object>>> Delete(long id, CancellationToken ct)
        => Ok(await _service.AdminDeleteCourse(id, ct));

    [HttpPost("{courseId:long}/modules")]
    public async Task<ActionResult<ApiResponse<RoadmapModuleResponse>>> PostModule(long courseId, RoadmapModuleRequest request, CancellationToken ct)
        => Ok(await _service.AdminCreateModule(courseId, request, ct));
}

[ApiController]
[Route("api/v1/admin/modules")]
[Authorize(Roles = "Admin")]
public sealed class AdminRoadmapModulesController : ControllerBase
{
    private readonly IRoadmapService _service;
    public AdminRoadmapModulesController(IRoadmapService service) => _service = service;

    [HttpPut("{moduleId:long}")]
    public async Task<ActionResult<ApiResponse<RoadmapModuleResponse>>> Put(long moduleId, RoadmapModuleRequest request, CancellationToken ct)
        => Ok(await _service.AdminUpdateModule(moduleId, request, ct));

    [HttpDelete("{moduleId:long}")]
    public async Task<ActionResult<ApiResponse<object>>> Delete(long moduleId, CancellationToken ct)
        => Ok(await _service.AdminDeleteModule(moduleId, ct));

    [HttpPost("{moduleId:long}/lessons")]
    public async Task<ActionResult<ApiResponse<RoadmapLessonResponse>>> PostLesson(long moduleId, RoadmapLessonRequest request, CancellationToken ct)
        => Ok(await _service.AdminCreateLesson(moduleId, request, ct));
}

[ApiController]
[Route("api/v1/admin/lessons")]
[Authorize(Roles = "Admin")]
public sealed class AdminRoadmapLessonsController : ControllerBase
{
    private readonly IRoadmapService _service;
    public AdminRoadmapLessonsController(IRoadmapService service) => _service = service;

    [HttpPut("{lessonId:long}")]
    public async Task<ActionResult<ApiResponse<RoadmapLessonResponse>>> Put(long lessonId, RoadmapLessonRequest request, CancellationToken ct)
        => Ok(await _service.AdminUpdateLesson(lessonId, request, ct));

    [HttpDelete("{lessonId:long}")]
    public async Task<ActionResult<ApiResponse<object>>> Delete(long lessonId, CancellationToken ct)
        => Ok(await _service.AdminDeleteLesson(lessonId, ct));
}
