import { CommonModule } from '@angular/common';
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
  model = { email: '', token: '', newPassword: '', confirmPassword: '' };
  loading = false;
  error = '';

  constructor(private api: ApiService, private route: ActivatedRoute, private router: Router) {}

  ngOnInit(): void {
    this.model.email = this.route.snapshot.queryParamMap.get('email') || '';
    this.model.token = this.route.snapshot.queryParamMap.get('token') || '';
  }

  submit(): void {
    this.error = '';
    if (this.model.newPassword !== this.model.confirmPassword) {
      this.error = 'Mật khẩu xác nhận không khớp.';
      return;
    }
    this.loading = true;
    this.api.resetPassword(this.model).subscribe({
      next: () => {
        this.loading = false;
        this.router.navigate(['/login'], { queryParams: { message: 'Đặt lại mật khẩu thành công.' } });
      },
      error: e => {
        this.error = this.api.errorMessage(e, 'Đặt lại mật khẩu thất bại.');
        this.loading = false;
      }
    });
  }
}
