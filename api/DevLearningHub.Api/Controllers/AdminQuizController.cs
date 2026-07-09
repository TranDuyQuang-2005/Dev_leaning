using System.Text;
using System.Text.Json;
using DevLearningHub.Api.Common;
using DevLearningHub.Api.Data;
using DevLearningHub.Api.DTOs;
using DevLearningHub.Api.Entities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace DevLearningHub.Api.Controllers;

[ApiController]
[Route("api/v1/admin")]
[Authorize(Roles = "Admin")]
public sealed class AdminQuizController : BaseApiController
{
    private readonly DevLearningHubDbContext _db;
    public AdminQuizController(DevLearningHubDbContext db) => _db = db;

    [HttpGet("quizzes/{quizSetId:long}/statistics")]
    public async Task<ActionResult<ApiResponse<QuizStatisticsResponse>>> QuizStatistics(long quizSetId, CancellationToken ct)
    {
        var exists = await _db.QuizSets.AnyAsync(x => x.Id == quizSetId && !x.IsDeleted, ct);
        if (!exists) return NotFound(ApiResponse<QuizStatisticsResponse>.Fail("Quiz set not found"));
        return Ok(ApiResponse<QuizStatisticsResponse>.Ok(await BuildStatistics(_db.QuizAttempts.AsNoTracking().Where(x => x.QuizSetId == quizSetId && x.Status != 0), quizSetId, ct)));
    }

    [HttpGet("quizzes/statistics/overview")]
    public async Task<ActionResult<ApiResponse<QuizStatisticsResponse>>> OverviewStatistics(CancellationToken ct)
        => Ok(ApiResponse<QuizStatisticsResponse>.Ok(await BuildStatistics(_db.QuizAttempts.AsNoTracking().Where(x => x.Status != 0), null, ct)));

    [HttpGet("questions/export.csv")]
    public async Task<IActionResult> ExportQuestions([FromQuery] long? categoryId, [FromQuery] byte? difficulty, [FromQuery] string? keyword, CancellationToken ct)
    {
        var query = _db.Questions.AsNoTracking().Include(x => x.Options).Where(x => !x.IsDeleted);
        if (categoryId.HasValue) query = query.Where(x => x.CategoryId == categoryId.Value);
        if (difficulty.HasValue) query = query.Where(x => x.Difficulty == difficulty.Value);
        if (!string.IsNullOrWhiteSpace(keyword)) query = query.Where(x => x.Title.Contains(keyword) || x.Content.Contains(keyword));
        var rows = await query.OrderBy(x => x.Id).ToListAsync(ct);
        return CsvFile(BuildQuestionCsv(rows), "questions.csv");
    }

    [HttpGet("quizzes/{quizSetId:long}/export.csv")]
    public async Task<IActionResult> ExportQuiz(long quizSetId, CancellationToken ct)
    {
        var questions = await _db.QuizSetQuestions.AsNoTracking()
            .Where(x => x.QuizSetId == quizSetId)
            .Include(x => x.Question).ThenInclude(x => x.Options)
            .OrderBy(x => x.DisplayOrder)
            .Select(x => x.Question)
            .Where(x => !x.IsDeleted)
            .ToListAsync(ct);
        return CsvFile(BuildQuestionCsv(questions), $"quiz-{quizSetId}.csv");
    }

    [HttpPost("quiz-attempts/{attemptId:long}/reset")]
    public async Task<ActionResult<ApiResponse<object>>> ResetAttempt(long attemptId, CancellationToken ct)
    {
        var attempt = await _db.QuizAttempts.Include(x => x.Answers).ThenInclude(x => x.SelectedOptions).FirstOrDefaultAsync(x => x.Id == attemptId, ct);
        if (attempt == null) return NotFound(ApiResponse<object>.Fail("Attempt not found"));
        var old = new { attempt.Status, attempt.Score, attempt.SubmittedAt };
        attempt.Status = 0;
        await WriteAudit("quiz_attempt.reset", "QuizAttempt", attemptId.ToString(), old, new { attempt.Status }, ct);
        await _db.SaveChangesAsync(ct);
        return Ok(ApiResponse<object>.Ok(new { attemptId }, "Quiz attempt reset"));
    }

    [HttpPost("quizzes/{quizSetId:long}/users/{userId:long}/reset-attempts")]
    public async Task<ActionResult<ApiResponse<object>>> ResetAttemptsForUser(long quizSetId, long userId, CancellationToken ct)
    {
        var attempts = await _db.QuizAttempts.Where(x => x.QuizSetId == quizSetId && x.UserId == userId && x.Status != 0).ToListAsync(ct);
        foreach (var attempt in attempts) attempt.Status = 0;
        await WriteAudit("quiz_attempt.reset_user_quiz", "QuizSet", quizSetId.ToString(), null, new { userId, count = attempts.Count }, ct);
        await _db.SaveChangesAsync(ct);
        return Ok(ApiResponse<object>.Ok(new { quizSetId, userId, count = attempts.Count }, "Quiz attempts reset"));
    }

    private static async Task<QuizStatisticsResponse> BuildStatistics(IQueryable<QuizAttempt> query, long? quizSetId, CancellationToken ct)
    {
        var total = await query.CountAsync(ct);
        if (total == 0) return new QuizStatisticsResponse { QuizSetId = quizSetId };
        var passCount = await query.CountAsync(x => x.IsPassed, ct);
        var failCount = total - passCount;
        return new QuizStatisticsResponse
        {
            QuizSetId = quizSetId,
            TotalAttempts = total,
            UniqueUsers = await query.Select(x => x.UserId).Distinct().CountAsync(ct),
            AverageScore = Math.Round(await query.AverageAsync(x => x.Score, ct), 2),
            HighestScore = await query.MaxAsync(x => x.Score, ct),
            LowestScore = await query.MinAsync(x => x.Score, ct),
            PassCount = passCount,
            FailCount = failCount,
            PassRate = Math.Round(passCount * 100m / total, 2),
            AverageDurationSeconds = await query.Where(x => x.DurationSeconds != null).AverageAsync(x => (double?)x.DurationSeconds, ct) ?? 0
        };
    }

    private static string BuildQuestionCsv(List<Question> questions)
    {
        var sb = new StringBuilder();
        sb.AppendLine("question_text,question_type,option_a,option_b,option_c,option_d,correct_answer,explanation,difficulty,tags");
        foreach (var q in questions)
        {
            var options = q.Options.Where(x => !x.IsDeleted).OrderBy(x => x.DisplayOrder).ToList();
            var correct = options.FirstOrDefault(x => x.IsCorrect);
            var correctLabel = correct == null ? string.Empty : ((char)('A' + Math.Max(0, options.IndexOf(correct)))).ToString();
            var fields = new[]
            {
                q.Content,
                q.QuestionType == 1 ? "single_choice" : q.QuestionType.ToString(),
                options.ElementAtOrDefault(0)?.Content ?? string.Empty,
                options.ElementAtOrDefault(1)?.Content ?? string.Empty,
                options.ElementAtOrDefault(2)?.Content ?? string.Empty,
                options.ElementAtOrDefault(3)?.Content ?? string.Empty,
                correctLabel,
                q.Explanation ?? string.Empty,
                q.Difficulty switch { 1 => "easy", 2 => "medium", 3 => "hard", _ => "medium" },
                q.Source ?? string.Empty
            };
            sb.AppendLine(string.Join(",", fields.Select(EscapeCsv)));
        }
        return sb.ToString();
    }

    private FileContentResult CsvFile(string csv, string fileName)
        => File(Encoding.UTF8.GetBytes(csv), "text/csv; charset=utf-8", fileName);

    private static string EscapeCsv(string value)
    {
        value ??= string.Empty;
        return value.Contains('"') || value.Contains(',') || value.Contains('\n') || value.Contains('\r')
            ? "\"" + value.Replace("\"", "\"\"") + "\""
            : value;
    }

    private async Task WriteAudit(string action, string targetType, string? targetId, object? oldValue, object? newValue, CancellationToken ct)
    {
        _db.AuditLogs.Add(new AuditLog
        {
            UserId = CurrentUserId,
            Action = action,
            EntityName = targetType,
            EntityId = targetId,
            OldValues = oldValue == null ? null : JsonSerializer.Serialize(oldValue),
            NewValues = newValue == null ? null : JsonSerializer.Serialize(newValue),
            IpAddress = HttpContext.Connection.RemoteIpAddress?.ToString(),
            UserAgent = Request.Headers.UserAgent.ToString(),
            CreatedAt = DateTime.UtcNow
        });
        await _db.SaveChangesAsync(ct);
    }
}
