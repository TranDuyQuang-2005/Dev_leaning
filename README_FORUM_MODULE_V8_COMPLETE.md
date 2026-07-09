# DevLearningHub v8 - Forum Module Complete

Bản v8 hoàn thiện phân hệ diễn đàn theo yêu cầu: giữ UI gốc ở mức class/layout chính, dùng Angular component thật, dữ liệu lấy từ API/CSDL thật, không dùng HTML tĩnh cho các trang chính.

## Chức năng chính

### User
- Xem danh sách post từ DB.
- Tìm kiếm/lọc theo tag.
- Tạo/sửa/xóa bài viết của mình.
- Xem chi tiết bài viết.
- Comment/reply comment.
- Upvote/downvote post/comment.
- Bookmark/bỏ bookmark.
- Report post/comment.

### Admin/Moderator
- Quản lý forum tại `http://localhost:4300/forum`.
- Quản lý posts/comments/reports/tags.
- Hide/restore/delete post.
- Hide/delete comment.
- Resolve/reject report.
- Resolve report + hide target.

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

## Test nhanh
- User Forum: `http://localhost:4200/learner/forum`
- Admin Forum: `http://localhost:4300/forum`
- Swagger: `http://localhost:5000/swagger`

Tài khoản admin mặc định:

```text
admin@example.com
123456Aa
```

## File test
- `docs/FORUM_MODULE_TESTING.md`
- `database/Seed_Forum_Test_Data.sql`
