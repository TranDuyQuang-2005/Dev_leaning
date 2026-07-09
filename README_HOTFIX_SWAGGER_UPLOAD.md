# HOTFIX v11.1 - Swagger Upload IFormFile

## Lỗi đã sửa
Swagger bị lỗi khi generate API docs:

```text
Swashbuckle.AspNetCore.SwaggerGen.SwaggerGeneratorException:
[FromForm] attribute used with IFormFile
```

## Nguyên nhân
Trong quá trình bổ sung v11 có thêm các endpoint upload ở Forum/AdminForum/ModeratorForum.
Một số endpoint dùng dạng:

```csharp
Upload([FromForm] IFormFile file, CancellationToken ct)
```

Dạng này vẫn có thể khiến upload chạy, nhưng Swagger/Swashbuckle bị crash khi mở `/swagger`.

## Đã sửa
Đổi thành:

```csharp
[HttpPost("uploads")]
[Consumes("multipart/form-data")]
public async Task<ActionResult<ApiResponse<ForumAttachmentResponse>>> Upload(IFormFile file, CancellationToken ct)
```

Các vị trí đã sửa:

- `api/v1/forum/uploads`
- `api/v1/admin/forum/uploads`
- `api/v1/moderator/forum/uploads`

## Cách chạy lại

```powershell
cd D:\DevLearningHub\api\DevLearningHub.Api
dotnet clean
dotnet restore
dotnet build
dotnet run
```

Sau đó mở:

```text
http://localhost:5000/swagger
```
