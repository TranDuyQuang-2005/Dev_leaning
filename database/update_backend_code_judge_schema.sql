/*
    Safe Code Judge schema compatibility update for an existing DevLearningHubDb.

    Run this against the existing database before testing Code Playground/Judge.
    Do not run the destructive baseline script on a database that already has data.
*/

SET XACT_ABORT ON;
GO

BEGIN TRANSACTION;
GO

/* ---------- CodingProblems compatibility columns ---------- */

IF OBJECT_ID(N'dbo.CodingProblems', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.CodingProblems (
        Id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CodingProblems PRIMARY KEY,
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
        StarterCodeTypeScript NVARCHAR(MAX) NULL,
        StarterCodeJava NVARCHAR(MAX) NULL,
        StarterCodeC NVARCHAR(MAX) NULL,
        StarterCodeCpp NVARCHAR(MAX) NULL,
        StarterCodeCsharp NVARCHAR(MAX) NULL,
        StarterCodeGo NVARCHAR(MAX) NULL,
        Difficulty TINYINT NOT NULL CONSTRAINT DF_CodingProblems_Difficulty DEFAULT 1,
        Status TINYINT NOT NULL CONSTRAINT DF_CodingProblems_Status DEFAULT 1,
        TimeLimitMs INT NOT NULL CONSTRAINT DF_CodingProblems_TimeLimitMs DEFAULT 2000,
        MemoryLimitKb INT NOT NULL CONSTRAINT DF_CodingProblems_MemoryLimitKb DEFAULT 131072,
        TotalSubmissions INT NOT NULL CONSTRAINT DF_CodingProblems_TotalSubmissions DEFAULT 0,
        AcceptedSubmissions INT NOT NULL CONSTRAINT DF_CodingProblems_AcceptedSubmissions DEFAULT 0,
        CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_CodingProblems_CreatedAt DEFAULT SYSUTCDATETIME(),
        UpdatedAt DATETIME2 NULL,
        IsDeleted BIT NOT NULL CONSTRAINT DF_CodingProblems_IsDeleted DEFAULT 0
    );
END;
GO

IF COL_LENGTH('dbo.CodingProblems', 'InputFormat') IS NULL ALTER TABLE dbo.CodingProblems ADD InputFormat NVARCHAR(1000) NULL;
IF COL_LENGTH('dbo.CodingProblems', 'OutputFormat') IS NULL ALTER TABLE dbo.CodingProblems ADD OutputFormat NVARCHAR(1000) NULL;
IF COL_LENGTH('dbo.CodingProblems', 'ExamplesJson') IS NULL ALTER TABLE dbo.CodingProblems ADD ExamplesJson NVARCHAR(MAX) NULL;
IF COL_LENGTH('dbo.CodingProblems', 'Tags') IS NULL ALTER TABLE dbo.CodingProblems ADD Tags NVARCHAR(500) NULL;
IF COL_LENGTH('dbo.CodingProblems', 'StarterCodeJavaScript') IS NULL ALTER TABLE dbo.CodingProblems ADD StarterCodeJavaScript NVARCHAR(MAX) NULL;
IF COL_LENGTH('dbo.CodingProblems', 'StarterCodePython') IS NULL ALTER TABLE dbo.CodingProblems ADD StarterCodePython NVARCHAR(MAX) NULL;
IF COL_LENGTH('dbo.CodingProblems', 'StarterCodeTypeScript') IS NULL ALTER TABLE dbo.CodingProblems ADD StarterCodeTypeScript NVARCHAR(MAX) NULL;
IF COL_LENGTH('dbo.CodingProblems', 'StarterCodeJava') IS NULL ALTER TABLE dbo.CodingProblems ADD StarterCodeJava NVARCHAR(MAX) NULL;
IF COL_LENGTH('dbo.CodingProblems', 'StarterCodeC') IS NULL ALTER TABLE dbo.CodingProblems ADD StarterCodeC NVARCHAR(MAX) NULL;
IF COL_LENGTH('dbo.CodingProblems', 'StarterCodeCpp') IS NULL ALTER TABLE dbo.CodingProblems ADD StarterCodeCpp NVARCHAR(MAX) NULL;
IF COL_LENGTH('dbo.CodingProblems', 'StarterCodeCsharp') IS NULL ALTER TABLE dbo.CodingProblems ADD StarterCodeCsharp NVARCHAR(MAX) NULL;
IF COL_LENGTH('dbo.CodingProblems', 'StarterCodeGo') IS NULL ALTER TABLE dbo.CodingProblems ADD StarterCodeGo NVARCHAR(MAX) NULL;
IF COL_LENGTH('dbo.CodingProblems', 'MemoryLimitKb') IS NULL ALTER TABLE dbo.CodingProblems ADD MemoryLimitKb INT NULL;

IF COL_LENGTH('dbo.CodingProblems', 'InputDescription') IS NOT NULL
    EXEC(N'UPDATE dbo.CodingProblems SET InputFormat = COALESCE(InputFormat, CONVERT(NVARCHAR(1000), InputDescription)) WHERE InputFormat IS NULL;');
IF COL_LENGTH('dbo.CodingProblems', 'OutputDescription') IS NOT NULL
    EXEC(N'UPDATE dbo.CodingProblems SET OutputFormat = COALESCE(OutputFormat, CONVERT(NVARCHAR(1000), OutputDescription)) WHERE OutputFormat IS NULL;');
IF COL_LENGTH('dbo.CodingProblems', 'MemoryLimitMb') IS NOT NULL
    EXEC(N'UPDATE dbo.CodingProblems SET MemoryLimitKb = COALESCE(MemoryLimitKb, MemoryLimitMb * 1024) WHERE MemoryLimitKb IS NULL;');
UPDATE dbo.CodingProblems SET MemoryLimitKb = COALESCE(MemoryLimitKb, 131072);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_CodingProblems_Slug' AND object_id = OBJECT_ID(N'dbo.CodingProblems'))
    CREATE UNIQUE INDEX UX_CodingProblems_Slug ON dbo.CodingProblems(Slug);
GO

/* ---------- CodingTestCases bridge from legacy ProblemTestCases ---------- */

IF OBJECT_ID(N'dbo.CodingTestCases', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.CodingTestCases (
        Id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CodingTestCases PRIMARY KEY,
        ProblemId BIGINT NOT NULL,
        Input NVARCHAR(MAX) NOT NULL CONSTRAINT DF_CodingTestCases_Input DEFAULT N'',
        ExpectedOutput NVARCHAR(MAX) NOT NULL CONSTRAINT DF_CodingTestCases_ExpectedOutput DEFAULT N'',
        Explanation NVARCHAR(1000) NULL,
        IsHidden BIT NOT NULL CONSTRAINT DF_CodingTestCases_IsHidden DEFAULT 0,
        DisplayOrder INT NOT NULL CONSTRAINT DF_CodingTestCases_DisplayOrder DEFAULT 1,
        CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_CodingTestCases_CreatedAt DEFAULT SYSUTCDATETIME()
    );
END;
GO

IF OBJECT_ID(N'dbo.ProblemTestCases', N'U') IS NOT NULL
BEGIN
    INSERT INTO dbo.CodingTestCases (ProblemId, Input, ExpectedOutput, Explanation, IsHidden, DisplayOrder, CreatedAt)
    SELECT
        pt.CodingProblemId,
        COALESCE(pt.InputData, N''),
        COALESCE(pt.ExpectedOutput, N''),
        NULL,
        pt.IsHidden,
        CASE WHEN pt.DisplayOrder > 0 THEN pt.DisplayOrder ELSE 1 END,
        COALESCE(pt.CreatedAt, SYSUTCDATETIME())
    FROM dbo.ProblemTestCases pt
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.CodingTestCases ct
        WHERE ct.ProblemId = pt.CodingProblemId
          AND ct.DisplayOrder = CASE WHEN pt.DisplayOrder > 0 THEN pt.DisplayOrder ELSE 1 END
          AND ct.Input = COALESCE(pt.InputData, N'')
    );
END;
GO

/* ---------- ProgrammingLanguages configuration table ---------- */

IF OBJECT_ID(N'dbo.ProgrammingLanguages', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.ProgrammingLanguages (
        Id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_ProgrammingLanguages PRIMARY KEY,
        Name NVARCHAR(100) NOT NULL,
        Code NVARCHAR(50) NOT NULL,
        DisplayName NVARCHAR(100) NULL,
        Version NVARCHAR(50) NULL,
        FileExtension NVARCHAR(20) NULL,
        DefaultTemplate NVARCHAR(MAX) NULL,
        CompileCommand NVARCHAR(500) NULL,
        RunCommand NVARCHAR(500) NULL,
        IsCompiled BIT NOT NULL CONSTRAINT DF_ProgrammingLanguages_IsCompiled DEFAULT 0,
        IsActive BIT NOT NULL CONSTRAINT DF_ProgrammingLanguages_IsActive DEFAULT 1,
        TimeLimitMs INT NOT NULL CONSTRAINT DF_ProgrammingLanguages_TimeLimitMs DEFAULT 5000,
        MemoryLimitKb INT NOT NULL CONSTRAINT DF_ProgrammingLanguages_MemoryLimitKb DEFAULT 262144,
        SortOrder INT NOT NULL CONSTRAINT DF_ProgrammingLanguages_SortOrder DEFAULT 100,
        CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_ProgrammingLanguages_CreatedAt DEFAULT SYSUTCDATETIME()
    );
END;
GO

IF COL_LENGTH('dbo.ProgrammingLanguages', 'DisplayName') IS NULL ALTER TABLE dbo.ProgrammingLanguages ADD DisplayName NVARCHAR(100) NULL;
IF COL_LENGTH('dbo.ProgrammingLanguages', 'FileExtension') IS NULL ALTER TABLE dbo.ProgrammingLanguages ADD FileExtension NVARCHAR(20) NULL;
IF COL_LENGTH('dbo.ProgrammingLanguages', 'CompileCommand') IS NULL ALTER TABLE dbo.ProgrammingLanguages ADD CompileCommand NVARCHAR(500) NULL;
IF COL_LENGTH('dbo.ProgrammingLanguages', 'RunCommand') IS NULL ALTER TABLE dbo.ProgrammingLanguages ADD RunCommand NVARCHAR(500) NULL;
IF COL_LENGTH('dbo.ProgrammingLanguages', 'IsCompiled') IS NULL ALTER TABLE dbo.ProgrammingLanguages ADD IsCompiled BIT NOT NULL CONSTRAINT DF_ProgrammingLanguages_IsCompiled_Compat DEFAULT 0 WITH VALUES;
IF COL_LENGTH('dbo.ProgrammingLanguages', 'TimeLimitMs') IS NULL ALTER TABLE dbo.ProgrammingLanguages ADD TimeLimitMs INT NOT NULL CONSTRAINT DF_ProgrammingLanguages_TimeLimitMs_Compat DEFAULT 5000 WITH VALUES;
IF COL_LENGTH('dbo.ProgrammingLanguages', 'MemoryLimitKb') IS NULL ALTER TABLE dbo.ProgrammingLanguages ADD MemoryLimitKb INT NOT NULL CONSTRAINT DF_ProgrammingLanguages_MemoryLimitKb_Compat DEFAULT 262144 WITH VALUES;
IF COL_LENGTH('dbo.ProgrammingLanguages', 'SortOrder') IS NULL ALTER TABLE dbo.ProgrammingLanguages ADD SortOrder INT NOT NULL CONSTRAINT DF_ProgrammingLanguages_SortOrder_Compat DEFAULT 100 WITH VALUES;

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_ProgrammingLanguages_Code' AND object_id = OBJECT_ID(N'dbo.ProgrammingLanguages'))
    CREATE UNIQUE INDEX UX_ProgrammingLanguages_Code ON dbo.ProgrammingLanguages(Code);
GO

MERGE dbo.ProgrammingLanguages AS target
USING (VALUES
    (N'python', N'Python', N'Python', N'3.x', N'py', N'print("Hello, World!")', NULL, N'python main.py', 0, 1, 5000, 262144, 1),
    (N'javascript', N'JavaScript', N'JavaScript', N'Node.js', N'js', N'console.log("Hello, World!");', NULL, N'node main.js', 0, 1, 5000, 262144, 2),
    (N'typescript', N'TypeScript', N'TypeScript', N'ES2020', N'ts', N'const message: string = "Hello, World!";
console.log(message);', N'npx tsc main.ts --target ES2020 --module commonjs --outDir out', N'node out/main.js', 1, 1, 5000, 262144, 3),
    (N'java', N'Java', N'Java', N'JDK', N'java', N'public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}', N'javac Main.java', N'java Main', 1, 1, 5000, 262144, 4),
    (N'c', N'C', N'C', N'C11', N'c', N'#include <stdio.h>
int main() {
    printf("Hello, World!\n");
    return 0;
}', N'gcc main.c -O2 -o main.exe', N'main.exe', 1, 1, 5000, 262144, 5),
    (N'cpp', N'C++17', N'C++17', N'C++17', N'cpp', N'#include <bits/stdc++.h>
using namespace std;
int main() {
    cout << "Hello, World!" << endl;
    return 0;
}', N'g++ main.cpp -std=c++17 -O2 -o main.exe', N'main.exe', 1, 1, 5000, 262144, 6),
    (N'csharp', N'C#', N'C#', N'.NET', N'cs', N'using System;
public class Program {
    public static void Main() {
        Console.WriteLine("Hello, World!");
    }
}', N'dotnet build Main.csproj --nologo -v quiet', N'dotnet bin/Debug/net9.0/Main.dll', 1, 1, 5000, 262144, 7),
    (N'go', N'Go', N'Go', N'1.x', N'go', N'package main
import "fmt"
func main() {
    fmt.Println("Hello, World!")
}', NULL, N'go run main.go', 0, 1, 5000, 262144, 8)
) AS src(Code, Name, DisplayName, Version, FileExtension, DefaultTemplate, CompileCommand, RunCommand, IsCompiled, IsActive, TimeLimitMs, MemoryLimitKb, SortOrder)
ON target.Code = src.Code
WHEN MATCHED THEN UPDATE SET
    target.Name = src.Name,
    target.DisplayName = src.DisplayName,
    target.Version = src.Version,
    target.FileExtension = src.FileExtension,
    target.DefaultTemplate = src.DefaultTemplate,
    target.CompileCommand = src.CompileCommand,
    target.RunCommand = src.RunCommand,
    target.IsCompiled = src.IsCompiled,
    target.IsActive = src.IsActive,
    target.TimeLimitMs = src.TimeLimitMs,
    target.MemoryLimitKb = src.MemoryLimitKb,
    target.SortOrder = src.SortOrder
WHEN NOT MATCHED THEN
    INSERT (Code, Name, DisplayName, Version, FileExtension, DefaultTemplate, CompileCommand, RunCommand, IsCompiled, IsActive, TimeLimitMs, MemoryLimitKb, SortOrder, CreatedAt)
    VALUES (src.Code, src.Name, src.DisplayName, src.Version, src.FileExtension, src.DefaultTemplate, src.CompileCommand, src.RunCommand, src.IsCompiled, src.IsActive, src.TimeLimitMs, src.MemoryLimitKb, src.SortOrder, SYSUTCDATETIME());
GO

/* ---------- CodeSubmissions old/new schema compatibility ---------- */

IF OBJECT_ID(N'dbo.CodeSubmissions', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.CodeSubmissions (
        Id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CodeSubmissions PRIMARY KEY,
        ProblemId BIGINT NULL,
        UserId BIGINT NOT NULL,
        Language NVARCHAR(50) NOT NULL CONSTRAINT DF_CodeSubmissions_Language DEFAULT N'javascript',
        SourceCode NVARCHAR(MAX) NOT NULL,
        Stdin NVARCHAR(MAX) NULL,
        Output NVARCHAR(MAX) NULL,
        Error NVARCHAR(MAX) NULL,
        Status NVARCHAR(50) NOT NULL CONSTRAINT DF_CodeSubmissions_Status DEFAULT N'Queued',
        Verdict NVARCHAR(100) NOT NULL CONSTRAINT DF_CodeSubmissions_Verdict DEFAULT N'Pending',
        ExecutionTimeMs INT NOT NULL CONSTRAINT DF_CodeSubmissions_ExecutionTimeMs DEFAULT 0,
        MemoryUsedKb INT NOT NULL CONSTRAINT DF_CodeSubmissions_MemoryUsedKb DEFAULT 0,
        PassedTestCases INT NOT NULL CONSTRAINT DF_CodeSubmissions_PassedTestCases DEFAULT 0,
        TotalTestCases INT NOT NULL CONSTRAINT DF_CodeSubmissions_TotalTestCases DEFAULT 0,
        IsAccepted BIT NOT NULL CONSTRAINT DF_CodeSubmissions_IsAccepted DEFAULT 0,
        CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_CodeSubmissions_CreatedAt DEFAULT SYSUTCDATETIME()
    );
END;
GO

IF COL_LENGTH('dbo.CodeSubmissions', 'ProblemId') IS NULL ALTER TABLE dbo.CodeSubmissions ADD ProblemId BIGINT NULL;
IF COL_LENGTH('dbo.CodeSubmissions', 'Language') IS NULL ALTER TABLE dbo.CodeSubmissions ADD Language NVARCHAR(50) NOT NULL CONSTRAINT DF_CodeSubmissions_Language_Compat DEFAULT N'javascript' WITH VALUES;
IF COL_LENGTH('dbo.CodeSubmissions', 'SourceCode') IS NULL ALTER TABLE dbo.CodeSubmissions ADD SourceCode NVARCHAR(MAX) NOT NULL CONSTRAINT DF_CodeSubmissions_SourceCode_Compat DEFAULT N'' WITH VALUES;
IF COL_LENGTH('dbo.CodeSubmissions', 'Stdin') IS NULL ALTER TABLE dbo.CodeSubmissions ADD Stdin NVARCHAR(MAX) NULL;
IF COL_LENGTH('dbo.CodeSubmissions', 'Output') IS NULL ALTER TABLE dbo.CodeSubmissions ADD Output NVARCHAR(MAX) NULL;
IF COL_LENGTH('dbo.CodeSubmissions', 'Error') IS NULL ALTER TABLE dbo.CodeSubmissions ADD Error NVARCHAR(MAX) NULL;
IF COL_LENGTH('dbo.CodeSubmissions', 'Status') IS NULL ALTER TABLE dbo.CodeSubmissions ADD Status NVARCHAR(50) NOT NULL CONSTRAINT DF_CodeSubmissions_Status_Compat DEFAULT N'Queued' WITH VALUES;
IF COL_LENGTH('dbo.CodeSubmissions', 'Verdict') IS NULL ALTER TABLE dbo.CodeSubmissions ADD Verdict NVARCHAR(100) NOT NULL CONSTRAINT DF_CodeSubmissions_Verdict_Compat DEFAULT N'Pending' WITH VALUES;
IF COL_LENGTH('dbo.CodeSubmissions', 'ExecutionTimeMs') IS NULL ALTER TABLE dbo.CodeSubmissions ADD ExecutionTimeMs INT NOT NULL CONSTRAINT DF_CodeSubmissions_ExecutionTimeMs_Compat DEFAULT 0 WITH VALUES;
IF COL_LENGTH('dbo.CodeSubmissions', 'MemoryUsedKb') IS NULL ALTER TABLE dbo.CodeSubmissions ADD MemoryUsedKb INT NOT NULL CONSTRAINT DF_CodeSubmissions_MemoryUsedKb_Compat DEFAULT 0 WITH VALUES;
IF COL_LENGTH('dbo.CodeSubmissions', 'PassedTestCases') IS NULL ALTER TABLE dbo.CodeSubmissions ADD PassedTestCases INT NOT NULL CONSTRAINT DF_CodeSubmissions_PassedTestCases_Compat DEFAULT 0 WITH VALUES;
IF COL_LENGTH('dbo.CodeSubmissions', 'TotalTestCases') IS NULL ALTER TABLE dbo.CodeSubmissions ADD TotalTestCases INT NOT NULL CONSTRAINT DF_CodeSubmissions_TotalTestCases_Compat DEFAULT 0 WITH VALUES;
IF COL_LENGTH('dbo.CodeSubmissions', 'IsAccepted') IS NULL ALTER TABLE dbo.CodeSubmissions ADD IsAccepted BIT NOT NULL CONSTRAINT DF_CodeSubmissions_IsAccepted_Compat DEFAULT 0 WITH VALUES;
IF COL_LENGTH('dbo.CodeSubmissions', 'CreatedAt') IS NULL ALTER TABLE dbo.CodeSubmissions ADD CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_CodeSubmissions_CreatedAt_Compat DEFAULT SYSUTCDATETIME() WITH VALUES;
GO

IF COL_LENGTH('dbo.CodeSubmissions', 'CodingProblemId') IS NOT NULL
    EXEC(N'UPDATE dbo.CodeSubmissions SET ProblemId = COALESCE(ProblemId, CodingProblemId) WHERE ProblemId IS NULL;');
IF COL_LENGTH('dbo.CodeSubmissions', 'SubmittedAt') IS NOT NULL
    EXEC(N'UPDATE dbo.CodeSubmissions SET CreatedAt = COALESCE(CreatedAt, SubmittedAt) WHERE CreatedAt IS NULL;');
IF COL_LENGTH('dbo.CodeSubmissions', 'ErrorMessage') IS NOT NULL
    EXEC(N'UPDATE dbo.CodeSubmissions SET Error = COALESCE(Error, ErrorMessage) WHERE Error IS NULL;');
IF COL_LENGTH('dbo.CodeSubmissions', 'ProgrammingLanguageId') IS NOT NULL
    EXEC(N'UPDATE cs
SET Language = pl.Code
FROM dbo.CodeSubmissions cs
JOIN dbo.ProgrammingLanguages pl ON cs.ProgrammingLanguageId = pl.Id
WHERE (cs.Language IS NULL OR LTRIM(RTRIM(cs.Language)) = N'''');');
UPDATE dbo.CodeSubmissions SET Language = N'javascript' WHERE Language IS NULL OR LTRIM(RTRIM(Language)) = N'';
UPDATE dbo.CodeSubmissions SET Verdict = CASE WHEN IsAccepted = 1 THEN N'Accepted' ELSE COALESCE(NULLIF(Verdict, N''), Status, N'Pending') END;
UPDATE dbo.CodeSubmissions SET ExecutionTimeMs = COALESCE(ExecutionTimeMs, 0), MemoryUsedKb = COALESCE(MemoryUsedKb, 0);
UPDATE cs
SET ProblemId = NULL
FROM dbo.CodeSubmissions cs
LEFT JOIN dbo.CodingProblems p ON p.Id = cs.ProblemId
WHERE cs.ProblemId IS NOT NULL AND p.Id IS NULL;
GO

IF COL_LENGTH('dbo.CodeSubmissions', 'CodingProblemId') IS NOT NULL
   AND EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.CodeSubmissions') AND name = N'CodingProblemId' AND is_nullable = 0)
    ALTER TABLE dbo.CodeSubmissions ALTER COLUMN CodingProblemId BIGINT NULL;
IF COL_LENGTH('dbo.CodeSubmissions', 'ProgrammingLanguageId') IS NOT NULL
   AND EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.CodeSubmissions') AND name = N'ProgrammingLanguageId' AND is_nullable = 0)
    ALTER TABLE dbo.CodeSubmissions ALTER COLUMN ProgrammingLanguageId BIGINT NULL;

IF COL_LENGTH('dbo.CodeSubmissions', 'SubmittedAt') IS NOT NULL
   AND NOT EXISTS (
        SELECT 1 FROM sys.default_constraints dc
        JOIN sys.columns c ON c.default_object_id = dc.object_id
        WHERE dc.parent_object_id = OBJECT_ID(N'dbo.CodeSubmissions') AND c.name = N'SubmittedAt'
   )
    ALTER TABLE dbo.CodeSubmissions ADD CONSTRAINT DF_CodeSubmissions_SubmittedAt_Compat DEFAULT SYSUTCDATETIME() FOR SubmittedAt;

IF COL_LENGTH('dbo.CodeSubmissions', 'Score') IS NOT NULL
   AND NOT EXISTS (
        SELECT 1 FROM sys.default_constraints dc
        JOIN sys.columns c ON c.default_object_id = dc.object_id
        WHERE dc.parent_object_id = OBJECT_ID(N'dbo.CodeSubmissions') AND c.name = N'Score'
   )
    ALTER TABLE dbo.CodeSubmissions ADD CONSTRAINT DF_CodeSubmissions_Score_Compat DEFAULT 0 FOR Score;
GO

/* ---------- CodeSubmissionTestCaseResults and legacy result copy ---------- */

IF OBJECT_ID(N'dbo.CodeSubmissionTestCaseResults', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.CodeSubmissionTestCaseResults (
        Id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CodeSubmissionTestCaseResults PRIMARY KEY,
        SubmissionId BIGINT NOT NULL,
        TestCaseId BIGINT NULL,
        DisplayOrder INT NOT NULL CONSTRAINT DF_CSTCR_DisplayOrder DEFAULT 1,
        Input NVARCHAR(MAX) NOT NULL CONSTRAINT DF_CSTCR_Input DEFAULT N'',
        ExpectedOutput NVARCHAR(MAX) NOT NULL CONSTRAINT DF_CSTCR_ExpectedOutput DEFAULT N'',
        ActualOutput NVARCHAR(MAX) NOT NULL CONSTRAINT DF_CSTCR_ActualOutput DEFAULT N'',
        Error NVARCHAR(MAX) NULL,
        Status NVARCHAR(50) NOT NULL CONSTRAINT DF_CSTCR_Status DEFAULT N'Pending',
        Passed BIT NOT NULL CONSTRAINT DF_CSTCR_Passed DEFAULT 0,
        ExecutionTimeMs INT NOT NULL CONSTRAINT DF_CSTCR_ExecutionTimeMs DEFAULT 0
    );
END;
GO

IF OBJECT_ID(N'dbo.SubmissionTestResults', N'U') IS NOT NULL
BEGIN
    INSERT INTO dbo.CodeSubmissionTestCaseResults (SubmissionId, TestCaseId, DisplayOrder, Input, ExpectedOutput, ActualOutput, Error, Status, Passed, ExecutionTimeMs)
    SELECT
        r.CodeSubmissionId,
        NULL,
        ROW_NUMBER() OVER (PARTITION BY r.CodeSubmissionId ORDER BY r.Id),
        N'[legacy]',
        COALESCE(r.ExpectedOutput, N''),
        COALESCE(r.ActualOutput, N''),
        r.ErrorMessage,
        COALESCE(r.Status, N'Pending'),
        CASE WHEN r.Status IN (N'Accepted', N'Success', N'Passed') THEN 1 ELSE 0 END,
        COALESCE(r.ExecutionTimeMs, 0)
    FROM dbo.SubmissionTestResults r
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.CodeSubmissionTestCaseResults nr
        WHERE nr.SubmissionId = r.CodeSubmissionId
          AND nr.ActualOutput = COALESCE(r.ActualOutput, N'')
          AND nr.ExpectedOutput = COALESCE(r.ExpectedOutput, N'')
    );
END;
GO

DELETE r
FROM dbo.CodeSubmissionTestCaseResults r
LEFT JOIN dbo.CodeSubmissions s ON s.Id = r.SubmissionId
WHERE s.Id IS NULL;

IF OBJECT_ID(N'dbo.CodingTestCases', N'U') IS NOT NULL
BEGIN
    UPDATE r
    SET TestCaseId = NULL
    FROM dbo.CodeSubmissionTestCaseResults r
    LEFT JOIN dbo.CodingTestCases t ON t.Id = r.TestCaseId
    WHERE r.TestCaseId IS NOT NULL AND t.Id IS NULL;
END;
GO

/* ---------- Safe indexes and foreign keys. NO ACTION avoids multiple cascade paths. ---------- */

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_CodeSubmissions_UserId_CreatedAt' AND object_id = OBJECT_ID(N'dbo.CodeSubmissions'))
    CREATE INDEX IX_CodeSubmissions_UserId_CreatedAt ON dbo.CodeSubmissions(UserId, CreatedAt DESC);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_CodeSubmissions_ProblemId' AND object_id = OBJECT_ID(N'dbo.CodeSubmissions'))
    CREATE INDEX IX_CodeSubmissions_ProblemId ON dbo.CodeSubmissions(ProblemId);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_CodeSubmissionTestCaseResults_SubmissionId' AND object_id = OBJECT_ID(N'dbo.CodeSubmissionTestCaseResults'))
    CREATE INDEX IX_CodeSubmissionTestCaseResults_SubmissionId ON dbo.CodeSubmissionTestCaseResults(SubmissionId);
GO

IF OBJECT_ID(N'dbo.Users', N'U') IS NOT NULL
   AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_CodeSubmissions_Users_Compat')
    ALTER TABLE dbo.CodeSubmissions WITH CHECK ADD CONSTRAINT FK_CodeSubmissions_Users_Compat FOREIGN KEY (UserId) REFERENCES dbo.Users(Id) ON DELETE NO ACTION;

IF OBJECT_ID(N'dbo.CodingProblems', N'U') IS NOT NULL
   AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_CodeSubmissions_CodingProblems_Compat')
    ALTER TABLE dbo.CodeSubmissions WITH CHECK ADD CONSTRAINT FK_CodeSubmissions_CodingProblems_Compat FOREIGN KEY (ProblemId) REFERENCES dbo.CodingProblems(Id) ON DELETE NO ACTION;

IF OBJECT_ID(N'dbo.CodingProblems', N'U') IS NOT NULL
   AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_CodingTestCases_CodingProblems_Compat')
   AND NOT EXISTS (
        SELECT 1
        FROM dbo.CodingTestCases ct
        LEFT JOIN dbo.CodingProblems p ON p.Id = ct.ProblemId
        WHERE p.Id IS NULL
   )
    ALTER TABLE dbo.CodingTestCases WITH CHECK ADD CONSTRAINT FK_CodingTestCases_CodingProblems_Compat FOREIGN KEY (ProblemId) REFERENCES dbo.CodingProblems(Id) ON DELETE NO ACTION;

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_CSTCR_CodeSubmissions_Compat')
    ALTER TABLE dbo.CodeSubmissionTestCaseResults WITH CHECK ADD CONSTRAINT FK_CSTCR_CodeSubmissions_Compat FOREIGN KEY (SubmissionId) REFERENCES dbo.CodeSubmissions(Id) ON DELETE NO ACTION;

IF OBJECT_ID(N'dbo.CodingTestCases', N'U') IS NOT NULL
   AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_CSTCR_CodingTestCases_Compat')
    ALTER TABLE dbo.CodeSubmissionTestCaseResults WITH CHECK ADD CONSTRAINT FK_CSTCR_CodingTestCases_Compat FOREIGN KEY (TestCaseId) REFERENCES dbo.CodingTestCases(Id) ON DELETE NO ACTION;
GO

COMMIT TRANSACTION;
GO

SELECT Code, DisplayName, Version, FileExtension, IsActive, SortOrder
FROM dbo.ProgrammingLanguages
ORDER BY SortOrder, Code;
GO
