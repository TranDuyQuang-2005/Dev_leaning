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
- Reply mapping flattens nested replies to the top-level comment reply list so a one-level frontend does not break.
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
