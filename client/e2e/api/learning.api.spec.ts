import { test, expect, request } from '@playwright/test';

const API_URL = 'http://localhost:5000';

async function printResponse(response: any, name: string) {
  const body = await response.text();

  console.log(`\n===== ${name} =====`);
  console.log('STATUS:', response.status());
  console.log('BODY:', body);
  console.log('=====================\n');

  return body;
}

test('API_LEARNING_001 - Lay danh sach categories', async () => {
  const api = await request.newContext({ baseURL: API_URL });

  const response = await api.get('/api/v1/categories');

  await printResponse(response, 'GET /api/v1/categories');

  expect(response.ok()).toBeTruthy();

  await api.dispose();
});

test('API_LEARNING_002 - Lay danh sach quiz sets', async () => {
  const api = await request.newContext({ baseURL: API_URL });

  const response = await api.get('/api/v1/quiz-sets');

  await printResponse(response, 'GET /api/v1/quiz-sets');

  expect(response.ok()).toBeTruthy();

  await api.dispose();
});

test('API_LEARNING_003 - Kiem tra endpoint roadmaps', async () => {
  const api = await request.newContext({ baseURL: API_URL });

  const response = await api.get('/api/v1/roadmaps');

  await printResponse(response, 'GET /api/v1/roadmaps');

  expect([200, 404]).toContain(response.status());

  await api.dispose();
});