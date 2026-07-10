import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { ApiService } from '../core/services/api.service';

@Component({
  selector: 'app-submissions',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './submissions.component.html'
})
export class SubmissionsComponent implements OnInit {
  submissions: any[] = [];
  loading = false;
  error = '';
  filters = { language: '', verdict: '', pageIndex: 1, pageSize: 20 };
  totalItems = 0;
  totalPages = 1;

  constructor(private api: ApiService) {}

  ngOnInit(): void {
    this.load();
  }

  load(pageIndex = this.filters.pageIndex): void {
    this.loading = true;
    this.error = '';
    this.filters.pageIndex = pageIndex;
    const query = Object.fromEntries(Object.entries(this.filters).filter(([, value]) => value !== '' && value !== null && value !== undefined));
    this.api.getMyCodeSubmissions(query).subscribe({
      next: r => {
        const data: any = r.data || {};
        this.submissions = data.items || (Array.isArray(data) ? data : []);
        this.totalItems = data.totalItems || this.submissions.length;
        this.totalPages = data.totalPages || 1;
        this.loading = false;
      },
      error: e => {
        this.error = this.api.errorMessage(e, 'Không tải được lịch sử nộp bài.');
        this.loading = false;
      }
    });
  }

  resetFilters(): void {
    this.filters = { language: '', verdict: '', pageIndex: 1, pageSize: 20 };
    this.load(1);
  }

  verdictText(item: any): string {
    return item.verdict || item.status || '-';
  }

  scoreText(item: any): string {
    if (item.score !== null && item.score !== undefined) return `${item.score}`;
    if (item.isAccepted) return 'Accepted';
    if (item.totalTestCases) return `${item.passedTestCases || 0}/${item.totalTestCases}`;
    return '-';
  }

  memoryText(item: any): string {
    const memory = item.memoryUsedKb ?? item.memoryKb;
    return memory === null || memory === undefined || memory === '' ? '-' : `${memory} KB`;
  }

  runtimeText(item: any): string {
    const runtime = item.executionTimeMs ?? item.runtimeMs;
    return runtime === null || runtime === undefined || runtime === '' ? '-' : `${runtime} ms`;
  }

  submittedAt(item: any): any {
    return item.submittedAt || item.createdAt;
  }
}
