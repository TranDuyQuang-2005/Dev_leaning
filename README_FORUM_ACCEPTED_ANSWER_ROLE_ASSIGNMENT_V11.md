# DevLearningHub v11 - Forum Accepted Answer + Account Role Assignment

Bản v11 bổ sung 2 chức năng theo hướng thực tế/chuyên nghiệp:

## 1. Forum - Chấm câu trả lời đúng

### Chức năng
- Chủ bài viết có thể bấm **Đánh dấu đúng** cho một câu trả lời chính.
- Admin/Moderator cũng có thể đánh dấu câu trả lời đúng khi cần hỗ trợ kiểm duyệt.
- Một bài viết chỉ có duy nhất 1 câu trả lời đúng.
- Khi chọn câu trả lời mới, câu trả lời đúng cũ tự động bị bỏ chọn.
- Khi câu trả lời đúng bị xóa/ẩn, trạng thái solved của bài viết tự động bị gỡ.
- Danh sách Forum hiển thị nhãn **Solved** cho bài đã có câu trả lời đúng.
- Trang chi tiết Forum đưa câu trả lời đúng lên đầu và hiển thị nhãn **Câu trả lời đúng**.

### API mới
```http
POST /api/v1/forum/posts/{postId}/comments/{commentId}/accept
DELETE /api/v1/forum/posts/{postId}/accepted-answer
```

### Quy tắc quyền
- User thường: chỉ chủ bài viết được đánh dấu/bỏ đánh dấu.
- Admin: được đánh dấu/bỏ đánh dấu mọi bài.
- Moderator: được đánh dấu/bỏ đánh dấu mọi bài trong phạm vi Forum.
- Không đánh dấu reply; chỉ đánh dấu câu trả lời chính.

### DB sử dụng
- `Posts.AcceptedCommentId`
- `Comments.IsAcceptedAnswer`

---

## 2. Admin - Phân quyền tài khoản bằng checkbox

### Chức năng
- Admin vào tab **Users**.
- Bấm **Phân quyền** ở từng tài khoản.
- Hệ thống show toàn bộ role/quyền trong hệ thống: User, Moderator, Admin.
- Bên cạnh mỗi role có checkbox.
- Tick/untick checkbox sẽ tự động gọi API cập nhật quyền cho tài khoản.
- Sau khi cập nhật, DB bảng `UserRoles` được thay đổi ngay.
- Nếu tài khoản đang đăng nhập bị đổi quyền, cần logout/login lại để JWT nhận quyền mới.

### API mới
```http
GET /api/v1/admin/users/{userId}/roles
PUT /api/v1/admin/users/{userId}/roles
```

Payload cập nhật:
```json
{
  "roleIds": [1, 2, 3]
}
```

### Quy tắc an toàn
- Chỉ Admin được dùng chức năng phân quyền.
- Không cho tự gỡ quyền Admin khỏi chính tài khoản đang đăng nhập.
- Mỗi tài khoản phải có ít nhất 1 role.

---

## Luồng test nhanh

### Test Accepted Answer
1. User A tạo bài viết Forum.
2. User B vào bài viết và bình luận trả lời.
3. User A mở bài viết, bấm **Đánh dấu đúng** dưới câu trả lời.
4. Câu trả lời hiển thị nhãn **Câu trả lời đúng**.
5. Danh sách Forum hiển thị bài viết có nhãn **Solved**.
6. User khác thử đánh dấu câu trả lời đúng cho bài không phải của mình → hệ thống từ chối.
7. Moderator/Admin đăng nhập và đánh dấu/bỏ đánh dấu câu trả lời đúng → thành công.

### Test phân quyền tài khoản
1. Đăng nhập Admin App bằng `admin@example.com / 123456Aa`.
2. Vào tab **Users**.
3. Bấm **Phân quyền** ở một tài khoản.
4. Tick role `Moderator`.
5. Kiểm tra DB bảng `UserRoles` có role mới.
6. Đăng xuất tài khoản đó và đăng nhập lại.
7. Tài khoản được cấp Moderator có thể vào `/forum` trong Admin App.
8. Untick role `Moderator` rồi đăng nhập lại → không còn quyền Moderator.

