import { Injectable, signal } from '@angular/core';
import { Router } from '@angular/router';
import { tap } from 'rxjs';
import { AuthResponse, CurrentUser } from '../models/api.models';
import { ApiService } from './api.service';

@Injectable({ providedIn: 'root' })
export class AuthService {
  currentUser = signal<CurrentUser | null>(this.stored());

  constructor(private api: ApiService, private router: Router) {}

  login(emailOrUserName: string, password: string) {
    return this.api
      .post<AuthResponse>('/api/v1/auth/login', { emailOrUserName, password })
      .pipe(tap((r: any) => this.save(r.data)));
  }

  register(body: any) {
    return this.api.post<any>('/api/v1/auth/register', body);
  }

  acceptExternalSession(data: AuthResponse, redirectTo = '/learner/forum'): void {
    this.save(data);
    this.router.navigateByUrl(redirectTo || '/learner/forum', { replaceUrl: true });
  }

  logout(): void {
    localStorage.removeItem('accessToken');
    localStorage.removeItem('refreshToken');
    localStorage.removeItem('currentUser');
    this.currentUser.set(null);
    this.router.navigate(['/login']);
  }

  isLoggedIn(): boolean {
    return !!localStorage.getItem('accessToken');
  }

  hasRole(role: string): boolean {
    return this.currentUser()?.roles?.includes(role) || false;
  }

  private save(data: AuthResponse): void {
    localStorage.setItem('accessToken', data.accessToken);
    localStorage.setItem('refreshToken', data.refreshToken);
    localStorage.setItem('currentUser', JSON.stringify(data.user));
    this.currentUser.set(data.user);
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
}
