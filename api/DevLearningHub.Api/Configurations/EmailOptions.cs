namespace DevLearningHub.Api.Configurations;

public sealed class EmailOptions
{
    public string Provider { get; set; } = "Smtp";
    public string FromName { get; set; } = "DevLearningHub";
    public string FromEmail { get; set; } = string.Empty;
    public bool RequireRealSmtp { get; set; } = true;
    public string FrontendBaseUrl { get; set; } = "http://localhost:4200";
    public string AdminBaseUrl { get; set; } = "http://localhost:4300";
    public SmtpOptions Smtp { get; set; } = new();
}

public sealed class SmtpOptions
{
    public string Host { get; set; } = string.Empty;
    public int Port { get; set; } = 587;
    public bool UseSsl { get; set; } = true;
    public string Username { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
}
