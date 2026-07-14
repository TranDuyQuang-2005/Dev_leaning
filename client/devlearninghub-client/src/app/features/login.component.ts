import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { AuthService } from '../core/services/auth.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './login.component.html'
})
export class LoginComponent implements OnInit {
  model = { emailOrUserName: 'admin@example.com', password: '123456Aa' };
  loading = false;
  errorMessage = '';
  infoMessage = '';

  constructor(private auth: AuthService, private router: Router, private route: ActivatedRoute) {}

  ngOnInit(): void {
    this.infoMessage = this.route.snapshot.queryParamMap.get('message') || '';
  }

  onSubmit(): void {
    this.errorMessage = '';
    this.infoMessage = '';
    this.loading = true;
    this.auth.login(this.model.emailOrUserName, this.model.password).subscribe({
      next: (r: any) => {
        this.loading = false;
        const roles = r?.data?.user?.roles || [];
        if (roles.includes('Admin')) {
          window.location.href = 'http://localhost:4300/dashboard';
          return;
        }
        this.router.navigate(['/learner/dashboard']);
      },
      error: (e: any) => {
        this.loading = false;
        this.errorMessage = e?.error?.message || 'Đăng nhập thất bại. Kiểm tra API, database hoặc tài khoản.';
      }
    });
  }
}
