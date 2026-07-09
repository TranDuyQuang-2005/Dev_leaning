using DevLearningHub.Api.Common;
using DevLearningHub.Api.Data;
using DevLearningHub.Api.DTOs;
using DevLearningHub.Api.Entities;
using Microsoft.EntityFrameworkCore;

namespace DevLearningHub.Api.Services;

public interface IForumModuleService
{
    Task<ApiResponse<ForumAttachmentResponse>> UploadAttachment(long userId, IFormFile file, CancellationToken ct);
    Task<ApiResponse<PagedResult<ForumPostSummaryResponse>>> GetPosts(long? currentUserId, string? keyword, string? tag, int pageIndex, int pageSize, CancellationToken ct);
    Task<ApiResponse<ForumPostDetailResponse>> GetPost(long? currentUserId, long postId, CancellationToken ct);
    Task<ApiResponse<ForumPostDetailResponse>> CreatePost(long userId, ForumPostRequest request, CancellationToken ct);
    Task<ApiResponse<ForumPostDetailResponse>> UpdatePost(long userId, bool canModerate, long postId, ForumPostRequest request, CancellationToken ct);
    Task<ApiResponse<object>> DeletePost(long userId, bool canModerate, long postId, CancellationToken ct);
    Task<ApiResponse<ForumCommentResponse>> AddComment(long userId, long postId, ForumCommentRequest request, CancellationToken ct);
    Task<ApiResponse<ForumCommentResponse>> UpdateComment(long userId, bool canModerate, long commentId, ForumCommentRequest request, CancellationToken ct);
    Task<ApiResponse<object>> DeleteComment(long userId, bool canModerate, long commentId, CancellationToken ct);
    Task<ApiResponse<object>> AcceptCommentAsAnswer(long userId, bool canModerate, long postId, long commentId, CancellationToken ct);
    Task<ApiResponse<object>> ClearAcceptedAnswer(long userId, bool canModerate, long postId, CancellationToken ct);
    Task<ApiResponse<object>> VotePost(long userId, long postId, ForumVoteRequest request, CancellationToken ct);
    Task<ApiResponse<object>> VoteComment(long userId, long commentId, ForumVoteRequest request, CancellationToken ct);
    Task<ApiResponse<object>> BookmarkPost(long userId, long postId, CancellationToken ct);
    Task<ApiResponse<object>> RemoveBookmark(long userId, long postId, CancellationToken ct);
    Task<ApiResponse<object>> CreateReport(long userId, ForumReportRequest request, CancellationToken ct);
    Task<ApiResponse<List<ForumTagResponse>>> GetTags(CancellationToken ct);
    Task<ApiResponse<ForumTagResponse>> CreateTag(ForumTagRequest request, CancellationToken ct);
    Task<ApiResponse<ForumTagResponse>> UpdateTag(long id, ForumTagRequest request, CancellationToken ct);
    Task<ApiResponse<object>> DeleteTag(long id, CancellationToken ct);
    Task<ApiResponse<PagedResult<ForumPostSummaryResponse>>> AdminPosts(string? keyword, byte? status, int pageIndex, int pageSize, CancellationToken ct);
    Task<ApiResponse<object>> HidePost(long moderatorId, long postId, string? reason, CancellationToken ct);
    Task<ApiResponse<object>> RestorePost(long moderatorId, long postId, string? reason, CancellationToken ct);
    Task<ApiResponse<PagedResult<ForumCommentResponse>>> AdminComments(string? keyword, byte? status, int pageIndex, int pageSize, CancellationToken ct);
    Task<ApiResponse<object>> HideComment(long moderatorId, long commentId, string? reason, CancellationToken ct);
    Task<ApiResponse<PagedResult<ForumReportResponse>>> AdminReports(byte? status, int pageIndex, int pageSize, CancellationToken ct);
    Task<ApiResponse<object>> ResolveReport(long moderatorId, long reportId, ResolveReportRequest request, CancellationToken ct);
}

public sealed class ForumModuleService : IForumModuleService
{
    private readonly DevLearningHubDbContext _db;
    private readonly IObjectStorageService _storage;

    public ForumModuleService(DevLearningHubDbContext db, IObjectStorageService storage)
    {
        _db = db;
        _storage = storage;
    }

    public async Task<ApiResponse<ForumAttachmentResponse>> UploadAttachment(long userId, IFormFile file, CancellationToken ct)
    {
        try
        {
            var stored = await _storage.UploadForumFileAsync(file, userId, ct);
            var entity = new AppFile
            {
                UploadedByUserId = userId,
                OriginalFileName = stored.OriginalFileName,
                StoredFileName = stored.StoredFileName,
                FileUrl = stored.FileUrl,
                MimeType = stored.MimeType,
                FileSizeBytes = stored.FileSizeBytes,
                StorageProvider = stored.StorageProvider,
                FileType = stored.FileType,
                CreatedAt = DateTime.UtcNow,
                IsDeleted = false
            };
            _db.Files.Add(entity);
            await _db.SaveChangesAsync(ct);
            return ApiResponse<ForumAttachmentResponse>.Ok(MapAttachment(entity), "Upload file thÃ nh cÃ´ng");
        }
        catch (Exception ex)
        {
            return ApiResponse<ForumAttachmentResponse>.Fail(ex.Message);
        }
    }

    public async Task<ApiResponse<List<ForumTagResponse>>> GetTags(CancellationToken ct)
    {
        var tags = await _db.Tags.AsNoTracking().OrderBy(x => x.Name).Select(MapTagExpr()).ToListAsync(ct);
        return ApiResponse<List<ForumTagResponse>>.Ok(tags);
    }

    public async Task<ApiResponse<ForumTagResponse>> CreateTag(ForumTagRequest request, CancellationToken ct)
    {
        var errors = ValidateTag(request);
        if (errors.Count > 0) return ApiResponse<ForumTagResponse>.Fail("Dá»¯ liá»‡u tag khÃ´ng há»£p lá»‡", errors);
        var slug = Slugify(string.IsNullOrWhiteSpace(request.Slug) ? request.Name : request.Slug);
        if (await _db.Tags.AnyAsync(x => x.Slug == slug, ct)) return ApiResponse<ForumTagResponse>.Fail("Slug tag Ä‘Ã£ tá»“n táº¡i");
        var tag = new Tag { Name = request.Name.Trim(), Slug = slug, Description = request.Description, CreatedAt = DateTime.UtcNow };
        _db.Tags.Add(tag);
        await _db.SaveChangesAsync(ct);
        return ApiResponse<ForumTagResponse>.Ok(MapTag(tag), "Táº¡o tag thÃ nh cÃ´ng");
    }

    public async Task<ApiResponse<ForumTagResponse>> UpdateTag(long id, ForumTagRequest request, CancellationToken ct)
    {
        var tag = await _db.Tags.FirstOrDefaultAsync(x => x.Id == id, ct);
        if (tag == null) return ApiResponse<ForumTagResponse>.Fail("KhÃ´ng tÃ¬m tháº¥y tag");
        var errors = ValidateTag(request);
        if (errors.Count > 0) return ApiResponse<ForumTagResponse>.Fail("Dá»¯ liá»‡u tag khÃ´ng há»£p lá»‡", errors);
        var slug = Slugify(string.IsNullOrWhiteSpace(request.Slug) ? request.Name : request.Slug);
        if (await _db.Tags.AnyAsync(x => x.Id != id && x.Slug == slug, ct)) return ApiResponse<ForumTagResponse>.Fail("Slug tag Ä‘Ã£ tá»“n táº¡i");
        tag.Name = request.Name.Trim();
        tag.Slug = slug;
        tag.Description = request.Description;
        await _db.SaveChangesAsync(ct);
        return ApiResponse<ForumTagResponse>.Ok(MapTag(tag), "Cáº­p nháº­t tag thÃ nh cÃ´ng");
    }

    public async Task<ApiResponse<object>> DeleteTag(long id, CancellationToken ct)
    {
        var used = await _db.PostTags.AnyAsync(x => x.TagId == id, ct);
        if (used) return ApiResponse<object>.Fail("Tag Ä‘ang Ä‘Æ°á»£c sá»­ dá»¥ng, khÃ´ng thá»ƒ xÃ³a");
        var tag = await _db.Tags.FirstOrDefaultAsync(x => x.Id == id, ct);
        if (tag == null) return ApiResponse<object>.Fail("KhÃ´ng tÃ¬m tháº¥y tag");
        _db.Tags.Remove(tag);
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { id }, "XÃ³a tag thÃ nh cÃ´ng");
    }

    public async Task<ApiResponse<PagedResult<ForumPostSummaryResponse>>> GetPosts(long? currentUserId, string? keyword, string? tag, int pageIndex, int pageSize, CancellationToken ct)
    {
        var query = _db.Posts.AsNoTracking()
            .Include(x => x.Author)
            .Include(x => x.PostTags).ThenInclude(x => x.Tag)
            .Include(x => x.Bookmarks)
            .Include(x => x.Votes)
            .Where(x => !x.IsDeleted && x.Status == 1);

        if (!string.IsNullOrWhiteSpace(keyword))
        {
            var kw = keyword.Trim();
            query = query.Where(x => x.Title.Contains(kw) || x.Content.Contains(kw));
        }
        if (!string.IsNullOrWhiteSpace(tag) && tag != "all")
        {
            var slug = Slugify(tag);
            query = query.Where(x => x.PostTags.Any(pt => pt.Tag.Slug == slug));
        }
        pageIndex = Math.Max(1, pageIndex);
        pageSize = Math.Clamp(pageSize, 1, 50);
        var total = await query.CountAsync(ct);
        var posts = await query.OrderByDescending(x => x.LastActivityAt ?? x.CreatedAt).Skip((pageIndex - 1) * pageSize).Take(pageSize).ToListAsync(ct);
        var items = new List<ForumPostSummaryResponse>();
        foreach (var post in posts) items.Add(await MapPostSummaryAsync(post, currentUserId, ct));
        return ApiResponse<PagedResult<ForumPostSummaryResponse>>.Ok(PagedResult<ForumPostSummaryResponse>.Create(items, pageIndex, pageSize, total));
    }

    public async Task<ApiResponse<ForumPostDetailResponse>> GetPost(long? currentUserId, long postId, CancellationToken ct)
    {
        var post = await LoadPostDetail(postId, ct);
        if (post == null || post.IsDeleted || post.Status != 1) return ApiResponse<ForumPostDetailResponse>.Fail("KhÃ´ng tÃ¬m tháº¥y bÃ i viáº¿t");
        post.ViewCount++;
        await _db.SaveChangesAsync(ct);
        return ApiResponse<ForumPostDetailResponse>.Ok(await MapPostDetailAsync(post, currentUserId, false, ct));
    }

    public async Task<ApiResponse<ForumPostDetailResponse>> CreatePost(long userId, ForumPostRequest request, CancellationToken ct)
    {
        var errors = ValidatePost(request);
        if (errors.Count > 0) return ApiResponse<ForumPostDetailResponse>.Fail("Dá»¯ liá»‡u bÃ i viáº¿t khÃ´ng há»£p lá»‡", errors);
        await using var tx = await _db.Database.BeginTransactionAsync(ct);
        var slug = await UniquePostSlug(request.Title, ct);
        var post = new Post { AuthorId = userId, Title = request.Title.Trim(), Slug = slug, Content = request.Content.Trim(), Status = 1, CreatedAt = DateTime.UtcNow, LastActivityAt = DateTime.UtcNow };
        _db.Posts.Add(post);
        await _db.SaveChangesAsync(ct);
        await SetPostTags(post.Id, request.Tags, ct);
        var attachError = await SetPostAttachments(post.Id, userId, request.AttachmentIds, ct);
        if (attachError != null) return ApiResponse<ForumPostDetailResponse>.Fail(attachError);
        await UpdateUserForumStats(userId, postsDelta: 1, commentsDelta: 0, ct);
        await tx.CommitAsync(ct);
        var loaded = await LoadPostDetail(post.Id, ct);
        return ApiResponse<ForumPostDetailResponse>.Ok(await MapPostDetailAsync(loaded!, userId, false, ct), "Táº¡o bÃ i viáº¿t thÃ nh cÃ´ng");
    }

    public async Task<ApiResponse<ForumPostDetailResponse>> UpdatePost(long userId, bool canModerate, long postId, ForumPostRequest request, CancellationToken ct)
    {
        var post = await _db.Posts.Include(x => x.PostTags).FirstOrDefaultAsync(x => x.Id == postId && !x.IsDeleted, ct);
        if (post == null) return ApiResponse<ForumPostDetailResponse>.Fail("KhÃ´ng tÃ¬m tháº¥y bÃ i viáº¿t");
        if (!canModerate && post.AuthorId != userId) return ApiResponse<ForumPostDetailResponse>.Fail("Báº¡n khÃ´ng cÃ³ quyá»n sá»­a bÃ i viáº¿t nÃ y");
        var errors = ValidatePost(request);
        if (errors.Count > 0) return ApiResponse<ForumPostDetailResponse>.Fail("Dá»¯ liá»‡u bÃ i viáº¿t khÃ´ng há»£p lá»‡", errors);
        await using var tx = await _db.Database.BeginTransactionAsync(ct);
        post.Title = request.Title.Trim();
        post.Content = request.Content.Trim();
        post.Slug = await UniquePostSlug(request.Title, ct, post.Id);
        post.UpdatedAt = DateTime.UtcNow;
        post.LastActivityAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);
        await SetPostTags(post.Id, request.Tags, ct);
        var attachError = await SetPostAttachments(post.Id, userId, request.AttachmentIds, ct);
        if (attachError != null) return ApiResponse<ForumPostDetailResponse>.Fail(attachError);
        await tx.CommitAsync(ct);
        var loaded = await LoadPostDetail(post.Id, ct);
        return ApiResponse<ForumPostDetailResponse>.Ok(await MapPostDetailAsync(loaded!, userId, canModerate, ct), "Cáº­p nháº­t bÃ i viáº¿t thÃ nh cÃ´ng");
    }

    public async Task<ApiResponse<object>> DeletePost(long userId, bool canModerate, long postId, CancellationToken ct)
    {
        var post = await _db.Posts.FirstOrDefaultAsync(x => x.Id == postId && !x.IsDeleted, ct);
        if (post == null) return ApiResponse<object>.Fail("KhÃ´ng tÃ¬m tháº¥y bÃ i viáº¿t");
        if (!canModerate && post.AuthorId != userId) return ApiResponse<object>.Fail("Báº¡n khÃ´ng cÃ³ quyá»n xÃ³a bÃ i viáº¿t nÃ y");
        post.IsDeleted = true;
        post.Status = 0;
        post.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { postId }, "XÃ³a bÃ i viáº¿t thÃ nh cÃ´ng");
    }

    public async Task<ApiResponse<ForumCommentResponse>> AddComment(long userId, long postId, ForumCommentRequest request, CancellationToken ct)
    {
        var errors = ValidateComment(request);
        if (errors.Count > 0) return ApiResponse<ForumCommentResponse>.Fail("Dá»¯ liá»‡u bÃ¬nh luáº­n khÃ´ng há»£p lá»‡", errors);
        var post = await _db.Posts.FirstOrDefaultAsync(x => x.Id == postId && !x.IsDeleted && x.Status == 1, ct);
        if (post == null) return ApiResponse<ForumCommentResponse>.Fail("KhÃ´ng tÃ¬m tháº¥y bÃ i viáº¿t hoáº·c bÃ i Ä‘Ã£ bá»‹ áº©n");
        if (request.ParentCommentId.HasValue)
        {
            var parentOk = await _db.Comments.AnyAsync(x => x.Id == request.ParentCommentId && x.PostId == postId && !x.IsDeleted && x.Status == 1, ct);
            if (!parentOk) return ApiResponse<ForumCommentResponse>.Fail("BÃ¬nh luáº­n cha khÃ´ng há»£p lá»‡");
        }
        var comment = new Comment { PostId = postId, AuthorId = userId, ParentCommentId = request.ParentCommentId, Content = request.Content.Trim(), Status = 1, CreatedAt = DateTime.UtcNow };
        _db.Comments.Add(comment);
        post.AnswerCount++;
        post.LastActivityAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);
        await UpdateUserForumStats(userId, postsDelta: 0, commentsDelta: 1, ct);
        var loaded = await _db.Comments.Include(x => x.Author).Include(x => x.Votes).FirstAsync(x => x.Id == comment.Id, ct);
        return ApiResponse<ForumCommentResponse>.Ok(MapComment(loaded, userId), "BÃ¬nh luáº­n thÃ nh cÃ´ng");
    }

    public async Task<ApiResponse<ForumCommentResponse>> UpdateComment(long userId, bool canModerate, long commentId, ForumCommentRequest request, CancellationToken ct)
    {
        var comment = await _db.Comments.Include(x => x.Author).Include(x => x.Votes).FirstOrDefaultAsync(x => x.Id == commentId && !x.IsDeleted, ct);
        if (comment == null) return ApiResponse<ForumCommentResponse>.Fail("KhÃ´ng tÃ¬m tháº¥y bÃ¬nh luáº­n");
        if (!canModerate && comment.AuthorId != userId) return ApiResponse<ForumCommentResponse>.Fail("Báº¡n khÃ´ng cÃ³ quyá»n sá»­a bÃ¬nh luáº­n nÃ y");
        var errors = ValidateComment(request);
        if (errors.Count > 0) return ApiResponse<ForumCommentResponse>.Fail("Dá»¯ liá»‡u bÃ¬nh luáº­n khÃ´ng há»£p lá»‡", errors);
        comment.Content = request.Content.Trim();
        comment.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);
        return ApiResponse<ForumCommentResponse>.Ok(MapComment(comment, userId), "Cáº­p nháº­t bÃ¬nh luáº­n thÃ nh cÃ´ng");
    }

    public async Task<ApiResponse<object>> DeleteComment(long userId, bool canModerate, long commentId, CancellationToken ct)
    {
        var comment = await _db.Comments.FirstOrDefaultAsync(x => x.Id == commentId && !x.IsDeleted, ct);
        if (comment == null) return ApiResponse<object>.Fail("KhÃ´ng tÃ¬m tháº¥y bÃ¬nh luáº­n");
        if (!canModerate && comment.AuthorId != userId) return ApiResponse<object>.Fail("Báº¡n khÃ´ng cÃ³ quyá»n xÃ³a bÃ¬nh luáº­n nÃ y");
        comment.IsDeleted = true;
        comment.Status = 0;
        comment.UpdatedAt = DateTime.UtcNow;
        if (comment.IsAcceptedAnswer)
        {
            var post = await _db.Posts.FirstOrDefaultAsync(x => x.Id == comment.PostId, ct);
            if (post != null && post.AcceptedCommentId == comment.Id)
            {
                post.AcceptedCommentId = null;
                post.UpdatedAt = DateTime.UtcNow;
            }
            comment.IsAcceptedAnswer = false;
        }
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { commentId }, "XÃ³a bÃ¬nh luáº­n thÃ nh cÃ´ng");
    }

    public async Task<ApiResponse<object>> AcceptCommentAsAnswer(long userId, bool canModerate, long postId, long commentId, CancellationToken ct)
    {
        var post = await _db.Posts.FirstOrDefaultAsync(x => x.Id == postId && !x.IsDeleted && x.Status == 1, ct);
        if (post == null) return ApiResponse<object>.Fail("KhÃ´ng tÃ¬m tháº¥y bÃ i viáº¿t hoáº·c bÃ i viáº¿t Ä‘Ã£ bá»‹ áº©n");
        if (!canModerate && post.AuthorId != userId) return ApiResponse<object>.Fail("Chá»‰ chá»§ bÃ i viáº¿t, Admin hoáº·c Moderator Ä‘Æ°á»£c Ä‘Ã¡nh dáº¥u cÃ¢u tráº£ lá»i Ä‘Ãºng");

        var comment = await _db.Comments.FirstOrDefaultAsync(x => x.Id == commentId && x.PostId == postId && !x.IsDeleted && x.Status == 1, ct);
        if (comment == null) return ApiResponse<object>.Fail("KhÃ´ng tÃ¬m tháº¥y bÃ¬nh luáº­n há»£p lá»‡ trong bÃ i viáº¿t nÃ y");
        await using var tx = await _db.Database.BeginTransactionAsync(ct);
        var acceptedComments = await _db.Comments.Where(x => x.PostId == postId && x.IsAcceptedAnswer).ToListAsync(ct);
        foreach (var item in acceptedComments) item.IsAcceptedAnswer = false;

        comment.IsAcceptedAnswer = true;
        comment.UpdatedAt = DateTime.UtcNow;
        post.AcceptedCommentId = comment.Id;
        post.UpdatedAt = DateTime.UtcNow;
        post.LastActivityAt = DateTime.UtcNow;

        if (canModerate && post.AuthorId != userId)
        {
            _db.ModerationActions.Add(new ModerationAction
            {
                ModeratorId = userId,
                TargetType = "Comment",
                TargetId = commentId,
                ActionType = "AcceptAnswer",
                Reason = "Moderator/Admin Ä‘Ã¡nh dáº¥u cÃ¢u tráº£ lá»i Ä‘Ãºng",
                CreatedAt = DateTime.UtcNow
            });
        }

        await _db.SaveChangesAsync(ct);
        await tx.CommitAsync(ct);
        return ApiResponse<object>.Ok(new { postId, acceptedCommentId = commentId }, "ÄÃ£ Ä‘Ã¡nh dáº¥u cÃ¢u tráº£ lá»i Ä‘Ãºng");
    }

    public async Task<ApiResponse<object>> ClearAcceptedAnswer(long userId, bool canModerate, long postId, CancellationToken ct)
    {
        var post = await _db.Posts.FirstOrDefaultAsync(x => x.Id == postId && !x.IsDeleted && x.Status == 1, ct);
        if (post == null) return ApiResponse<object>.Fail("KhÃ´ng tÃ¬m tháº¥y bÃ i viáº¿t hoáº·c bÃ i viáº¿t Ä‘Ã£ bá»‹ áº©n");
        if (!canModerate && post.AuthorId != userId) return ApiResponse<object>.Fail("Chá»‰ chá»§ bÃ i viáº¿t, Admin hoáº·c Moderator Ä‘Æ°á»£c bá» Ä‘Ã¡nh dáº¥u cÃ¢u tráº£ lá»i Ä‘Ãºng");

        var comments = await _db.Comments.Where(x => x.PostId == postId && x.IsAcceptedAnswer).ToListAsync(ct);
        foreach (var comment in comments)
        {
            comment.IsAcceptedAnswer = false;
            comment.UpdatedAt = DateTime.UtcNow;
        }
        post.AcceptedCommentId = null;
        post.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { postId }, "ÄÃ£ bá» Ä‘Ã¡nh dáº¥u cÃ¢u tráº£ lá»i Ä‘Ãºng");
    }

    public async Task<ApiResponse<object>> VotePost(long userId, long postId, ForumVoteRequest request, CancellationToken ct)
    {
        if (request.VoteType != 1 && request.VoteType != -1) return ApiResponse<object>.Fail("VoteType chá»‰ Ä‘Æ°á»£c lÃ  1 hoáº·c -1");
        var post = await _db.Posts.FirstOrDefaultAsync(x => x.Id == postId && !x.IsDeleted && x.Status == 1, ct);
        if (post == null) return ApiResponse<object>.Fail("KhÃ´ng tÃ¬m tháº¥y bÃ i viáº¿t");
        var vote = await _db.PostVotes.FirstOrDefaultAsync(x => x.PostId == postId && x.UserId == userId, ct);
        if (vote == null) _db.PostVotes.Add(new PostVote { PostId = postId, UserId = userId, VoteType = request.VoteType, CreatedAt = DateTime.UtcNow });
        else if (vote.VoteType == request.VoteType) _db.PostVotes.Remove(vote);
        else { vote.VoteType = request.VoteType; vote.CreatedAt = DateTime.UtcNow; }
        await _db.SaveChangesAsync(ct);
        post.VoteScore = await _db.PostVotes.Where(x => x.PostId == postId).SumAsync(x => (int)x.VoteType, ct);
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { postId, post.VoteScore }, "Cáº­p nháº­t vote bÃ i viáº¿t thÃ nh cÃ´ng");
    }

    public async Task<ApiResponse<object>> VoteComment(long userId, long commentId, ForumVoteRequest request, CancellationToken ct)
    {
        if (request.VoteType != 1 && request.VoteType != -1) return ApiResponse<object>.Fail("VoteType chá»‰ Ä‘Æ°á»£c lÃ  1 hoáº·c -1");
        var comment = await _db.Comments.FirstOrDefaultAsync(x => x.Id == commentId && !x.IsDeleted && x.Status == 1, ct);
        if (comment == null) return ApiResponse<object>.Fail("KhÃ´ng tÃ¬m tháº¥y bÃ¬nh luáº­n");
        var vote = await _db.CommentVotes.FirstOrDefaultAsync(x => x.CommentId == commentId && x.UserId == userId, ct);
        if (vote == null) _db.CommentVotes.Add(new CommentVote { CommentId = commentId, UserId = userId, VoteType = request.VoteType, CreatedAt = DateTime.UtcNow });
        else if (vote.VoteType == request.VoteType) _db.CommentVotes.Remove(vote);
        else { vote.VoteType = request.VoteType; vote.CreatedAt = DateTime.UtcNow; }
        await _db.SaveChangesAsync(ct);
        comment.VoteScore = await _db.CommentVotes.Where(x => x.CommentId == commentId).SumAsync(x => (int)x.VoteType, ct);
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { commentId, comment.VoteScore }, "Cáº­p nháº­t vote bÃ¬nh luáº­n thÃ nh cÃ´ng");
    }

    public async Task<ApiResponse<object>> BookmarkPost(long userId, long postId, CancellationToken ct)
    {
        if (!await _db.Posts.AnyAsync(x => x.Id == postId && !x.IsDeleted && x.Status == 1, ct)) return ApiResponse<object>.Fail("KhÃ´ng tÃ¬m tháº¥y bÃ i viáº¿t");
        if (!await _db.PostBookmarks.AnyAsync(x => x.PostId == postId && x.UserId == userId, ct))
        {
            _db.PostBookmarks.Add(new PostBookmark { PostId = postId, UserId = userId, CreatedAt = DateTime.UtcNow });
            await _db.SaveChangesAsync(ct);
        }
        return ApiResponse<object>.Ok(new { postId }, "ÄÃ£ lÆ°u bÃ i viáº¿t");
    }

    public async Task<ApiResponse<object>> RemoveBookmark(long userId, long postId, CancellationToken ct)
    {
        var bookmark = await _db.PostBookmarks.FirstOrDefaultAsync(x => x.PostId == postId && x.UserId == userId, ct);
        if (bookmark != null)
        {
            _db.PostBookmarks.Remove(bookmark);
            await _db.SaveChangesAsync(ct);
        }
        return ApiResponse<object>.Ok(new { postId }, "ÄÃ£ bá» lÆ°u bÃ i viáº¿t");
    }

    public async Task<ApiResponse<object>> CreateReport(long userId, ForumReportRequest request, CancellationToken ct)
    {
        var targetType = NormalizeTargetType(request.TargetType);
        if (targetType is null) return ApiResponse<object>.Fail("TargetType chá»‰ Ä‘Æ°á»£c lÃ  Post hoáº·c Comment");
        if (string.IsNullOrWhiteSpace(request.Reason) || request.Reason.Trim().Length < 5) return ApiResponse<object>.Fail("LÃ½ do report pháº£i cÃ³ Ã­t nháº¥t 5 kÃ½ tá»±");
        var existsTarget = targetType == "Post"
            ? await _db.Posts.AnyAsync(x => x.Id == request.TargetId && !x.IsDeleted, ct)
            : await _db.Comments.AnyAsync(x => x.Id == request.TargetId && !x.IsDeleted, ct);
        if (!existsTarget) return ApiResponse<object>.Fail("Ná»™i dung cáº§n report khÃ´ng tá»“n táº¡i");
        var duplicate = await _db.Reports.AnyAsync(x => x.ReporterId == userId && x.TargetType == targetType && x.TargetId == request.TargetId && x.Status == 1, ct);
        if (duplicate) return ApiResponse<object>.Fail("Báº¡n Ä‘Ã£ report ná»™i dung nÃ y vÃ  report Ä‘ang chá» xá»­ lÃ½");
        _db.Reports.Add(new Report { ReporterId = userId, TargetType = targetType, TargetId = request.TargetId, Reason = request.Reason.Trim(), Description = request.Description, Status = 1, CreatedAt = DateTime.UtcNow });
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { request.TargetId, TargetType = targetType }, "Gá»­i report thÃ nh cÃ´ng");
    }

    public Task<ApiResponse<PagedResult<ForumPostSummaryResponse>>> AdminPosts(string? keyword, byte? status, int pageIndex, int pageSize, CancellationToken ct)
        => GetPostsForAdmin(keyword, status, pageIndex, pageSize, ct);

    public async Task<ApiResponse<object>> HidePost(long moderatorId, long postId, string? reason, CancellationToken ct)
    {
        var post = await _db.Posts.FirstOrDefaultAsync(x => x.Id == postId && !x.IsDeleted, ct);
        if (post == null) return ApiResponse<object>.Fail("KhÃ´ng tÃ¬m tháº¥y bÃ i viáº¿t");
        post.Status = 0;
        post.UpdatedAt = DateTime.UtcNow;
        _db.ModerationActions.Add(new ModerationAction { ModeratorId = moderatorId, TargetType = "Post", TargetId = postId, ActionType = "Hide", Reason = reason, CreatedAt = DateTime.UtcNow });
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { postId }, "ÄÃ£ áº©n bÃ i viáº¿t");
    }

    public async Task<ApiResponse<object>> RestorePost(long moderatorId, long postId, string? reason, CancellationToken ct)
    {
        var post = await _db.Posts.FirstOrDefaultAsync(x => x.Id == postId && !x.IsDeleted, ct);
        if (post == null) return ApiResponse<object>.Fail("KhÃ´ng tÃ¬m tháº¥y bÃ i viáº¿t");
        post.Status = 1;
        post.UpdatedAt = DateTime.UtcNow;
        _db.ModerationActions.Add(new ModerationAction { ModeratorId = moderatorId, TargetType = "Post", TargetId = postId, ActionType = "Restore", Reason = reason, CreatedAt = DateTime.UtcNow });
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { postId }, "ÄÃ£ khÃ´i phá»¥c bÃ i viáº¿t");
    }

    public async Task<ApiResponse<PagedResult<ForumCommentResponse>>> AdminComments(string? keyword, byte? status, int pageIndex, int pageSize, CancellationToken ct)
    {
        var query = _db.Comments.AsNoTracking().Include(x => x.Author).Include(x => x.Votes).Where(x => !x.IsDeleted).AsQueryable();
        if (status.HasValue) query = query.Where(x => x.Status == status.Value);
        if (!string.IsNullOrWhiteSpace(keyword)) query = query.Where(x => x.Content.Contains(keyword.Trim()));
        pageIndex = Math.Max(1, pageIndex);
        pageSize = Math.Clamp(pageSize, 1, 100);
        var total = await query.CountAsync(ct);
        var comments = await query.OrderByDescending(x => x.CreatedAt).Skip((pageIndex - 1) * pageSize).Take(pageSize).ToListAsync(ct);
        var items = comments.Select(x => MapComment(x, null)).ToList();
        return ApiResponse<PagedResult<ForumCommentResponse>>.Ok(PagedResult<ForumCommentResponse>.Create(items, pageIndex, pageSize, total));
    }

    public async Task<ApiResponse<object>> HideComment(long moderatorId, long commentId, string? reason, CancellationToken ct)
    {
        var comment = await _db.Comments.FirstOrDefaultAsync(x => x.Id == commentId && !x.IsDeleted, ct);
        if (comment == null) return ApiResponse<object>.Fail("KhÃ´ng tÃ¬m tháº¥y bÃ¬nh luáº­n");
        comment.Status = 0;
        comment.UpdatedAt = DateTime.UtcNow;
        if (comment.IsAcceptedAnswer)
        {
            var post = await _db.Posts.FirstOrDefaultAsync(x => x.Id == comment.PostId, ct);
            if (post != null && post.AcceptedCommentId == comment.Id)
            {
                post.AcceptedCommentId = null;
                post.UpdatedAt = DateTime.UtcNow;
            }
            comment.IsAcceptedAnswer = false;
        }
        _db.ModerationActions.Add(new ModerationAction { ModeratorId = moderatorId, TargetType = "Comment", TargetId = commentId, ActionType = "Hide", Reason = reason, CreatedAt = DateTime.UtcNow });
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { commentId }, "ÄÃ£ áº©n bÃ¬nh luáº­n");
    }

    public async Task<ApiResponse<PagedResult<ForumReportResponse>>> AdminReports(byte? status, int pageIndex, int pageSize, CancellationToken ct)
    {
        var query = _db.Reports.AsNoTracking().Include(x => x.Reporter).AsQueryable();
        if (status.HasValue) query = query.Where(x => x.Status == status.Value);
        pageIndex = Math.Max(1, pageIndex);
        pageSize = Math.Clamp(pageSize, 1, 100);
        var total = await query.CountAsync(ct);
        var reports = await query.OrderByDescending(x => x.CreatedAt).Skip((pageIndex - 1) * pageSize).Take(pageSize).ToListAsync(ct);
        var items = reports.Select(x => new ForumReportResponse { Id = x.Id, ReporterId = x.ReporterId, ReporterName = x.Reporter.FullName, TargetType = x.TargetType, TargetId = x.TargetId, Reason = x.Reason, Description = x.Description, Status = x.Status, ResolvedByUserId = x.ResolvedByUserId, ResolvedAt = x.ResolvedAt, CreatedAt = x.CreatedAt }).ToList();
        return ApiResponse<PagedResult<ForumReportResponse>>.Ok(PagedResult<ForumReportResponse>.Create(items, pageIndex, pageSize, total));
    }

    public async Task<ApiResponse<object>> ResolveReport(long moderatorId, long reportId, ResolveReportRequest request, CancellationToken ct)
    {
        var report = await _db.Reports.FirstOrDefaultAsync(x => x.Id == reportId, ct);
        if (report == null) return ApiResponse<object>.Fail("KhÃ´ng tÃ¬m tháº¥y report");
        report.Status = request.Status == 3 ? (byte)3 : (byte)2;
        report.ResolvedByUserId = moderatorId;
        report.ResolvedAt = DateTime.UtcNow;
        if (request.HideTarget)
        {
            if (report.TargetType == "Post")
            {
                var post = await _db.Posts.FirstOrDefaultAsync(x => x.Id == report.TargetId, ct);
                if (post != null) post.Status = 0;
            }
            else if (report.TargetType == "Comment")
            {
                var comment = await _db.Comments.FirstOrDefaultAsync(x => x.Id == report.TargetId, ct);
                if (comment != null)
                {
                    comment.Status = 0;
                    if (comment.IsAcceptedAnswer)
                    {
                        var post = await _db.Posts.FirstOrDefaultAsync(x => x.Id == comment.PostId, ct);
                        if (post != null && post.AcceptedCommentId == comment.Id) post.AcceptedCommentId = null;
                        comment.IsAcceptedAnswer = false;
                    }
                }
            }
        }
        _db.ModerationActions.Add(new ModerationAction { ModeratorId = moderatorId, TargetType = report.TargetType, TargetId = report.TargetId, ActionType = request.Status == 3 ? "RejectReport" : "ResolveReport", Reason = request.Reason, CreatedAt = DateTime.UtcNow });
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { reportId }, "ÄÃ£ xá»­ lÃ½ report");
    }

    private async Task<ApiResponse<PagedResult<ForumPostSummaryResponse>>> GetPostsForAdmin(string? keyword, byte? status, int pageIndex, int pageSize, CancellationToken ct)
    {
        var query = _db.Posts.AsNoTracking().Include(x => x.Author).Include(x => x.PostTags).ThenInclude(x => x.Tag).Include(x => x.Bookmarks).Include(x => x.Votes).Where(x => !x.IsDeleted).AsQueryable();
        if (!string.IsNullOrWhiteSpace(keyword)) query = query.Where(x => x.Title.Contains(keyword.Trim()) || x.Content.Contains(keyword.Trim()));
        if (status.HasValue) query = query.Where(x => x.Status == status.Value);
        pageIndex = Math.Max(1, pageIndex);
        pageSize = Math.Clamp(pageSize, 1, 100);
        var total = await query.CountAsync(ct);
        var posts = await query.OrderByDescending(x => x.CreatedAt).Skip((pageIndex - 1) * pageSize).Take(pageSize).ToListAsync(ct);
        var items = new List<ForumPostSummaryResponse>();
        foreach (var post in posts) items.Add(await MapPostSummaryAsync(post, null, ct));
        return ApiResponse<PagedResult<ForumPostSummaryResponse>>.Ok(PagedResult<ForumPostSummaryResponse>.Create(items, pageIndex, pageSize, total));
    }

    private async Task<Post?> LoadPostDetail(long postId, CancellationToken ct)
    {
        return await _db.Posts
            .Include(x => x.Author)
            .Include(x => x.PostTags).ThenInclude(x => x.Tag)
            .Include(x => x.Bookmarks)
            .Include(x => x.Votes)
            .Include(x => x.Comments.Where(c => !c.IsDeleted && c.Status == 1)).ThenInclude(x => x.Author)
            .Include(x => x.Comments.Where(c => !c.IsDeleted && c.Status == 1)).ThenInclude(x => x.Votes)
            .FirstOrDefaultAsync(x => x.Id == postId, ct);
    }

    private async Task SetPostTags(long postId, List<string> tagNames, CancellationToken ct)
    {
        var existing = await _db.PostTags.Where(x => x.PostId == postId).ToListAsync(ct);
        _db.PostTags.RemoveRange(existing);
        var cleanNames = tagNames.Where(x => !string.IsNullOrWhiteSpace(x)).Select(x => x.Trim()).Distinct(StringComparer.OrdinalIgnoreCase).Take(5).ToList();
        foreach (var name in cleanNames)
        {
            var slug = Slugify(name);
            var tag = await _db.Tags.FirstOrDefaultAsync(x => x.Slug == slug, ct);
            if (tag == null)
            {
                tag = new Tag { Name = name, Slug = slug, CreatedAt = DateTime.UtcNow };
                _db.Tags.Add(tag);
                await _db.SaveChangesAsync(ct);
            }
            _db.PostTags.Add(new PostTag { PostId = postId, TagId = tag.Id });
        }
        await _db.SaveChangesAsync(ct);
    }

    private async Task<string?> SetPostAttachments(long postId, long userId, List<long>? attachmentIds, CancellationToken ct)
    {
        var cleanIds = (attachmentIds ?? new List<long>()).Distinct().Take(5).ToList();
        var existing = await _db.FileReferences.Where(x => x.OwnerService == "Forum" && x.OwnerType == "Post" && x.OwnerId == postId).ToListAsync(ct);
        _db.FileReferences.RemoveRange(existing);
        if (cleanIds.Count == 0)
        {
            await _db.SaveChangesAsync(ct);
            return null;
        }
        var validFiles = await _db.Files
            .Where(f => cleanIds.Contains(f.Id) && !f.IsDeleted && f.UploadedByUserId == userId)
            .Select(f => f.Id)
            .ToListAsync(ct);
        if (validFiles.Count != cleanIds.Count) return "CÃ³ file Ä‘Ã­nh kÃ¨m khÃ´ng tá»“n táº¡i hoáº·c khÃ´ng thuá»™c quyá»n upload cá»§a báº¡n";
        foreach (var fileId in cleanIds)
        {
            _db.FileReferences.Add(new FileReference { FileId = fileId, OwnerService = "Forum", OwnerType = "Post", OwnerId = postId, CreatedAt = DateTime.UtcNow });
        }
        await _db.SaveChangesAsync(ct);
        return null;
    }

    private async Task<List<ForumAttachmentResponse>> LoadPostAttachments(long postId, CancellationToken ct)
    {
        var rows = await _db.FileReferences.AsNoTracking()
            .Where(r => r.OwnerService == "Forum" && r.OwnerType == "Post" && r.OwnerId == postId)
            .Join(_db.Files.AsNoTracking().Where(f => !f.IsDeleted), r => r.FileId, f => f.Id, (r, f) => f)
            .OrderBy(f => f.Id)
            .ToListAsync(ct);
        return rows.Select(MapAttachment).ToList();
    }

    private async Task<string> UniquePostSlug(string title, CancellationToken ct, long? excludeId = null)
    {
        var baseSlug = Slugify(title);
        if (baseSlug.Length == 0) baseSlug = "post";
        var slug = baseSlug;
        var i = 2;
        while (await _db.Posts.AnyAsync(x => x.Slug == slug && (!excludeId.HasValue || x.Id != excludeId.Value), ct)) slug = $"{baseSlug}-{i++}";
        return slug;
    }

    private async Task<ForumPostSummaryResponse> MapPostSummaryAsync(Post p, long? currentUserId, CancellationToken ct)
    {
        var content = p.Content ?? string.Empty;
        var attachments = await LoadPostAttachments(p.Id, ct);
        return new ForumPostSummaryResponse
        {
            Id = p.Id,
            AuthorId = p.AuthorId,
            AuthorName = p.Author?.FullName ?? "Unknown",
            AuthorInitials = Initials(p.Author?.FullName ?? p.Author?.UserName ?? "U"),
            Title = p.Title,
            Slug = p.Slug,
            ContentPreview = content.Length > 180 ? content[..180] + "..." : content,
            ViewCount = p.ViewCount,
            VoteScore = p.VoteScore, LikeCount = p.Votes.Count(x => x.VoteType == 1), DislikeCount = p.Votes.Count(x => x.VoteType == -1),
            CommentCount = (p.Comments != null && p.Comments.Count > 0) ? p.Comments.Count(x => !x.IsDeleted && x.Status == 1) : p.AnswerCount,
            Status = p.Status,
            CreatedAt = p.CreatedAt,
            UpdatedAt = p.UpdatedAt,
            IsBookmarked = currentUserId.HasValue && p.Bookmarks.Any(x => x.UserId == currentUserId.Value),
            MyVote = currentUserId.HasValue ? p.Votes.FirstOrDefault(x => x.UserId == currentUserId.Value)?.VoteType : null,
            Tags = p.PostTags.OrderBy(x => x.Tag.Name).Select(x => MapTag(x.Tag)).ToList(),
            AttachmentCount = attachments.Count,
            FirstImageUrl = attachments.FirstOrDefault(a => a.IsImage)?.FileUrl,
            AcceptedCommentId = p.AcceptedCommentId,
            IsSolved = p.AcceptedCommentId.HasValue
        };
    }

    private async Task<ForumPostDetailResponse> MapPostDetailAsync(Post p, long? currentUserId, bool canModerate, CancellationToken ct)
    {
        var summary = await MapPostSummaryAsync(p, currentUserId, ct);
        var comments = p.Comments.Where(x => x.ParentCommentId == null).OrderByDescending(x => x.IsAcceptedAnswer).ThenByDescending(x => x.VoteScore).ThenBy(x => x.CreatedAt).Select(x => MapCommentTree(x, p.Comments, currentUserId, canModerate)).ToList();
        return new ForumPostDetailResponse
        {
            Id = summary.Id,
            AuthorId = summary.AuthorId,
            AuthorName = summary.AuthorName,
            AuthorInitials = summary.AuthorInitials,
            Title = summary.Title,
            Slug = summary.Slug,
            ContentPreview = summary.ContentPreview,
            Content = p.Content,
            ViewCount = summary.ViewCount,
            VoteScore = summary.VoteScore, LikeCount = summary.LikeCount, DislikeCount = summary.DislikeCount,
            CommentCount = summary.CommentCount,
            Status = summary.Status,
            CreatedAt = summary.CreatedAt,
            UpdatedAt = summary.UpdatedAt,
            IsBookmarked = summary.IsBookmarked,
            MyVote = summary.MyVote,
            Tags = summary.Tags,
            AttachmentCount = summary.AttachmentCount,
            FirstImageUrl = summary.FirstImageUrl,
            AcceptedCommentId = summary.AcceptedCommentId,
            IsSolved = summary.IsSolved,
            CanEdit = currentUserId.HasValue && (p.AuthorId == currentUserId.Value || canModerate),
            CanAcceptAnswer = currentUserId.HasValue && (p.AuthorId == currentUserId.Value || canModerate),
            Attachments = await LoadPostAttachments(p.Id, ct),
            Comments = comments
        };
    }

    private static ForumCommentResponse MapCommentTree(Comment c, IEnumerable<Comment> all, long? currentUserId, bool canModerate)
    {
        var mapped = MapComment(c, currentUserId, canModerate);
        mapped.Replies = all.Where(x => x.ParentCommentId == c.Id).OrderBy(x => x.CreatedAt).Select(x => MapCommentTree(x, all, currentUserId, canModerate)).ToList();
        return mapped;
    }

    private static ForumCommentResponse MapComment(Comment c, long? currentUserId, bool canModerate = false)
    {
        return new ForumCommentResponse
        {
            Id = c.Id,
            PostId = c.PostId,
            AuthorId = c.AuthorId,
            AuthorName = c.Author?.FullName ?? "Unknown",
            AuthorInitials = Initials(c.Author?.FullName ?? c.Author?.UserName ?? "U"),
            ParentCommentId = c.ParentCommentId,
            Content = c.Content,
            VoteScore = c.VoteScore, LikeCount = c.Votes.Count(x => x.VoteType == 1), DislikeCount = c.Votes.Count(x => x.VoteType == -1),
            IsAcceptedAnswer = c.IsAcceptedAnswer,
            Status = c.Status,
            CreatedAt = c.CreatedAt,
            UpdatedAt = c.UpdatedAt,
            CanEdit = currentUserId.HasValue && (c.AuthorId == currentUserId.Value || canModerate),
            MyVote = currentUserId.HasValue ? c.Votes.FirstOrDefault(x => x.UserId == currentUserId.Value)?.VoteType : null
        };
    }

    private static ForumAttachmentResponse MapAttachment(AppFile f) => new()
    {
        FileId = f.Id,
        OriginalFileName = f.OriginalFileName,
        // Do not expose MinIO/private storage URL to the browser.
        // Frontend will prepend API base URL and read the file through FilesController proxy.
        FileUrl = $"/api/v1/files/{f.Id}/view",
        MimeType = f.MimeType,
        FileSizeBytes = f.FileSizeBytes,
        FileType = f.FileType,
        StorageProvider = f.StorageProvider
    };

    private static ForumTagResponse MapTag(Tag t) => new() { Id = t.Id, Name = t.Name, Slug = t.Slug, Description = t.Description };
    private static System.Linq.Expressions.Expression<Func<Tag, ForumTagResponse>> MapTagExpr() => t => new ForumTagResponse { Id = t.Id, Name = t.Name, Slug = t.Slug, Description = t.Description };

    private static List<ApiError> ValidatePost(ForumPostRequest r)
    {
        var errors = new List<ApiError>();
        if (string.IsNullOrWhiteSpace(r.Title)) errors.Add(new ApiError { Field = "title", Message = "TiÃªu Ä‘á» báº¯t buá»™c" });
        else if (r.Title.Trim().Length < 10 || r.Title.Trim().Length > 200) errors.Add(new ApiError { Field = "title", Message = "TiÃªu Ä‘á» pháº£i tá»« 10 Ä‘áº¿n 200 kÃ½ tá»±" });
        if (string.IsNullOrWhiteSpace(r.Content)) errors.Add(new ApiError { Field = "content", Message = "Ná»™i dung báº¯t buá»™c" });
        else if (r.Content.Trim().Length < 20) errors.Add(new ApiError { Field = "content", Message = "Ná»™i dung pháº£i cÃ³ Ã­t nháº¥t 20 kÃ½ tá»±" });
        if (r.Tags == null || !r.Tags.Any(x => !string.IsNullOrWhiteSpace(x))) errors.Add(new ApiError { Field = "tags", Message = "Cáº§n Ã­t nháº¥t 1 tag" });
        if (r.Tags != null && r.Tags.Count(x => !string.IsNullOrWhiteSpace(x)) > 5) errors.Add(new ApiError { Field = "tags", Message = "Tá»‘i Ä‘a 5 tag" });
        if (r.AttachmentIds != null && r.AttachmentIds.Distinct().Count() > 5) errors.Add(new ApiError { Field = "attachmentIds", Message = "Tá»‘i Ä‘a 5 file Ä‘Ã­nh kÃ¨m cho má»—i bÃ i viáº¿t" });
        return errors;
    }

    private static List<ApiError> ValidateComment(ForumCommentRequest r)
    {
        var errors = new List<ApiError>();
        if (string.IsNullOrWhiteSpace(r.Content)) errors.Add(new ApiError { Field = "content", Message = "Ná»™i dung bÃ¬nh luáº­n báº¯t buá»™c" });
        else if (r.Content.Trim().Length < 2 || r.Content.Trim().Length > 1000) errors.Add(new ApiError { Field = "content", Message = "BÃ¬nh luáº­n pháº£i tá»« 2 Ä‘áº¿n 1000 kÃ½ tá»±" });
        return errors;
    }

    private static List<ApiError> ValidateTag(ForumTagRequest r)
    {
        var errors = new List<ApiError>();
        if (string.IsNullOrWhiteSpace(r.Name)) errors.Add(new ApiError { Field = "name", Message = "TÃªn tag báº¯t buá»™c" });
        else if (r.Name.Trim().Length < 2 || r.Name.Trim().Length > 100) errors.Add(new ApiError { Field = "name", Message = "TÃªn tag pháº£i tá»« 2 Ä‘áº¿n 100 kÃ½ tá»±" });
        return errors;
    }

    private static string? NormalizeTargetType(string? value)
    {
        if (string.IsNullOrWhiteSpace(value)) return null;
        var v = value.Trim().ToLowerInvariant();
        if (v == "post") return "Post";
        if (v == "comment") return "Comment";
        return null;
    }

    private static string Slugify(string input)
    {
        var normalized = input.ToLowerInvariant().Normalize(System.Text.NormalizationForm.FormD);
        var sb = new System.Text.StringBuilder();
        var lastDash = false;
        foreach (var ch in normalized)
        {
            var category = System.Globalization.CharUnicodeInfo.GetUnicodeCategory(ch);
            if (category == System.Globalization.UnicodeCategory.NonSpacingMark) continue;
            var c = (ch == '\u0111' || ch == '\u0110') ? 'd' : ch;
            if (char.IsLetterOrDigit(c)) { sb.Append(c); lastDash = false; }
            else if (!lastDash) { sb.Append('-'); lastDash = true; }
        }
        return sb.ToString().Trim('-');
    }

    private static string Initials(string name)
    {
        var parts = name.Split(' ', StringSplitOptions.RemoveEmptyEntries);
        if (parts.Length == 0) return "U";
        if (parts.Length == 1) return parts[0][0].ToString().ToUpperInvariant();
        return (parts[0][0].ToString() + parts[^1][0].ToString()).ToUpperInvariant();
    }

    private async Task UpdateUserForumStats(long userId, int postsDelta, int commentsDelta, CancellationToken ct)
    {
        var stat = await _db.UserStats.FirstOrDefaultAsync(x => x.UserId == userId, ct);
        if (stat == null)
        {
            stat = new UserStat { UserId = userId, UpdatedAt = DateTime.UtcNow };
            _db.UserStats.Add(stat);
        }
        stat.TotalPosts += postsDelta;
        stat.TotalComments += commentsDelta;
        stat.Reputation += postsDelta * 2 + commentsDelta;
        stat.LastActivityAt = DateTime.UtcNow;
        stat.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);
    }
}




