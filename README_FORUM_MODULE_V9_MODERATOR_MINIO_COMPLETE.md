# DevLearningHub v9 - Forum Professional Complete

Bản v9 hoàn thiện phân hệ Forum theo hướng thực tế:

## Tài khoản có sẵn

- Admin: `admin@example.com` / `123456Aa`
- Moderator: `moderator@example.com` / `123456Aa`

Khi API chạy, `DatabaseSeeder` tự tạo role `Moderator`, quyền `forum.moderate` và tài khoản moderator.

## Phân quyền

### User
- Xem forum
- Tạo/sửa/xóa bài viết của mình
- Upload ảnh/file khi tạo bài
- Comment/reply
- Upvote/downvote
- Bookmark
- Report bài viết/comment

### Moderator
- Đăng nhập Admin App nhưng được chuyển vào `/forum`
- Xem Posts/Comments/Reports
- Hide/Restore post
- Hide comment
- Resolve/Reject report
- Không được quản lý quiz/user/tag toàn hệ thống

### Admin
- Toàn quyền Moderator
- Quản lý tags forum
- Xóa post/comment
- Quản lý các phân hệ khác

## Upload ảnh/file Forum bằng MinIO

Luồng thực tế:

```text
User chọn file/hình
→ Angular gửi multipart/form-data tới API
→ API validate dung lượng/định dạng/quyền user
→ API upload lên MinIO Docker localhost:9000
→ API lưu metadata vào Files
→ Khi tạo bài, API gắn FileReferences với Post
→ User xem chi tiết bài thấy ảnh/file
```

## Chạy MinIO Docker

Ở thư mục root project:

```powershell
docker compose up -d
```

MinIO Console:

```text
http://localhost:9001
admin / 12345678
```

Public file URL dạng:

```text
http://localhost:9000/devlearninghub/forum/...
```

Nếu MinIO chưa chạy, API tự fallback lưu local `/uploads/forum/...` để không làm hỏng luồng demo.

## Chạy project

```powershell
cd api\DevLearningHub.Api
dotnet restore
dotnet run
```

```powershell
cd client\devlearninghub-client
npm install --legacy-peer-deps
npm start
```

```powershell
cd admin\devlearninghub-admin
npm install --legacy-peer-deps
npm start
```

## Test nhanh Forum Upload

1. Chạy Docker MinIO.
2. Chạy API, client, admin.
3. Login user ở `http://localhost:4200/login`.
4. Vào `http://localhost:4200/learner/create-post`.
5. Nhập title, content, tag.
6. Chọn ảnh `.png/.jpg` hoặc file `.pdf/.docx`.
7. Bấm Create Post.
8. Vào chi tiết bài, kiểm tra ảnh/file hiển thị.
9. Mở MinIO Console để thấy object được lưu trong bucket `devlearninghub`.
10. Login `moderator@example.com / 123456Aa` ở `http://localhost:4300`, kiểm duyệt report/post/comment.

## Validation file

- Tối đa 10MB/file
- Tối đa 5 file/post
- Cho phép: jpg, jpeg, png, gif, webp, pdf, doc, docx, txt, zip
- Upload bắt buộc qua API, không cho frontend upload thẳng vào MinIO
