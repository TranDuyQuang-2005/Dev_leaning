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
        <h1>{{ error ? 'KhÃ´ng thá»ƒ chuyá»ƒn phiÃªn Ä‘Äƒng nháº­p' : 'Äang má»Ÿ User Forum...' }}</h1>
        <p>{{ error || 'Há»‡ thá»‘ng Ä‘ang Ä‘á»“ng bá»™ phiÃªn Ä‘Äƒng nháº­p tá»« Admin sang User Workspace.' }}</p>
        <button *ngIf="error" type="button" (click)="goLogin()">ÄÄƒng nháº­p láº¡i</button>
      </section>
    </main>
  `,
  styles: [`
    .sso-page { min-height: 100vh; display: grid; place-items: center; background: #f5f7fb; padding: 24px; }
    .sso-card { width: min(440px, 100%); padding: 32px; border-radius: 24px; background: #fff; box-shadow: 0 18px 45px rgba(15, 23, 42, .12); text-align: center; }
    .sso-card h1 { margin: 16px 0 8px; font-size: 24px; color: #111827; }
    .sso-card p { margin: 0; color: #64748b; line-height: 1.6; }
    .sso-card button { margin-top: 18px; border: 0; border-radius: 12px; padding: 11px 18px; color: #fff; background: #2563eb; font-weight: 700; cursor: pointer; }
    .sso-spinner { width: 42px; height: 42px; margin: 0 auto; border-radius: 999px; border: 4px solid #dbeafe; border-top-color: #2563eb; animation: ssoSpin .8s linear infinite; }
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
      this.error = 'Thiáº¿u thÃ´ng tin phiÃªn Ä‘Äƒng nháº­p. Vui lÃ²ng quay láº¡i Admin vÃ  má»Ÿ láº¡i User Forum.';
      return;
    }

    try {
      const user = JSON.parse(this.decodeBase64Url(userEncoded)) as CurrentUser;
      const session: AuthResponse = {
        accessToken,
        refreshToken,
        expiresIn: 0,
        user
      };

      this.auth.acceptExternalSession(session, redirect);
    } catch {
      this.error = 'ThÃ´ng tin phiÃªn Ä‘Äƒng nháº­p khÃ´ng há»£p lá»‡. Vui lÃ²ng Ä‘Äƒng nháº­p láº¡i.';
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
