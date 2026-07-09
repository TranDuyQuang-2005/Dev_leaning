using System.Globalization;
using System.Net;
using System.Net.Http;
using System.Security.Cryptography;
using System.Text;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Options;

namespace DevLearningHub.Api.Services;

public sealed class ObjectStorageOptions
{
    public string Provider { get; set; } = "MinIO"; // MinIO or Local
    public bool FallbackToLocal { get; set; } = true;
    public long MaxFileSizeBytes { get; set; } = 10 * 1024 * 1024;
    public string[] AllowedExtensions { get; set; } = new[] { ".jpg", ".jpeg", ".png", ".gif", ".webp", ".pdf", ".doc", ".docx", ".txt", ".zip" };
    public string[] AllowedImageExtensions { get; set; } = new[] { ".jpg", ".jpeg", ".png", ".gif", ".webp" };
    public string LocalRootPath { get; set; } = "uploads";
    public string LocalPublicBaseUrl { get; set; } = "/uploads";
    public MinioOptions MinIO { get; set; } = new();
}

public sealed class MinioOptions
{
    public string Endpoint { get; set; } = "http://localhost:9000";
    public string PublicBaseUrl { get; set; } = "http://localhost:9000/devlearninghub";
    public string AccessKey { get; set; } = "admin";
    public string SecretKey { get; set; } = "12345678";
    public string Bucket { get; set; } = "devlearninghub";
    public string Region { get; set; } = "us-east-1";
    public string ForumFolder { get; set; } = "forum";
}

public sealed class StoredObjectResult
{
    public string OriginalFileName { get; set; } = string.Empty;
    public string StoredFileName { get; set; } = string.Empty;
    public string FileUrl { get; set; } = string.Empty;
    public string MimeType { get; set; } = string.Empty;
    public long FileSizeBytes { get; set; }
    public string StorageProvider { get; set; } = string.Empty;
    public string FileType { get; set; } = string.Empty;
}

public sealed class StoredObjectReadResult
{
    public byte[] Bytes { get; set; } = Array.Empty<byte>();
    public string ContentType { get; set; } = "application/octet-stream";
    public string FileName { get; set; } = string.Empty;
    public long FileSizeBytes { get; set; }
}

public interface IObjectStorageService
{
    Task<StoredObjectResult> UploadForumFileAsync(IFormFile file, long userId, CancellationToken ct);
    Task<StoredObjectReadResult> ReadFileAsync(string storageProvider, string storedFileName, string fileUrl, string contentType, string originalFileName, CancellationToken ct);
}

public sealed class ObjectStorageService : IObjectStorageService
{
    private readonly ObjectStorageOptions _options;
    private readonly IWebHostEnvironment _env;
    private readonly IHttpClientFactory _httpClientFactory;

    public ObjectStorageService(IOptions<ObjectStorageOptions> options, IWebHostEnvironment env, IHttpClientFactory httpClientFactory)
    {
        _options = options.Value;
        _env = env;
        _httpClientFactory = httpClientFactory;
    }

    public async Task<StoredObjectResult> UploadForumFileAsync(IFormFile file, long userId, CancellationToken ct)
    {
        Validate(file);
        var originalName = Path.GetFileName(file.FileName);
        var ext = Path.GetExtension(originalName).ToLowerInvariant();
        var isImage = _options.AllowedImageExtensions.Contains(ext, StringComparer.OrdinalIgnoreCase);
        var safeName = $"{Guid.NewGuid():N}{ext}";
        var objectKey = $"{_options.MinIO.ForumFolder}/{DateTime.UtcNow:yyyy/MM}/{safeName}";
        var mime = string.IsNullOrWhiteSpace(file.ContentType) ? "application/octet-stream" : file.ContentType;

        await using var stream = file.OpenReadStream();
        using var ms = new MemoryStream();
        await stream.CopyToAsync(ms, ct);
        var bytes = ms.ToArray();

        if (_options.Provider.Equals("MinIO", StringComparison.OrdinalIgnoreCase))
        {
            try
            {
                await EnsureBucketAsync(ct);
                await PutObjectAsync(objectKey, bytes, mime, ct);
                return new StoredObjectResult
                {
                    OriginalFileName = originalName,
                    StoredFileName = objectKey,
                    FileUrl = $"{_options.MinIO.PublicBaseUrl.TrimEnd('/')}/{objectKey}",
                    MimeType = mime,
                    FileSizeBytes = bytes.LongLength,
                    StorageProvider = "MinIO",
                    FileType = isImage ? "Image" : "File"
                };
            }
            catch when (_options.FallbackToLocal)
            {
                return await SaveLocal(originalName, safeName, mime, isImage, bytes, ct);
            }
        }

        return await SaveLocal(originalName, safeName, mime, isImage, bytes, ct);
    }

    public async Task<StoredObjectReadResult> ReadFileAsync(string storageProvider, string storedFileName, string fileUrl, string contentType, string originalFileName, CancellationToken ct)
    {
        var mime = string.IsNullOrWhiteSpace(contentType) ? "application/octet-stream" : contentType;

        if (storageProvider.Equals("MinIO", StringComparison.OrdinalIgnoreCase))
        {
            var objectKey = storedFileName.TrimStart('/').Replace("\\", "/");
            var escapedKey = string.Join('/', objectKey.Split('/', StringSplitOptions.RemoveEmptyEntries).Select(Uri.EscapeDataString));
            var uri = new Uri($"{_options.MinIO.Endpoint.TrimEnd('/')}/{_options.MinIO.Bucket}/{escapedKey}");
            using var req = BuildSignedRequest(HttpMethod.Get, uri, Array.Empty<byte>(), string.Empty);
            using var client = _httpClientFactory.CreateClient();
            using var res = await client.SendAsync(req, HttpCompletionOption.ResponseHeadersRead, ct);
            if (!res.IsSuccessStatusCode)
            {
                var body = await res.Content.ReadAsStringAsync(ct);
                throw new FileNotFoundException($"Không đọc được file từ MinIO: {(int)res.StatusCode} {body}");
            }
            var bytes = await res.Content.ReadAsByteArrayAsync(ct);
            return new StoredObjectReadResult
            {
                Bytes = bytes,
                ContentType = mime,
                FileName = originalFileName,
                FileSizeBytes = bytes.LongLength
            };
        }

        var localPath = ResolveLocalPath(storedFileName, fileUrl);
        if (!File.Exists(localPath))
        {
            throw new FileNotFoundException("Không tìm thấy file local", localPath);
        }

        var localBytes = await File.ReadAllBytesAsync(localPath, ct);
        return new StoredObjectReadResult
        {
            Bytes = localBytes,
            ContentType = mime,
            FileName = originalFileName,
            FileSizeBytes = localBytes.LongLength
        };
    }

    private string ResolveLocalPath(string storedFileName, string fileUrl)
    {
        if (!string.IsNullOrWhiteSpace(fileUrl) && fileUrl.StartsWith(_options.LocalPublicBaseUrl, StringComparison.OrdinalIgnoreCase))
        {
            var relative = fileUrl.TrimStart('/').Replace('/', Path.DirectorySeparatorChar);
            return Path.Combine(_env.ContentRootPath, relative);
        }

        var clean = storedFileName.TrimStart('/').Replace('/', Path.DirectorySeparatorChar);
        return Path.Combine(_env.ContentRootPath, _options.LocalRootPath, clean);
    }

    private void Validate(IFormFile file)
    {
        if (file == null || file.Length <= 0) throw new InvalidOperationException("File không hợp lệ");
        if (file.Length > _options.MaxFileSizeBytes) throw new InvalidOperationException($"File vượt quá dung lượng cho phép {Math.Round(_options.MaxFileSizeBytes / 1024m / 1024m, 1)}MB");
        var ext = Path.GetExtension(file.FileName).ToLowerInvariant();
        if (string.IsNullOrWhiteSpace(ext) || !_options.AllowedExtensions.Contains(ext, StringComparer.OrdinalIgnoreCase))
            throw new InvalidOperationException("Định dạng file không được hỗ trợ. Chỉ cho phép ảnh, PDF, DOC/DOCX, TXT, ZIP.");
    }

    private async Task<StoredObjectResult> SaveLocal(string originalName, string safeName, string mime, bool isImage, byte[] bytes, CancellationToken ct)
    {
        var folder = Path.Combine(_env.ContentRootPath, _options.LocalRootPath, "forum", DateTime.UtcNow.ToString("yyyy"), DateTime.UtcNow.ToString("MM"));
        Directory.CreateDirectory(folder);
        var path = Path.Combine(folder, safeName);
        await File.WriteAllBytesAsync(path, bytes, ct);
        var relative = $"/forum/{DateTime.UtcNow:yyyy/MM}/{safeName}";
        return new StoredObjectResult
        {
            OriginalFileName = originalName,
            StoredFileName = relative.TrimStart('/'),
            FileUrl = $"{_options.LocalPublicBaseUrl.TrimEnd('/')}{relative}",
            MimeType = mime,
            FileSizeBytes = bytes.LongLength,
            StorageProvider = "Local",
            FileType = isImage ? "Image" : "File"
        };
    }

    private async Task EnsureBucketAsync(CancellationToken ct)
    {
        var uri = new Uri($"{_options.MinIO.Endpoint.TrimEnd('/')}/{_options.MinIO.Bucket}");
        using var req = BuildSignedRequest(HttpMethod.Put, uri, Array.Empty<byte>(), "application/octet-stream");
        req.Content = new ByteArrayContent(Array.Empty<byte>());
        req.Content.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue("application/octet-stream");
        using var client = _httpClientFactory.CreateClient();
        using var res = await client.SendAsync(req, ct);
        if (res.StatusCode == HttpStatusCode.OK || res.StatusCode == HttpStatusCode.Conflict) return;
        if ((int)res.StatusCode == 409) return;
        if ((int)res.StatusCode == 200) return;
        // MinIO may return BucketAlreadyOwnedByYou as 409, otherwise throw.
        if (!res.IsSuccessStatusCode) throw new InvalidOperationException($"Không tạo được MinIO bucket: {(int)res.StatusCode}");
    }

    private async Task PutObjectAsync(string objectKey, byte[] bytes, string contentType, CancellationToken ct)
    {
        var escapedKey = string.Join('/', objectKey.Split('/').Select(Uri.EscapeDataString));
        var uri = new Uri($"{_options.MinIO.Endpoint.TrimEnd('/')}/{_options.MinIO.Bucket}/{escapedKey}");
        using var req = BuildSignedRequest(HttpMethod.Put, uri, bytes, contentType);
        req.Content = new ByteArrayContent(bytes);
        req.Content.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue(contentType);
        using var client = _httpClientFactory.CreateClient();
        using var res = await client.SendAsync(req, ct);
        if (!res.IsSuccessStatusCode)
        {
            var body = await res.Content.ReadAsStringAsync(ct);
            throw new InvalidOperationException($"Upload MinIO thất bại: {(int)res.StatusCode} {body}");
        }
    }

    private HttpRequestMessage BuildSignedRequest(HttpMethod method, Uri uri, byte[] payload, string contentType)
    {
        var now = DateTime.UtcNow;
        var amzDate = now.ToString("yyyyMMdd'T'HHmmss'Z'", CultureInfo.InvariantCulture);
        var dateStamp = now.ToString("yyyyMMdd", CultureInfo.InvariantCulture);
        var payloadHash = ToHex(SHA256.HashData(payload));
        var host = uri.IsDefaultPort ? uri.Host : $"{uri.Host}:{uri.Port}";

        var headers = new SortedDictionary<string, string>(StringComparer.Ordinal)
        {
            ["host"] = host,
            ["x-amz-content-sha256"] = payloadHash,
            ["x-amz-date"] = amzDate
        };
        if (!string.IsNullOrWhiteSpace(contentType))
        {
            headers["content-type"] = contentType;
        }
        var canonicalHeaders = string.Concat(headers.Select(h => $"{h.Key}:{h.Value.Trim()}\n"));
        var signedHeaders = string.Join(';', headers.Keys);
        var canonicalUri = string.IsNullOrEmpty(uri.AbsolutePath) ? "/" : uri.AbsolutePath;
        var canonicalRequest = string.Join('\n', new[] { method.Method, canonicalUri, string.Empty, canonicalHeaders, signedHeaders, payloadHash });
        var credentialScope = $"{dateStamp}/{_options.MinIO.Region}/s3/aws4_request";
        var stringToSign = string.Join('\n', new[] { "AWS4-HMAC-SHA256", amzDate, credentialScope, ToHex(SHA256.HashData(Encoding.UTF8.GetBytes(canonicalRequest))) });
        var signingKey = GetSignatureKey(_options.MinIO.SecretKey, dateStamp, _options.MinIO.Region, "s3");
        var signature = ToHex(HmacSHA256(signingKey, stringToSign));
        var authorization = $"AWS4-HMAC-SHA256 Credential={_options.MinIO.AccessKey}/{credentialScope}, SignedHeaders={signedHeaders}, Signature={signature}";

        var request = new HttpRequestMessage(method, uri);
        request.Headers.TryAddWithoutValidation("x-amz-date", amzDate);
        request.Headers.TryAddWithoutValidation("x-amz-content-sha256", payloadHash);
        request.Headers.TryAddWithoutValidation("Authorization", authorization);
        request.Headers.Host = host;
        return request;
    }

    private static byte[] GetSignatureKey(string key, string dateStamp, string regionName, string serviceName)
    {
        var kDate = HmacSHA256(Encoding.UTF8.GetBytes("AWS4" + key), dateStamp);
        var kRegion = HmacSHA256(kDate, regionName);
        var kService = HmacSHA256(kRegion, serviceName);
        return HmacSHA256(kService, "aws4_request");
    }

    private static byte[] HmacSHA256(byte[] key, string data)
    {
        using var hmac = new HMACSHA256(key);
        return hmac.ComputeHash(Encoding.UTF8.GetBytes(data));
    }

    private static string ToHex(byte[] bytes) => Convert.ToHexString(bytes).ToLowerInvariant();
}
