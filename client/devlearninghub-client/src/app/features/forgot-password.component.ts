import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { ApiService } from '../core/services/api.service';

@Component({
  selector: 'app-forgot-password',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './forgot-password.component.html'
})
export class ForgotPasswordComponent {
  email = '';
  loading = false;
  message = '';
  error = '';

  constructor(private api: ApiService) {}

  submit(): void {
    this.message = '';
    this.error = '';
    this.loading = true;
    this.api.forgotPassword({ email: this.email }).subscribe({
      next: () => {
        this.message = 'Nếu email tồn tại, hệ thống đã gửi hướng dẫn đặt lại mật khẩu.';
        this.loading = false;
      },
      error: e => {
        this.error = this.api.errorMessage(e, 'Không gửi được yêu cầu đặt lại mật khẩu.');
        this.loading = false;
      }
    });
  }
}
