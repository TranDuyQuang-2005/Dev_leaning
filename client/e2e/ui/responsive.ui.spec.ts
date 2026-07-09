import { test, expect } from '@playwright/test';
import {
  emailInput,
  passwordInput,
  loginButton,
  assertPageNotBroken
} from '../helpers/ui';

async function expectNoHorizontalScroll(page: any) {
  const result = await page.evaluate(() => {
    return document.documentElement.scrollWidth <= document.documentElement.clientWidth + 2;
  });

  expect(result).toBeTruthy();
}

test('UI_RESPONSIVE_001 - Trang login hien thi tot tren kich thuoc man hinh nho', async ({ page }) => {
  await page.setViewportSize({
    width: 390,
    height: 844
  });

  await page.goto('/login');

  await assertPageNotBroken(page);

  await expect(emailInput(page)).toBeVisible();
  await expect(passwordInput(page)).toBeVisible();
  await expect(loginButton(page)).toBeVisible();

  await expectNoHorizontalScroll(page);
});

test('UI_RESPONSIVE_002 - Cac trang chinh khong bi loi tren kich thuoc man hinh nho', async ({ page }) => {
  await page.setViewportSize({
    width: 390,
    height: 844
  });

  const routes = ['/', '/quiz', '/roadmaps', '/problems', '/forum', '/leaderboard'];

  for (const route of routes) {
    await page.goto(route);

    await assertPageNotBroken(page);
    await expectNoHorizontalScroll(page);
  }
});