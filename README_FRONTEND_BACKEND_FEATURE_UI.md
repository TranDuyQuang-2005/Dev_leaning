# 2026 Code Runner / Progress UI Update

- Client Playground consumes `GET /api/v1/code/languages`.
- Playground supports starter templates for `python`, `javascript`, `typescript`, `java`, `c`, `cpp`, `csharp`, and `go`.
- Problem Detail uses problem-specific starter code when available and falls back to language templates otherwise.
- Admin Code Management has a `Languages` tab showing code, extension, compile command, run command, runtime, and active status.
- Admin problem form includes starter-code editors for TypeScript, C, C#, and Go.
- Roadmap calls `GET /api/v1/me/progress/roadmap`.
- Leaderboard calls `GET /api/v1/leaderboard`.
- Backend also exposes `GET /api/v1/me/progress/overview` and `GET /api/v1/me/progress/topics`.
- Forum image/file display remains through backend proxy URLs only: `http://localhost:5000/api/v1/files/{fileId}/view`.
- Do not render direct MinIO URLs such as `http://localhost:9000/devlearninghub/...`.

# Frontend UI for Backend Feature Branch

## UI mới đã thêm

- User Personal Practice: upload CSV/JSON, danh sách bank, chi tiết bank, làm bài, lịch sử, kết quả.
- Forgot Password, Reset Password, Verify Email, Resend Verification.
- Change Password trong Profile.
- Admin Permission Groups, Assign Groups cho user/role, Effective Permissions.
- Admin Lock/Unlock User.
- Admin Audit Logs.
- Admin Quiz Analytics, Export CSV, Reset Attempts.
- User Code Submission Detail.
- Admin Code Submission Detail.

## Route mới

Client:

- `/forgot-password`
- `/reset-password`
- `/verify-email`
- `/resend-verification`
- `/learner/practice-banks`
- `/learner/practice-banks/:id`
- `/learner/practice-attempts`
- `/learner/practice-attempts/:attemptId`
- `/learner/practice-attempts/:attemptId/result`
- `/learner/submissions/:submissionId`
- Có alias top-level cho `/practice-banks`, `/practice-attempts`, `/submissions/:submissionId`.

Admin:

- Dashboard tab `Access Control`
- Dashboard tab `Audit Logs`
- Dashboard tab `Quiz Analytics`
- Code Management tab `Submissions`

## API backend đã nối

Personal Practice:

- `POST /api/v1/me/practice-banks/upload`
- `GET /api/v1/me/practice-banks`
- `GET /api/v1/me/practice-banks/{bankId}`
- `DELETE /api/v1/me/practice-banks/{bankId}`
- `POST /api/v1/me/practice-banks/{bankId}/attempts`
- `GET /api/v1/me/practice-attempts`
- `GET /api/v1/me/practice-attempts/{attemptId}`
- `POST /api/v1/me/practice-attempts/{attemptId}/submit`

Auth:

- `POST /api/v1/auth/forgot-password`
- `POST /api/v1/auth/reset-password`
- `POST /api/v1/auth/resend-email-verification`
- `POST /api/v1/auth/verify-email`
- `PUT /api/v1/auth/change-password`

Admin access/security:

- `GET/POST/PUT/DELETE /api/v1/admin/permission-groups`
- `POST /api/v1/admin/permission-groups/{id}/permissions`
- `POST /api/v1/admin/roles/{roleId}/permission-groups`
- `POST /api/v1/admin/users/{userId}/permission-groups`
- `GET /api/v1/admin/users/{userId}/effective-permissions`
- `POST /api/v1/admin/users/{userId}/lock`
- `POST /api/v1/admin/users/{userId}/unlock`
- `GET /api/v1/admin/audit-logs`

Admin quiz/code:

- `GET /api/v1/admin/quizzes/statistics/overview`
- `GET /api/v1/admin/quizzes/{quizSetId}/statistics`
- `GET /api/v1/admin/questions/export.csv`
- `GET /api/v1/admin/quizzes/{quizSetId}/export.csv`
- `POST /api/v1/admin/quiz-attempts/{attemptId}/reset`
- `POST /api/v1/admin/quizzes/{quizSetId}/users/{userId}/reset-attempts`
- `GET /api/v1/code/submissions/{submissionId}`
- `GET /api/v1/admin/code/submissions/{submissionId}`

## Test nhanh

1. Client: đăng nhập, mở `/learner/practice-banks`, upload CSV mẫu, start attempt, submit, xem result/history.
2. Client: mở `/forgot-password`, `/reset-password`, `/verify-email`, `/resend-verification`.
3. Client: vào Profile và đổi mật khẩu.
4. Client: submit code trong problem detail, bấm `Xem chi tiết submission` nếu response có `id` hoặc `submissionId`.
5. Admin: vào Dashboard, mở `Access Control`, tạo/sửa nhóm quyền, gán nhóm cho user/role, xem quyền hiệu lực.
6. Admin: vào `Users`, khóa/mở khóa user.
7. Admin: mở `Audit Logs`, lọc và xem detail JSON.
8. Admin: mở `Quiz Analytics`, xem overview/statistics, export CSV, reset attempt.
9. Admin: vào `Code Judge > Submissions`, nhập submissionId để xem detail.

## TODO

- Nếu backend chỉ hỗ trợ add/remove permission group từng item thay vì set theo mảng, cần điều chỉnh save handler để diff và gọi nhiều request.
- Nếu backend bổ sung API list code submissions, có thể mở rộng tab Submissions thành bảng lịch sử thay vì ô nhập submissionId.
- Một số DTO backend có thể đặt tên field khác nhau; UI đã fallback các tên phổ biến nhưng nên chuẩn hóa contract khi API ổn định.

## Encoding

Đã quét và sửa mojibake tiếng Việt trong `client/devlearninghub-client/src/app`, `admin/devlearninghub-admin/src/app`, `src/assets` và `src/styles.css` theo các pattern lỗi chính: `Ã`, `Â`, `Ä`, `Æ`, `â€`, `ðŸ`, `ï¿½`.
