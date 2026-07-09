# DevLearningHub v13 - User Direct Permissions

## Mục tiêu

Bản v11 trước đó mới làm phân quyền theo **Role** như User/Moderator/Admin. Đây là nhóm quyền, chưa đúng yêu cầu phân quyền theo từng quyền lẻ.

Bản v13 bổ sung phân quyền theo **Permission lẻ** cho từng tài khoản.

## Mô hình quyền mới

Hệ thống có 3 lớp:

1. Role: nhóm quyền, ví dụ User, Moderator, Admin.
2. RolePermissions: quyền mặc định đi theo role.
3. UserPermissions: quyền lẻ gán trực tiếp cho từng account.

Quyền có hiệu lực của user:

```text
Effective Permissions = RolePermissions + UserPermissions
```

## Database mới

Thêm bảng:

```sql
UserPermissions
```

Cấu trúc:

```text
UserId
PermissionId
AssignedAt
AssignedBy
```

## API mới

```http
GET /api/v1/admin/permissions
GET /api/v1/admin/users/{userId}/permissions
PUT /api/v1/admin/users/{userId}/permissions
```

Payload cập nhật quyền:

```json
{
  "permissionIds": [1, 2, 5, 7]
}
```

## UI Admin

Vào:

```text
Admin App → Users → Phân quyền lẻ
```

Khi bấm vào một tài khoản, hệ thống show toàn bộ permission trong hệ thống, gom theo module:

- User
- Auth
- Learning
- Forum
- Judge
- File
- Audit

Bên cạnh mỗi permission có checkbox. Tick/untick sẽ tự động cập nhật DB.

## Ý nghĩa nhãn trong UI

- Tick checkbox: quyền được gán trực tiếp cho account qua UserPermissions.
- Từ role: account đang có quyền đó thông qua RolePermissions.
- Có hiệu lực: account có quyền này từ role hoặc từ quyền trực tiếp.

## Script nâng cấp DB

Chạy file:

```text
database/Upgrade_v13_User_Direct_Permissions.sql
```

## Lưu ý

Sau khi cập nhật quyền cho một tài khoản đang đăng nhập, tài khoản đó cần logout/login lại để JWT nhận danh sách permissions mới.
