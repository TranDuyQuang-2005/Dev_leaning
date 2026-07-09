import { test, expect, request } from '@playwright/test';

const API_URL = 'http://localhost:5000';
const TEST_PASSWORD = 'Test@123456';

async function printResponseIfFailed(response: any) {
  if (!response.ok()) {
    const body = await response.text();
    console.log('STATUS:', response.status());
    console.log('BODY:', body);
  }
}

test('API_AUTH_001 - Dang ky tai khoan moi', async () => {
  const api = await request.newContext({ baseURL: API_URL });
  const now = Date.now();

  const response = await api.post('/api/v1/auth/register', {
    data: {
      fullName: `Auto Test ${now}`,
      userName: `autotest${now}`,
      email: `autotest${now}@gmail.com`,
      password: TEST_PASSWORD,
      confirmPassword: TEST_PASSWORD
    }
  });

  await printResponseIfFailed(response);

  expect([200, 201]).toContain(response.status());

  await api.dispose();
});

test('API_AUTH_002 - Dang nhap thanh cong', async () => {
  const api = await request.newContext({ baseURL: API_URL });
  const now = Date.now();

  const email = `login${now}@gmail.com`;
  const userName = `login${now}`;

  const registerResponse = await api.post('/api/v1/auth/register', {
    data: {
      fullName: `Login Test ${now}`,
      userName,
      email,
      password: TEST_PASSWORD,
      confirmPassword: TEST_PASSWORD
    }
  });

  await printResponseIfFailed(registerResponse);
  expect([200, 201]).toContain(registerResponse.status());

  const response = await api.post('/api/v1/auth/login', {
    data: {
      emailOrUserName: email,
      password: TEST_PASSWORD
    }
  });

  await printResponseIfFailed(response);

  expect(response.ok()).toBeTruthy();

  const json = await response.json();
  const text = JSON.stringify(json);

  expect(text).toMatch(/accessToken|token/i);

  await api.dispose();
});

test('API_AUTH_003 - Dang nhap sai mat khau bi tu choi', async () => {
  const api = await request.newContext({ baseURL: API_URL });

  const response = await api.post('/api/v1/auth/login', {
    data: {
      emailOrUserName: 'admin@example.com',
      password: 'sai-mat-khau'
    }
  });

  expect([400, 401]).toContain(response.status());

  await api.dispose();
});