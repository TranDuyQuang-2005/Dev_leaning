import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { ApiService } from '../core/services/api.service';

@Component({
  selector: 'app-resend-verification',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './resend-verification.component.html'
})
export class ResendVerificationComponent {
  email = '';
  loading = false;
  message = '';
  error = '';

  constructor(private api: ApiService) {}

  submit(): void {
    this.message = '';
    this.error = '';
    this.loading = true;
    this.api.resendEmailVerification({ email: this.email }).subscribe({
      next: r => {
        this.message = r.message || 'Email xác thực đã được gửi. Vui lòng kiểm tra hộp thư.';
        this.loading = false;
      },
      error: e => {
        this.error = this.api.errorMessage(e, 'Không gửi lại được email xác minh.');
        this.loading = false;
      }
    });
  }
}
