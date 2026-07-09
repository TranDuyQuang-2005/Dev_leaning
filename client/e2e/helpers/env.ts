/// <reference types="node" />

export const API_URL = process.env.API_URL || 'http://localhost:5000';
export const CLIENT_URL = process.env.CLIENT_URL || 'http://localhost:4200';

export const STRONG_PASSWORD = 'Test@123456';
export const WEAK_PASSWORD = '123';

export const ROUTES = {
  register: '/api/v1/auth/register',
  login: '/api/v1/auth/login',
  refreshToken: '/api/v1/auth/refresh-token',
  logout: '/api/v1/auth/logout',
  me: '/api/v1/auth/me',

  roles: '/api/v1/auth/roles',
  permissions: '/api/v1/auth/permissions',

  profile: '/api/v1/users/me/profile',
  settings: '/api/v1/users/me/settings',
  stats: '/api/v1/users/me/stats',

  categories: '/api/v1/categories',
  quizSets: '/api/v1/quiz-sets',
  roadmaps: '/api/v1/roadmaps'
};