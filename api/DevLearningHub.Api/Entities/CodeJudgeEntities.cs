namespace DevLearningHub.Api.Entities;

public sealed class CodingProblem
{
    public long Id { get; set; }
    public long CreatedByUserId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Slug { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public string? InputFormat { get; set; }
    public string? OutputFormat { get; set; }
    public string? Constraints { get; set; }
    public string? ExamplesJson { get; set; }
    public string? Tags { get; set; }
    public string? StarterCodeJavaScript { get; set; }
    public string? StarterCodePython { get; set; }
    public string? StarterCodeTypeScript { get; set; }
    public string? StarterCodeJava { get; set; }
    public string? StarterCodeC { get; set; }
    public string? StarterCodeCpp { get; set; }
    public string? StarterCodeCsharp { get; set; }
    public string? StarterCodeGo { get; set; }
    public byte Difficulty { get; set; } = 1;
    public byte Status { get; set; } = 1;
    public int TimeLimitMs { get; set; } = 2000;
    public int MemoryLimitKb { get; set; } = 131072;
    public int TotalSubmissions { get; set; }
    public int AcceptedSubmissions { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public bool IsDeleted { get; set; }
    public User CreatedByUser { get; set; } = null!;
    public ICollection<CodingTestCase> TestCases { get; set; } = new List<CodingTestCase>();
    public ICollection<CodeSubmission> Submissions { get; set; } = new List<CodeSubmission>();
}

public sealed class CodingTestCase
{
    public long Id { get; set; }
    public long ProblemId { get; set; }
    public string Input { get; set; } = string.Empty;
    public string ExpectedOutput { get; set; } = string.Empty;
    public string? Explanation { get; set; }
    public bool IsHidden { get; set; }
    public int DisplayOrder { get; set; }
    public DateTime CreatedAt { get; set; }
    public CodingProblem Problem { get; set; } = null!;
}

public sealed class CodeSubmission
{
    public long Id { get; set; }
    public long? ProblemId { get; set; }
    public long UserId { get; set; }
    public string Language { get; set; } = string.Empty;
    public string SourceCode { get; set; } = string.Empty;
    public string? Stdin { get; set; }
    public string? Output { get; set; }
    public string? Error { get; set; }
    public string Status { get; set; } = "Queued";
    public string Verdict { get; set; } = "Pending";
    public int ExecutionTimeMs { get; set; }
    public int MemoryUsedKb { get; set; }
    public int PassedTestCases { get; set; }
    public int TotalTestCases { get; set; }
    public bool IsAccepted { get; set; }
    public DateTime CreatedAt { get; set; }
    public CodingProblem? Problem { get; set; }
    public User User { get; set; } = null!;
    public ICollection<CodeSubmissionTestCaseResult> TestCaseResults { get; set; } = new List<CodeSubmissionTestCaseResult>();
}

public sealed class CodeSubmissionTestCaseResult
{
    public long Id { get; set; }
    public long SubmissionId { get; set; }
    public long? TestCaseId { get; set; }
    public int DisplayOrder { get; set; }
    public string Input { get; set; } = string.Empty;
    public string ExpectedOutput { get; set; } = string.Empty;
    public string ActualOutput { get; set; } = string.Empty;
    public string? Error { get; set; }
    public string Status { get; set; } = "Pending";
    public bool Passed { get; set; }
    public int ExecutionTimeMs { get; set; }
    public CodeSubmission Submission { get; set; } = null!;
    public CodingTestCase? TestCase { get; set; }
}
