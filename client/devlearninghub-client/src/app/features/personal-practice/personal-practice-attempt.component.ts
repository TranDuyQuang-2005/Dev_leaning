import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { ApiService } from '../../core/services/api.service';

@Component({
  selector: 'app-personal-practice-attempt',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './personal-practice-attempt.component.html'
})
export class PersonalPracticeAttemptComponent implements OnInit {
  attempt: any;
  selected: Record<string, string> = {};
  loading = false;
  submitting = false;
  error = '';

  constructor(private route: ActivatedRoute, private router: Router, private api: ApiService) {}

  ngOnInit(): void {
    this.load();
  }

  get questions(): any[] {
    return this.attempt?.questions || this.attempt?.items || [];
  }

  get answeredCount(): number {
    return this.questions.filter(q => this.selected[this.questionId(q)]).length;
  }

  load(): void {
    const id = this.route.snapshot.paramMap.get('attemptId') || '';
    this.loading = true;
    this.api.getPracticeAttempt(id).subscribe({
      next: r => {
        this.attempt = r.data;
        for (const q of this.questions) {
          const current = q.selectedOptionLabel || q.selectedAnswer;
          if (current) this.selected[this.questionId(q)] = current;
        }
        this.loading = false;
      },
      error: e => {
        this.error = this.api.errorMessage(e, 'Không tải được lượt luyện tập.');
        this.loading = false;
      }
    });
  }

  questionId(q: any): string {
    return String(q.questionId || q.id);
  }

  optionLabel(option: any, index: number): string {
    return option.label || option.optionLabel || String.fromCharCode(65 + index);
  }

  optionText(option: any): string {
    return option.text || option.content || option.optionText || option.answerText || '';
  }

  submit(): void {
    if (!confirm('Bạn chắc chắn muốn nộp bài?')) return;
    const id = this.route.snapshot.paramMap.get('attemptId') || '';
    const answers = this.questions
      .filter(q => this.selected[this.questionId(q)])
      .map(q => ({ questionId: Number(this.questionId(q)), selectedOptionKey: this.selected[this.questionId(q)] }));

    this.submitting = true;
    this.api.submitPracticeAttempt(id, { answers }).subscribe({
      next: () => {
        this.submitting = false;
        this.router.navigate(['/learner/practice-attempts', id, 'result']);
      },
      error: e => {
        this.error = this.api.errorMessage(e, 'Không nộp được bài luyện tập.');
        this.submitting = false;
      }
    });
  }
}
