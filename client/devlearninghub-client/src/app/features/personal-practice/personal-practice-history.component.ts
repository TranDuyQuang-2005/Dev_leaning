import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { RouterLink } from '@angular/router';
import { ApiService } from '../../core/services/api.service';

@Component({
  selector: 'app-personal-practice-history',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './personal-practice-history.component.html'
})
export class PersonalPracticeHistoryComponent implements OnInit {
  attempts: any[] = [];
  loading = false;
  error = '';

  constructor(private api: ApiService) {}

  ngOnInit(): void {
    this.loading = true;
    this.api.getPracticeAttempts().subscribe({
      next: r => {
        const data: any = r.data || [];
        this.attempts = Array.isArray(data) ? data : data.items || [];
        this.loading = false;
      },
      error: e => {
        this.error = this.api.errorMessage(e, 'Không tải được lịch sử tự luyện.');
        this.loading = false;
      }
    });
  }
}
