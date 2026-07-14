import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from '../services/auth.service';

export const authGuard: CanActivateFn = () =>
  inject(AuthService).isLoggedIn() ? true : inject(Router).createUrlTree(['/login']);

export const adminGuard: CanActivateFn = () => {
  const a = inject(AuthService);
  return a.isLoggedIn() && a.canAccessAdmin() ? true : inject(Router).createUrlTree(['/login']);
};

export const staffGuard: CanActivateFn = () => {
  const a = inject(AuthService);
  return a.isLoggedIn() && (a.hasRole('Admin') || a.hasRole('Moderator') || a.hasPermission('forum.moderate')) ? true : inject(Router).createUrlTree(['/login']);
};

export const permissionGuard: CanActivateFn = (route) => {
  const a = inject(AuthService);
  if (!a.isLoggedIn() || !a.canAccessAdmin()) return inject(Router).createUrlTree(['/login']);
  const required = route.data?.['permissions'] as string[] | undefined;
  return !required?.length || a.hasRole('Admin') || a.hasAnyPermission(required)
    ? true
    : inject(Router).createUrlTree(['/dashboard']);
};
