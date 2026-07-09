using DevLearningHub.Api.Common;
using DevLearningHub.Api.DTOs;
using DevLearningHub.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace DevLearningHub.Api.Controllers;

[ApiController]
[Route("api/v1/categories")]
public sealed class CategoriesController : ControllerBase
{
    private readonly ILearningModuleService _service;
    public CategoriesController(ILearningModuleService service) => _service = service;

    [HttpGet]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<PagedResult<CategoryResponse>>>> Get(string? keyword, int pageIndex = 1, int pageSize = 20, CancellationToken ct = default)
        => Ok(await _service.GetCategories(keyword, pageIndex, pageSize, ct));

    [HttpPost]
    [Authorize(Roles = "Admin")]
    public async Task<ActionResult<ApiResponse<CategoryResponse>>> Post(CategoryRequest request, CancellationToken ct)
        => Ok(await _service.CreateCategory(request, ct));

    [HttpPut("{id:long}")]
    [Authorize(Roles = "Admin")]
    public async Task<ActionResult<ApiResponse<CategoryResponse>>> Put(long id, CategoryRequest request, CancellationToken ct)
        => Ok(await _service.UpdateCategory(id, request, ct));

    [HttpDelete("{id:long}")]
    [Authorize(Roles = "Admin")]
    public async Task<ActionResult<ApiResponse<object>>> Delete(long id, CancellationToken ct)
        => Ok(await _service.DeleteCategory(id, ct));
}

[ApiController]
[Route("api/v1/questions")]
[Authorize]
public sealed class QuestionsController : BaseApiController
{
    private readonly ILearningModuleService _service;
    private readonly IFileModuleService _files;
    public QuestionsController(ILearningModuleService service, IFileModuleService files) { _service = service; _files = files; }

    [HttpGet]
    public async Task<ActionResult<ApiResponse<PagedResult<QuestionResponse>>>> Get(long? categoryId, int pageIndex = 1, int pageSize = 20, CancellationToken ct = default)
        => Ok(await _service.GetQuestions(categoryId, pageIndex, pageSize, ct));

    [HttpPost]
    [Authorize(Roles = "Admin")]
    public async Task<ActionResult<ApiResponse<QuestionResponse>>> Post(QuestionRequest request, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _service.CreateQuestion(CurrentUserId.Value, request, ct));
    }

    [HttpPut("{id:long}")]
    [Authorize(Roles = "Admin")]
    public async Task<ActionResult<ApiResponse<QuestionResponse>>> Put(long id, QuestionRequest request, CancellationToken ct)
        => Ok(await _service.UpdateQuestion(id, request, ct));

    [HttpDelete("{id:long}")]
    [Authorize(Roles = "Admin")]
    public async Task<ActionResult<ApiResponse<object>>> Delete(long id, CancellationToken ct)
        => Ok(await _service.DeleteQuestion(id, ct));

    [HttpPost("import-csv")]
    [Authorize(Roles = "Admin")]
    public async Task<ActionResult<ApiResponse<ImportQuestionResult>>> ImportCsv(IFormFile file, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _files.ImportQuestionsCsv(CurrentUserId.Value, file, ct));
    }

    [HttpPost("import-json")]
    [Authorize(Roles = "Admin")]
    public async Task<ActionResult<ApiResponse<ImportQuestionResult>>> ImportJson(IFormFile file, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _files.ImportQuestionsJson(CurrentUserId.Value, file, ct));
    }
}

[ApiController]
[Route("api/v1/quiz-sets")]
public sealed class QuizSetsController : BaseApiController
{
    private readonly ILearningModuleService _service;
    public QuizSetsController(ILearningModuleService service) => _service = service;

    [HttpGet]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<PagedResult<QuizSetResponse>>>> Get(long? categoryId, int pageIndex = 1, int pageSize = 20, CancellationToken ct = default)
        => Ok(await _service.GetQuizSets(categoryId, pageIndex, pageSize, ct));

    [HttpGet("{id:long}")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<QuizSetResponse>>> GetById(long id, CancellationToken ct)
        => Ok(await _service.GetQuizSet(id, ct));

    [HttpPost]
    [Authorize(Roles = "Admin")]
    public async Task<ActionResult<ApiResponse<QuizSetResponse>>> Post(QuizSetRequest request, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _service.CreateQuizSet(CurrentUserId.Value, request, ct));
    }

    [HttpPut("{id:long}")]
    [Authorize(Roles = "Admin")]
    public async Task<ActionResult<ApiResponse<QuizSetResponse>>> Put(long id, QuizSetRequest request, CancellationToken ct)
        => Ok(await _service.UpdateQuizSet(id, request, ct));

    [HttpDelete("{id:long}")]
    [Authorize(Roles = "Admin")]
    public async Task<ActionResult<ApiResponse<object>>> Delete(long id, CancellationToken ct)
        => Ok(await _service.DeleteQuizSet(id, ct));
}

[ApiController]
[Route("api/v1/quiz-attempts")]
[Authorize]
public sealed class QuizAttemptsController : BaseApiController
{
    private readonly ILearningModuleService _service;
    public QuizAttemptsController(ILearningModuleService service) => _service = service;

    [HttpPost]
    public async Task<ActionResult<ApiResponse<QuizAttemptResponse>>> Start(StartQuizAttemptRequest request, [FromQuery] long? lessonId, [FromQuery] long? roadmapLessonId, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        request.LessonId ??= lessonId;
        request.RoadmapLessonId ??= roadmapLessonId;
        var response = await _service.StartAttempt(CurrentUserId.Value, request, ct);
        return response.Success ? Ok(response) : BadRequest(response);
    }

    [HttpPost("{id:long}/submit")]
    public async Task<ActionResult<ApiResponse<QuizAttemptDetailResultResponse>>> Submit(long id, SubmitQuizAttemptRequest request, [FromQuery] long? lessonId, [FromQuery] long? roadmapLessonId, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        request.LessonId ??= lessonId;
        request.RoadmapLessonId ??= roadmapLessonId;
        var response = await _service.SubmitAttempt(CurrentUserId.Value, id, request, ct);
        return response.Success ? Ok(response) : BadRequest(response);
    }

    [HttpGet("{id:long}/result")]
    public async Task<ActionResult<ApiResponse<QuizAttemptDetailResultResponse>>> Result(long id, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _service.GetAttemptResult(CurrentUserId.Value, id, ct));
    }

    [HttpGet("me")]
    public async Task<ActionResult<ApiResponse<List<QuizSubmitResultResponse>>>> Mine(CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _service.MyAttempts(CurrentUserId.Value, ct));
    }
}
