USE DevLearningHubDb;
GO

IF OBJECT_ID('dbo.CodingProblems', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CodingProblems (
        Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        CreatedByUserId BIGINT NOT NULL,
        Title NVARCHAR(255) NOT NULL,
        Slug NVARCHAR(255) NOT NULL,
        Description NVARCHAR(MAX) NOT NULL,
        InputFormat NVARCHAR(1000) NULL,
        OutputFormat NVARCHAR(1000) NULL,
        Constraints NVARCHAR(2000) NULL,
        ExamplesJson NVARCHAR(MAX) NULL,
        Tags NVARCHAR(500) NULL,
        StarterCodeJavaScript NVARCHAR(MAX) NULL,
        StarterCodePython NVARCHAR(MAX) NULL,
        StarterCodeJava NVARCHAR(MAX) NULL,
        StarterCodeCpp NVARCHAR(MAX) NULL,
        Difficulty TINYINT NOT NULL DEFAULT 1,
        Status TINYINT NOT NULL DEFAULT 1,
        TimeLimitMs INT NOT NULL DEFAULT 2000,
        MemoryLimitKb INT NOT NULL DEFAULT 131072,
        TotalSubmissions INT NOT NULL DEFAULT 0,
        AcceptedSubmissions INT NOT NULL DEFAULT 0,
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        UpdatedAt DATETIME2 NULL,
        IsDeleted BIT NOT NULL DEFAULT 0,
        CONSTRAINT FK_CodingProblems_Users FOREIGN KEY (CreatedByUserId) REFERENCES dbo.Users(Id)
    );
    CREATE UNIQUE INDEX UX_CodingProblems_Slug ON dbo.CodingProblems(Slug);
END;
GO

IF OBJECT_ID('dbo.CodingTestCases', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CodingTestCases (
        Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ProblemId BIGINT NOT NULL,
        Input NVARCHAR(MAX) NOT NULL,
        ExpectedOutput NVARCHAR(MAX) NOT NULL,
        Explanation NVARCHAR(1000) NULL,
        IsHidden BIT NOT NULL DEFAULT 0,
        DisplayOrder INT NOT NULL DEFAULT 1,
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_CodingTestCases_CodingProblems FOREIGN KEY (ProblemId) REFERENCES dbo.CodingProblems(Id) ON DELETE CASCADE
    );
END;
GO

IF OBJECT_ID('dbo.CodeSubmissions', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CodeSubmissions (
        Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ProblemId BIGINT NULL,
        UserId BIGINT NOT NULL,
        Language NVARCHAR(50) NOT NULL,
        SourceCode NVARCHAR(MAX) NOT NULL,
        Stdin NVARCHAR(MAX) NULL,
        Output NVARCHAR(MAX) NULL,
        Error NVARCHAR(MAX) NULL,
        Status NVARCHAR(50) NOT NULL DEFAULT 'Queued',
        Verdict NVARCHAR(100) NOT NULL DEFAULT 'Pending',
        ExecutionTimeMs INT NOT NULL DEFAULT 0,
        MemoryUsedKb INT NOT NULL DEFAULT 0,
        PassedTestCases INT NOT NULL DEFAULT 0,
        TotalTestCases INT NOT NULL DEFAULT 0,
        IsAccepted BIT NOT NULL DEFAULT 0,
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_CodeSubmissions_CodingProblems FOREIGN KEY (ProblemId) REFERENCES dbo.CodingProblems(Id),
        CONSTRAINT FK_CodeSubmissions_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id)
    );
END;
GO

IF OBJECT_ID('dbo.CodeSubmissionTestCaseResults', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CodeSubmissionTestCaseResults (
        Id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        SubmissionId BIGINT NOT NULL,
        TestCaseId BIGINT NULL,
        DisplayOrder INT NOT NULL DEFAULT 1,
        Input NVARCHAR(MAX) NOT NULL,
        ExpectedOutput NVARCHAR(MAX) NOT NULL,
        ActualOutput NVARCHAR(MAX) NOT NULL,
        Error NVARCHAR(MAX) NULL,
        Status NVARCHAR(50) NOT NULL DEFAULT 'Pending',
        Passed BIT NOT NULL DEFAULT 0,
        ExecutionTimeMs INT NOT NULL DEFAULT 0,
        CONSTRAINT FK_CodeSubmissionTestCaseResults_CodeSubmissions FOREIGN KEY (SubmissionId) REFERENCES dbo.CodeSubmissions(Id) ON DELETE CASCADE,
        CONSTRAINT FK_CodeSubmissionTestCaseResults_CodingTestCases FOREIGN KEY (TestCaseId) REFERENCES dbo.CodingTestCases(Id)
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'code.run')
    INSERT INTO Permissions(Code, Name, Module, Description, CreatedAt) VALUES ('code.run', N'Chạy code playground', 'Code', N'Cho phép chạy code trong playground', SYSUTCDATETIME());
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'code.submit')
    INSERT INTO Permissions(Code, Name, Module, Description, CreatedAt) VALUES ('code.submit', N'Nộp bài lập trình', 'Code', N'Cho phép submit bài vào judge', SYSUTCDATETIME());
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'code.manage')
    INSERT INTO Permissions(Code, Name, Module, Description, CreatedAt) VALUES ('code.manage', N'Quản lý bài lập trình', 'Code', N'Cho phép Admin quản lý problem/testcase', SYSUTCDATETIME());
GO

DECLARE @AdminRoleId BIGINT = (SELECT TOP 1 Id FROM Roles WHERE NormalizedName = 'ADMIN');
IF @AdminRoleId IS NOT NULL
BEGIN
    INSERT INTO RolePermissions(RoleId, PermissionId)
    SELECT @AdminRoleId, p.Id
    FROM Permissions p
    WHERE p.Code IN ('code.run','code.submit','code.manage')
      AND NOT EXISTS (SELECT 1 FROM RolePermissions rp WHERE rp.RoleId = @AdminRoleId AND rp.PermissionId = p.Id);
END;
GO

DECLARE @AdminUserId BIGINT = (SELECT TOP 1 Id FROM Users WHERE Email = 'admin@example.com' ORDER BY Id);
IF @AdminUserId IS NULL SELECT TOP 1 @AdminUserId = Id FROM Users ORDER BY Id;

IF @AdminUserId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM CodingProblems WHERE Slug = 'sum-two-numbers')
BEGIN
    INSERT INTO CodingProblems
    (CreatedByUserId, Title, Slug, Description, InputFormat, OutputFormat, Constraints, Tags, Difficulty, Status, TimeLimitMs, MemoryLimitKb,
     StarterCodeJavaScript, StarterCodePython, StarterCodeJava, StarterCodeCpp, CreatedAt)
    VALUES
    (@AdminUserId, N'Sum Two Numbers', 'sum-two-numbers',
     N'Cho một dòng gồm hai số nguyên a và b. Hãy in ra tổng của hai số đó. Bài này dùng để kiểm tra luồng Playground, Run Code và Submit Judge.',
     N'Một dòng gồm hai số nguyên a và b, cách nhau bởi khoảng trắng.',
     N'In ra một số nguyên là tổng a + b.',
     N'-10^9 <= a,b <= 10^9', N'math, beginner, io', 1, 1, 2000, 131072,
     N'const fs = require(''fs'');
const input = fs.readFileSync(0, ''utf8'').trim().split(/\s+/).map(Number);
const a = input[0];
const b = input[1];
console.log(a + b);',
     N'import sys
nums = list(map(int, sys.stdin.read().strip().split()))
print(nums[0] + nums[1])',
     N'import java.io.*;
import java.util.*;

public class Main {
    public static void main(String[] args) throws Exception {
        Scanner sc = new Scanner(System.in);
        long a = sc.nextLong();
        long b = sc.nextLong();
        System.out.println(a + b);
    }
}',
     N'#include <bits/stdc++.h>
using namespace std;

int main(){
    long long a,b;
    cin >> a >> b;
    cout << a + b << endl;
    return 0;
}', SYSUTCDATETIME());

    DECLARE @P1 BIGINT = SCOPE_IDENTITY();
    INSERT INTO CodingTestCases(ProblemId, Input, ExpectedOutput, Explanation, IsHidden, DisplayOrder)
    VALUES (@P1, N'2 7', N'9', N'2 + 7 = 9', 0, 1),
           (@P1, N'-5 12', N'7', N'-5 + 12 = 7', 0, 2),
           (@P1, N'1000000000 -1', N'999999999', N'Hidden large number case', 1, 3);
END;
GO

DECLARE @AdminUserId2 BIGINT = (SELECT TOP 1 Id FROM Users WHERE Email = 'admin@example.com' ORDER BY Id);
IF @AdminUserId2 IS NULL SELECT TOP 1 @AdminUserId2 = Id FROM Users ORDER BY Id;

IF @AdminUserId2 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM CodingProblems WHERE Slug = 'reverse-string')
BEGIN
    INSERT INTO CodingProblems
    (CreatedByUserId, Title, Slug, Description, InputFormat, OutputFormat, Constraints, Tags, Difficulty, Status, TimeLimitMs, MemoryLimitKb,
     StarterCodeJavaScript, StarterCodePython, StarterCodeJava, StarterCodeCpp, CreatedAt)
    VALUES
    (@AdminUserId2, N'Reverse String', 'reverse-string',
     N'Cho một chuỗi ký tự. Hãy in ra chuỗi đảo ngược. Bài này kiểm tra thao tác xử lý chuỗi cơ bản.',
     N'Một dòng chứa chuỗi s.', N'In ra chuỗi đảo ngược của s.', N'1 <= length(s) <= 1000', N'string, beginner', 1, 1, 2000, 131072,
     N'const fs = require(''fs'');
const s = fs.readFileSync(0, ''utf8'').trim();
console.log(s.split('''').reverse().join(''''));',
     N'import sys
s = sys.stdin.read().strip()
print(s[::-1])',
     N'import java.io.*;
public class Main {
    public static void main(String[] args) throws Exception {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String s = br.readLine();
        System.out.println(new StringBuilder(s == null ? "" : s).reverse().toString());
    }
}',
     N'#include <bits/stdc++.h>
using namespace std;
int main(){ string s; getline(cin, s); reverse(s.begin(), s.end()); cout << s << endl; return 0; }', SYSUTCDATETIME());

    DECLARE @P2 BIGINT = SCOPE_IDENTITY();
    INSERT INTO CodingTestCases(ProblemId, Input, ExpectedOutput, Explanation, IsHidden, DisplayOrder)
    VALUES (@P2, N'hello', N'olleh', N'Đảo ngược hello', 0, 1),
           (@P2, N'DevLearning', N'gninraeLveD', N'Đảo ngược DevLearning', 0, 2),
           (@P2, N'abc123', N'321cba', N'Hidden mixed case', 1, 3);
END;
GO

SELECT TOP 20 Id, Title, Slug, Difficulty, Status, TotalSubmissions, AcceptedSubmissions
FROM CodingProblems
WHERE IsDeleted = 0
ORDER BY Id;
