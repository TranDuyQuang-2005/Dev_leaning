import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { ActivatedRoute } from '@angular/router';
import { ApiService } from '../../core/services/api.service';

@Component({
  selector: 'app-personal-practice-result',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './personal-practice-result.component.html'
})
export class PersonalPracticeResultComponent implements OnInit {
  attempt: any;
  error = '';
  loading = false;

  constructor(private route: ActivatedRoute, private router: Router, private api: ApiService) {}

  ngOnInit(): void {
    const id = this.route.snapshot.paramMap.get('attemptId') || '';
    this.loading = true;
    this.api.getPracticeAttempt(id).subscribe({
      next: r => {
        this.attempt = r.data;
        this.loading = false;
      },
      error: e => {
        this.error = this.api.errorMessage(e, 'Không tải được kết quả tự luyện.');
        this.loading = false;
      }
    });
  }

  get questions(): any[] {
    const questions = this.attempt?.questions || this.attempt?.items || [];
    return questions.length ? questions : (this.attempt?.details || []);
  }

  questionId(q: any): string {
    return String(q.questionId || q.id);
  }

  detailFor(q: any): any {
    const id = this.questionId(q);
    return (this.attempt?.details || []).find((x: any) => String(x.questionId || x.id) === id) || {};
  }

  value(q: any, fields: string[]): any {
    const detail = this.detailFor(q);
    for (const field of fields) {
      const value = q?.[field] ?? detail?.[field];
      if (value !== undefined && value !== null && String(value).trim() !== '') return value;
    }
    return '';
  }

  options(q: any): any[] {
    const detail = this.detailFor(q);
    return q?.options || detail?.options || [];
  }

  optionKey(option: any, index: number): string {
    return (option?.key || option?.label || option?.optionKey || option?.optionLabel || String.fromCharCode(65 + index)).toString().trim().toUpperCase();
  }

  optionText(option: any): string {
    return option?.content || option?.text || option?.optionText || option?.answerText || '';
  }

  selectedOption(q: any): string {
    const direct = this.value(q, ['selectedOption', 'selectedOptionKey', 'selectedOptionLabel', 'selectedAnswer']);
    return direct ? String(direct).trim().toUpperCase() : '';
  }

  correctOption(q: any): string {
    const direct = this.value(q, ['correctOption', 'correctOptionKey', 'correctOptionLabel', 'correctAnswer']);
    if (direct) return String(direct).trim().toUpperCase();
    const fromOptions = this.options(q).find((option, index) => option?.isCorrect === true || option?.correct === true);
    return fromOptions ? this.optionKey(fromOptions, this.options(q).indexOf(fromOptions)) : '';
  }

  selectedAnswerText(q: any): string {
    const direct = this.value(q, ['selectedAnswerText']);
    if (direct) return direct;
    const selected = this.selectedOption(q);
    const option = this.options(q).find((item, index) => this.optionKey(item, index) === selected);
    return option ? this.optionText(option) : '';
  }

  correctAnswerText(q: any): string {
    const direct = this.value(q, ['correctAnswerText']);
    if (direct) return direct;
    const correct = this.correctOption(q);
    const option = this.options(q).find((item, index) => this.optionKey(item, index) === correct);
    return option ? this.optionText(option) : '';
  }

  explanation(q: any): string {
    return this.value(q, ['explanation']) || '';
  }

  isCorrect(q: any): boolean {
    const detail = this.detailFor(q);
    return q?.isCorrect === true || detail?.isCorrect === true;
  }

  optionClass(q: any, option: any, index: number): Record<string, boolean> {
    const key = this.optionKey(option, index);
    const selected = this.selectedOption(q);
    const correct = this.correctOption(q);
    return {
      'result-option-correct': key === correct,
      'result-option-wrong': key === selected && key !== correct,
      'result-option-selected': key === selected
    };
  }

  retry(): void {
    const bankId = this.attempt?.bankId || this.attempt?.practiceBankId || this.attempt?.practiceBank?.id;
    if (bankId) this.router.navigate(['/learner/practice-banks', bankId]);
  }
}
