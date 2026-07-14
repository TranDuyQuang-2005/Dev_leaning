# Deployment Notes

## Code Runner

- The demo build uses a local process runner.
- Each run uses an isolated temp folder outside the source tree and cleans it in `finally`.
- Output is truncated before returning to the client.
- Timeouts kill the process tree.
- Demo currently uses the hardened Local runner.
- Production should use Judge0, Docker, Kubernetes jobs, or another hardened sandbox. Do not expose this local runner to untrusted public traffic.
- To switch to Judge0, start Judge0 at `http://localhost:2358` and set `CodeRunner:Provider` to `Judge0`.
- To roll back if Judge0 is not ready, set `CodeRunner:Provider` back to `Local`.
- If `Judge0` is selected but unavailable, code APIs return: `Judge0 service is not available. Please start Judge0 or switch CodeRunner:Provider to Local.`

## Database

- For an existing database, run `database/update_backend_code_judge_schema.sql` before testing Code Playground/Judge.
- For notification demo, run `database/update_backend_notifications.sql`.
- The notification script is safe to re-run and creates the `Notifications` table, indexes, and `Users` FK with `ON DELETE NO ACTION`.
- Do not run the destructive baseline SQL against an existing schema.
- Do not drop tables to fix judge schema drift.

## Notifications

- Notification endpoints live under `/api/v1/notifications` and require JWT auth.
- Users can only list, mark read, mark all read, or delete their own notifications.
- Event coverage currently includes quiz passed, code accepted, forum reply, accepted answer, and admin lock/unlock.
- Realtime notifications use SignalR hub `/hubs/notifications` with JWT auth. Browser clients pass the JWT through the SignalR `access_token` query string, and the backend only joins the authenticated user to group `user:{userId}`.
- The REST notification APIs remain the fallback and initial-load path.

## Cấu hình gửi email thật

- Email verification, resend verification, and forgot password use real SMTP. The backend does not log verification/reset links as a delivery fallback.
- `Email:RequireRealSmtp=true` means missing `Email:FromEmail`, `Email:Smtp:Host`, `Email:Smtp:Username`, or `Email:Smtp:Password` returns: `SMTP is not configured. Please configure Email:Smtp settings.`
- Do not commit SMTP passwords. Use user-secrets, environment variables, or a secret manager.

Gmail SMTP:

- Bật 2-Step Verification.
- Tạo App Password.
- Dùng App Password làm `Email:Smtp:Password`.
- Không dùng mật khẩu Gmail thường.
- Host `smtp.gmail.com`, port `587`, SSL enabled.

SendGrid SMTP:

- Host `smtp.sendgrid.net`.
- Username `apikey`.
- Password là SendGrid API key.
- Port `587`, SSL enabled.

Local development with user-secrets:

```bash
dotnet user-secrets init --project api/DevLearningHub.Api/DevLearningHub.Api.csproj
dotnet user-secrets set "Email:Smtp:Host" "smtp.gmail.com" --project api/DevLearningHub.Api/DevLearningHub.Api.csproj
dotnet user-secrets set "Email:Smtp:Port" "587" --project api/DevLearningHub.Api/DevLearningHub.Api.csproj
dotnet user-secrets set "Email:Smtp:UseSsl" "true" --project api/DevLearningHub.Api/DevLearningHub.Api.csproj
dotnet user-secrets set "Email:Smtp:Username" "your-demo-email@gmail.com" --project api/DevLearningHub.Api/DevLearningHub.Api.csproj
dotnet user-secrets set "Email:Smtp:Password" "YOUR_APP_PASSWORD" --project api/DevLearningHub.Api/DevLearningHub.Api.csproj
dotnet user-secrets set "Email:FromEmail" "your-demo-email@gmail.com" --project api/DevLearningHub.Api/DevLearningHub.Api.csproj
```

## Forum Comments

- Forum post detail normalizes backend comments into root answers plus `threadReplies`.
- Flat responses must include `ParentCommentId`; nested responses can use `replies` or `threadReplies`.
- Forum files and images must still be served through `GET /api/v1/files/{id}/view`; do not expose MinIO URLs to the browser.

## Object Storage

- Backend API should run on `http://localhost:5000`.
- MinIO should run on `http://localhost:9000` with console on `http://localhost:9001`.
- Frontend must load forum images/files through the backend proxy:
  - View: `GET /api/v1/files/{id}/view`
  - Download: `GET /api/v1/files/{id}/download`
- Do not expose MinIO access keys, object keys, or public bucket URLs to the frontend.

## Secrets

- Keep JWT secrets, MinIO credentials, SMTP credentials, and production connection strings out of git.
- Use environment variables or a secret manager in production.
