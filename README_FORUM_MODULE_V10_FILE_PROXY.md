# DevLearningHub v10 - Forum File Proxy Professional Fix

## Mục tiêu
Bản v10 sửa phần hiển thị ảnh/file trong Forum theo hướng chuyên nghiệp:

- Frontend không đọc trực tiếp link MinIO nữa.
- Bucket MinIO không cần public read.
- Ảnh/file được đọc qua API proxy: `GET /api/v1/files/{id}/view`.
- API tự đọc file từ MinIO hoặc local fallback rồi stream về browser.
- Vẫn lưu metadata file trong `Files` và quan hệ bài viết trong `FileReferences`.

## API mới

```http
GET /api/v1/files/{id}/view
GET /api/v1/files/{id}/download
```

## Luồng mới

```text
User tạo bài viết + chọn ảnh/file
→ API upload lên MinIO
→ DB lưu Files + FileReferences
→ Forum detail trả attachment với fileUrl = /api/v1/files/{fileId}/view
→ Angular prepend http://localhost:5000
→ Browser load ảnh qua API
→ API ký request đọc MinIO và stream ảnh/file về browser
```

## Ưu điểm

- Không cần mở public bucket MinIO.
- Không bị lỗi browser không hiểu host `minio`.
- Không bị lỗi 403 do object private.
- Có thể kiểm soát quyền tải file sau này.
- Dễ thay MinIO bằng S3/Azure Blob/local storage.

## Cách test

1. Chạy MinIO:

```powershell
docker compose up -d
```

2. Chạy API:

```powershell
cd api\DevLearningHub.Api
dotnet run
```

3. Chạy Client:

```powershell
cd client\devlearninghub-client
npm install --legacy-peer-deps
npm start
```

4. User tạo bài Forum có ảnh.
5. Vào chi tiết bài viết.
6. Ảnh phải hiện qua URL dạng:

```text
http://localhost:5000/api/v1/files/{fileId}/view
```

7. Kiểm tra DB:

```sql
USE DevLearningHubDb;
SELECT TOP 20 * FROM Files ORDER BY Id DESC;
SELECT TOP 20 * FROM FileReferences ORDER BY Id DESC;
```

## Ghi chú
Nếu MinIO lỗi, API vẫn fallback local upload theo cấu hình `FallbackToLocal = true`.
