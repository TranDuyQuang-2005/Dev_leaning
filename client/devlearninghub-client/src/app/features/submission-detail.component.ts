import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { ApiService } from '../core/services/api.service';

@Component({
  selector: 'app-submission-detail',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './submission-detail.component.html'
})
export class SubmissionDetailComponent implements OnInit {
  submission: any;
  loading = false;
  error = '';

  constructor(private route: ActivatedRoute, private api: ApiService) {}

  ngOnInit(): void {
    const id = this.route.snapshot.paramMap.get('submissionId') || '';
    this.loading = true;
    this.api.getSubmissionDetail(id).subscribe({
      next: r => {
        this.submission = r.data;
        this.loading = false;
      },
      error: e => {
        this.error = this.api.errorMessage(e, 'Không tải được chi tiết submission.');
        this.loading = false;
      }
    });
  }

  get tests(): any[] {
    return this.submission?.testcaseResults || this.submission?.testCaseResults || [];
  }
}
