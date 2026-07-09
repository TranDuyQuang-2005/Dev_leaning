using System.Security.Claims;
using Microsoft.AspNetCore.Mvc;

namespace DevLearningHub.Api.Controllers;

public abstract class BaseApiController : ControllerBase
{
    protected long? CurrentUserId
    {
        get
        {
            var value = User.FindFirstValue(ClaimTypes.NameIdentifier);
            return long.TryParse(value, out var id) ? id : null;
        }
    }
}
