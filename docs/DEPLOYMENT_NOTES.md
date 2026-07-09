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
