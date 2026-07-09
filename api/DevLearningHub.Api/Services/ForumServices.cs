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
            return ApiResponse<ForumAttachmentResponse>.Ok(MapAttachment(entity), "Upload file thành công");
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
        if (errors.Count > 0) return ApiResponse<ForumTagResponse>.Fail("Dữ liệu tag không hợp lệ", errors);
        var slug = Slugify(string.IsNullOrWhiteSpace(request.Slug) ? request.Name : request.Slug);
        if (await _db.Tags.AnyAsync(x => x.Slug == slug, ct)) return ApiResponse<ForumTagResponse>.Fail("Slug tag đã tồn tại");
        var tag = new Tag { Name = request.Name.Trim(), Slug = slug, Description = request.Description, CreatedAt = DateTime.UtcNow };
        _db.Tags.Add(tag);
        await _db.SaveChangesAsync(ct);
        return ApiResponse<ForumTagResponse>.Ok(MapTag(tag), "Tạo tag thành công");
    }

    public async Task<ApiResponse<ForumTagResponse>> UpdateTag(long id, ForumTagRequest request, CancellationToken ct)
    {
        var tag = await _db.Tags.FirstOrDefaultAsync(x => x.Id == id, ct);
        if (tag == null) return ApiResponse<ForumTagResponse>.Fail("Không tìm thấy tag");
        var errors = ValidateTag(request);
        if (errors.Count > 0) return ApiResponse<ForumTagResponse>.Fail("Dữ liệu tag không hợp lệ", errors);
        var slug = Slugify(string.IsNullOrWhiteSpace(request.Slug) ? request.Name : request.Slug);
        if (await _db.Tags.AnyAsync(x => x.Id != id && x.Slug == slug, ct)) return ApiResponse<ForumTagResponse>.Fail("Slug tag đã tồn tại");
        tag.Name = request.Name.Trim();
        tag.Slug = slug;
        tag.Description = request.Description;
        await _db.SaveChangesAsync(ct);
        return ApiResponse<ForumTagResponse>.Ok(MapTag(tag), "Cập nhật tag thành công");
    }

    public async Task<ApiResponse<object>> DeleteTag(long id, CancellationToken ct)
    {
        var used = await _db.PostTags.AnyAsync(x => x.TagId == id, ct);
        if (used) return ApiResponse<object>.Fail("Tag đang được sử dụng, không thể xóa");
        var tag = await _db.Tags.FirstOrDefaultAsync(x => x.Id == id, ct);
        if (tag == null) return ApiResponse<object>.Fail("Không tìm thấy tag");
        _db.Tags.Remove(tag);
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { id }, "Xóa tag thành công");
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
        if (post == null || post.IsDeleted || post.Status != 1) return ApiResponse<ForumPostDetailResponse>.Fail("Không tìm thấy bài viết");
        post.ViewCount++;
        await _db.SaveChangesAsync(ct);
        return ApiResponse<ForumPostDetailResponse>.Ok(await MapPostDetailAsync(post, currentUserId, false, ct));
    }

    public async Task<ApiResponse<ForumPostDetailResponse>> CreatePost(long userId, ForumPostRequest request, CancellationToken ct)
    {
        var errors = ValidatePost(request);
        if (errors.Count > 0) return ApiResponse<ForumPostDetailResponse>.Fail("Dữ liệu bài viết không hợp lệ", errors);
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
        return ApiResponse<ForumPostDetailResponse>.Ok(await MapPostDetailAsync(loaded!, userId, false, ct), "Tạo bài viết thành công");
    }

    public async Task<ApiResponse<ForumPostDetailResponse>> UpdatePost(long userId, bool canModerate, long postId, ForumPostRequest request, CancellationToken ct)
    {
        var post = await _db.Posts.Include(x => x.PostTags).FirstOrDefaultAsync(x => x.Id == postId && !x.IsDeleted, ct);
        if (post == null) return ApiResponse<ForumPostDetailResponse>.Fail("Không tìm thấy bài viết");
        if (!canModerate && post.AuthorId != userId) return ApiResponse<ForumPostDetailResponse>.Fail("Bạn không có quyền sửa bài viết này");
        var errors = ValidatePost(request);
        if (errors.Count > 0) return ApiResponse<ForumPostDetailResponse>.Fail("Dữ liệu bài viết không hợp lệ", errors);
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
        return ApiResponse<ForumPostDetailResponse>.Ok(await MapPostDetailAsync(loaded!, userId, canModerate, ct), "Cập nhật bài viết thành công");
    }

    public async Task<ApiResponse<object>> DeletePost(long userId, bool canModerate, long postId, CancellationToken ct)
    {
        var post = await _db.Posts.FirstOrDefaultAsync(x => x.Id == postId && !x.IsDeleted, ct);
        if (post == null) return ApiResponse<object>.Fail("Không tìm thấy bài viết");
        if (!canModerate && post.AuthorId != userId) return ApiResponse<object>.Fail("Bạn không có quyền xóa bài viết này");
        post.IsDeleted = true;
        post.Status = 0;
        post.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { postId }, "Xóa bài viết thành công");
    }

    public async Task<ApiResponse<ForumCommentResponse>> AddComment(long userId, long postId, ForumCommentRequest request, CancellationToken ct)
    {
        var errors = ValidateComment(request);
        if (errors.Count > 0) return ApiResponse<ForumCommentResponse>.Fail("Dữ liệu bình luận không hợp lệ", errors);
        var post = await _db.Posts.FirstOrDefaultAsync(x => x.Id == postId && !x.IsDeleted && x.Status == 1, ct);
        if (post == null) return ApiResponse<ForumCommentResponse>.Fail("Không tìm thấy bài viết hoặc bài đã bị ẩn");
        if (request.ParentCommentId.HasValue)
        {
            var parentOk = await _db.Comments.AnyAsync(x => x.Id == request.ParentCommentId && x.PostId == postId && !x.IsDeleted && x.Status == 1, ct);
            if (!parentOk) return ApiResponse<ForumCommentResponse>.Fail("Bình luận cha không hợp lệ");
        }
        var comment = new Comment { PostId = postId, AuthorId = userId, ParentCommentId = request.ParentCommentId, Content = request.Content.Trim(), Status = 1, CreatedAt = DateTime.UtcNow };
        _db.Comments.Add(comment);
        post.AnswerCount++;
        post.LastActivityAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);
        await UpdateUserForumStats(userId, postsDelta: 0, commentsDelta: 1, ct);
        var loaded = await _db.Comments.Include(x => x.Author).Include(x => x.Votes).FirstAsync(x => x.Id == comment.Id, ct);
        return ApiResponse<ForumCommentResponse>.Ok(MapComment(loaded, userId), "Bình luận thành công");
    }

    public async Task<ApiResponse<ForumCommentResponse>> UpdateComment(long userId, bool canModerate, long commentId, ForumCommentRequest request, CancellationToken ct)
    {
        var comment = await _db.Comments.Include(x => x.Author).Include(x => x.Votes).FirstOrDefaultAsync(x => x.Id == commentId && !x.IsDeleted, ct);
        if (comment == null) return ApiResponse<ForumCommentResponse>.Fail("Không tìm thấy bình luận");
        if (!canModerate && comment.AuthorId != userId) return ApiResponse<ForumCommentResponse>.Fail("Bạn không có quyền sửa bình luận này");
        var errors = ValidateComment(request);
        if (errors.Count > 0) return ApiResponse<ForumCommentResponse>.Fail("Dữ liệu bình luận không hợp lệ", errors);
        comment.Content = request.Content.Trim();
        comment.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);
        return ApiResponse<ForumCommentResponse>.Ok(MapComment(comment, userId), "Cập nhật bình luận thành công");
    }

    public async Task<ApiResponse<object>> DeleteComment(long userId, bool canModerate, long commentId, CancellationToken ct)
    {
        var comment = await _db.Comments.FirstOrDefaultAsync(x => x.Id == commentId && !x.IsDeleted, ct);
        if (comment == null) return ApiResponse<object>.Fail("Không tìm thấy bình luận");
        if (!canModerate && comment.AuthorId != userId) return ApiResponse<object>.Fail("Bạn không có quyền xóa bình luận này");
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
        return ApiResponse<object>.Ok(new { commentId }, "Xóa bình luận thành công");
    }

    public async Task<ApiResponse<object>> AcceptCommentAsAnswer(long userId, bool canModerate, long postId, long commentId, CancellationToken ct)
    {
        var post = await _db.Posts.FirstOrDefaultAsync(x => x.Id == postId && !x.IsDeleted && x.Status == 1, ct);
        if (post == null) return ApiResponse<object>.Fail("Không tìm thấy bài viết hoặc bài viết đã bị ẩn");
        if (!canModerate && post.AuthorId != userId) return ApiResponse<object>.Fail("Chỉ chủ bài viết, Admin hoặc Moderator được đánh dấu câu trả lời đúng");

        var comment = await _db.Comments.FirstOrDefaultAsync(x => x.Id == commentId && x.PostId == postId && !x.IsDeleted && x.Status == 1, ct);
        if (comment == null) return ApiResponse<object>.Fail("Không tìm thấy bình luận hợp lệ trong bài viết này");
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
                Reason = "Moderator/Admin đánh dấu câu trả lời đúng",
                CreatedAt = DateTime.UtcNow
            });
        }

        await _db.SaveChangesAsync(ct);
        await tx.CommitAsync(ct);
        return ApiResponse<object>.Ok(new { postId, acceptedCommentId = commentId }, "Đã đánh dấu câu trả lời đúng");
    }

    public async Task<ApiResponse<object>> ClearAcceptedAnswer(long userId, bool canModerate, long postId, CancellationToken ct)
    {
        var post = await _db.Posts.FirstOrDefaultAsync(x => x.Id == postId && !x.IsDeleted && x.Status == 1, ct);
        if (post == null) return ApiResponse<object>.Fail("Không tìm thấy bài viết hoặc bài viết đã bị ẩn");
        if (!canModerate && post.AuthorId != userId) return ApiResponse<object>.Fail("Chỉ chủ bài viết, Admin hoặc Moderator được bỏ đánh dấu câu trả lời đúng");

        var comments = await _db.Comments.Where(x => x.PostId == postId && x.IsAcceptedAnswer).ToListAsync(ct);
        foreach (var comment in comments)
        {
            comment.IsAcceptedAnswer = false;
            comment.UpdatedAt = DateTime.UtcNow;
        }
        post.AcceptedCommentId = null;
        post.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { postId }, "Đã bỏ đánh dấu câu trả lời đúng");
    }

    public async Task<ApiResponse<object>> VotePost(long userId, long postId, ForumVoteRequest request, CancellationToken ct)
    {
        if (request.VoteType != 1 && request.VoteType != -1) return ApiResponse<object>.Fail("VoteType chỉ được là 1 hoặc -1");
        var post = await _db.Posts.FirstOrDefaultAsync(x => x.Id == postId && !x.IsDeleted && x.Status == 1, ct);
        if (post == null) return ApiResponse<object>.Fail("Không tìm thấy bài viết");
        var vote = await _db.PostVotes.FirstOrDefaultAsync(x => x.PostId == postId && x.UserId == userId, ct);
        if (vote == null) _db.PostVotes.Add(new PostVote { PostId = postId, UserId = userId, VoteType = request.VoteType, CreatedAt = DateTime.UtcNow });
        else if (vote.VoteType == request.VoteType) _db.PostVotes.Remove(vote);
        else { vote.VoteType = request.VoteType; vote.CreatedAt = DateTime.UtcNow; }
        await _db.SaveChangesAsync(ct);
        post.VoteScore = await _db.PostVotes.Where(x => x.PostId == postId).SumAsync(x => (int)x.VoteType, ct);
        await _db.SaveChangesAsync(ct);
        var likeCount = await _db.PostVotes.CountAsync(x => x.PostId == postId && x.VoteType > 0, ct);
        var dislikeCount = await _db.PostVotes.CountAsync(x => x.PostId == postId && x.VoteType < 0, ct);
        return ApiResponse<object>.Ok(new { postId, post.VoteScore, LikeCount = likeCount, DislikeCount = dislikeCount }, "Cập nhật vote bài viết thành công");
    }

    public async Task<ApiResponse<object>> VoteComment(long userId, long commentId, ForumVoteRequest request, CancellationToken ct)
    {
        if (request.VoteType != 1 && request.VoteType != -1) return ApiResponse<object>.Fail("VoteType chỉ được là 1 hoặc -1");
        var comment = await _db.Comments.FirstOrDefaultAsync(x => x.Id == commentId && !x.IsDeleted && x.Status == 1, ct);
        if (comment == null) return ApiResponse<object>.Fail("Không tìm thấy bình luận");
        var vote = await _db.CommentVotes.FirstOrDefaultAsync(x => x.CommentId == commentId && x.UserId == userId, ct);
        if (vote == null) _db.CommentVotes.Add(new CommentVote { CommentId = commentId, UserId = userId, VoteType = request.VoteType, CreatedAt = DateTime.UtcNow });
        else if (vote.VoteType == request.VoteType) _db.CommentVotes.Remove(vote);
        else { vote.VoteType = request.VoteType; vote.CreatedAt = DateTime.UtcNow; }
        await _db.SaveChangesAsync(ct);
        comment.VoteScore = await _db.CommentVotes.Where(x => x.CommentId == commentId).SumAsync(x => (int)x.VoteType, ct);
        await _db.SaveChangesAsync(ct);
        var likeCount = await _db.CommentVotes.CountAsync(x => x.CommentId == commentId && x.VoteType > 0, ct);
        var dislikeCount = await _db.CommentVotes.CountAsync(x => x.CommentId == commentId && x.VoteType < 0, ct);
        return ApiResponse<object>.Ok(new { commentId, comment.VoteScore, LikeCount = likeCount, DislikeCount = dislikeCount }, "Cập nhật vote bình luận thành công");
    }

    public async Task<ApiResponse<object>> BookmarkPost(long userId, long postId, CancellationToken ct)
    {
        if (!await _db.Posts.AnyAsync(x => x.Id == postId && !x.IsDeleted && x.Status == 1, ct)) return ApiResponse<object>.Fail("Không tìm thấy bài viết");
        if (!await _db.PostBookmarks.AnyAsync(x => x.PostId == postId && x.UserId == userId, ct))
        {
            _db.PostBookmarks.Add(new PostBookmark { PostId = postId, UserId = userId, CreatedAt = DateTime.UtcNow });
            await _db.SaveChangesAsync(ct);
        }
        return ApiResponse<object>.Ok(new { postId }, "Đã lưu bài viết");
    }

    public async Task<ApiResponse<object>> RemoveBookmark(long userId, long postId, CancellationToken ct)
    {
        var bookmark = await _db.PostBookmarks.FirstOrDefaultAsync(x => x.PostId == postId && x.UserId == userId, ct);
        if (bookmark != null)
        {
            _db.PostBookmarks.Remove(bookmark);
            await _db.SaveChangesAsync(ct);
        }
        return ApiResponse<object>.Ok(new { postId }, "Đã bỏ lưu bài viết");
    }

    public async Task<ApiResponse<object>> CreateReport(long userId, ForumReportRequest request, CancellationToken ct)
    {
        var targetType = NormalizeTargetType(request.TargetType);
        if (targetType is null) return ApiResponse<object>.Fail("TargetType chỉ được là Post hoặc Comment");
        if (string.IsNullOrWhiteSpace(request.Reason) || request.Reason.Trim().Length < 5) return ApiResponse<object>.Fail("Lý do report phải có ít nhất 5 ký tự");
        var existsTarget = targetType == "Post"
            ? await _db.Posts.AnyAsync(x => x.Id == request.TargetId && !x.IsDeleted, ct)
            : await _db.Comments.AnyAsync(x => x.Id == request.TargetId && !x.IsDeleted, ct);
        if (!existsTarget) return ApiResponse<object>.Fail("Nội dung cần report không tồn tại");
        var duplicate = await _db.Reports.AnyAsync(x => x.ReporterId == userId && x.TargetType == targetType && x.TargetId == request.TargetId && x.Status == 1, ct);
        if (duplicate) return ApiResponse<object>.Fail("Bạn đã report nội dung này và report đang chờ xử lý");
        _db.Reports.Add(new Report { ReporterId = userId, TargetType = targetType, TargetId = request.TargetId, Reason = request.Reason.Trim(), Description = request.Description, Status = 1, CreatedAt = DateTime.UtcNow });
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { request.TargetId, TargetType = targetType }, "Gửi report thành công");
    }

    public Task<ApiResponse<PagedResult<ForumPostSummaryResponse>>> AdminPosts(string? keyword, byte? status, int pageIndex, int pageSize, CancellationToken ct)
        => GetPostsForAdmin(keyword, status, pageIndex, pageSize, ct);

    public async Task<ApiResponse<object>> HidePost(long moderatorId, long postId, string? reason, CancellationToken ct)
    {
        var post = await _db.Posts.FirstOrDefaultAsync(x => x.Id == postId && !x.IsDeleted, ct);
        if (post == null) return ApiResponse<object>.Fail("Không tìm thấy bài viết");
        post.Status = 0;
        post.UpdatedAt = DateTime.UtcNow;
        _db.ModerationActions.Add(new ModerationAction { ModeratorId = moderatorId, TargetType = "Post", TargetId = postId, ActionType = "Hide", Reason = reason, CreatedAt = DateTime.UtcNow });
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { postId }, "Đã ẩn bài viết");
    }

    public async Task<ApiResponse<object>> RestorePost(long moderatorId, long postId, string? reason, CancellationToken ct)
    {
        var post = await _db.Posts.FirstOrDefaultAsync(x => x.Id == postId && !x.IsDeleted, ct);
        if (post == null) return ApiResponse<object>.Fail("Không tìm thấy bài viết");
        post.Status = 1;
        post.UpdatedAt = DateTime.UtcNow;
        _db.ModerationActions.Add(new ModerationAction { ModeratorId = moderatorId, TargetType = "Post", TargetId = postId, ActionType = "Restore", Reason = reason, CreatedAt = DateTime.UtcNow });
        await _db.SaveChangesAsync(ct);
        return ApiResponse<object>.Ok(new { postId }, "Đã khôi phục bài viết");
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
        if (comment == null) return ApiResponse<object>.Fail("Không tìm thấy bình luận");
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
        return ApiResponse<object>.Ok(new { commentId }, "Đã ẩn bình luận");
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
        if (report == null) return ApiResponse<object>.Fail("Không tìm thấy report");
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
        return ApiResponse<object>.Ok(new { reportId }, "Đã xử lý report");
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
        if (validFiles.Count != cleanIds.Count) return "Có file đính kèm không tồn tại hoặc không thuộc quyền upload của bạn";
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
        var likeCount = p.Votes.Count(x => x.VoteType > 0);
        var dislikeCount = p.Votes.Count(x => x.VoteType < 0);
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
            VoteScore = likeCount - dislikeCount,
            LikeCount = likeCount,
            DislikeCount = dislikeCount,
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
            VoteScore = summary.VoteScore,
            LikeCount = summary.LikeCount,
            DislikeCount = summary.DislikeCount,
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
        mapped.Replies = FlattenReplies(c.Id, all)
            .OrderBy(x => x.CreatedAt)
            .Select(x =>
            {
                var reply = MapComment(x, currentUserId, canModerate);
                reply.ParentCommentId = c.Id;
                reply.Replies = new List<ForumCommentResponse>();
                return reply;
            })
            .ToList();
        mapped.ReplyCount = mapped.Replies.Count;
        return mapped;
    }

    private static ForumCommentResponse MapComment(Comment c, long? currentUserId, bool canModerate = false)
    {
        var likeCount = c.Votes.Count(x => x.VoteType > 0);
        var dislikeCount = c.Votes.Count(x => x.VoteType < 0);
        return new ForumCommentResponse
        {
            Id = c.Id,
            PostId = c.PostId,
            AuthorId = c.AuthorId,
            AuthorName = c.Author?.FullName ?? "Unknown",
            AuthorInitials = Initials(c.Author?.FullName ?? c.Author?.UserName ?? "U"),
            ParentCommentId = c.ParentCommentId,
            Content = c.Content,
            VoteScore = likeCount - dislikeCount,
            LikeCount = likeCount,
            DislikeCount = dislikeCount,
            IsAcceptedAnswer = c.IsAcceptedAnswer,
            Status = c.Status,
            CreatedAt = c.CreatedAt,
            UpdatedAt = c.UpdatedAt,
            CanEdit = currentUserId.HasValue && (c.AuthorId == currentUserId.Value || canModerate),
            MyVote = currentUserId.HasValue ? c.Votes.FirstOrDefault(x => x.UserId == currentUserId.Value)?.VoteType : null,
            ReplyCount = c.Replies.Count(x => !x.IsDeleted && x.Status == 1)
        };
    }

    private static List<Comment> FlattenReplies(long parentId, IEnumerable<Comment> all)
    {
        var comments = all.ToList();
        var result = new List<Comment>();
        var queue = new Queue<long>();
        queue.Enqueue(parentId);
        var seen = new HashSet<long> { parentId };

        while (queue.Count > 0)
        {
            var currentParentId = queue.Dequeue();
            foreach (var child in comments.Where(x => x.ParentCommentId == currentParentId))
            {
                if (!seen.Add(child.Id)) continue;
                result.Add(child);
                queue.Enqueue(child.Id);
            }
        }

        return result;
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
        if (string.IsNullOrWhiteSpace(r.Title)) errors.Add(new ApiError { Field = "title", Message = "Tiêu đề bắt buộc" });
        else if (r.Title.Trim().Length < 10 || r.Title.Trim().Length > 200) errors.Add(new ApiError { Field = "title", Message = "Tiêu đề phải từ 10 đến 200 ký tự" });
        if (string.IsNullOrWhiteSpace(r.Content)) errors.Add(new ApiError { Field = "content", Message = "Nội dung bắt buộc" });
        else if (r.Content.Trim().Length < 20) errors.Add(new ApiError { Field = "content", Message = "Nội dung phải có ít nhất 20 ký tự" });
        if (r.Tags == null || !r.Tags.Any(x => !string.IsNullOrWhiteSpace(x))) errors.Add(new ApiError { Field = "tags", Message = "Cần ít nhất 1 tag" });
        if (r.Tags != null && r.Tags.Count(x => !string.IsNullOrWhiteSpace(x)) > 5) errors.Add(new ApiError { Field = "tags", Message = "Tối đa 5 tag" });
        if (r.AttachmentIds != null && r.AttachmentIds.Distinct().Count() > 5) errors.Add(new ApiError { Field = "attachmentIds", Message = "Tối đa 5 file đính kèm cho mỗi bài viết" });
        return errors;
    }

    private static List<ApiError> ValidateComment(ForumCommentRequest r)
    {
        var errors = new List<ApiError>();
        if (string.IsNullOrWhiteSpace(r.Content)) errors.Add(new ApiError { Field = "content", Message = "Nội dung bình luận bắt buộc" });
        else if (r.Content.Trim().Length < 2 || r.Content.Trim().Length > 1000) errors.Add(new ApiError { Field = "content", Message = "Bình luận phải từ 2 đến 1000 ký tự" });
        return errors;
    }

    private static List<ApiError> ValidateTag(ForumTagRequest r)
    {
        var errors = new List<ApiError>();
        if (string.IsNullOrWhiteSpace(r.Name)) errors.Add(new ApiError { Field = "name", Message = "Tên tag bắt buộc" });
        else if (r.Name.Trim().Length < 2 || r.Name.Trim().Length > 100) errors.Add(new ApiError { Field = "name", Message = "Tên tag phải từ 2 đến 100 ký tự" });
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
            var c = ch == 'đ' ? 'd' : ch;
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
