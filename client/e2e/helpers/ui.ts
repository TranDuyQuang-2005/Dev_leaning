import { Page, expect } from '@playwright/test';

export function emailInput(page: Page) {
  return page.locator(
    'input[type="email"], input[name="email"], input[name="emailOrUserName"], input[formcontrolname="email"], input[formcontrolname="emailOrUserName"], input[placeholder*="Email" i]'
  ).first();
}

export function passwordInput(page: Page) {
  return page.locator(
    'input[type="password"], input[name="password"], input[formcontrolname="password"], input[placeholder*="Password" i]'
  ).first();
}

export function loginButton(page: Page) {
  return page.getByRole('button', {
    name: /login|sign in|đăng nhập|dang nhap/i
  });
}

export function registerButton(page: Page) {
  return page.getByRole('button', {
    name: /register|create account|sign up|đăng ký|dang ky/i
  });
}

export function firstNameInput(page: Page) {
  return page.locator(
    'input[name="firstName"], input[formcontrolname="firstName"], input[placeholder*="First" i]'
  ).first();
}

export function lastNameInput(page: Page) {
  return page.locator(
    'input[name="lastName"], input[formcontrolname="lastName"], input[placeholder*="Last" i]'
  ).first();
}

export function usernameInput(page: Page) {
  return page.locator(
    'input[name="username"], input[name="userName"], input[formcontrolname="username"], input[formcontrolname="userName"], input[placeholder*="Username" i]'
  ).first();
}

export function registerEmailInput(page: Page) {
  return page.locator(
    'input[type="email"], input[name="email"], input[formcontrolname="email"], input[placeholder*="Email" i]'
  ).first();
}

export async function assertPageNotBroken(page: Page) {
  await expect(page.locator('body')).toBeVisible();
  await expect(page.locator('body')).not.toContainText('Cannot GET');
  await expect(page.locator('body')).not.toContainText('Application error');
  await expect(page.locator('body')).not.toContainText('This site can’t be reached');
}

export async function fillRegisterForm(page: Page, data: {
  firstName: string;
  lastName: string;
  username: string;
  email: string;
  password: string;
}) {
  await firstNameInput(page).fill(data.firstName);
  await lastNameInput(page).fill(data.lastName);
  await usernameInput(page).fill(data.username);
  await registerEmailInput(page).fill(data.email);

  const passwordInputs = page.locator('input[type="password"]');

  await passwordInputs.nth(0).fill(data.password);
  await passwordInputs.nth(1).fill(data.password);
}