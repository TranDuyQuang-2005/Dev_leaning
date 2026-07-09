# DevLearningHub v5 - Quiz Result Explanation Fixed

Bản này sửa luồng nộp bài quiz:

- Submit quiz trả về kết quả chi tiết.
- Hiển thị đáp án người dùng đã chọn.
- Hiển thị đáp án đúng.
- Hiển thị lời giải thích của câu hỏi (`Questions.Explanation`).
- Hiển thị lời giải thích của từng đáp án (`QuestionOptions.Explanation`) nếu có.
- Thêm API `GET /api/v1/quiz-attempts/{id}/result` để xem lại kết quả chi tiết.

## Chạy

API:
```powershell
cd api\DevLearningHub.Api
dotnet restore
dotnet run
```

Client:
```powershell
cd client\devlearninghub-client
npm install --legacy-peer-deps
npm start
```

Admin:
```powershell
cd admin\devlearninghub-admin
npm install --legacy-peer-deps
npm start
```

## Test

1. Import câu hỏi JSON có `explanation`.
2. Tạo Quiz Set và gắn câu hỏi.
3. User vào Learning -> Start Quiz -> Submit Quiz.
4. Sau khi nộp, trang quiz sẽ hiện điểm, đúng/sai, đáp án đúng và giải thích.

Nếu câu hỏi không hiện giải thích, kiểm tra DB:

```sql
SELECT Id, Content, Explanation FROM Questions ORDER BY Id DESC;
SELECT Id, QuestionId, Content, IsCorrect, Explanation FROM QuestionOptions ORDER BY Id DESC;
```
