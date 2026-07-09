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
    return this.attempt?.questions || this.attempt?.items || [];
  }

  retry(): void {
    const bankId = this.attempt?.bankId || this.attempt?.practiceBankId || this.attempt?.practiceBank?.id;
    if (bankId) this.router.navigate(['/learner/practice-banks', bankId]);
  }
}
