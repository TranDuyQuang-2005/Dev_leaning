using System.Text.Json;
using DevLearningHub.Api.Common;
using DevLearningHub.Api.Data;
using DevLearningHub.Api.DTOs;
using DevLearningHub.Api.Entities;
using DevLearningHub.Api.Hubs;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.SignalR;

namespace DevLearningHub.Api.Services;

public interface INotificationService
{
    Task<NotificationDto> CreateAsync(long userId, string type, string title, string message, string? linkUrl, object? metadata, CancellationToken ct);
    Task<ApiResponse<PagedResult<NotificationDto>>> GetMyNotificationsAsync(long userId, NotificationListQuery query, CancellationToken ct);
    Task<ApiResponse<NotificationUnreadCountDto>> GetUnreadCountAsync(long userId, CancellationToken ct);
    Task<ApiResponse<NotificationDto>> MarkAsReadAsync(long userId, long id, CancellationToken ct);
    Task<ApiResponse<NotificationUnreadCountDto>> MarkAllAsReadAsync(long userId, CancellationToken ct);
    Task<ApiResponse<object>> DeleteAsync(long userId, long id, CancellationToken ct);
}

public sealed class NotificationService : INotificationService
{
    private static readonly JsonSerializerOptions JsonOptions = new(JsonSerializerDefaults.Web);
    private readonly DevLearningHubDbContext _db;
    private readonly IHubContext<NotificationHub> _hub;
    private readonly ILogger<NotificationService> _logger;

    public NotificationService(DevLearningHubDbContext db, IHubContext<NotificationHub> hub, ILogger<NotificationService> logger)
    {
        _db = db;
        _hub = hub;
        _logger = logger;
    }

    public async Task<NotificationDto> CreateAsync(long userId, string type, string title, string message, string? linkUrl, object? metadata, CancellationToken ct)
    {
        var metadataJson = SerializeMetadata(metadata);
        var cleanType = string.IsNullOrWhiteSpace(type) ? "general" : type.Trim();
        var cleanTitle = string.IsNullOrWhiteSpace(title) ? "Thông báo" : title.Trim();
        var content = NormalizeContent(cleanTitle, message);
        var eventKey = ExtractEventKey(metadataJson);
        if (!string.IsNullOrWhiteSpace(eventKey))
        {
            var tracked = _db.ChangeTracker.Entries<Notification>()
                .Where(x => x.State != EntityState.Deleted)
                .Select(x => x.Entity)
                .FirstOrDefault(x => x.UserId == userId && x.NotificationType == cleanType && EventKeyMatches(x.MetadataJson, eventKey));
            if (tracked != null) return Map(tracked);

            var existing = await _db.Notifications
                .AsNoTracking()
                .Where(x => x.UserId == userId && x.NotificationType == cleanType && x.MetadataJson != null && x.MetadataJson.Contains(eventKey))
                .OrderByDescending(x => x.CreatedAt)
                .FirstOrDefaultAsync(ct);
            if (existing != null) return Map(existing);
        }

        var notification = new Notification
        {
            UserId = userId,
            NotificationType = cleanType,
            Title = cleanTitle,
            Content = content,
            LinkUrl = string.IsNullOrWhiteSpace(linkUrl) ? null : linkUrl.Trim(),
            IsRead = false,
            CreatedAt = DateTime.UtcNow,
            MetadataJson = metadataJson
        };

        _db.Notifications.Add(notification);
        var savedHere = _db.Database.CurrentTransaction == null;
        if (savedHere)
        {
            await _db.SaveChangesAsync(ct);
        }

        var dto = Map(notification);
        if (savedHere)
        {
            await EmitNotificationCreatedAsync(userId, dto, ct);
            await EmitUnreadCountChangedAsync(userId, ct);
        }

        return dto;
    }

    public async Task<ApiResponse<PagedResult<NotificationDto>>> GetMyNotificationsAsync(long userId, NotificationListQuery query, CancellationToken ct)
    {
        var pageIndex = Math.Max(1, query.PageIndex);
        var pageSize = Math.Clamp(query.PageSize, 1, 100);
        var rows = _db.Notifications.AsNoTracking().Where(x => x.UserId == userId);

        if (query.IsRead.HasValue) rows = rows.Where(x => x.IsRead == query.IsRead.Value);
        if (!string.IsNullOrWhiteSpace(query.Type))
        {
            var type = query.Type.Trim();
            rows = rows.Where(x => x.NotificationType == type);
        }

        var total = await rows.CountAsync(ct);
        var notifications = await rows
            .OrderByDescending(x => x.CreatedAt)
            .Skip((pageIndex - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync(ct);
        var items = notifications.Select(Map).ToList();

        return ApiResponse<PagedResult<NotificationDto>>.Ok(PagedResult<NotificationDto>.Create(items, pageIndex, pageSize, total));
    }

    public async Task<ApiResponse<NotificationUnreadCountDto>> GetUnreadCountAsync(long userId, CancellationToken ct)
    {
        var unread = await _db.Notifications.AsNoTracking().CountAsync(x => x.UserId == userId && !x.IsRead, ct);
        return ApiResponse<NotificationUnreadCountDto>.Ok(new NotificationUnreadCountDto { UnreadCount = unread });
    }

    public async Task<ApiResponse<NotificationDto>> MarkAsReadAsync(long userId, long id, CancellationToken ct)
    {
        var notification = await _db.Notifications.FirstOrDefaultAsync(x => x.Id == id && x.UserId == userId, ct);
        if (notification == null) return ApiResponse<NotificationDto>.Fail("Notification not found");
        if (!notification.IsRead)
        {
            notification.IsRead = true;
            notification.ReadAt = DateTime.UtcNow;
            await _db.SaveChangesAsync(ct);
            await EmitUnreadCountChangedAsync(userId, ct);
        }

        return ApiResponse<NotificationDto>.Ok(Map(notification), "Notification marked as read");
    }

    public async Task<ApiResponse<NotificationUnreadCountDto>> MarkAllAsReadAsync(long userId, CancellationToken ct)
    {
        var notifications = await _db.Notifications.Where(x => x.UserId == userId && !x.IsRead).ToListAsync(ct);
        var now = DateTime.UtcNow;
        foreach (var notification in notifications)
        {
            notification.IsRead = true;
            notification.ReadAt = now;
        }

        if (notifications.Count > 0) await _db.SaveChangesAsync(ct);
        await EmitUnreadCountChangedAsync(userId, 0, ct);
        return ApiResponse<NotificationUnreadCountDto>.Ok(new NotificationUnreadCountDto { UnreadCount = 0 }, "All notifications marked as read");
    }

    public async Task<ApiResponse<object>> DeleteAsync(long userId, long id, CancellationToken ct)
    {
        var notification = await _db.Notifications.FirstOrDefaultAsync(x => x.Id == id && x.UserId == userId, ct);
        if (notification == null) return ApiResponse<object>.Fail("Notification not found");
        _db.Notifications.Remove(notification);
        await _db.SaveChangesAsync(ct);
        await EmitUnreadCountChangedAsync(userId, ct);
        return ApiResponse<object>.Ok(new { id }, "Notification deleted");
    }

    private static string? SerializeMetadata(object? metadata)
    {
        if (metadata == null) return null;
        if (metadata is string text) return string.IsNullOrWhiteSpace(text) ? null : text;
        return JsonSerializer.Serialize(metadata, JsonOptions);
    }

    private static string? ExtractEventKey(string? metadataJson)
    {
        if (string.IsNullOrWhiteSpace(metadataJson)) return null;
        try
        {
            using var document = JsonDocument.Parse(metadataJson);
            if (document.RootElement.ValueKind != JsonValueKind.Object) return null;
            if (document.RootElement.TryGetProperty("eventKey", out var eventKey)) return eventKey.GetString();
            if (document.RootElement.TryGetProperty("EventKey", out var legacyEventKey)) return legacyEventKey.GetString();
        }
        catch (JsonException)
        {
            return null;
        }

        return null;
    }

    private static string NormalizeContent(string title, string? message)
    {
        var content = (message ?? string.Empty).Trim();
        if (!string.IsNullOrWhiteSpace(content)) return content;
        return string.IsNullOrWhiteSpace(title) ? "You have a new notification." : title.Trim();
    }

    private static bool EventKeyMatches(string? metadataJson, string eventKey)
        => string.Equals(ExtractEventKey(metadataJson), eventKey, StringComparison.Ordinal);

    private async Task EmitNotificationCreatedAsync(long userId, NotificationDto notification, CancellationToken ct)
    {
        try
        {
            await _hub.Clients.Group(GroupName(userId)).SendAsync("notification.created", notification, ct);
        }
        catch (Exception ex)
        {
            _logger.LogWarning(ex, "Failed to emit realtime notification.created for user {UserId}", userId);
        }
    }

    private async Task EmitUnreadCountChangedAsync(long userId, CancellationToken ct)
    {
        var unread = await _db.Notifications.AsNoTracking().CountAsync(x => x.UserId == userId && !x.IsRead, ct);
        await EmitUnreadCountChangedAsync(userId, unread, ct);
    }

    private async Task EmitUnreadCountChangedAsync(long userId, int unreadCount, CancellationToken ct)
    {
        try
        {
            await _hub.Clients.Group(GroupName(userId)).SendAsync("notification.unreadCountChanged", new NotificationUnreadCountDto { UnreadCount = unreadCount }, ct);
        }
        catch (Exception ex)
        {
            _logger.LogWarning(ex, "Failed to emit realtime notification.unreadCountChanged for user {UserId}", userId);
        }
    }

    private static string GroupName(long userId) => $"user:{userId}";

    private static NotificationDto Map(Notification x) => new()
    {
        Id = x.Id,
        UserId = x.UserId,
        Type = x.NotificationType,
        NotificationType = x.NotificationType,
        Title = x.Title,
        Content = x.Content,
        Message = x.Content,
        LinkUrl = x.LinkUrl,
        IsRead = x.IsRead,
        ReadAt = x.ReadAt,
        CreatedAt = x.CreatedAt,
        MetadataJson = x.MetadataJson
    };
}
