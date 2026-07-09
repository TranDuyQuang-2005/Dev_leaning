import { test } from '@playwright/test';
import {
  createAndLoginUser,
  createApiContext,
  authHeaders,
  expectStatus
} from '../helpers/api';
import { ROUTES } from '../helpers/env';

test('API_USER_001 - Dang nhap roi lay profile', async () => {
  const { api, accessToken } = await createAndLoginUser('profileuser');

  const response = await api.get(ROUTES.profile, {
    headers: authHeaders(accessToken)
  });

  await expectStatus(response, [200], 'GET PROFILE WITH TOKEN');

  await api.dispose();
});

test('API_USER_002 - Khong co token thi khong lay duoc profile', async () => {
  const api = await createApiContext();

  const response = await api.get(ROUTES.profile);

  await expectStatus(response, [401, 403], 'GET PROFILE WITHOUT TOKEN');

  await api.dispose();
});