# DevLearningHub v12.1 HOTFIX - Build lỗi sealed class

## Lỗi đã sửa

Khi chạy API bản v12 có lỗi:

```text
DTOs/Dtos.cs(471,51): error CS0509: 'CodingProblemDetailResponse': cannot derive from sealed type 'CodingProblemSummaryResponse'
```

Nguyên nhân: `CodingProblemDetailResponse` kế thừa từ `CodingProblemSummaryResponse`, nhưng `CodingProblemSummaryResponse` bị khai báo `sealed`.

## File đã sửa

```text
api/DevLearningHub.Api/DTOs/Dtos.cs
```

Đã đổi:

```csharp
public sealed class CodingProblemSummaryResponse
```

thành:

```csharp
public class CodingProblemSummaryResponse
```

## Cách chạy lại

```powershell
cd D:\DevLearningHub\api\DevLearningHub.Api
dotnet clean
Remove-Item -Recurse -Force .\bin, .\obj -ErrorAction SilentlyContinue
dotnet restore
dotnet build
dotnet run
```
