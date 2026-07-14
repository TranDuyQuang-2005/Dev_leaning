using System.Net;
using System.Text.Json;
using DevLearningHub.Api.Common;

namespace DevLearningHub.Api.Middlewares;

public sealed class ExceptionHandlingMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<ExceptionHandlingMiddleware> _logger;
    private readonly IHostEnvironment _env;

    public ExceptionHandlingMiddleware(RequestDelegate next, ILogger<ExceptionHandlingMiddleware> logger, IHostEnvironment env)
    {
        _next = next; _logger = logger; _env = env;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        try { await _next(context); }
        catch (OperationCanceledException) when (context.RequestAborted.IsCancellationRequested)
        {
            _logger.LogDebug("Request was canceled by the client. TraceId: {TraceId}", context.TraceIdentifier);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Unhandled exception");
            if (context.Response.HasStarted) throw;
            context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
            context.Response.ContentType = "application/json";
            var message = _env.IsDevelopment() ? ex.InnerException?.Message ?? ex.Message : "An unexpected error occurred";
            var response = ApiResponse<object>.Fail(message);
            response.TraceId = context.TraceIdentifier;
            await context.Response.WriteAsync(JsonSerializer.Serialize(response, new JsonSerializerOptions { PropertyNamingPolicy = JsonNamingPolicy.CamelCase }));
        }
    }
}
