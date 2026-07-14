using System.Net.Mail;
using DevLearningHub.Api.Common;

namespace DevLearningHub.Api.Utilities;

public sealed record EmailValidationResult(
    bool IsValid,
    string NormalizedEmail,
    string? SuggestedEmail,
    string? Message,
    List<ApiError> Errors);

public static class EmailValidationHelper
{
    private static readonly Dictionary<string, string> TypoDomains = new(StringComparer.OrdinalIgnoreCase)
    {
        ["gmail.co"] = "gmail.com",
        ["gmai.com"] = "gmail.com",
        ["gmial.com"] = "gmail.com",
        ["gnail.com"] = "gmail.com",
        ["gmail.con"] = "gmail.com",
        ["gmail.cm"] = "gmail.com",
        ["yahoo.co"] = "yahoo.com",
        ["hotmial.com"] = "hotmail.com",
        ["outlook.co"] = "outlook.com"
    };

    public static EmailValidationResult Validate(string? email)
    {
        var errors = new List<ApiError>();
        var normalized = (email ?? string.Empty).Trim().ToLowerInvariant();

        if (string.IsNullOrWhiteSpace(email))
        {
            errors.Add(new ApiError { Field = "email", Message = "Email is required" });
            return Invalid(normalized, "Email is required", errors);
        }

        if (normalized.Any(char.IsWhiteSpace))
        {
            errors.Add(new ApiError { Field = "email", Message = "Email must not contain whitespace" });
            return Invalid(normalized, "Email không được chứa khoảng trắng.", errors);
        }

        if (!HasValidFormat(normalized, out var domain))
        {
            errors.Add(new ApiError { Field = "email", Message = "Email không đúng định dạng." });
            return Invalid(normalized, "Email không đúng định dạng.", errors);
        }

        if (TypoDomains.TryGetValue(domain, out var correctedDomain))
        {
            var localPart = normalized[..normalized.LastIndexOf('@')];
            var suggestedEmail = $"{localPart}@{correctedDomain}";
            var message = $"Email có vẻ bị nhập sai. Bạn có muốn dùng {suggestedEmail} không?";
            errors.Add(new ApiError { Field = "email", Message = message });
            return new EmailValidationResult(false, normalized, suggestedEmail, message, errors);
        }

        return new EmailValidationResult(true, normalized, null, null, errors);
    }

    public static IReadOnlyDictionary<string, string> GetTypoDomains() => TypoDomains;

    private static EmailValidationResult Invalid(string normalized, string message, List<ApiError> errors)
        => new(false, normalized, null, message, errors);

    private static bool HasValidFormat(string email, out string domain)
    {
        domain = string.Empty;

        if (email.Count(c => c == '@') != 1) return false;

        try
        {
            var address = new MailAddress(email);
            if (!string.Equals(address.Address, email, StringComparison.OrdinalIgnoreCase)) return false;

            var atIndex = email.LastIndexOf('@');
            if (atIndex <= 0 || atIndex == email.Length - 1) return false;

            domain = email[(atIndex + 1)..];
            if (!domain.Contains('.')) return false;
            if (domain.StartsWith('.') || domain.EndsWith('.') || domain.Contains("..")) return false;

            var labels = domain.Split('.');
            if (labels.Any(label => string.IsNullOrWhiteSpace(label) || label.StartsWith('-') || label.EndsWith('-')))
                return false;

            var tld = labels[^1];
            if (tld.Length < 2 || !tld.All(char.IsLetter)) return false;

            return true;
        }
        catch (FormatException)
        {
            return false;
        }
    }
}
