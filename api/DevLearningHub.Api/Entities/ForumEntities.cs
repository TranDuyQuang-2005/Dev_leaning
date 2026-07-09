namespace DevLearningHub.Api.Entities;

public sealed class Tag
{
    public long Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Slug { get; set; } = string.Empty;
    public string? Description { get; set; }
    public DateTime CreatedAt { get; set; }
    public ICollection<PostTag> PostTags { get; set; } = new List<PostTag>();
}

public sealed class Post
{
    public long Id { get; set; }
    public long AuthorId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Slug { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
    public string? ContentHtml { get; set; }
    public int ViewCount { get; set; }
    public int VoteScore { get; set; }
    public int AnswerCount { get; set; }
    public long? AcceptedCommentId { get; set; }
    public byte Status { get; set; } = 1;
    public DateTime? LastActivityAt { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public bool IsDeleted { get; set; }
    public User Author { get; set; } = null!;
    public ICollection<Comment> Comments { get; set; } = new List<Comment>();
    public ICollection<PostTag> PostTags { get; set; } = new List<PostTag>();
    public ICollection<PostVote> Votes { get; set; } = new List<PostVote>();
    public ICollection<PostBookmark> Bookmarks { get; set; } = new List<PostBookmark>();
}

public sealed class Comment
{
    public long Id { get; set; }
    public long PostId { get; set; }
    public long AuthorId { get; set; }
    public long? ParentCommentId { get; set; }
    public string Content { get; set; } = string.Empty;
    public string? ContentHtml { get; set; }
    public int VoteScore { get; set; }
    public bool IsAcceptedAnswer { get; set; }
    public byte Status { get; set; } = 1;
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public bool IsDeleted { get; set; }
    public Post Post { get; set; } = null!;
    public User Author { get; set; } = null!;
    public Comment? ParentComment { get; set; }
    public ICollection<Comment> Replies { get; set; } = new List<Comment>();
    public ICollection<CommentVote> Votes { get; set; } = new List<CommentVote>();
}

public sealed class PostTag
{
    public long PostId { get; set; }
    public long TagId { get; set; }
    public Post Post { get; set; } = null!;
    public Tag Tag { get; set; } = null!;
}

public sealed class PostVote
{
    public long Id { get; set; }
    public long PostId { get; set; }
    public long UserId { get; set; }
    public short VoteType { get; set; }
    public DateTime CreatedAt { get; set; }
    public Post Post { get; set; } = null!;
    public User User { get; set; } = null!;
}

public sealed class CommentVote
{
    public long Id { get; set; }
    public long CommentId { get; set; }
    public long UserId { get; set; }
    public short VoteType { get; set; }
    public DateTime CreatedAt { get; set; }
    public Comment Comment { get; set; } = null!;
    public User User { get; set; } = null!;
}

public sealed class PostBookmark
{
    public long PostId { get; set; }
    public long UserId { get; set; }
    public DateTime CreatedAt { get; set; }
    public Post Post { get; set; } = null!;
    public User User { get; set; } = null!;
}

public sealed class Report
{
    public long Id { get; set; }
    public long ReporterId { get; set; }
    public string TargetType { get; set; } = string.Empty;
    public long TargetId { get; set; }
    public string Reason { get; set; } = string.Empty;
    public string? Description { get; set; }
    public byte Status { get; set; } = 1;
    public long? ResolvedByUserId { get; set; }
    public DateTime? ResolvedAt { get; set; }
    public DateTime CreatedAt { get; set; }
    public User Reporter { get; set; } = null!;
}

public sealed class ModerationAction
{
    public long Id { get; set; }
    public long ModeratorId { get; set; }
    public string TargetType { get; set; } = string.Empty;
    public long TargetId { get; set; }
    public string ActionType { get; set; } = string.Empty;
    public string? Reason { get; set; }
    public DateTime CreatedAt { get; set; }
}
