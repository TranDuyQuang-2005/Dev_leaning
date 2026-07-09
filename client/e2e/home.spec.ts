import { test, expect } from '@playwright/test';

test('HOME_001 - Trang chu mo duoc', async ({ page }) => {
  await page.goto('/');

  await expect(page.locator('body')).toBeVisible();
  await expect(page.locator('body')).not.toContainText('Cannot GET');
  await expect(page.locator('body')).not.toContainText('Application error');
});