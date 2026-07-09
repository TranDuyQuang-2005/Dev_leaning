using System.Net.Mime;
using DevLearningHub.Api.Common;
using DevLearningHub.Api.Data;
using DevLearningHub.Api.DTOs;
using DevLearningHub.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace DevLearningHub.Api.Controllers;

[ApiController]
[Route("api/v1/files")]
public sealed class FilesController : BaseApiController
{
    private readonly IFileModuleService _service;
    private readonly DevLearningHubDbContext _db;
    private readonly IObjectStorageService _storage;

    public FilesController(IFileModuleService service, DevLearningHubDbContext db, IObjectStorageService storage)
    {
        _service = service;
        _db = db;
        _storage = storage;
    }

    [HttpPost("upload")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<FileUploadResponse>>> Upload(IFormFile file, string fileType = "general", CancellationToken ct = default)
    {
        if (CurrentUserId is null) return Unauthorized();
        return Ok(await _service.Upload(CurrentUserId.Value, file, fileType, ct));
    }

    // Professional file proxy endpoint:
    // Frontend reads images/files through API instead of directly exposing private MinIO objects.
    [HttpGet("{id:long}/view")]
    [AllowAnonymous]
    [ResponseCache(Duration = 300, Location = ResponseCacheLocation.Client)]
    public async Task<IActionResult> View(long id, CancellationToken ct)
    {
        var file = await _db.Files.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, ct);
        if (file == null) return NotFound("File không tồn tại hoặc đã bị xóa.");

        try
        {
            var result = await _storage.ReadFileAsync(
                file.StorageProvider,
                file.StoredFileName,
                file.FileUrl,
                file.MimeType,
                file.OriginalFileName,
                ct);

            Response.Headers["X-Content-Type-Options"] = "nosniff";
            Response.Headers["Content-Disposition"] = new ContentDisposition
            {
                Inline = true,
                FileName = result.FileName
            }.ToString();

            return File(result.Bytes, result.ContentType, enableRangeProcessing: true);
        }
        catch (Exception ex)
        {
            return NotFound(ex.Message);
        }
    }

    [HttpGet("{id:long}/download")]
    [AllowAnonymous]
    public async Task<IActionResult> Download(long id, CancellationToken ct)
    {
        var file = await _db.Files.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, ct);
        if (file == null) return NotFound("File không tồn tại hoặc đã bị xóa.");

        try
        {
            var result = await _storage.ReadFileAsync(
                file.StorageProvider,
                file.StoredFileName,
                file.FileUrl,
                file.MimeType,
                file.OriginalFileName,
                ct);

            Response.Headers["X-Content-Type-Options"] = "nosniff";
            return File(result.Bytes, result.ContentType, result.FileName, enableRangeProcessing: true);
        }
        catch (Exception ex)
        {
            return NotFound(ex.Message);
        }
    }
}
