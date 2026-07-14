import { CommonModule, Location } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { ApiService } from '../core/services/api.service';

@Component({
  selector: 'app-verify-email',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './verify-email.component.html'
})
export class VerifyEmailComponent implements OnInit {
  loading = false;
  message = '';
  error = '';
  canResend = false;

  constructor(private api: ApiService, private route: ActivatedRoute, private location: Location) {}

  ngOnInit(): void {
    const email = this.route.snapshot.queryParamMap.get('email') || '';
    const token = this.route.snapshot.queryParamMap.get('token') || '';
    this.location.replaceState('/verify-email');

    if (!email || !token) {
      this.error = 'Liên kết xác thực đã được xử lý hoặc không còn đầy đủ thông tin.';
      this.canResend = true;
      return;
    }

    this.verify(email, token);
  }

  private verify(email: string, token: string): void {
    this.loading = true;
    this.message = '';
    this.error = '';
    this.canResend = false;

    this.api.verifyEmail({ email, token }).subscribe({
      next: () => {
        this.message = 'Xác thực email thành công. Bạn có thể đăng nhập.';
        this.loading = false;
      },
      error: () => {
        this.error = 'Liên kết xác thực không hợp lệ hoặc đã hết hạn.';
        this.canResend = true;
        this.loading = false;
      }
    });
  }
}
