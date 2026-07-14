import { CommonModule, Location } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { ApiService } from '../core/services/api.service';

@Component({
  selector: 'app-reset-password',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './reset-password.component.html'
})
export class ResetPasswordComponent implements OnInit {
  model = { newPassword: '', confirmPassword: '' };
  loading = false;
  error = '';
  sessionInvalid = false;
  private resetEmail = '';
  private resetToken = '';

  constructor(
    private api: ApiService,
    private route: ActivatedRoute,
    private router: Router,
    private location: Location) {}

  ngOnInit(): void {
    this.resetEmail = this.route.snapshot.queryParamMap.get('email') || '';
    this.resetToken = this.route.snapshot.queryParamMap.get('token') || '';
    this.location.replaceState('/reset-password');

    if (!this.resetEmail || !this.resetToken) {
      this.sessionInvalid = true;
      this.error = 'Phiên đặt lại mật khẩu không còn hiệu lực. Vui lòng mở lại liên kết trong email hoặc yêu cầu gửi lại email.';
    }
  }

  submit(): void {
    this.error = '';
    if (this.sessionInvalid || !this.resetEmail || !this.resetToken) {
      this.error = 'Phiên đặt lại mật khẩu không còn hiệu lực. Vui lòng mở lại liên kết trong email hoặc yêu cầu gửi lại email.';
      return;
    }

    const validationError = this.validatePassword();
    if (validationError) {
      this.error = validationError;
      return;
    }

    this.loading = true;
    this.api.resetPassword({
      email: this.resetEmail,
      token: this.resetToken,
      newPassword: this.model.newPassword,
      confirmPassword: this.model.confirmPassword
    }).subscribe({
      next: () => {
        this.loading = false;
        this.resetEmail = '';
        this.resetToken = '';
        this.router.navigate(['/login'], { queryParams: { message: 'Đặt lại mật khẩu thành công.' } });
      },
      error: () => {
        this.error = 'Đặt lại mật khẩu thất bại. Liên kết có thể không hợp lệ hoặc đã hết hạn.';
        this.loading = false;
      }
    });
  }

  private validatePassword(): string {
    const password = this.model.newPassword || '';
    const errors: string[] = [];
    if (!password) errors.push('Mật khẩu mới là bắt buộc.');
    if (password.length < 8) errors.push('Mật khẩu phải có ít nhất 8 ký tự.');
    if (!/[A-Z]/.test(password)) errors.push('Mật khẩu phải có ít nhất 1 chữ hoa.');
    if (!/[a-z]/.test(password)) errors.push('Mật khẩu phải có ít nhất 1 chữ thường.');
    if (!/[0-9]/.test(password)) errors.push('Mật khẩu phải có ít nhất 1 số.');
    if (!/[^A-Za-z0-9]/.test(password)) errors.push('Mật khẩu phải có ít nhất 1 ký tự đặc biệt.');
    if (password !== this.model.confirmPassword) errors.push('Xác nhận mật khẩu không khớp.');
    return errors.join('\n');
  }
}
