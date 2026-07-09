using DevLearningHub.Api.Common;
using DevLearningHub.Api.DTOs;
using DevLearningHub.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace DevLearningHub.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/v1/notifications")]
public sealed class NotificationsController : BaseApiController
{
    private readonly INotificationService _notifications;

    public NotificationsController(INotificationService notifications)
    {
        _notifications = notifications;
    }

    [HttpGet]
    public async Task<ActionResult<ApiResponse<PagedResult<NotificationDto>>>> Get([FromQuery] NotificationListQuery query, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _notifications.GetMyNotificationsAsync(CurrentUserId.Value, query, ct));
    }

    [HttpGet("unread-count")]
    public async Task<ActionResult<ApiResponse<NotificationUnreadCountDto>>> UnreadCount(CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _notifications.GetUnreadCountAsync(CurrentUserId.Value, ct));
    }

    [HttpPost("{id:long}/read")]
    public async Task<ActionResult<ApiResponse<NotificationDto>>> MarkAsRead(long id, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        var res = await _notifications.MarkAsReadAsync(CurrentUserId.Value, id, ct);
        return res.Success ? Ok(res) : NotFound(res);
    }

    [HttpPost("read-all")]
    public async Task<ActionResult<ApiResponse<NotificationUnreadCountDto>>> MarkAllAsRead(CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _notifications.MarkAllAsReadAsync(CurrentUserId.Value, ct));
    }

    [HttpDelete("{id:long}")]
    public async Task<ActionResult<ApiResponse<object>>> Delete(long id, CancellationToken ct)
    {
        if (CurrentUserId is null) return Unauthorized();
        var res = await _notifications.DeleteAsync(CurrentUserId.Value, id, ct);
        return res.Success ? Ok(res) : NotFound(res);
    }
}
