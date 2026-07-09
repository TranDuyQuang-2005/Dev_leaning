# Bộ test Postman - DevLearningHub Modular Monolith

Base URL:

```text
http://localhost:5000
```

## 1. Register

POST `/api/v1/auth/register`

```json
{
  "fullName": "Nguyen Van A",
  "userName": "user1",
  "email": "user1@example.com",
  "password": "123456Aa",
  "confirmPassword": "123456Aa"
}
```

## 2. Login

POST `/api/v1/auth/login`

```json
{
  "emailOrUserName": "user1@example.com",
  "password": "123456Aa"
}
```

Copy `data.accessToken`.

## 3. Me

GET `/api/v1/auth/me`

Authorization: Bearer Token.

## 4. Create Category

POST `/api/v1/categories`

```json
{
  "parentId": null,
  "name": "SQL Cơ Bản",
  "slug": "sql-co-ban-test-01",
  "description": "Chủ đề SQL cơ bản",
  "iconUrl": null,
  "displayOrder": 1,
  "status": 1
}
```

## 5. Create Question

POST `/api/v1/questions`

```json
{
  "categoryId": 1,
  "title": "Lệnh SELECT dùng để làm gì?",
  "content": "Trong SQL, lệnh SELECT được dùng để làm gì?",
  "explanation": "SELECT dùng để truy vấn dữ liệu.",
  "difficulty": 1,
  "questionType": 1,
  "status": 2,
  "source": "SQL Basic",
  "options": [
    { "content": "Dùng để truy vấn dữ liệu", "isCorrect": true, "explanation": "Đúng", "displayOrder": 1 },
    { "content": "Dùng để xóa database", "isCorrect": false, "explanation": "Sai", "displayOrder": 2 },
    { "content": "Dùng để tạo bảng", "isCorrect": false, "explanation": "Sai", "displayOrder": 3 },
    { "content": "Dùng để cập nhật dữ liệu", "isCorrect": false, "explanation": "Sai", "displayOrder": 4 }
  ]
}
```

## 6. Create Quiz Set

POST `/api/v1/quiz-sets`

```json
{
  "categoryId": 1,
  "title": "Quiz SQL Cơ Bản 01",
  "slug": "quiz-sql-co-ban-01",
  "description": "Bài kiểm tra SQL cơ bản",
  "difficulty": 1,
  "quizType": 1,
  "timeLimitMinutes": 10,
  "passingScore": 7,
  "allowReview": true,
  "shuffleQuestions": false,
  "shuffleOptions": false,
  "maxAttempts": null,
  "status": 2,
  "questions": [
    { "questionId": 1, "displayOrder": 1, "score": 1 }
  ]
}
```

## 7. Start Quiz

POST `/api/v1/quiz-attempts`

```json
{
  "quizSetId": 1
}
```

## 8. Submit Quiz

POST `/api/v1/quiz-attempts/{attemptId}/submit`

```json
{
  "answers": [
    {
      "questionId": 1,
      "selectedOptionIds": [1]
    }
  ]
}
```

## 9. Upload file

POST `/api/v1/files/upload`

Body: form-data

- key: file
- type: File

## 10. Import questions JSON

POST `/api/v1/questions/import-json`

Body: form-data

- key: file
- type: File
- value: questions.json

JSON mẫu:

```json
[
  {
    "categoryId": 1,
    "title": "WHERE dùng để làm gì?",
    "content": "Trong SQL, WHERE dùng để làm gì?",
    "explanation": "WHERE dùng để lọc dữ liệu.",
    "difficulty": 1,
    "questionType": 1,
    "status": 2,
    "source": "Import JSON",
    "options": [
      { "content": "Lọc dữ liệu", "isCorrect": true, "explanation": "Đúng", "displayOrder": 1 },
      { "content": "Sắp xếp dữ liệu", "isCorrect": false, "explanation": "Sai", "displayOrder": 2 }
    ]
  }
]
```
