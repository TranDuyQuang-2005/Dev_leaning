import { test } from '@playwright/test';
import {
  createApiContext,
  expectStatus
} from '../helpers/api';
import { ROUTES, STRONG_PASSWORD } from '../helpers/env';

test('AUTH_NEG_001 - Dang ky thieu fullName', async () => {
  const api = await createApiContext();
  const now = Date.now();

  const response = await api.post(ROUTES.register, {
    data: {
      fullName: '',
      userName: `nofullname${now}`,
      email: `nofullname${now}@gmail.com`,
      password: STRONG_PASSWORD,
      confirmPassword: STRONG_PASSWORD
    }
  });

  await expectStatus(response, [400, 422], 'REGISTER MISSING FULLNAME');

  await api.dispose();
});

test('AUTH_NEG_002 - Dang ky thieu username', async () => {
  const api = await createApiContext();
  const now = Date.now();

  const response = await api.post(ROUTES.register, {
    data: {
      fullName: `No Username ${now}`,
      userName: '',
      email: `nousername${now}@gmail.com`,
      password: STRONG_PASSWORD,
      confirmPassword: STRONG_PASSWORD
    }
  });

  await expectStatus(response, [400, 422], 'REGISTER MISSING USERNAME');

  await api.dispose();
});

test('AUTH_NEG_003 - Dang ky thieu email', async () => {
  const api = await createApiContext();
  const now = Date.now();

  const response = await api.post(ROUTES.register, {
    data: {
      fullName: `No Email ${now}`,
      userName: `noemail${now}`,
      email: '',
      password: STRONG_PASSWORD,
      confirmPassword: STRONG_PASSWORD
    }
  });

  await expectStatus(response, [400, 422], 'REGISTER MISSING EMAIL');

  await api.dispose();
});

test('AUTH_NEG_004 - Dang ky thieu password', async () => {
  const api = await createApiContext();
  const now = Date.now();

  const response = await api.post(ROUTES.register, {
    data: {
      fullName: `No Password ${now}`,
      userName: `nopassword${now}`,
      email: `nopassword${now}@gmail.com`,
      password: '',
      confirmPassword: ''
    }
  });

  await expectStatus(response, [400, 422], 'REGISTER MISSING PASSWORD');

  await api.dispose();
});

test('AUTH_NEG_005 - Dang nhap tai khoan khong ton tai', async () => {
  const api = await createApiContext();

  const response = await api.post(ROUTES.login, {
    data: {
      emailOrUserName: `notfound${Date.now()}@gmail.com`,
      password: STRONG_PASSWORD
    }
  });

  await expectStatus(response, [400, 401, 404], 'LOGIN USER NOT FOUND');

  await api.dispose();
});

test('AUTH_NEG_006 - Khong cho dang nhap khi thieu emailOrUserName', async () => {
  const api = await createApiContext();

  const response = await api.post(ROUTES.login, {
    data: {
      emailOrUserName: '',
      password: STRONG_PASSWORD
    }
  });

  await expectStatus(response, [400, 401, 422], 'LOGIN MISSING USERNAME');

  await api.dispose();
});

test('AUTH_NEG_007 - Khong cho dang nhap khi thieu password', async () => {
  const api = await createApiContext();

  const response = await api.post(ROUTES.login, {
    data: {
      emailOrUserName: 'admin@example.com',
      password: ''
    }
  });

  await expectStatus(response, [400, 401, 422], 'LOGIN MISSING PASSWORD');

  await api.dispose();
});