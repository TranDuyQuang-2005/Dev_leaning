using DevLearningHub.Api.Common;
using DevLearningHub.Api.DTOs;
using DevLearningHub.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;

namespace DevLearningHub.Api.Controllers;

[ApiController]
[Route("api/v1/forum")]
public sealed class ForumController : BaseApiController
{
    private readonly IForumModuleService _forum;
    public ForumController(IForumModuleService forum) => _forum = forum;

    [HttpGet("tags")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<List<ForumTagResponse>>>> Tags(CancellationToken ct)
        => Ok(await _forum.GetTags(ct));

    [HttpPost("uploads")]
    [Consumes("multipart/form-data")]
    [Authorize]
    [EnableRateLimiting("file-upload")]
    [RequestSizeLimit(15 * 1024 * 1024)]
    public async Task<ActionResult<ApiResponse<ForumAttachmentResponse>>> Upload(IFormFile file, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _forum.UploadAttachment(CurrentUserId.Value, file, ct));
    }

    [HttpGet("posts")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<PagedResult<ForumPostSummaryResponse>>>> Posts(string? keyword, string? tag, int pageIndex = 1, int pageSize = 10, CancellationToken ct = default)
        => Ok(await _forum.GetPosts(CurrentUserId, keyword, tag, pageIndex, pageSize, ct));

    [HttpGet("posts/{id:long}")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<ForumPostDetailResponse>>> Post(long id, CancellationToken ct)
        => Ok(await _forum.GetPost(CurrentUserId, id, ct));

    [HttpPost("posts")]
    [Authorize]
    [EnableRateLimiting("forum-write")]
    public async Task<ActionResult<ApiResponse<ForumPostDetailResponse>>> CreatePost(ForumPostRequest request, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _forum.CreatePost(CurrentUserId.Value, request, ct));
    }

    [HttpPut("posts/{id:long}")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<ForumPostDetailResponse>>> UpdatePost(long id, ForumPostRequest request, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _forum.UpdatePost(CurrentUserId.Value, User.IsInRole("Admin") || User.IsInRole("Moderator"), id, request, ct));
    }

    [HttpDelete("posts/{id:long}")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<object>>> DeletePost(long id, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _forum.DeletePost(CurrentUserId.Value, User.IsInRole("Admin") || User.IsInRole("Moderator"), id, ct));
    }

    [HttpPost("posts/{id:long}/comments")]
    [Authorize]
    [EnableRateLimiting("forum-write")]
    public async Task<ActionResult<ApiResponse<ForumCommentResponse>>> AddComment(long id, ForumCommentRequest request, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _forum.AddComment(CurrentUserId.Value, id, request, ct));
    }

    [HttpPut("comments/{id:long}")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<ForumCommentResponse>>> UpdateComment(long id, ForumCommentRequest request, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _forum.UpdateComment(CurrentUserId.Value, User.IsInRole("Admin") || User.IsInRole("Moderator"), id, request, ct));
    }

    [HttpDelete("comments/{id:long}")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<object>>> DeleteComment(long id, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _forum.DeleteComment(CurrentUserId.Value, User.IsInRole("Admin") || User.IsInRole("Moderator"), id, ct));
    }


    [HttpPost("posts/{postId:long}/comments/{commentId:long}/accept")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<object>>> AcceptAnswer(long postId, long commentId, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _forum.AcceptCommentAsAnswer(CurrentUserId.Value, User.IsInRole("Admin") || User.IsInRole("Moderator"), postId, commentId, ct));
    }

    [HttpDelete("posts/{postId:long}/accepted-answer")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<object>>> ClearAcceptedAnswer(long postId, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _forum.ClearAcceptedAnswer(CurrentUserId.Value, User.IsInRole("Admin") || User.IsInRole("Moderator"), postId, ct));
    }

    [HttpPost("posts/{id:long}/vote")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<object>>> VotePost(long id, ForumVoteRequest request, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _forum.VotePost(CurrentUserId.Value, id, request, ct));
    }

    [HttpPost("comments/{id:long}/vote")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<object>>> VoteComment(long id, ForumVoteRequest request, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _forum.VoteComment(CurrentUserId.Value, id, request, ct));
    }

    [HttpPost("posts/{id:long}/bookmark")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<object>>> Bookmark(long id, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _forum.BookmarkPost(CurrentUserId.Value, id, ct));
    }

    [HttpDelete("posts/{id:long}/bookmark")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<object>>> RemoveBookmark(long id, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _forum.RemoveBookmark(CurrentUserId.Value, id, ct));
    }

    [HttpPost("reports")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<object>>> Report(ForumReportRequest request, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _forum.CreateReport(CurrentUserId.Value, request, ct));
    }
}

[ApiController]
[Route("api/v1/admin/forum")]
[Authorize(Roles = "Admin,Moderator")]
public sealed class AdminForumController : BaseApiController
{
    private readonly IForumModuleService _forum;
    public AdminForumController(IForumModuleService forum) => _forum = forum;

    [HttpGet("posts")]
    public async Task<ActionResult<ApiResponse<PagedResult<ForumPostSummaryResponse>>>> Posts(string? keyword, byte? status, int pageIndex = 1, int pageSize = 20, CancellationToken ct = default)
        => Ok(await _forum.AdminPosts(keyword, status, pageIndex, pageSize, ct));

    [HttpPut("posts/{id:long}/hide")]
    public async Task<ActionResult<ApiResponse<object>>> HidePost(long id, ModerationReasonRequest request, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _forum.HidePost(CurrentUserId.Value, id, request.Reason, ct));
    }

    [HttpPut("posts/{id:long}/restore")]
    public async Task<ActionResult<ApiResponse<object>>> RestorePost(long id, ModerationReasonRequest request, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _forum.RestorePost(CurrentUserId.Value, id, request.Reason, ct));
    }

    [HttpDelete("posts/{id:long}")]
    public async Task<ActionResult<ApiResponse<object>>> DeletePost(long id, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _forum.DeletePost(CurrentUserId.Value, true, id, ct));
    }

    [HttpGet("comments")]
    public async Task<ActionResult<ApiResponse<PagedResult<ForumCommentResponse>>>> Comments(string? keyword, byte? status, int pageIndex = 1, int pageSize = 20, CancellationToken ct = default)
        => Ok(await _forum.AdminComments(keyword, status, pageIndex, pageSize, ct));

    [HttpPut("comments/{id:long}/hide")]
    public async Task<ActionResult<ApiResponse<object>>> HideComment(long id, ModerationReasonRequest request, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _forum.HideComment(CurrentUserId.Value, id, request.Reason, ct));
    }

    [HttpDelete("comments/{id:long}")]
    public async Task<ActionResult<ApiResponse<object>>> DeleteComment(long id, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _forum.DeleteComment(CurrentUserId.Value, true, id, ct));
    }

    [HttpGet("reports")]
    public async Task<ActionResult<ApiResponse<PagedResult<ForumReportResponse>>>> Reports(byte? status, int pageIndex = 1, int pageSize = 20, CancellationToken ct = default)
        => Ok(await _forum.AdminReports(status, pageIndex, pageSize, ct));

    [HttpPut("reports/{id:long}/resolve")]
    public async Task<ActionResult<ApiResponse<object>>> ResolveReport(long id, ResolveReportRequest request, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _forum.ResolveReport(CurrentUserId.Value, id, request, ct));
    }

    [HttpGet("tags")]
    public async Task<ActionResult<ApiResponse<List<ForumTagResponse>>>> Tags(CancellationToken ct)
        => Ok(await _forum.GetTags(ct));

    [HttpPost("uploads")]
    [Consumes("multipart/form-data")]
    [Authorize]
    [EnableRateLimiting("file-upload")]
    [RequestSizeLimit(15 * 1024 * 1024)]
    public async Task<ActionResult<ApiResponse<ForumAttachmentResponse>>> Upload(IFormFile file, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _forum.UploadAttachment(CurrentUserId.Value, file, ct));
    }

    [HttpPost("tags")]
    public async Task<ActionResult<ApiResponse<ForumTagResponse>>> CreateTag(ForumTagRequest request, CancellationToken ct)
        => Ok(await _forum.CreateTag(request, ct));

    [HttpPut("tags/{id:long}")]
    public async Task<ActionResult<ApiResponse<ForumTagResponse>>> UpdateTag(long id, ForumTagRequest request, CancellationToken ct)
        => Ok(await _forum.UpdateTag(id, request, ct));

    [HttpDelete("tags/{id:long}")]
    public async Task<ActionResult<ApiResponse<object>>> DeleteTag(long id, CancellationToken ct)
        => Ok(await _forum.DeleteTag(id, ct));
}


[ApiController]
[Route("api/v1/moderator/forum")]
[Authorize(Roles = "Admin,Moderator")]
public sealed class ModeratorForumController : BaseApiController
{
    private readonly IForumModuleService _forum;
    public ModeratorForumController(IForumModuleService forum) => _forum = forum;

    [HttpGet("posts")]
    public async Task<ActionResult<ApiResponse<PagedResult<ForumPostSummaryResponse>>>> Posts(string? keyword, byte? status, int pageIndex = 1, int pageSize = 20, CancellationToken ct = default)
        => Ok(await _forum.AdminPosts(keyword, status, pageIndex, pageSize, ct));

    [HttpPut("posts/{id:long}/hide")]
    public async Task<ActionResult<ApiResponse<object>>> HidePost(long id, ModerationReasonRequest request, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _forum.HidePost(CurrentUserId.Value, id, request.Reason, ct));
    }

    [HttpPut("posts/{id:long}/restore")]
    public async Task<ActionResult<ApiResponse<object>>> RestorePost(long id, ModerationReasonRequest request, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _forum.RestorePost(CurrentUserId.Value, id, request.Reason, ct));
    }

    [HttpGet("comments")]
    public async Task<ActionResult<ApiResponse<PagedResult<ForumCommentResponse>>>> Comments(string? keyword, byte? status, int pageIndex = 1, int pageSize = 20, CancellationToken ct = default)
        => Ok(await _forum.AdminComments(keyword, status, pageIndex, pageSize, ct));

    [HttpPut("comments/{id:long}/hide")]
    public async Task<ActionResult<ApiResponse<object>>> HideComment(long id, ModerationReasonRequest request, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _forum.HideComment(CurrentUserId.Value, id, request.Reason, ct));
    }

    [HttpGet("reports")]
    public async Task<ActionResult<ApiResponse<PagedResult<ForumReportResponse>>>> Reports(byte? status, int pageIndex = 1, int pageSize = 20, CancellationToken ct = default)
        => Ok(await _forum.AdminReports(status, pageIndex, pageSize, ct));

    [HttpPut("reports/{id:long}/resolve")]
    public async Task<ActionResult<ApiResponse<object>>> ResolveReport(long id, ResolveReportRequest request, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _forum.ResolveReport(CurrentUserId.Value, id, request, ct));
    }

    [HttpGet("tags")]
    public async Task<ActionResult<ApiResponse<List<ForumTagResponse>>>> Tags(CancellationToken ct)
        => Ok(await _forum.GetTags(ct));

    [HttpPost("uploads")]
    [Consumes("multipart/form-data")]
    [Authorize]
    [EnableRateLimiting("file-upload")]
    [RequestSizeLimit(15 * 1024 * 1024)]
    public async Task<ActionResult<ApiResponse<ForumAttachmentResponse>>> Upload(IFormFile file, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _forum.UploadAttachment(CurrentUserId.Value, file, ct));
    }
}
