# DevLearningHub Angular Original UI Real API - FINAL v4 BUILD OK

Bản này sửa lỗi build Angular ở `client/src/app/features/playground.component.ts`.

## Đã kiểm tra

- `client/devlearninghub-client`: đã chạy `npm install --legacy-peer-deps` và `npm run build` thành công.
- `admin/devlearninghub-admin`: đã chạy `npm install --legacy-peer-deps` và `npm run build` thành công.

## Cách chạy

### 1. Chạy API

```powershell
cd api\DevLearningHub.Api
dotnet restore
dotnet run
```

API: `http://localhost:5000/swagger`

### 2. Chạy Client

```powershell
cd client\devlearninghub-client
npm install --legacy-peer-deps
npm start
```

Client: `http://localhost:4200`

### 3. Chạy Admin

```powershell
cd admin\devlearninghub-admin
npm install --legacy-peer-deps
npm start
```

Admin: `http://localhost:4300`

## Tài khoản admin demo

```text
admin@example.com
123456Aa
```

## Ghi chú

- Không dùng `OriginalPageComponent`/`LegacyPageComponent` cho các trang chính.
- UI dùng lại CSS/assets gốc trong `src/assets`.
- Client/Admin dùng Angular component thật cho các chức năng chính.
- Dữ liệu chính lấy từ API/CSDL: Auth, Dashboard, Learning, Quiz, Profile, Admin Users/Categories/Questions/Quiz Sets/Import.
