namespace DevLearningHub.Api.Common;

public sealed class ApiResponse<T>
{
    public bool Success { get; set; }
    public string Message { get; set; } = string.Empty;
    public T? Data { get; set; }
    public List<ApiError>? Errors { get; set; }
    public string? TraceId { get; set; }

    public static ApiResponse<T> Ok(T data, string message = "Thao tác thành công") => new()
    {
        Success = true,
        Message = message,
        Data = data
    };

    public static ApiResponse<T> Fail(string message, List<ApiError>? errors = null) => new()
    {
        Success = false,
        Message = message,
        Data = default,
        Errors = errors
    };
}

public sealed class ApiError
{
    public string Field { get; set; } = string.Empty;
    public string Message { get; set; } = string.Empty;
}

public sealed class PagedResult<T>
{
    public List<T> Items { get; set; } = new();
    public int PageIndex { get; set; }
    public int PageSize { get; set; }
    public int TotalItems { get; set; }
    public int TotalPages { get; set; }

    public static PagedResult<T> Create(List<T> items, int pageIndex, int pageSize, int totalItems) => new()
    {
        Items = items,
        PageIndex = pageIndex,
        PageSize = pageSize,
        TotalItems = totalItems,
        TotalPages = (int)Math.Ceiling(totalItems / (double)pageSize)
    };
}
