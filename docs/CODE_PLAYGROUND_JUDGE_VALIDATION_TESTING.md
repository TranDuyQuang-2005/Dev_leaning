# Validation & Testing - Online Code Playground & Judge

## 1. Validation

| Chức năng | Điều kiện kiểm tra | Kết quả mong muốn |
|---|---|---|
| Run code | Source code rỗng | Không cho chạy, báo source code không được trống |
| Run code | Source code quá dài | Không cho chạy, giới hạn 20.000 ký tự |
| Run code | Ngôn ngữ không hỗ trợ | Trả lỗi Unsupported Language |
| Run code | Code chạy quá thời gian | Trả Time Limit Exceeded |
| Run code | Code lỗi runtime | Trả Runtime Error và stderr |
| Submit problem | User chưa đăng nhập | Trả 401 Unauthorized |
| Submit problem | Problem không tồn tại | Báo không tìm thấy bài lập trình |
| Submit problem | Problem chưa có test case | Không cho submit |
| Submit problem | Output khác expected output | Verdict Wrong Answer |
| Submit problem | Tất cả test case đúng | Verdict Accepted |
| Admin create problem | Title rỗng/ngắn | Báo tiêu đề tối thiểu 5 ký tự |
| Admin create problem | Description quá ngắn | Báo mô tả tối thiểu 20 ký tự |
| Admin create problem | Không có test case | Báo cần ít nhất 1 test case |
| Admin create problem | Slug trùng | Báo slug đã tồn tại |
| Admin delete problem | Problem đã có submission | Soft delete, không xóa vật lý dữ liệu submission |

## 2. Test cases User

| Mã TC | Nội dung | Dữ liệu test | Kết quả mong muốn |
|---|---|---|---|
| CODE_USER_01 | Mở Playground | User đã login | Hiển thị editor, ngôn ngữ, stdin/stdout |
| CODE_USER_02 | Run JavaScript hợp lệ | console.log hello | Trả Accepted, có output |
| CODE_USER_03 | Run code lỗi cú pháp | JS thiếu dấu ngoặc | Trả Runtime Error |
| CODE_USER_04 | Run code vòng lặp lâu | while(true) | Trả Time Limit Exceeded |
| CODE_USER_05 | Xem danh sách problem | Có dữ liệu seed | Hiển thị Sum Two Numbers, Reverse String |
| CODE_USER_06 | Mở chi tiết problem | Click Solve | Hiển thị đề bài và test case mẫu |
| CODE_USER_07 | Submit bài đúng | Code mẫu Sum Two Numbers | Accepted |
| CODE_USER_08 | Submit bài sai | Luôn in 0 | Wrong Answer |
| CODE_USER_09 | Hidden test | Code đúng sample nhưng sai hidden | Failed ở hidden test |
| CODE_USER_10 | Kiểm tra thống kê | Submit Accepted | UserStats tăng TotalCodeSubmissions/AcceptedCodeSubmissions |

## 3. Test cases Admin

| Mã TC | Nội dung | Dữ liệu test | Kết quả mong muốn |
|---|---|---|---|
| CODE_ADMIN_01 | Vào Code Judge Management | admin@example.com | Truy cập được `/code` |
| CODE_ADMIN_02 | Tạo problem hợp lệ | Title, description, testcases | Problem lưu vào DB |
| CODE_ADMIN_03 | Tạo problem thiếu testcase | Không nhập testcase | Báo validation |
| CODE_ADMIN_04 | Sửa problem | Đổi title/tags | Cập nhật DB |
| CODE_ADMIN_05 | Thêm hidden test | IsHidden = true | User không thấy expected output hidden |
| CODE_ADMIN_06 | Xóa problem | Click delete | Problem soft delete |
| CODE_ADMIN_07 | User thấy problem mới | Status Published | Hiện trong User Problem Set |
| CODE_ADMIN_08 | Draft problem | Status Draft | User không thấy problem |

## 4. SQL kiểm tra

```sql
USE DevLearningHubDb;

SELECT TOP 20 * FROM CodingProblems ORDER BY Id DESC;
SELECT TOP 50 * FROM CodingTestCases ORDER BY ProblemId, DisplayOrder;
SELECT TOP 50 * FROM CodeSubmissions ORDER BY Id DESC;
SELECT TOP 50 * FROM CodeSubmissionTestCaseResults ORDER BY SubmissionId DESC, DisplayOrder;
SELECT TOP 20 UserId, TotalCodeSubmissions, AcceptedCodeSubmissions, Reputation FROM UserStats ORDER BY UserId;
```
