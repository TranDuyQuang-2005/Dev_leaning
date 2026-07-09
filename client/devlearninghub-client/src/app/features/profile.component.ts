import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AuthService } from '../core/services/auth.service';
import { ApiService } from '../core/services/api.service';

@Component({
  selector: 'app-profile',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './profile.component.html'
})
export class ProfileComponent implements OnInit {
  profile: any = {};
  stats: any = {};
  editing = false;
  message = '';
  error = '';
  passwordMessage = '';
  passwordError = '';
  passwordForm = { currentPassword: '', newPassword: '', confirmPassword: '' };

  constructor(public auth: AuthService, private api: ApiService) {}

  get initials(): string {
    const n = this.auth.currentUser()?.fullName || this.profile.fullName || 'User';
    return n.split(' ').filter(Boolean).slice(0, 2).map((x: string) => x[0]).join('').toUpperCase();
  }

  get level(): number { return Math.max(1, Math.floor((this.stats.reputation || 0) / 1000) + 1); }
  get nextLevelXp(): number { return this.level * 1000; }
  get xpPercent(): number { return Math.min(100, Math.round(((this.stats.reputation || 0) % 1000) / 10)); }

  ngOnInit(): void {
    this.api.get<any>('/api/v1/users/me/profile').subscribe({
      next: (r: any) => this.profile = { ...r.data, fullName: r.data?.fullName || this.auth.currentUser()?.fullName },
      error: () => this.profile = { fullName: this.auth.currentUser()?.fullName }
    });
    this.api.get<any>('/api/v1/users/me/stats').subscribe({
      next: (r: any) => this.stats = r.data || {},
      error: () => this.stats = {}
    });
  }

  save(): void {
    this.message = '';
    this.error = '';
    this.api.put<any>('/api/v1/users/me/profile', this.profile).subscribe({
      next: () => this.message = 'Đã lưu hồ sơ.',
      error: e => this.error = this.api.errorMessage(e, 'Không lưu được hồ sơ.')
    });
  }

  changePassword(): void {
    this.passwordMessage = '';
    this.passwordError = '';
    if (this.passwordForm.newPassword !== this.passwordForm.confirmPassword) {
      this.passwordError = 'Mật khẩu xác nhận không khớp.';
      return;
    }

    this.api.changePassword(this.passwordForm).subscribe({
      next: () => {
        this.passwordMessage = 'Đổi mật khẩu thành công.';
        this.passwordForm = { currentPassword: '', newPassword: '', confirmPassword: '' };
      },
      error: e => this.passwordError = this.api.errorMessage(e, 'Không đổi được mật khẩu.')
    });
  }
}
