# DevLearningHub - Forum Module v8 Testing Guide

## Chức năng đã hoàn thiện

### User / Learner
- Xem danh sách bài viết từ CSDL thật.
- Tìm kiếm bài viết theo tiêu đề/nội dung.
- Lọc bài viết theo tag.
- Xem chi tiết bài viết.
- Tạo bài viết mới với validation title/content/tags.
- Sửa bài viết của chính mình.
- Xóa bài viết của chính mình.
- Bình luận vào bài viết.
- Reply comment.
- Upvote/downvote bài viết.
- Upvote/downvote comment.
- Bookmark/bỏ bookmark bài viết.
- Report bài viết/comment vi phạm.

### Admin / Moderator
- Quản lý danh sách bài viết.
- Ẩn/khôi phục/xóa bài viết.
- Quản lý bình luận.
- Ẩn/xóa bình luận.
- Xem danh sách report.
- Resolve/reject report, có tùy chọn ẩn nội dung bị report.
- Quản lý tag forum: thêm/sửa/xóa.

## API chính

### User API
- `GET /api/v1/forum/posts`
- `GET /api/v1/forum/posts/{id}`
- `POST /api/v1/forum/posts`
- `PUT /api/v1/forum/posts/{id}`
- `DELETE /api/v1/forum/posts/{id}`
- `POST /api/v1/forum/posts/{id}/comments`
- `PUT /api/v1/forum/comments/{id}`
- `DELETE /api/v1/forum/comments/{id}`
- `POST /api/v1/forum/posts/{id}/vote`
- `POST /api/v1/forum/comments/{id}/vote`
- `POST /api/v1/forum/posts/{id}/bookmark`
- `DELETE /api/v1/forum/posts/{id}/bookmark`
- `POST /api/v1/forum/reports`
- `GET /api/v1/forum/tags`

### Admin API
- `GET /api/v1/admin/forum/posts`
- `PUT /api/v1/admin/forum/posts/{id}/hide`
- `PUT /api/v1/admin/forum/posts/{id}/restore`
- `DELETE /api/v1/admin/forum/posts/{id}`
- `GET /api/v1/admin/forum/comments`
- `PUT /api/v1/admin/forum/comments/{id}/hide`
- `DELETE /api/v1/admin/forum/comments/{id}`
- `GET /api/v1/admin/forum/reports`
- `PUT /api/v1/admin/forum/reports/{id}/resolve`
- `GET /api/v1/admin/forum/tags`
- `POST /api/v1/admin/forum/tags`
- `PUT /api/v1/admin/forum/tags/{id}`
- `DELETE /api/v1/admin/forum/tags/{id}`

## Validation cần test

| Case | Dữ liệu | Kết quả mong muốn |
|---|---|---|
| Tạo post thiếu title | title rỗng | Báo lỗi validation |
| Tạo post title quá ngắn | < 10 ký tự | Báo lỗi validation |
| Tạo post content quá ngắn | < 20 ký tự | Báo lỗi validation |
| Tạo post không tag | tags rỗng | Báo lỗi validation |
| Comment rỗng | content rỗng | Báo lỗi validation |
| Report thiếu reason | reason rỗng | Báo lỗi validation |
| Vote post | voteType = 1/-1 | Cập nhật VoteScore |
| Vote lại cùng loại | voteType giống lần trước | Hủy vote |
| Đổi vote | 1 sang -1 | Cập nhật điểm đúng |
| User sửa bài người khác | Không phải owner | API trả lỗi quyền |
| User xóa bài người khác | Không phải owner | API trả lỗi quyền |
| Chưa login tạo post | Không token | 401 Unauthorized |
| Admin ẩn post | status post về 0 | User không thấy post |
| Admin restore post | status post về 1 | User thấy lại post |
| Resolve report + Hide Target | report resolved, target hidden | Report status đổi, post/comment bị ẩn |

## Luồng test UI User
1. Login user.
2. Vào `http://localhost:4200/learner/forum`.
3. Search bài viết.
4. Lọc theo tag.
5. Bấm New Post.
6. Tạo bài với title/content/tags hợp lệ.
7. Vào chi tiết bài.
8. Upvote/downvote post.
9. Bookmark post.
10. Comment vào bài.
11. Reply comment.
12. Upvote/downvote comment.
13. Report post/comment.
14. Edit/Delete bài của chính mình.

## Luồng test UI Admin
1. Login admin.
2. Vào `http://localhost:4300/forum`.
3. Tạo tag forum.
4. Xem danh sách posts.
5. Hide một post.
6. Qua User kiểm tra post đã ẩn.
7. Restore post.
8. Xem comments và hide/delete comment.
9. Vào reports.
10. Resolve report hoặc Resolve + Hide.

## SQL kiểm tra dữ liệu
```sql
USE DevLearningHubDb;

SELECT TOP 20 * FROM Posts ORDER BY Id DESC;
SELECT TOP 20 * FROM Comments ORDER BY Id DESC;
SELECT TOP 20 * FROM Tags ORDER BY Id DESC;
SELECT TOP 20 * FROM PostTags ORDER BY PostId DESC;
SELECT TOP 20 * FROM PostVotes ORDER BY Id DESC;
SELECT TOP 20 * FROM CommentVotes ORDER BY Id DESC;
SELECT TOP 20 * FROM PostBookmarks ORDER BY CreatedAt DESC;
SELECT TOP 20 * FROM Reports ORDER BY Id DESC;
SELECT TOP 20 * FROM ModerationActions ORDER BY Id DESC;
```
