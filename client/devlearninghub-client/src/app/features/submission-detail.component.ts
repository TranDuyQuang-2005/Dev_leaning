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
  copied = false;

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

  get sourceCode(): string {
    const s = this.submission || {};
    return s.sourceCode ?? s.code ?? s.submittedCode ?? s.userCode ?? s.content ?? '';
  }

  get scoreText(): string {
    const s = this.submission || {};
    if (s.score !== null && s.score !== undefined) return `${s.score}`;
    if (s.isAccepted) return 'Accepted';
    if (s.totalTestCases) return `${s.passedTestCases || 0}/${s.totalTestCases}`;
    return '-';
  }

  get memoryText(): string {
    const memory = this.submission?.memoryUsedKb ?? this.submission?.memoryKb;
    return memory === null || memory === undefined || memory === '' ? '-' : `${memory} KB`;
  }

  get runtimeText(): string {
    const runtime = this.submission?.executionTimeMs ?? this.submission?.runtimeMs;
    return runtime === null || runtime === undefined || runtime === '' ? '-' : `${runtime} ms`;
  }

  get submittedAt(): any {
    return this.submission?.submittedAt || this.submission?.createdAt;
  }

  get verdictText(): string {
    return this.submission?.verdict || this.submission?.status || '-';
  }

  get outputText(): string {
    return this.submission?.stdout ?? this.submission?.output ?? '';
  }

  get errorText(): string {
    return this.submission?.stderr ?? this.submission?.error ?? '';
  }

  get compileOutputText(): string {
    return this.submission?.compileOutput ?? '';
  }

  async copyCode(): Promise<void> {
    await navigator.clipboard?.writeText(this.sourceCode || '');
    this.copied = true;
    setTimeout(() => this.copied = false, 1200);
  }
}
