using DevLearningHub.Api.Common;
using DevLearningHub.Api.Data;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace DevLearningHub.Api.Controllers;

[ApiController]
[Route("api/v1/leaderboard")]
public sealed class LeaderboardController : ControllerBase
{
    private readonly DevLearningHubDbContext _db;

    public LeaderboardController(DevLearningHubDbContext db) => _db = db;

    [HttpGet]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<object>>> Get([FromQuery] int limit = 50, CancellationToken ct = default)
    {
        limit = Math.Clamp(limit, 1, 100);
        var rows = await _db.UserStats.AsNoTracking()
            .Join(_db.Users.AsNoTracking().Where(x => !x.IsDeleted && x.Status != 0),
                stat => stat.UserId,
                user => user.Id,
                (stat, user) => new
                {
                    user.Id,
                    user.FullName,
                    user.UserName,
                    user.AvatarUrl,
                    Xp = stat.Reputation,
                    stat.AcceptedCodeSubmissions,
                    stat.TotalQuizAttempts,
                    stat.TotalPosts,
                    stat.TotalComments,
                    stat.StreakDays
                })
            .OrderByDescending(x => x.Xp)
            .ThenByDescending(x => x.AcceptedCodeSubmissions)
            .ThenByDescending(x => x.TotalQuizAttempts)
            .Take(limit)
            .ToListAsync(ct);

        var ranked = rows.Select((x, index) => new
        {
            rank = index + 1,
            userId = x.Id,
            name = string.IsNullOrWhiteSpace(x.FullName) ? x.UserName : x.FullName,
            avatarUrl = x.AvatarUrl,
            xp = x.Xp,
            reputation = x.Xp,
            acceptedSubmissions = x.AcceptedCodeSubmissions,
            quizPassed = x.TotalQuizAttempts,
            posts = x.TotalPosts,
            comments = x.TotalComments,
            streakDays = x.StreakDays
        }).ToList();

        return Ok(ApiResponse<object>.Ok(ranked));
    }
}
