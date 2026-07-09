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
  lessonId?: number;
  private timer?: any;

  constructor(
    private route: ActivatedRoute,
    private api: ApiService
  ) {}

  ngOnInit(): void {
    const quizSetId = Number(this.route.snapshot.paramMap.get('id'));
    const queryLessonId = Number(this.route.snapshot.queryParamMap.get('lessonId') || this.route.snapshot.queryParamMap.get('roadmapLessonId') || 0);
    this.lessonId = queryLessonId > 0 ? queryLessonId : undefined;
    const body: any = { quizSetId };
    if (this.lessonId) body.lessonId = this.lessonId;
    this.api.post<any>('/api/v1/quiz-attempts', body).subscribe({
      next: (r: any) => {
        this.attempt = r.data;
        this.result = null;
        this.secondsLeft = (this.attempt?.timeLimitMinutes || 0) * 60;
        if (this.secondsLeft > 0) this.startTimer();
      },
      error: (e: any) => {
        this.error = e?.error?.message || 'Không bắt đầu được quiz. Kiểm tra quiz set có câu hỏi chưa hoặc bạn đã hết lượt làm bài.';
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
        this.warning = 'Đã hết thời gian. Hệ thống tự động nộp bài.';
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
      this.error = 'Không tìm thấy lượt làm bài.';
      return;
    }

    const total = this.attempt?.questions?.length || 0;
    const skipped = total - this.answeredCount;
    if (!auto && skipped > 0) {
      const ok = confirm(`Bạn còn ${skipped} câu chưa chọn. Vẫn nộp bài?`);
      if (!ok) return;
    }

    this.isSubmitting = true;
    this.error = '';

    const body = {
      answers: Object.keys(this.answers).map(k => ({
        questionId: Number(k),
        selectedOptionIds: [this.answers[Number(k)]]
      }))
    } as any;
    if (this.lessonId) body.lessonId = this.lessonId;

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
        this.error = e?.error?.message || 'Không nộp được bài.';
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
    return selected.length ? selected.join(', ') : 'Chưa chọn đáp án';
  }

  correctText(question: any): string {
    const correct = question.options?.filter((x: any) => x.isCorrect).map((x: any) => x.content) || [];
    return correct.length ? correct.join(', ') : 'Chưa có đáp án đúng';
  }
}

