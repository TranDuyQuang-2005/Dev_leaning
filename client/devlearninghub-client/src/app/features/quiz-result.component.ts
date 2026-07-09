import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { CommonModule } from '@angular/common';
import { ApiService } from '../core/services/api.service';

@Component({
  selector: 'app-quiz-result',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './quiz-result.component.html'
})
export class QuizResultComponent implements OnInit {
  result: any;
  error = '';

  constructor(
    private route: ActivatedRoute,
    private api: ApiService
  ) {}

  ngOnInit(): void {
    const attemptId = Number(this.route.snapshot.paramMap.get('attemptId'));
    if (!attemptId) {
      this.error = 'Không tìm thấy mã lượt làm bài.';
      return;
    }

    this.api.get<any>(`/api/v1/quiz-attempts/${attemptId}/result`).subscribe({
      next: (r: any) => this.result = r.data,
      error: (e: any) => this.error = e?.error?.message || 'Không tải được kết quả bài làm.'
    });
  }

  selectedText(question: any): string {
    const selected = question.options?.filter((x: any) => x.isSelected).map((x: any) => x.content) || [];
    return selected.length ? selected.join(', ') : 'Chưa chọn đáp án';
  }

  correctText(question: any): string {
    const correct = question.options?.filter((x: any) => x.isCorrect).map((x: any) => x.content) || [];
    return correct.length ? correct.join(', ') : 'Chưa có đáp án đúng';
  }
}

