import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { ApiService } from '../core/services/api.service';

@Component({
  selector: 'app-quiz-history',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './quiz-history.component.html'
})
export class QuizHistoryComponent implements OnInit {
  attempts: any[] = [];
  error = '';
  constructor(private api: ApiService) {}
  ngOnInit(): void {
    this.api.get<any>('/api/v1/quiz-attempts/me').subscribe({
      next: r => this.attempts = r.data || [],
      error: e => this.error = e?.error?.message || 'Không tải được lịch sử làm bài.'
    });
  }
}
