USE DevLearningHubDb;
GO

DECLARE @UserId BIGINT;
SELECT TOP 1 @UserId = Id FROM Users ORDER BY Id;
IF @UserId IS NULL
BEGIN
    RAISERROR(N'Chưa có user. Hãy chạy API để seed admin hoặc đăng ký user trước.', 16, 1);
    RETURN;
END;

IF NOT EXISTS (SELECT 1 FROM Tags WHERE Slug = 'angular') INSERT INTO Tags(Name, Slug, Description, CreatedAt) VALUES (N'Angular', N'angular', N'Thảo luận Angular', SYSUTCDATETIME());
IF NOT EXISTS (SELECT 1 FROM Tags WHERE Slug = 'sql') INSERT INTO Tags(Name, Slug, Description, CreatedAt) VALUES (N'SQL', N'sql', N'Thảo luận SQL Server', SYSUTCDATETIME());
IF NOT EXISTS (SELECT 1 FROM Tags WHERE Slug = 'api') INSERT INTO Tags(Name, Slug, Description, CreatedAt) VALUES (N'API', N'api', N'Thảo luận API backend', SYSUTCDATETIME());

IF NOT EXISTS (SELECT 1 FROM Posts WHERE Slug = 'cach-goi-api-trong-angular')
BEGIN
    INSERT INTO Posts(AuthorId, Title, Slug, Content, ViewCount, VoteScore, AnswerCount, Status, LastActivityAt, CreatedAt, IsDeleted)
    VALUES(@UserId, N'Cách gọi API trong Angular đúng chuẩn?', N'cach-goi-api-trong-angular', N'Mình đang xây dựng Angular client và muốn gọi API .NET backend bằng HttpClient. Nên tách ApiService/AuthService như thế nào để dễ bảo trì?', 0, 0, 0, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), 0);
    DECLARE @PostId BIGINT = SCOPE_IDENTITY();
    INSERT INTO PostTags(PostId, TagId) SELECT @PostId, Id FROM Tags WHERE Slug IN ('angular','api');
END;

IF NOT EXISTS (SELECT 1 FROM Posts WHERE Slug = 'toi-uu-truy-van-sql-cho-quiz')
BEGIN
    INSERT INTO Posts(AuthorId, Title, Slug, Content, ViewCount, VoteScore, AnswerCount, Status, LastActivityAt, CreatedAt, IsDeleted)
    VALUES(@UserId, N'Tối ưu truy vấn SQL cho phân hệ quiz?', N'toi-uu-truy-van-sql-cho-quiz', N'Khi lấy QuizSet, Questions và Options thì nên join bảng hay include bằng EF Core? Mình muốn tối ưu tốc độ cho trang Learning.', 0, 0, 0, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), 0);
    DECLARE @PostId2 BIGINT = SCOPE_IDENTITY();
    INSERT INTO PostTags(PostId, TagId) SELECT @PostId2, Id FROM Tags WHERE Slug IN ('sql','api');
END;
GO
