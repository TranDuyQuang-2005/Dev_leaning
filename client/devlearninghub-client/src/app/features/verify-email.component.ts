import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { ApiService } from '../core/services/api.service';

@Component({
  selector: 'app-verify-email',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './verify-email.component.html'
})
export class VerifyEmailComponent implements OnInit {
  model = { email: '', token: '' };
  loading = false;
  message = '';
  error = '';

  constructor(private api: ApiService, private route: ActivatedRoute) {}

  ngOnInit(): void {
    this.model.email = this.route.snapshot.queryParamMap.get('email') || '';
    this.model.token = this.route.snapshot.queryParamMap.get('token') || '';
    if (this.model.email && this.model.token) this.verify();
  }

  verify(): void {
    this.loading = true;
    this.message = '';
    this.error = '';
    this.api.verifyEmail(this.model).subscribe({
      next: r => {
        this.message = r.message || 'Xác minh email thành công.';
        this.loading = false;
      },
      error: e => {
        this.error = this.api.errorMessage(e, 'Xác minh email thất bại.');
        this.loading = false;
      }
    });
  }
}
