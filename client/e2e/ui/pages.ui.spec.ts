import { test } from '@playwright/test';
import { assertPageNotBroken } from '../helpers/ui';

const pages = [
  { name: 'Trang chu', url: '/' },
  { name: 'Quiz', url: '/quiz' },
  { name: 'Roadmaps', url: '/roadmaps' },
  { name: 'Problems', url: '/problems' },
  { name: 'Forum', url: '/forum' },
  { name: 'Leaderboard', url: '/leaderboard' }
];

for (const item of pages) {
  test(`UI_PAGE - ${item.name} khong bi loi hien thi`, async ({ page }) => {
    await page.goto(item.url);

    await assertPageNotBroken(page);
  });
}