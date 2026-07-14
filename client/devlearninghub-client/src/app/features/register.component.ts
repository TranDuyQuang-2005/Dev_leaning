import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../core/services/auth.service';

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './register.component.html'
})
export class RegisterComponent {
  firstName = '';
  lastName = '';
  model = { fullName: '', userName: '', email: '', password: '', confirmPassword: '' };
  loading = false;
  errorMessage = '';
  successMessage = '';
  emailError = '';
  emailSuggestionMessage = '';
  suggestedEmail = '';
  passwordErrors: string[] = [];
  confirmPasswordError = '';

  private readonly typoDomains: Record<string, string> = {
    'gmail.co': 'gmail.com',
    'gmai.com': 'gmail.com',
    'gmial.com': 'gmail.com',
    'gnail.com': 'gmail.com',
    'gmail.con': 'gmail.com',
    'gmail.cm': 'gmail.com',
    'yahoo.co': 'yahoo.com',
    'hotmial.com': 'hotmail.com',
    'outlook.co': 'outlook.com'
  };

  constructor(private auth: AuthService, private router: Router) {}

  onEmailChange(): void {
    this.validateEmail();
  }

  onPasswordChange(): void {
    this.validatePassword();
    this.validateConfirmPassword();
  }

  useSuggestedEmail(): void {
    if (!this.suggestedEmail) return;
    this.model.email = this.suggestedEmail;
    this.validateEmail();
  }

  onSubmit(): void {
    this.errorMessage = '';
    this.successMessage = '';
    this.model.fullName = `${this.firstName} ${this.lastName}`.trim();
    this.model.email = this.model.email.trim().toLowerCase();

    this.validateEmail();
    this.validatePassword();
    this.validateConfirmPassword();

    if (!this.model.fullName || !this.model.userName.trim()) {
      this.errorMessage = 'Vui lòng nhập đầy đủ họ tên và username.';
      return;
    }

    if (this.emailError || this.suggestedEmail || this.passwordErrors.length > 0 || this.confirmPasswordError) {
      this.errorMessage = 'Vui lòng kiểm tra lại thông tin đăng ký.';
      return;
    }

    this.loading = true;
    this.auth.register(this.model).subscribe({
      next: (res: any) => {
        this.loading = false;
        this.successMessage = res?.message || `Hệ thống đã gửi email xác thực đến ${this.model.email}. Vui lòng mở hộp thư và bấm liên kết xác thực.`;
        window.setTimeout(() => this.router.navigate(['/login']), 1200);
      },
      error: (e: any) => {
        this.loading = false;
        const payload = e?.error || {};
        const suggestion = payload?.suggestedEmail || payload?.data?.suggestedEmail;
        if (suggestion) {
          this.suggestedEmail = suggestion;
          const suggestedDomain = suggestion.split('@')[1] || suggestion;
          this.emailSuggestionMessage = `Có phải bạn muốn nhập ${suggestedDomain}?`;
        }
        this.errorMessage = payload?.message || payload?.errors?.[0]?.message || 'Đăng ký thất bại. Kiểm tra lại dữ liệu hoặc email/userName đã tồn tại.';
      }
    });
  }

  get canSubmit(): boolean {
    return !this.loading
      && !!this.firstName.trim()
      && !!this.lastName.trim()
      && !!this.model.userName.trim()
      && !!this.model.email.trim()
      && !!this.model.password
      && !!this.model.confirmPassword
      && !this.emailError
      && !this.suggestedEmail
      && this.passwordErrors.length === 0
      && !this.confirmPasswordError;
  }

  private validateEmail(): void {
    const email = this.model.email.trim().toLowerCase();
    this.emailError = '';
    this.emailSuggestionMessage = '';
    this.suggestedEmail = '';

    if (!email) {
      this.emailError = 'Email là bắt buộc.';
      return;
    }

    if (/\s/.test(email) || !/^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/.test(email)) {
      this.emailError = 'Email không đúng định dạng.';
      return;
    }

    const [localPart, domain] = email.split('@');
    const suggestedDomain = this.typoDomains[domain];
    if (suggestedDomain) {
      this.suggestedEmail = `${localPart}@${suggestedDomain}`;
      this.emailSuggestionMessage = `Có phải bạn muốn nhập ${suggestedDomain}?`;
    }
  }

  private validatePassword(): void {
    const password = this.model.password || '';
    const errors: string[] = [];
    if (!password) errors.push('Password là bắt buộc.');
    if (password.length < 8) errors.push('Password phải có ít nhất 8 ký tự.');
    if (!/[A-Z]/.test(password)) errors.push('Password cần có chữ hoa.');
    if (!/[a-z]/.test(password)) errors.push('Password cần có chữ thường.');
    if (!/\d/.test(password)) errors.push('Password cần có số.');
    if (!/[^A-Za-z0-9]/.test(password)) errors.push('Password cần có ký tự đặc biệt.');
    this.passwordErrors = errors;
  }

  private validateConfirmPassword(): void {
    this.confirmPasswordError = '';
    if (!this.model.confirmPassword) {
      this.confirmPasswordError = 'Confirm password là bắt buộc.';
      return;
    }

    if (this.model.password !== this.model.confirmPassword) {
      this.confirmPasswordError = 'Mật khẩu xác nhận không khớp.';
    }
  }
}
