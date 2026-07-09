# MVP Test Checklist

## User

- Register, login, refresh token, logout, and confirm old refresh token cannot be reused.
- Run Python and JavaScript in Code Playground.
- Run TypeScript if Node.js and TypeScript are installed.
- Submit a Python or JavaScript accepted solution.
- Open submission detail and confirm hidden test case input/expected output is not exposed.
- Upload a personal practice CSV, start an attempt, submit it, and review results.
- Take a quiz, submit, review answers and explanations, and open quiz history.
- Create a forum post with an image, open detail, comment, reply, vote, bookmark, report, and mark accepted answer if owner.
- Confirm forum image requests go to `http://localhost:5000/api/v1/files/{id}/view`, not MinIO port `9000`.
- Open dashboard, roadmap, leaderboard, notifications, and profile pages.

## Moderator

- Open moderation forum views.
- Hide and restore posts/comments.
- Resolve or reject reports.
- Confirm moderator cannot access admin-only security or permission-group actions unless granted.

## Admin

- Manage users, lock/unlock a user, and verify locked login fails.
- Manage permission groups and inspect effective permissions.
- Open audit logs.
- Manage quiz questions/categories/sets/import.
- Open quiz analytics, export CSV, and reset attempts.
- Manage code problems/test cases/starter code.
- Open Programming Languages tab in Code Management.
- Open admin submission detail and confirm hidden test cases are visible only to admin/code management.

## Security

- Invalid POST/PUT payloads return consistent validation errors with `traceId`.
- Rate limited endpoints return HTTP `429`.
- Normal users cannot access admin APIs.
- Users cannot access another user's personal practice bank or attempt.
- Users cannot access another user's code submission detail.
- Forum content is rendered through Angular interpolation; do not use unsanitized `innerHTML` for user content.
