import { test, expect } from '@playwright/test';
import {
  emailInput,
  passwordInput,
  loginButton,
  registerButton,
  assertPageNotBroken
} from '../helpers/ui';

test('UI_AUTH_001 - Trang login hien thi form dang nhap', async ({ page }) => {
  await page.goto('/login');

  await assertPageNotBroken(page);

  await expect(emailInput(page)).toBeVisible();
  await expect(passwordInput(page)).toBeVisible();
  await expect(loginButton(page)).toBeVisible();
});

test('UI_AUTH_002 - Dang nhap sai mat khau bi tu choi', async ({ page }) => {
  await page.goto('/login');

  await emailInput(page).fill('admin@example.com');
  await passwordInput(page).fill('sai-mat-khau');

  await loginButton(page).click();

  await expect(page.locator('body')).toContainText(/sai|khong dung|không đúng|invalid|error|failed|incorrect/i);
});

test('UI_AUTH_003 - Trang register hien thi form dang ky', async ({ page }) => {
  await page.goto('/register');

  await assertPageNotBroken(page);

  await expect(page.locator('input').first()).toBeVisible();
  await expect(registerButton(page)).toBeVisible();
});