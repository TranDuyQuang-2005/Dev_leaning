import { request, expect, APIRequestContext, APIResponse } from '@playwright/test';
import { API_URL, ROUTES, STRONG_PASSWORD } from './env';

export type TestUser = {
  fullName: string;
  userName: string;
  email: string;
  password: string;
};

export async function createApiContext(): Promise<APIRequestContext> {
  return await request.newContext({
    baseURL: API_URL,
    extraHTTPHeaders: {
      Accept: 'application/json'
    }
  });
}

export function createRandomUser(prefix = 'autotest'): TestUser {
  const now = Date.now();

  return {
    fullName: `Auto Test ${now}`,
    userName: `${prefix}${now}`,
    email: `${prefix}${now}@gmail.com`,
    password: STRONG_PASSWORD
  };
}

export function authHeaders(token: string) {
  return {
    Authorization: `Bearer ${token}`
  };
}

export async function printResponse(response: APIResponse, label: string) {
  const body = await response.text();

  console.log(`\n===== ${label} =====`);
  console.log('STATUS:', response.status());
  console.log('BODY:', body);
  console.log('=====================\n');

  return body;
}

export async function expectStatus(
  response: APIResponse,
  expectedStatuses: number[],
  label: string
) {
  if (!expectedStatuses.includes(response.status())) {
    await printResponse(response, label);
  }

  expect(expectedStatuses).toContain(response.status());
}

export function getData(json: any) {
  return json?.data ?? json;
}

export function getAccessToken(json: any): string | undefined {
  const data = getData(json);

  return (
    data?.accessToken ||
    data?.token ||
    data?.access_token ||
    json?.accessToken ||
    json?.token
  );
}

export function getRefreshToken(json: any): string | undefined {
  const data = getData(json);

  return (
    data?.refreshToken ||
    data?.refresh_token ||
    json?.refreshToken
  );
}

export async function registerUser(api: APIRequestContext, user: TestUser) {
  const response = await api.post(ROUTES.register, {
    data: {
      fullName: user.fullName,
      userName: user.userName,
      email: user.email,
      password: user.password,
      confirmPassword: user.password
    }
  });

  await expectStatus(response, [200, 201], 'REGISTER USER');

  return response;
}

export async function loginUser(
  api: APIRequestContext,
  emailOrUserName: string,
  password: string
) {
  const response = await api.post(ROUTES.login, {
    data: {
      emailOrUserName,
      password
    }
  });

  await expectStatus(response, [200], 'LOGIN USER');

  const json = await response.json();
  const accessToken = getAccessToken(json);
  const refreshToken = getRefreshToken(json);

  expect(accessToken).toBeTruthy();

  return {
    response,
    json,
    accessToken: accessToken!,
    refreshToken
  };
}

export async function createAndLoginUser(prefix = 'autotest') {
  const api = await createApiContext();
  const user = createRandomUser(prefix);

  await registerUser(api, user);

  const login = await loginUser(api, user.email, user.password);

  return {
    api,
    user,
    accessToken: login.accessToken,
    refreshToken: login.refreshToken
  };
}