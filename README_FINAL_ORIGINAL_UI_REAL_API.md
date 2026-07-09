# DevLearningHub Angular ORIGINAL UI + REAL API FINAL

Bản này dùng đúng UI gốc từ `dev_learning.zip`, không nhúng bằng `innerHTML` cho các trang chính. Các trang chính đã được map thành Angular component thật và gọi API thật.

## Chức năng đã thao tác thật

Client `http://localhost:4200`:
- Landing giữ giao diện gốc.
- Login/Register gọi API thật.
- Dashboard lấy stats và lịch sử quiz từ SQL Server qua API.
- Learning lấy Quiz Sets từ CSDL qua `/api/v1/quiz-sets`.
- Quiz tạo attempt và submit đáp án thật qua API.
- Profile lấy/cập nhật profile thật.

Admin `http://localhost:4300`:
- Login admin gọi API thật.
- Dashboard lấy Users, Categories, Questions, Quiz Sets từ CSDL.
- Tạo Category thật.
- Tạo Question thật.
- Tạo Quiz Set thật.
- Import Questions JSON thật.

Các trang Forum/Problems/Playground/Roadmap/Leaderboard vẫn giữ giao diện gốc; phần Judge/Forum API full nằm ở giai đoạn sau vì backend hiện tại chưa có nghiệp vụ đó.

## Cách chạy

```powershell
cd api\DevLearningHub.Api
dotnet restore
dotnet run
```

```powershell
cd client\devlearninghub-client
npm install
npm start
```

```powershell
cd admin\devlearninghub-admin
npm install
npm start
```

Tài khoản admin:

```text
admin@example.com
123456Aa
```

## Lưu ý

- Không cần chạy patch, không cần giải nén RAR.
- `client` port 4200, `admin` port 4300, `api` port 5000.
- Nếu CSDL của bạn có dữ liệu thật, web sẽ hiển thị dữ liệu thật từ CSDL, không lấy data tĩnh cho các trang chính.
