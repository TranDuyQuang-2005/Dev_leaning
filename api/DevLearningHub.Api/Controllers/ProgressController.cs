using DevLearningHub.Api.Common;
using DevLearningHub.Api.Data;
using DevLearningHub.Api.DTOs;
using DevLearningHub.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace DevLearningHub.Api.Controllers;

[ApiController]
[Route("api/v1/me/progress")]
[Authorize]
public sealed class ProgressController : BaseApiController
{
    private static readonly string[] DefaultRecommendations = { "Algorithms", "System Design", "SQL" };

    private readonly DevLearningHubDbContext _db;
    private readonly IRoadmapService _roadmaps;

    public ProgressController(DevLearningHubDbContext db, IRoadmapService roadmaps)
    {
        _db = db;
        _roadmaps = roadmaps;
    }

    [HttpGet("overview")]
    public async Task<ActionResult<ApiResponse<ProgressOverviewResponse>>> Overview(CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _roadmaps.GetProgressOverview(CurrentUserId.Value, ct));
    }

    [HttpGet("topics")]
    public async Task<ActionResult<ApiResponse<object>>> Topics(CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        var topicRows = await BuildTopicRows(CurrentUserId.Value, ct);
        return Ok(ApiResponse<object>.Ok(topicRows.OrderBy(x => x.Topic).ToList()));
    }

    [HttpGet("roadmap")]
    public async Task<ActionResult<ApiResponse<ProgressRoadmapResponse>>> Roadmap(CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _roadmaps.GetProgressRoadmap(CurrentUserId.Value, ct));
    }

    private async Task<List<TopicProgressRow>> BuildTopicRows(long userId, CancellationToken ct)
    {
        var categories = await _db.Categories.AsNoTracking()
            .Where(x => !x.IsDeleted && x.Status != 0)
            .OrderBy(x => x.DisplayOrder)
            .Select(x => new { x.Id, x.Name })
            .ToListAsync(ct);

        var attempts = await _db.QuizAttempts.AsNoTracking()
            .Include(x => x.QuizSet)
            .Where(x => x.UserId == userId && x.Status == 2 && x.QuizSet != null && x.QuizSet.CategoryId != null)
            .Select(x => new
            {
                CategoryId = x.QuizSet!.CategoryId!.Value,
                x.Score,
                x.IsPassed,
                x.SubmittedAt
            })
            .ToListAsync(ct);

        return categories.Select(category =>
        {
            var rows = attempts.Where(x => x.CategoryId == category.Id).ToList();
            var total = rows.Count;
            var average = total == 0 ? 0 : Math.Round(rows.Average(x => x.Score), 2);
            return new TopicProgressRow
            {
                Topic = category.Name,
                TotalQuizAttempts = total,
                AverageScore = average,
                PassedAttempts = rows.Count(x => x.IsPassed),
                LastPracticedAt = rows.Max(x => x.SubmittedAt)
            };
        }).ToList();
    }

    private static List<string> RecommendedTopics(List<TopicProgressRow> topicRows, List<string> weakTopics)
    {
        var recommendations = weakTopics
            .Concat(DefaultRecommendations)
            .Concat(topicRows.Where(x => x.TotalQuizAttempts == 0).Select(x => x.Topic))
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .Take(5)
            .ToList();

        return recommendations.Count > 0 ? recommendations : DefaultRecommendations.ToList();
    }

    private static string[] Prioritize(string[] topics, List<string> priority)
        => topics.OrderByDescending(topic => priority.Contains(topic, StringComparer.OrdinalIgnoreCase)).ThenBy(topic => Array.IndexOf(topics, topic)).ToArray();

    private sealed class TopicProgressRow
    {
        public string Topic { get; set; } = string.Empty;
        public int TotalQuizAttempts { get; set; }
        public decimal AverageScore { get; set; }
        public int PassedAttempts { get; set; }
        public DateTime? LastPracticedAt { get; set; }
    }
}
