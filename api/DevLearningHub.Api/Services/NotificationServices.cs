using System.Text.Json;
using DevLearningHub.Api.Common;
using DevLearningHub.Api.Data;
using DevLearningHub.Api.DTOs;
using DevLearningHub.Api.Entities;
using Microsoft.EntityFrameworkCore;

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

    public NotificationService(DevLearningHubDbContext db)
    {
        _db = db;
    }

    public async Task<NotificationDto> CreateAsync(long userId, string type, string title, string message, string? linkUrl, object? metadata, CancellationToken ct)
    {
        var metadataJson = SerializeMetadata(metadata);
        var eventKey = ExtractEventKey(metadataJson);
        if (!string.IsNullOrWhiteSpace(eventKey))
        {
            var tracked = _db.ChangeTracker.Entries<Notification>()
                .Where(x => x.State != EntityState.Deleted)
                .Select(x => x.Entity)
                .FirstOrDefault(x => x.UserId == userId && x.Type == type && EventKeyMatches(x.MetadataJson, eventKey));
            if (tracked != null) return Map(tracked);

            var existing = await _db.Notifications
                .AsNoTracking()
                .Where(x => x.UserId == userId && x.Type == type && x.MetadataJson != null && x.MetadataJson.Contains(eventKey))
                .OrderByDescending(x => x.CreatedAt)
                .FirstOrDefaultAsync(ct);
            if (existing != null) return Map(existing);
        }

        var notification = new Notification
        {
            UserId = userId,
            Type = type.Trim(),
            Title = title.Trim(),
            Message = message.Trim(),
            LinkUrl = string.IsNullOrWhiteSpace(linkUrl) ? null : linkUrl.Trim(),
            IsRead = false,
            CreatedAt = DateTime.UtcNow,
            MetadataJson = metadataJson
        };

        _db.Notifications.Add(notification);
        if (_db.Database.CurrentTransaction == null)
        {
            await _db.SaveChangesAsync(ct);
        }

        return Map(notification);
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
            rows = rows.Where(x => x.Type == type);
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
        return ApiResponse<NotificationUnreadCountDto>.Ok(new NotificationUnreadCountDto { UnreadCount = 0 }, "All notifications marked as read");
    }

    public async Task<ApiResponse<object>> DeleteAsync(long userId, long id, CancellationToken ct)
    {
        var notification = await _db.Notifications.FirstOrDefaultAsync(x => x.Id == id && x.UserId == userId, ct);
        if (notification == null) return ApiResponse<object>.Fail("Notification not found");
        _db.Notifications.Remove(notification);
        await _db.SaveChangesAsync(ct);
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

    private static bool EventKeyMatches(string? metadataJson, string eventKey)
        => string.Equals(ExtractEventKey(metadataJson), eventKey, StringComparison.Ordinal);

    private static NotificationDto Map(Notification x) => new()
    {
        Id = x.Id,
        UserId = x.UserId,
        Type = x.Type,
        Title = x.Title,
        Message = x.Message,
        LinkUrl = x.LinkUrl,
        IsRead = x.IsRead,
        ReadAt = x.ReadAt,
        CreatedAt = x.CreatedAt,
        MetadataJson = x.MetadataJson
    };
}
