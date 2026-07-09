import { test } from '@playwright/test';
import {
  createApiContext,
  createRandomUser,
  registerUser,
  createAndLoginUser,
  authHeaders,
  expectStatus,
  printResponse
} from '../helpers/api';
import { ROUTES, WEAK_PASSWORD, STRONG_PASSWORD } from '../helpers/env';

test('SEC_001 - Khong cho truy cap profile khi thieu token', async () => {
  const api = await createApiContext();

  const response = await api.get(ROUTES.profile);

  await expectStatus(response, [401, 403], 'GET PROFILE WITHOUT TOKEN');

  await api.dispose();
});

test('SEC_002 - Khong cho truy cap profile voi token gia', async () => {
  const api = await createApiContext();

  const response = await api.get(ROUTES.profile, {
    headers: authHeaders('fake-token-123')
  });

  await expectStatus(response, [401, 403], 'GET PROFILE WITH FAKE TOKEN');

  await api.dispose();
});

test('SEC_003 - Khong cho goi /me voi token sai', async () => {
  const api = await createApiContext();

  const response = await api.get(ROUTES.me, {
    headers: authHeaders('invalid.jwt.token')
  });

  await expectStatus(response, [401, 403], 'GET ME WITH INVALID TOKEN');

  await api.dispose();
});

test('SEC_004 - Chan SQL Injection trong login', async () => {
  const api = await createApiContext();

  const response = await api.post(ROUTES.login, {
    data: {
      emailOrUserName: "' OR 1=1 --",
      password: "' OR 1=1 --"
    }
  });

  await expectStatus(response, [400, 401], 'SQL INJECTION LOGIN');

  await api.dispose();
});

test('SEC_005 - Khong cho dang ky email sai dinh dang', async () => {
  const api = await createApiContext();
  const now = Date.now();

  const response = await api.post(ROUTES.register, {
    data: {
      fullName: `Invalid Email ${now}`,
      userName: `invalidemail${now}`,
      email: `invalid-email-${now}`,
      password: STRONG_PASSWORD,
      confirmPassword: STRONG_PASSWORD
    }
  });

  await printResponse(response, 'REGISTER INVALID EMAIL');

  await expectStatus(response, [400, 422], 'REGISTER INVALID EMAIL');

  await api.dispose();
});

test('SEC_006 - Khong cho dang ky password yeu', async () => {
  const api = await createApiContext();
  const now = Date.now();

  const response = await api.post(ROUTES.register, {
    data: {
      fullName: `Weak Password ${now}`,
      userName: `weakpass${now}`,
      email: `weakpass${now}@gmail.com`,
      password: WEAK_PASSWORD,
      confirmPassword: WEAK_PASSWORD
    }
  });

  await expectStatus(response, [400, 422], 'REGISTER WEAK PASSWORD');

  await api.dispose();
});

test('SEC_007 - Khong cho dang ky khi confirmPassword khong khop', async () => {
  const api = await createApiContext();
  const now = Date.now();

  const response = await api.post(ROUTES.register, {
    data: {
      fullName: `Mismatch Password ${now}`,
      userName: `mismatch${now}`,
      email: `mismatch${now}@gmail.com`,
      password: STRONG_PASSWORD,
      confirmPassword: 'Khac@123456'
    }
  });

  await expectStatus(response, [400, 422], 'REGISTER PASSWORD MISMATCH');

  await api.dispose();
});

test('SEC_008 - Khong cho dang ky trung email', async () => {
  const api = await createApiContext();
  const user = createRandomUser('duplicate');

  await registerUser(api, user);

  const response = await api.post(ROUTES.register, {
    data: {
      fullName: 'Duplicate Email',
      userName: `${user.userName}2`,
      email: user.email,
      password: user.password,
      confirmPassword: user.password
    }
  });

  await expectStatus(response, [400, 409], 'REGISTER DUPLICATE EMAIL');

  await api.dispose();
});

test('SEC_009 - Khong cho dang ky trung username', async () => {
  const api = await createApiContext();
  const user = createRandomUser('duplicateuser');

  await registerUser(api, user);

  const response = await api.post(ROUTES.register, {
    data: {
      fullName: 'Duplicate Username',
      userName: user.userName,
      email: `other${Date.now()}@gmail.com`,
      password: user.password,
      confirmPassword: user.password
    }
  });

  await expectStatus(response, [400, 409], 'REGISTER DUPLICATE USERNAME');

  await api.dispose();
});

test('SEC_010 - Khong cho tao category khi thieu token', async () => {
  const api = await createApiContext();

  const response = await api.post(ROUTES.categories, {
    data: {
      parentId: null,
      name: `Security Category ${Date.now()}`,
      slug: `security-category-${Date.now()}`,
      description: 'Test security',
      iconUrl: null,
      displayOrder: 1,
      status: 1
    }
  });

  await expectStatus(response, [401, 403], 'CREATE CATEGORY WITHOUT TOKEN');

  await api.dispose();
});

test('SEC_011 - User thuong khong duoc goi API roles admin', async () => {
  const { api, accessToken } = await createAndLoginUser('normaluser');

  const response = await api.get(ROUTES.roles, {
    headers: authHeaders(accessToken)
  });

  await expectStatus(response, [401, 403, 404], 'NORMAL USER GET ROLES');

  await api.dispose();
});

test('SEC_012 - User thuong khong duoc goi API permissions admin', async () => {
  const { api, accessToken } = await createAndLoginUser('normaluserperm');

  const response = await api.get(ROUTES.permissions, {
    headers: authHeaders(accessToken)
  });

  await expectStatus(response, [401, 403, 404], 'NORMAL USER GET PERMISSIONS');

  await api.dispose();
});

test('SEC_013 - Refresh token gia bi tu choi', async () => {
  const api = await createApiContext();

  const response = await api.post(ROUTES.refreshToken, {
    data: {
      refreshToken: 'fake-refresh-token'
    }
  });

  await expectStatus(response, [400, 401, 404], 'FAKE REFRESH TOKEN');

  await api.dispose();
});

test('SEC_014 - Payload XSS khong duoc lam API loi 500', async () => {
  const api = await createApiContext();
  const now = Date.now();

  const response = await api.post(ROUTES.register, {
    data: {
      fullName: `<script>alert('xss')</script> Auto ${now}`,
      userName: `xss${now}`,
      email: `xss${now}@gmail.com`,
      password: STRONG_PASSWORD,
      confirmPassword: STRONG_PASSWORD
    }
  });

  await printResponse(response, 'REGISTER WITH XSS PAYLOAD');

  if (response.status() >= 500) {
    throw new Error('API bi loi 500 khi nhan payload XSS');
  }

  await api.dispose();
});

test('SEC_015 - Query injection khong lam categories bi loi 500', async () => {
  const api = await createApiContext();

  const response = await api.get(`${ROUTES.categories}?keyword=' OR 1=1 --`);

  await printResponse(response, 'CATEGORY QUERY INJECTION');

  if (response.status() >= 500) {
    throw new Error('API bi loi 500 khi nhan query injection');
  }

  await api.dispose();
});