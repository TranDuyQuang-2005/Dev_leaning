# DevLearningHub Backend Update

## Auth/logout

- `POST /api/v1/auth/logout` is still protected by `[Authorize]`.
- The controller now passes `CurrentUserId` into `AuthService.Logout`.
- Logout accepts `refreshToken`, trims it, hashes it, and revokes only the row matching `UserId + TokenHash`.
- Missing/empty refresh token still returns success so the frontend can clear local state.
- A revoked refresh token cannot be reused by `POST /api/v1/auth/refresh-token` because refresh rejects tokens with `RevokedAt != null`.

## Refresh token rotation

- Refresh token lookup uses the user id from the expired access token plus the refresh token hash.
- Invalid, revoked, or expired refresh tokens fail.
- Successful refresh revokes the old refresh token, stores `ReplacedByTokenHash`, creates a new refresh token row, and returns a new access token.
- Login, refresh, and me responses use effective permissions from direct user permissions, role permissions, role permission groups, and user permission groups.

## Backend features kept

- Advanced auth: change password, forgot password, reset password, resend email verification, verify email.
- Personal practice: upload/list/detail/delete banks, start/submit/list/detail attempts.
- Permission groups: CRUD, assign to role/user, effective permissions.
- Admin security/audit: lock/unlock user and audit logs.
- Admin quiz: statistics, overview, CSV export, reset attempts.
- Code judge: user/admin submission detail; hidden test cases remain hidden from normal users.
- Forum APIs remain in place for posts, comments/replies, votes, bookmarks, reports, accepted answer, and moderation.

## Forum compatibility

- Post/comment DTOs now include `LikeCount`, `DislikeCount`, `VoteScore`, `MyVote`, `Replies`, `ReplyCount`, `CommentCount`, and `IsAcceptedAnswer`.
- Vote logic toggles same vote off, switches opposite votes, and does not intentionally create duplicate votes for the same user/post or user/comment.
- EF model now has unique indexes for post/comment vote ownership.
- Reply mapping preserves `ParentCommentId`; the learner forum detail page normalizes flat or nested `replies`/`threadReplies` into `threadReplies` with `replyDepth`.
- Accepted answer now supports both comments and replies; only the chosen item is marked accepted and the rest are cleared.

## Personal practice security

- Bank and attempt queries are scoped by the authenticated `UserId`.
- A different user accessing another user's bank/attempt receives not found.
- Start attempt does not expose correct answers.
- Submit result exposes correct answer and explanation.
- Upload response does not expose `FileStorageKey` or real stored path.
- CSV/JSON import validates required question text, single choice type, A/B/C/D options, correct answer, difficulty, tags, file size, and extension.

## Database

- Do not drop the existing database.
- Do not run a baseline migration against an existing schema.
- Incremental migration: `api/DevLearningHub.Api/Migrations/20260709070000_ExistingDatabase_AddPermissionGroupsAndPersonalPractice.cs`.
- Safe SQL script added: `database/update_backend_permission_personal_practice.sql`.
- The SQL script uses `IF OBJECT_ID(...) IS NULL` before table creation and checks FK/index existence before adding them.
- Seeder is idempotent and skips permission-group seeding until permission-group tables exist.

Apply one of these:

```powershell
dotnet ef database update --project api/DevLearningHub.Api/DevLearningHub.Api.csproj --startup-project api/DevLearningHub.Api/DevLearningHub.Api.csproj
```

or run:

```sql
database/update_backend_permission_personal_practice.sql
```

## Frontend compatibility

- Client and admin logout now call `POST /api/v1/auth/logout` with `refreshToken`.
- Logout clears only `accessToken`, `refreshToken`, and `currentUser`.
- Interceptors clear only auth keys on `401`.
- API base URL remains `http://localhost:5000`.

## Verification

```powershell
dotnet restore api/DevLearningHub.Api/DevLearningHub.Api.csproj
dotnet build api/DevLearningHub.Api/DevLearningHub.Api.csproj --no-restore
```

Result: build succeeded with `0 Warning(s), 0 Error(s)`.

```powershell
dotnet ef migrations list --project api/DevLearningHub.Api/DevLearningHub.Api.csproj --no-build
```

Result: migration `20260709070000_ExistingDatabase_AddPermissionGroupsAndPersonalPractice` is listed. EF cannot determine applied/pending status because local DB access fails.

```powershell
dotnet run --project api/DevLearningHub.Api/DevLearningHub.Api.csproj --no-build
```

Result: app did not start because the local SQL Server connection failed with: `The instance of SQL Server you attempted to connect to requires encryption but this machine does not support it.`

For local dev, fix the SQL Server/TLS configuration or use a development connection string compatible with the installed SQL Server. The current `appsettings.json` already includes `TrustServerCertificate=True`.

## Quick test flow

1. Login user A.
2. Logout user A with refreshToken.
3. Call refresh-token with the old refreshToken; it must fail.
4. Login user A again.
5. Upload personal practice CSV.
6. Start an attempt.
7. Submit the attempt.
8. Login user B.
9. User B accesses user A bank/attempt; it must return 404.
10. Login admin.
11. Create a permission group.
12. Assign the group to a role/user.
13. View effective permissions.
14. Lock a user and confirm login fails.
15. Unlock the user.
16. Test forum vote/comment/reply/accepted/report/delete.
17. Test quiz statistics/export/reset.
18. Test code submission detail.

## TODO

- Configure real SMTP for password reset and email verification instead of logging tokens.
- Run database update and E2E flows against a working local SQL Server.

## Code Judge compatibility update

- Safe DB script added: `database/update_backend_code_judge_schema.sql`.
- Run this script before testing Code Playground/Judge on an existing database.
- Do not run the destructive baseline SQL against an existing schema.
- The script adds missing `CodeSubmissions` columns, relaxes legacy `CodingProblemId`/`ProgrammingLanguageId` to nullable, syncs `ProblemId` and `CreatedAt`, creates `CodeSubmissionTestCaseResults` when missing, seeds `ProgrammingLanguages`, and uses `ON DELETE NO ACTION` for new compatibility FKs.

## Code runner language support

- `GET /api/v1/code/languages` now returns centralized runtime metadata and starter templates.
- Active languages: `python`, `javascript`, `typescript`, `java`, `c`, `cpp`, `csharp`, `go`.
- Required runtimes: Python 3, Node.js, TypeScript compiler, JDK, GCC/G++, .NET SDK, Go.
- Local runner uses per-run OS temp directories, hard timeouts, process-tree kill on timeout, output truncation, and readable missing-runtime errors.
- Production TODO: move code execution to Docker/Judge0/Kubernetes sandbox.

## Progress and leaderboard APIs

- Added `GET /api/v1/me/progress/overview`.
- Added `GET /api/v1/me/progress/topics`.
- Added `GET /api/v1/me/progress/roadmap`.
- Added `GET /api/v1/leaderboard`.

## Forum file proxy reminder

- Forum attachment responses continue to expose `/api/v1/files/{id}/view`.
- Frontend must prepend backend base URL `http://localhost:5000`.
- Do not point the frontend directly at MinIO port `9000`, do not require public buckets, and do not expose MinIO keys.

## Notification backend update

- Safe DB script added: `database/update_backend_notifications.sql`.
- Run the script in SSMS against the existing DevLearningHub database. It is idempotent and does not drop tables.
- The script creates `Notifications`, separate indexes for `UserId`, `IsRead`, `CreatedAt`, the composite read-list index, and the `Users` FK with `ON DELETE NO ACTION`.
- Notification API endpoints:
  - `GET /api/v1/notifications`
  - `GET /api/v1/notifications/unread-count`
  - `POST /api/v1/notifications/{id}/read`
  - `POST /api/v1/notifications/read-all`
  - `DELETE /api/v1/notifications/{id}`
- All notification endpoints require `[Authorize]` and scope reads/writes/deletes to the current JWT user.
- Events creating notifications:
  - `quiz.passed` when a learner submits and passes a quiz.
  - `code.accepted` when a coding problem submission is accepted.
  - `forum.reply` when another user replies/comments on a learner's post.
  - `forum.accepted_answer` when a learner's comment/reply is marked as accepted.
  - `account.locked` and `account.unlocked` when admin locks/unlocks a user.
- Event metadata includes an `eventKey`; the service checks tracked and existing notifications to avoid duplicate notifications for the same event.

Run notification DB update:

```sql
database/update_backend_notifications.sql
```

## Code runner provider update

- `ICodeExecutionProvider` added with `RunAsync` and `ExecuteTestCasesAsync`.
- `LocalCodeExecutionProvider` keeps the current local process runner behavior: temp folder, timeout, process cleanup, missing-runtime messages, and output truncation.
- `Judge0ExecutionProvider` provides a basic Judge0 HTTP integration and returns a clear error if Judge0 is not reachable:
  `Judge0 service is not available. Please start Judge0 or switch CodeRunner:Provider to Local.`
- Existing frontend APIs remain unchanged:
  - `POST /api/v1/code/run`
  - `POST /api/v1/code/problems/{id}/submit`
  - `GET /api/v1/code/languages`
- Configure provider in `api/DevLearningHub.Api/appsettings.json`:

```json
"CodeRunner": {
  "Provider": "Local",
  "DefaultTimeLimitMs": 5000,
  "MaxOutputBytes": 262144,
  "Judge0": {
    "BaseUrl": "http://localhost:2358",
    "TimeoutSeconds": 20
  }
}
```

## Notification backend

- Added `Notifications` table support through safe script `database/update_backend_notifications.sql`.
- Run the script on an existing database before demoing notification features. It is idempotent and does not drop existing data.
- User endpoints:
  - `GET /api/v1/notifications`
  - `GET /api/v1/notifications/unread-count`
  - `POST /api/v1/notifications/{id}/read`
  - `POST /api/v1/notifications/read-all`
  - `DELETE /api/v1/notifications/{id}`
- All notification endpoints require `[Authorize]` and are scoped to the authenticated user.
- Notification events currently created:
  - `quiz.passed` when a submitted quiz reaches the passing score.
  - `code.accepted` when a code submission is Accepted.
  - `forum.reply` when another user comments/replies to the user's forum post.
  - `forum.accepted_answer` when a user's comment/reply is marked accepted.
  - `account.locked` and `account.unlocked` when admin locks/unlocks a user.

## Code runner provider abstraction

- Code execution now goes through `ICodeExecutionProvider`.
- `LocalCodeExecutionProvider` keeps the current local runner behavior: temp folder per run, timeout, cleanup, and output truncation.
- `Judge0ExecutionProvider` is available as a configurable provider and returns a clear error if Judge0 is not reachable.
- Switch to Judge0 by setting `CodeRunner:Provider` to `Judge0`; roll back by setting it back to `Local`.
- Config:

```json
"CodeRunner": {
  "Provider": "Local",
  "DefaultTimeLimitMs": 5000,
  "MaxOutputBytes": 262144,
  "Judge0": {
    "BaseUrl": "http://localhost:2358",
    "TimeoutSeconds": 20
  }
}
```

- Frontend APIs stay unchanged: `POST /api/v1/code/run`, `POST /api/v1/code/problems/{id}/submit`, and `GET /api/v1/code/languages`.

## Forum nested comments

- `forum-post.component.ts` rebuilds comment trees with `normalizeComments()`.
- It supports `id`/`commentId`, `parentCommentId`/`parentId`/`parentComment.id`, `replies`, `threadReplies`, and `acceptedCommentId`.
- Replies to replies send the exact replied comment id as `parentCommentId`.
- The UI renders root answers plus flattened `threadReplies` with `replyDepth`, expand/collapse controls, voting, reporting, delete, and accepted answer states.
