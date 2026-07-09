# DevLearningHub v7 - Quiz Module Import Excel/CSV

Bản này sửa luồng import câu hỏi cho thực tế hơn:

- Người học/User không import file.
- Admin/Giảng viên nhập ngân hàng câu hỏi bằng file CSV mở được bằng Excel.
- JSON vẫn được giữ ở mục Advanced để developer seed/test dữ liệu, không còn là luồng chính.

## Cách dùng import câu hỏi thực tế

1. Chạy API, Client, Admin.
2. Vào Admin: http://localhost:4300
3. Login admin: admin@example.com / 123456Aa
4. Vào tab Import Questions.
5. Bấm Download CSV Template.
6. Mở file bằng Excel, điền câu hỏi.
7. Lưu lại dạng CSV UTF-8 hoặc CSV.
8. Upload CSV và bấm Import CSV.
9. Qua tab Questions kiểm tra câu hỏi.
10. Qua tab Quiz Sets tick chọn câu hỏi và lưu bộ đề.
11. User vào Learning để làm quiz.

## Cột CSV hỗ trợ

- CategoryId hoặc CategorySlug hoặc CategoryName
- Title
- Content
- QuestionExplanation
- Difficulty
- CorrectOption: A/B/C/D hoặc 1/2/3/4
- OptionA, OptionB, OptionC, OptionD
- OptionAExplanation, OptionBExplanation, OptionCExplanation, OptionDExplanation
- Source

## API mới

- POST /api/v1/questions/import-csv
- POST /api/v1/questions/import-json vẫn giữ cho Advanced/Developer

## Ghi chú

Hiện tại import Excel được triển khai theo dạng CSV để tránh phụ thuộc thư viện Excel bên ngoài. Admin có thể thao tác hoàn toàn bằng Excel: tải CSV mẫu, mở trong Excel, điền dữ liệu, Save As CSV rồi upload.
