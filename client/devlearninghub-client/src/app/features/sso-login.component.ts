import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { AuthResponse, CurrentUser } from '../core/models/api.models';
import { AuthService } from '../core/services/auth.service';

@Component({
  selector: 'app-sso-login',
  standalone: true,
  imports: [CommonModule],
  template: `
    <main class="sso-page">
      <section class="sso-card">
        <div class="sso-spinner" *ngIf="!error"></div>

        <svg *ngIf="error" class="sso-icon-error" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <circle cx="12" cy="12" r="10"></circle>
          <path d="M12 8v5"></path>
          <path d="M12 16h.01"></path>
        </svg>

        <h1>{{ error ? 'Kh\u00f4ng th\u1ec3 chuy\u1ec3n phi\u00ean \u0111\u0103ng nh\u1eadp' : '\u0110ang m\u1edf User Forum...' }}</h1>
        <p>{{ error || 'H\u1ec7 th\u1ed1ng \u0111ang \u0111\u1ed3ng b\u1ed9 phi\u00ean \u0111\u0103ng nh\u1eadp t\u1eeb Admin sang User Workspace.' }}</p>

        <button type="button" *ngIf="error" (click)="goLogin()">\u0110\u0103ng nh\u1eadp l\u1ea1i</button>
      </section>
    </main>
  `,
  styles: [`
    .sso-page {
      min-height: 100vh;
      display: grid;
      place-items: center;
      background: #f5f7fb;
      padding: 24px;
    }
    .sso-card {
      width: min(440px, 100%);
      padding: 32px;
      border-radius: 24px;
      background: #fff;
      box-shadow: 0 18px 45px rgba(15, 23, 42, .12);
      text-align: center;
    }
    .sso-card h1 {
      margin: 16px 0 8px;
      font-size: 24px;
      color: #111827;
    }
    .sso-card p {
      margin: 0;
      color: #64748b;
      line-height: 1.6;
    }
    .sso-card button {
      margin-top: 18px;
      border: 0;
      border-radius: 12px;
      padding: 11px 18px;
      color: #fff;
      background: #2563eb;
      font-weight: 700;
      cursor: pointer;
    }
    .sso-spinner {
      width: 42px;
      height: 42px;
      margin: 0 auto;
      border-radius: 999px;
      border: 4px solid #dbeafe;
      border-top-color: #2563eb;
      animation: ssoSpin .8s linear infinite;
    }
    .sso-icon-error {
      width: 46px;
      height: 46px;
      color: #dc2626;
      margin-bottom: 4px;
    }
    @keyframes ssoSpin { to { transform: rotate(360deg); } }
  `]
})
export class SsoLoginComponent implements OnInit {
  error = '';

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private auth: AuthService
  ) {}

  ngOnInit(): void {
    const query = this.route.snapshot.queryParamMap;
    const accessToken = query.get('accessToken') || '';
    const refreshToken = query.get('refreshToken') || '';
    const userEncoded = query.get('user') || '';
    const redirect = this.safeRedirect(query.get('redirect') || '/learner/forum');

    if (!accessToken || !refreshToken || !userEncoded) {
      this.error = 'Thi\u1ebfu th\u00f4ng tin phi\u00ean \u0111\u0103ng nh\u1eadp. Vui l\u00f2ng quay l\u1ea1i Admin v\u00e0 m\u1edf l\u1ea1i User Forum.';
      return;
    }

    try {
      const user = JSON.parse(this.decodeBase64Url(userEncoded)) as CurrentUser;
      const session: AuthResponse = { accessToken, refreshToken, expiresIn: 0, user };
      this.auth.acceptExternalSession(session, redirect);
    } catch {
      this.error = 'Th\u00f4ng tin phi\u00ean \u0111\u0103ng nh\u1eadp kh\u00f4ng h\u1ee3p l\u1ec7. Vui l\u00f2ng \u0111\u0103ng nh\u1eadp l\u1ea1i.';
    }
  }

  goLogin(): void {
    this.router.navigate(['/login'], { replaceUrl: true });
  }

  private safeRedirect(value: string): string {
    if (!value || !value.startsWith('/')) return '/learner/forum';
    if (value.startsWith('//') || value.includes('://')) return '/learner/forum';
    return value;
  }

  private decodeBase64Url(value: string): string {
    let normalized = value.replace(/-/g, '+').replace(/_/g, '/');
    while (normalized.length % 4) normalized += '=';
    const binary = atob(normalized);
    const bytes = Uint8Array.from(binary, char => char.charCodeAt(0));
    return new TextDecoder().decode(bytes);
  }
}