# DevLearningHub Backend Update

## Run

```powershell
dotnet restore api/DevLearningHub.Api/DevLearningHub.Api.csproj
dotnet build api/DevLearningHub.Api/DevLearningHub.Api.csproj
dotnet run --project api/DevLearningHub.Api/DevLearningHub.Api.csproj
```

Swagger: `http://localhost:<port>/swagger`

## Migration

DbContext has been updated for the new tables and indexes. The active migration is `ExistingDatabase_AddPermissionGroupsAndPersonalPractice` under `api/DevLearningHub.Api/Migrations`. It is an incremental migration for the existing database and only creates the missing permission-group and personal-practice tables. Apply it with:

```powershell
dotnet ef database update --project api/DevLearningHub.Api/DevLearningHub.Api.csproj --startup-project api/DevLearningHub.Api/DevLearningHub.Api.csproj
```

## New Endpoints

Auth:
- `PUT /api/v1/auth/change-password`
- `POST /api/v1/auth/forgot-password`
- `POST /api/v1/auth/reset-password`
- `POST /api/v1/auth/resend-email-verification`
- `POST /api/v1/auth/verify-email`

Personal practice:
- `POST /api/v1/me/practice-banks/upload`
- `GET /api/v1/me/practice-banks`
- `GET /api/v1/me/practice-banks/{bankId}`
- `DELETE /api/v1/me/practice-banks/{bankId}`
- `POST /api/v1/me/practice-banks/{bankId}/attempts`
- `GET /api/v1/me/practice-attempts`
- `GET /api/v1/me/practice-attempts/{attemptId}`
- `POST /api/v1/me/practice-attempts/{attemptId}/submit`

Admin permission groups:
- `POST /api/v1/admin/permission-groups`
- `GET /api/v1/admin/permission-groups`
- `GET /api/v1/admin/permission-groups/{id}`
- `PUT /api/v1/admin/permission-groups/{id}`
- `DELETE /api/v1/admin/permission-groups/{id}`
- `POST /api/v1/admin/permission-groups/{id}/permissions`
- `DELETE /api/v1/admin/permission-groups/{id}/permissions/{permissionId}`
- `POST /api/v1/admin/roles/{roleId}/permission-groups`
- `DELETE /api/v1/admin/roles/{roleId}/permission-groups/{permissionGroupId}`
- `POST /api/v1/admin/users/{userId}/permission-groups`
- `DELETE /api/v1/admin/users/{userId}/permission-groups/{permissionGroupId}`
- `GET /api/v1/admin/users/{userId}/effective-permissions`

Admin/security utilities:
- `POST /api/v1/admin/users/{userId}/lock`
- `POST /api/v1/admin/users/{userId}/unlock`
- `GET /api/v1/admin/audit-logs`
- `GET /api/v1/admin/quizzes/{quizSetId}/statistics`
- `GET /api/v1/admin/quizzes/statistics/overview`
- `GET /api/v1/admin/questions/export.csv`
- `GET /api/v1/admin/quizzes/{quizSetId}/export.csv`
- `POST /api/v1/admin/quiz-attempts/{attemptId}/reset`
- `POST /api/v1/admin/quizzes/{quizSetId}/users/{userId}/reset-attempts`
- `GET /api/v1/code/submissions/{submissionId}`
- `GET /api/v1/admin/code/submissions/{submissionId}`

## Personal Practice CSV

```csv
question_text,question_type,option_a,option_b,option_c,option_d,correct_answer,explanation,difficulty,tags
"HTML stands for what?","single_choice","Hyper Text Markup Language","High Text Machine Language","Home Tool Markup Language","Hyperlink Text Manage Language","A","HTML is a markup language","easy","html,web"
```

Rules: CSV and JSON are accepted; CSV is the primary supported format. Files are limited to 5MB and 1000 rows. Practice bank content is always filtered by the authenticated owner user id.

## Quick Swagger/Postman Flow

1. Login user A.
2. User A uploads a CSV to `POST /api/v1/me/practice-banks/upload`.
3. User A calls `GET /api/v1/me/practice-banks`.
4. User A starts an attempt with `POST /api/v1/me/practice-banks/{bankId}/attempts`.
5. User A submits with `POST /api/v1/me/practice-attempts/{attemptId}/submit`.
6. Login user B.
7. User B calls user A's `bankId` and should receive not found.
8. Login Admin.
9. Admin creates a permission group.
10. Admin assigns the group to a role or user.
11. Admin verifies `GET /api/v1/admin/users/{userId}/effective-permissions`.

## TODO

- Integrate SMTP for password reset and email verification; tokens are logged via `ILogger` for development.
- Add a dedicated test project when package restore/migration tooling is available.
- Generate and commit the EF migration in an environment where `dotnet ef` can access NuGet metadata.
- Frontend should add screens for personal practice banks, permission groups, audit logs, and account lock/unlock.
