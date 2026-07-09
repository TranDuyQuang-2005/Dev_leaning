# DevLearningHub - Quiz Module V6 Complete

Bản này bổ sung các phần còn thiếu của phân hệ trắc nghiệm:

## Backend/API đã bổ sung

- CRUD Category:
  - `POST /api/v1/categories`
  - `PUT /api/v1/categories/{id}`
  - `DELETE /api/v1/categories/{id}`
- CRUD Question:
  - `GET /api/v1/questions`
  - `POST /api/v1/questions`
  - `PUT /api/v1/questions/{id}`
  - `DELETE /api/v1/questions/{id}`
- CRUD Quiz Set:
  - `GET /api/v1/quiz-sets`
  - `GET /api/v1/quiz-sets/{id}`
  - `POST /api/v1/quiz-sets`
  - `PUT /api/v1/quiz-sets/{id}`
  - `DELETE /api/v1/quiz-sets/{id}`
- Quiz attempt:
  - Chặn số lượt làm bài theo `MaxAttempts`.
  - Trả về `TimeLimitMinutes`, `PassingScore`, `AllowReview`, `MaxAttempts` khi bắt đầu quiz.
  - Xử lý `ShuffleQuestions` và `ShuffleOptions`.
  - Submit xong trả về kết quả chi tiết gồm đáp án đúng, đáp án user chọn và explanation.
  - Lịch sử làm bài trả thêm `QuizTitle`, `QuizSetId`, `StartedAt`, `SubmittedAt`.

## Admin đã bổ sung

- Tạo/sửa/xóa Category.
- Tạo/sửa/xóa Question.
- Nhập explanation cho câu hỏi và từng đáp án.
- Import JSON câu hỏi.
- Tạo/sửa/xóa Quiz Set.
- Gắn câu hỏi vào Quiz Set bằng checkbox, không cần nhập ID thủ công.
- Cấu hình Quiz Set:
  - Time limit
  - Passing score
  - Max attempts
  - Allow review
  - Shuffle questions
  - Shuffle options
  - Status active/inactive

## User đã bổ sung

- Learning hiển thị dữ liệu thật từ CSDL.
- Learning hiển thị category, level, số câu, time limit, passing score, attempts còn lại, best score.
- Làm quiz có timer realtime.
- Hết giờ tự động nộp bài.
- Khi nộp nếu còn câu chưa chọn sẽ hỏi xác nhận.
- Submit xong hiển thị điểm, đúng/sai/bỏ qua, đáp án đúng và explanation.
- Thêm trang `Quiz History` để xem lịch sử và mở lại kết quả cũ.

## Cách chạy

```powershell
cd api\DevLearningHub.Api
dotnet restore
dotnet run
```

```powershell
cd client\devlearninghub-client
npm install --legacy-peer-deps
npm start
```

```powershell
cd admin\devlearninghub-admin
npm install --legacy-peer-deps
npm start
```

Mở:

- API: http://localhost:5000/swagger
- Client: http://localhost:4200
- Admin: http://localhost:4300

## Luồng test khuyến nghị

1. Login Admin.
2. Tạo Category.
3. Import hoặc tạo Questions.
4. Vào Quiz Sets.
5. Chọn Category và tick câu hỏi cần gắn.
6. Cấu hình Time Limit, Passing Score, Max Attempts, Shuffle.
7. Save Quiz Set.
8. Login User.
9. Vào Learning.
10. Start Quiz.
11. Test timer, submit thiếu câu, submit đủ câu.
12. Xem đáp án, explanation.
13. Vào Quiz History để xem lại kết quả.
14. Làm lại tới quá MaxAttempts để test chặn lượt.
