import { Component, OnDestroy, OnInit } from '@angular/core';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../core/services/api.service';

@Component({
  selector: 'app-quiz',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './quiz.component.html'
})
export class QuizComponent implements OnInit, OnDestroy {
  attempt: any;
  result: any;
  answers: Record<number, number> = {};
  error = '';
  warning = '';
  isSubmitting = false;
  secondsLeft = 0;
  private timer?: any;

  constructor(
    private route: ActivatedRoute,
    private api: ApiService
  ) {}

  ngOnInit(): void {
    const quizSetId = Number(this.route.snapshot.paramMap.get('id'));
    this.api.post<any>('/api/v1/quiz-attempts', { quizSetId }).subscribe({
      next: (r: any) => {
        this.attempt = r.data;
        this.result = null;
        this.secondsLeft = (this.attempt?.timeLimitMinutes || 0) * 60;
        if (this.secondsLeft > 0) this.startTimer();
      },
      error: (e: any) => {
        this.error = e?.error?.message || 'KhÃ´ng báº¯t Ä‘áº§u Ä‘Æ°á»£c quiz. Kiá»ƒm tra quiz set cÃ³ cÃ¢u há»i chÆ°a hoáº·c báº¡n Ä‘Ã£ háº¿t lÆ°á»£t lÃ m bÃ i.';
      }
    });
  }

  ngOnDestroy(): void {
    if (this.timer) clearInterval(this.timer);
  }

  startTimer(): void {
    if (this.timer) clearInterval(this.timer);
    this.timer = setInterval(() => {
      if (this.result || this.isSubmitting) return;
      this.secondsLeft -= 1;
      if (this.secondsLeft <= 0) {
        this.secondsLeft = 0;
        clearInterval(this.timer);
        this.warning = 'ÄÃ£ háº¿t thá»i gian. Há»‡ thá»‘ng tá»± Ä‘á»™ng ná»™p bÃ i.';
        this.submit(true);
      }
    }, 1000);
  }

  get timerText(): string {
    if (!this.attempt?.timeLimitMinutes) return 'No limit';
    const m = Math.floor(this.secondsLeft / 60).toString().padStart(2, '0');
    const s = (this.secondsLeft % 60).toString().padStart(2, '0');
    return `${m}:${s}`;
  }

  get answeredCount(): number {
    return Object.keys(this.answers).filter(k => !!this.answers[Number(k)]).length;
  }

  get progressPercent(): number {
    const total = this.attempt?.questions?.length || 0;
    return total ? Math.round(this.answeredCount / total * 100) : 0;
  }

  submit(auto = false): void {
    if (!this.attempt?.attemptId) {
      this.error = 'KhÃ´ng tÃ¬m tháº¥y lÆ°á»£t lÃ m bÃ i.';
      return;
    }

    const total = this.attempt?.questions?.length || 0;
    const skipped = total - this.answeredCount;
    if (!auto && skipped > 0) {
      const ok = confirm(`Báº¡n cÃ²n ${skipped} cÃ¢u chÆ°a chá»n. Váº«n ná»™p bÃ i?`);
      if (!ok) return;
    }

    this.isSubmitting = true;
    this.error = '';

    const body = {
      answers: Object.keys(this.answers).map(k => ({
        questionId: Number(k),
        selectedOptionIds: [this.answers[Number(k)]]
      }))
    };

    this.api.post<any>(`/api/v1/quiz-attempts/${this.attempt.attemptId}/submit`, body).subscribe({
      next: (r: any) => {
        this.result = r.data;
        this.isSubmitting = false;
        if (this.timer) clearInterval(this.timer);
        localStorage.setItem('quiz-progress-' + this.attempt.quizSetId, '100');
        window.scrollTo({ top: 0, behavior: 'smooth' });
      },
      error: (e: any) => {
        this.isSubmitting = false;
        this.error = e?.error?.message || 'KhÃ´ng ná»™p Ä‘Æ°á»£c bÃ i.';
      }
    });
  }

  optionClass(option: any): Record<string, boolean> {
    if (!this.result) return {};
    return {
      'result-option-correct': option.isCorrect,
      'result-option-wrong': option.isSelected && !option.isCorrect,
      'result-option-selected': option.isSelected
    };
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

