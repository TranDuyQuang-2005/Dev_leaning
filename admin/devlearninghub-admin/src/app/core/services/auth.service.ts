import { Injectable, signal } from '@angular/core';
import { Router } from '@angular/router';
import { catchError, of, tap } from 'rxjs';
import { AuthResponse, CurrentUser } from '../models/api.models';
import { ApiService } from './api.service';

@Injectable({ providedIn: 'root' })
export class AuthService {
  currentUser = signal<CurrentUser | null>(this.stored());
  private readonly userAppUrl = 'http://localhost:4200';

  constructor(private api: ApiService, private router: Router) {}

  login(emailOrUserName: string, password: string) {
    return this.api
      .post('/api/v1/auth/login', { emailOrUserName, password })
      .pipe(tap((r: any) => this.save(r.data)));
  }

  register(body: any) {
    return this.api.post('/api/v1/auth/register', body);
  }

  logout(redirectTo = '/login'): void {
    const refreshToken = localStorage.getItem('refreshToken') || '';
    const finish = () => this.clearSession(redirectTo);

    if (!refreshToken) {
      finish();
      return;
    }

    this.api
      .post('/api/v1/auth/logout', { refreshToken })
      .pipe(catchError(() => of(null)))
      .subscribe({ next: finish, error: finish });
  }

  logoutLocal(redirectTo = '/login'): void {
    this.clearSession(redirectTo);
  }

  isLoggedIn(): boolean {
    return !!localStorage.getItem('accessToken');
  }

  hasRole(role: string): boolean {
    return this.currentUser()?.roles?.includes(role) || false;
  }

  hasPermission(permission: string): boolean {
    const user = this.currentUser();
    const permissions = [...(user?.permissions || []), ...(user?.effectivePermissions || [])];
    return permissions.some(p => p.toLowerCase() === permission.toLowerCase());
  }

  hasAnyPermission(permissions: string[]): boolean {
    return permissions.some(permission => this.hasPermission(permission));
  }

  canAccessAdmin(): boolean {
    const user = this.currentUser();
    return !!user?.isAdminPortalAllowed
      || this.hasRole('Admin')
      || this.hasRole('Moderator')
      || this.hasPermission('admin.access');
  }

  openUserApp(target = '/learner/forum'): void {
    const url = this.buildUserAppSsoUrl(target);
    window.open(url, '_blank', 'noopener,noreferrer');
  }

  buildUserAppSsoUrl(target = '/learner/forum'): string {
    const accessToken = localStorage.getItem('accessToken') || '';
    const refreshToken = localStorage.getItem('refreshToken') || '';
    const userRaw = localStorage.getItem('currentUser') || '';

    if (!accessToken || !refreshToken || !userRaw) {
      return `${this.userAppUrl}/login`;
    }

    const params = new URLSearchParams();
    params.set('accessToken', accessToken);
    params.set('refreshToken', refreshToken);
    params.set('user', this.encodeBase64Url(userRaw));
    params.set('redirect', target || '/learner/forum');

    return `${this.userAppUrl}/sso-login?${params.toString()}`;
  }

  private save(data: AuthResponse): void {
    localStorage.setItem('accessToken', data.accessToken);
    localStorage.setItem('refreshToken', data.refreshToken);
    localStorage.setItem('currentUser', JSON.stringify(data.user));
    this.currentUser.set(data.user);
  }

  private clearSession(redirectTo: string): void {
    localStorage.removeItem('accessToken');
    localStorage.removeItem('refreshToken');
    localStorage.removeItem('currentUser');
    this.currentUser.set(null);
    this.router.navigate([redirectTo]);
  }

  private stored(): CurrentUser | null {
    const raw = localStorage.getItem('currentUser');
    if (!raw) return null;

    try {
      return JSON.parse(raw) as CurrentUser;
    } catch {
      localStorage.removeItem('currentUser');
      return null;
    }
  }

  private encodeBase64Url(value: string): string {
    const bytes = new TextEncoder().encode(value);
    let binary = '';
    bytes.forEach(byte => binary += String.fromCharCode(byte));
    return btoa(binary).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/g, '');
  }
}
