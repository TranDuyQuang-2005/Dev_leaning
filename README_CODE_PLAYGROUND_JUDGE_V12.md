# DevLearningHub v12 - Online Code Playground & Judge

Bản v12 hoàn thiện thêm phân hệ **Online Code Playground & Judge** theo hướng thực tế hơn, có API thật, DB thật, giao diện User và giao diện Admin quản lý bài lập trình.

## 1. Chức năng đã bổ sung

### User App

- Trang `Code Playground` chạy code qua API `/api/v1/code/run`.
- Hỗ trợ nhập `STDIN`, xem `STDOUT`, `STDERR`, verdict và thời gian chạy.
- Trang `Problem Set` lấy danh sách bài lập trình từ DB.
- Trang `Problem Detail` hiển thị đề bài, input/output format, constraint, sample test case.
- User có thể chọn ngôn ngữ, chạy thử code với custom input và submit bài.
- Hệ thống chấm bài theo test case, trả về số test pass/fail, verdict, execution time.
- Sau khi accepted, thống kê user được cập nhật `TotalCodeSubmissions`, `AcceptedCodeSubmissions`, `Reputation`.

### Admin App

- Thêm route `http://localhost:4300/code`.
- Admin quản lý coding problem.
- Tạo/sửa/xóa problem.
- Quản lý test case public/hidden.
- Cấu hình difficulty, tag, time limit, memory limit, status.
- Cấu hình starter code cho JavaScript, Python, Java, C++.

### API

User API:

```http
GET  /api/v1/code/languages
POST /api/v1/code/run
GET  /api/v1/code/problems
GET  /api/v1/code/problems/{id}
POST /api/v1/code/problems/{id}/submit
GET  /api/v1/code/submissions/my
```

Admin API:

```http
GET    /api/v1/admin/code/problems
GET    /api/v1/admin/code/problems/{id}
POST   /api/v1/admin/code/problems
PUT    /api/v1/admin/code/problems/{id}
DELETE /api/v1/admin/code/problems/{id}
```

## 2. Database mới

Chạy file này trong SSMS trước khi test phân hệ Code Judge:

```text
D:\DevLearningHub\database\Upgrade_v12_Code_Playground_Judge.sql
```

Script sẽ tạo các bảng:

```text
CodingProblems
CodingTestCases
CodeSubmissions
CodeSubmissionTestCaseResults
```

Script cũng seed sẵn 2 bài mẫu:

```text
Sum Two Numbers
Reverse String
```

## 3. Cách chạy

API:

```powershell
cd D:\DevLearningHub\api\DevLearningHub.Api
dotnet clean
dotnet restore
dotnet build
dotnet run
```

Client:

```powershell
cd D:\DevLearningHub\client\devlearninghub-client
npm install --legacy-peer-deps
npm start
```

Admin:

```powershell
cd D:\DevLearningHub\admin\devlearninghub-admin
npm install --legacy-peer-deps
npm start
```

## 4. Runtime cần có trên máy chạy API

Để chạy code local, máy chạy API cần có runtime tương ứng:

```text
JavaScript: Node.js
Python: Python
Java: JDK, có javac/java trong PATH
C++: g++, có g++ trong PATH
```

Nếu máy chỉ có Node.js thì nên test JavaScript trước. Trên máy làm Angular thường đã có Node nên JavaScript là luồng test dễ nhất.

## 5. Test nhanh JavaScript

Vào User App:

```text
http://localhost:4200/learner/problems
```

Chọn bài `Sum Two Numbers`, để code JavaScript mặc định và bấm `Submit`.

Kết quả mong muốn:

```text
Accepted
3 / 3 test cases passed
```

Test Playground:

```text
http://localhost:4200/learner/playground
```

Chọn JavaScript, nhập STDIN:

```text
World
```

Bấm `Run Code`, kết quả mong muốn:

```text
Hello, World!
```

## 6. Ghi chú chuyên nghiệp

Bản v12 dùng local process runner có timeout để demo và kiểm thử chức năng. Khi triển khai production, nên chuyển phần execute code sang sandbox riêng như Docker executor, Kubernetes job hoặc Judge0 để cô lập tài nguyên, giới hạn network/file system và bảo mật tốt hơn.
