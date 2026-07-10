import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from '../core/services/auth.service';

@Component({ selector: 'app-login', standalone: true, imports: [CommonModule, FormsModule], templateUrl: './login.component.html' })
export class LoginComponent {
  emailOrUserName = 'admin@example.com';
  password = '123456Aa';
  error = '';
  loading = false;

  constructor(private auth: AuthService, private router: Router) {}

  submit(): void {
    this.error = '';
    this.loading = true;
    this.auth.login(this.emailOrUserName, this.password).subscribe({
      next: r => {
        this.loading = false;
        const user = r.data.user || {};
        const roles = user.roles || [];
        const permissions = [...(user.permissions || []), ...(user.effectivePermissions || [])];
        const canAccessAdmin = !!user.isAdminPortalAllowed
          || roles.includes('Admin')
          || roles.includes('Moderator')
          || permissions.includes('admin.access');

        if (!canAccessAdmin) {
          this.error = 'Tài khoản chưa có quyền truy cập trang quản trị.';
          return;
        }

        if (permissions.includes('forum.moderate') && !permissions.includes('dashboard.view') && !roles.includes('Admin')) {
          this.router.navigate(['/forum']);
          return;
        }

        this.router.navigate(['/dashboard']);
      },
      error: e => {
        this.loading = false;
        this.error = e?.error?.message || 'Đăng nhập thất bại';
      }
    });
  }
}
