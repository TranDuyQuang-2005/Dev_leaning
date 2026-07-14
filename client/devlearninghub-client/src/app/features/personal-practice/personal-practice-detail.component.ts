import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { ApiService } from '../../core/services/api.service';

@Component({
  selector: 'app-personal-practice-detail',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './personal-practice-detail.component.html'
})
export class PersonalPracticeDetailComponent implements OnInit {
  bank: any;
  config = { numberOfQuestions: 10, shuffleQuestions: true, shuffleOptions: true };
  loading = false;
  starting = false;
  error = '';

  constructor(private route: ActivatedRoute, private router: Router, private api: ApiService) {}

  ngOnInit(): void {
    this.load();
  }

  load(): void {
    const id = this.route.snapshot.paramMap.get('id') || '';
    this.loading = true;
    this.api.getPracticeBank(id).subscribe({
      next: r => {
        this.bank = r.data;
        this.config.numberOfQuestions = this.bank?.questionCount || this.bank?.questions?.length || 10;
        this.loading = false;
      },
      error: e => {
        this.error = this.api.errorMessage(e, 'Không tải được chi tiết ngân hàng câu hỏi.');
        this.loading = false;
      }
    });
  }

  start(): void {
    if (!this.bank || this.starting) return;
    this.error = '';
    this.starting = true;
    this.api.startPracticeAttempt(this.bank.id, {
      numberOfQuestions: Number(this.config.numberOfQuestions) || 1,
      shuffleQuestions: this.config.shuffleQuestions,
      shuffleOptions: this.config.shuffleOptions
    }).subscribe({
      next: r => {
        const attemptId = (r.data as any)?.id || (r.data as any)?.attemptId;
        this.starting = false;
        if (attemptId) this.router.navigate(['/learner/practice-attempts', attemptId]);
      },
      error: e => {
        this.error = this.api.errorMessage(e, 'Không bắt đầu được lượt luyện tập.');
        this.starting = false;
      }
    });
  }
}
