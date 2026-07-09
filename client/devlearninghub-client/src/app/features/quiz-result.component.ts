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
      this.error = 'KhÃ´ng tÃ¬m tháº¥y mÃ£ lÆ°á»£t lÃ m bÃ i.';
      return;
    }

    this.api.get<any>(`/api/v1/quiz-attempts/${attemptId}/result`).subscribe({
      next: (r: any) => this.result = r.data,
      error: (e: any) => this.error = e?.error?.message || 'KhÃ´ng táº£i Ä‘Æ°á»£c káº¿t quáº£ bÃ i lÃ m.'
    });
  }

  selectedText(question: any): string {
    const selected = question.options?.filter((x: any) => x.isSelected).map((x: any) => x.content) || [];
    return selected.length ? selected.join(', ') : 'ChÆ°a chá»n Ä‘Ã¡p Ã¡n';
  }

  correctText(question: any): string {
    const correct = question.options?.filter((x: any) => x.isCorrect).map((x: any) => x.content) || [];
    return correct.length ? correct.join(', ') : 'ChÆ°a cÃ³ Ä‘Ã¡p Ã¡n Ä‘Ãºng';
  }
}

