using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.Text;
using DevLearningHub.Api.Configurations;
using Microsoft.Extensions.Options;

namespace DevLearningHub.Api.Services;

public interface IEmailService
{
    Task SendEmailVerificationAsync(string email, string fullName, string verificationUrl, CancellationToken ct);
    Task SendPasswordResetAsync(string email, string fullName, string resetUrl, CancellationToken ct);
    Task SendGenericAsync(string to, string subject, string htmlBody, CancellationToken ct);
}

public sealed class EmailService : IEmailService
{
    public const string SmtpNotConfiguredMessage = "SMTP is not configured. Please configure Email:Smtp settings.";

    private readonly EmailOptions _options;
    private readonly ILogger<EmailService> _logger;

    public EmailService(IOptions<EmailOptions> options, ILogger<EmailService> logger)
    {
        _options = options.Value;
        _logger = logger;
    }

    public Task SendEmailVerificationAsync(string email, string fullName, string verificationUrl, CancellationToken ct)
    {
        var name = string.IsNullOrWhiteSpace(fullName) ? email : WebUtility.HtmlEncode(fullName.Trim());
        var url = WebUtility.HtmlEncode(verificationUrl);
        var body = BuildTemplate(
            "Xác thực tài khoản",
            $"""
            <p>Xin chào {name},</p>
            <p>Cảm ơn bạn đã đăng ký DevLearningHub. Vui lòng bấm nút bên dưới để xác thực tài khoản.</p>
            <p><a class="button" href="{url}" target="_blank" rel="noopener">Xác thực tài khoản</a></p>
            <p>Link xác thực hết hạn sau 24 giờ.</p>
            <p>Nếu không phải bạn đăng ký tài khoản này, hãy bỏ qua email này.</p>
            <p>Nếu nút không hoạt động, hãy mở liên kết sau:</p>
            <p><a href="{url}" target="_blank" rel="noopener">{url}</a></p>
            """);

        return SendGenericAsync(email, "Xác thực tài khoản DevLearningHub", body, ct);
    }

    public Task SendPasswordResetAsync(string email, string fullName, string resetUrl, CancellationToken ct)
    {
        var name = string.IsNullOrWhiteSpace(fullName) ? email : WebUtility.HtmlEncode(fullName.Trim());
        var url = WebUtility.HtmlEncode(resetUrl);
        var body = BuildTemplate(
            "Đặt lại mật khẩu",
            $"""
            <p>Xin chào {name},</p>
            <p>DevLearningHub nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn.</p>
            <p><a class="button" href="{url}" target="_blank" rel="noopener">Đặt lại mật khẩu</a></p>
            <p>Link đặt lại mật khẩu hết hạn sau 30 phút.</p>
            <p>Nếu không phải bạn yêu cầu, hãy bỏ qua email này.</p>
            <p>Nếu nút không hoạt động, hãy mở liên kết sau:</p>
            <p><a href="{url}" target="_blank" rel="noopener">{url}</a></p>
            """);

        return SendGenericAsync(email, "Đặt lại mật khẩu DevLearningHub", body, ct);
    }

    public async Task SendGenericAsync(string to, string subject, string htmlBody, CancellationToken ct)
    {
        ValidateSmtpOptions();

        using var message = new MailMessage
        {
            From = new MailAddress(_options.FromEmail.Trim(), _options.FromName.Trim(), Encoding.UTF8),
            Subject = subject,
            SubjectEncoding = Encoding.UTF8,
            BodyEncoding = Encoding.UTF8,
            IsBodyHtml = true
        };
        message.To.Add(new MailAddress(to.Trim()));

        var htmlView = AlternateView.CreateAlternateViewFromString(htmlBody, Encoding.UTF8, MediaTypeNames.Text.Html);
        message.AlternateViews.Add(htmlView);

        using var client = new SmtpClient(_options.Smtp.Host.Trim(), _options.Smtp.Port)
        {
            EnableSsl = _options.Smtp.UseSsl,
            Credentials = new NetworkCredential(_options.Smtp.Username.Trim(), _options.Smtp.Password)
        };

        _logger.LogInformation("Sending email via SMTP to {Email} with subject {Subject}", to, subject);
        await client.SendMailAsync(message, ct);
    }

    private void ValidateSmtpOptions()
    {
        if (!_options.Provider.Equals("Smtp", StringComparison.OrdinalIgnoreCase))
            throw new InvalidOperationException(SmtpNotConfiguredMessage);

        if (string.IsNullOrWhiteSpace(_options.FromEmail)
            || string.IsNullOrWhiteSpace(_options.Smtp.Host)
            || string.IsNullOrWhiteSpace(_options.Smtp.Username)
            || string.IsNullOrWhiteSpace(_options.Smtp.Password))
        {
            throw new InvalidOperationException(SmtpNotConfiguredMessage);
        }
    }

    private static string BuildTemplate(string title, string content) =>
        $$"""
        <!doctype html>
        <html lang="vi">
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <title>{{WebUtility.HtmlEncode(title)}}</title>
          <style>
            body { font-family: Arial, sans-serif; color: #111827; line-height: 1.6; margin: 0; padding: 24px; background: #f7f8fb; }
            .container { max-width: 640px; margin: 0 auto; background: #ffffff; border: 1px solid #e5e7eb; border-radius: 8px; padding: 28px; }
            .button { display: inline-block; padding: 12px 18px; background: #2563eb; color: #ffffff !important; border-radius: 6px; text-decoration: none; font-weight: 700; }
            .footer { margin-top: 24px; color: #6b7280; font-size: 13px; }
          </style>
        </head>
        <body>
          <div class="container">
            <h1>{{WebUtility.HtmlEncode(title)}}</h1>
            {{content}}
            <div class="footer">DevLearningHub</div>
          </div>
        </body>
        </html>
        """;
}
