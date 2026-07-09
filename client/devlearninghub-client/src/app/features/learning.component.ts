import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { ApiService } from '../core/services/api.service';

@Component({ selector: 'app-learning', standalone: true, imports: [CommonModule, FormsModule, RouterLink], templateUrl: './learning.component.html' })
export class LearningComponent implements OnInit {
  quizSets: any[] = [];
  categories: any[] = [];
  attempts: any[] = [];
  keyword = '';
  level = 'all';
  categoryId: any = 'all';
  error = '';

  constructor(private api: ApiService) {}

  ngOnInit(): void { this.load(); }

  load(): void {
    this.api.get<any>('/api/v1/categories?pageSize=100').subscribe({ next: (r: any) => this.categories = r.data?.items || [] });
    this.api.get<any>('/api/v1/quiz-sets?pageSize=100').subscribe({ next: (r: any) => this.quizSets = r.data?.items || [], error: (e: any) => this.error = e?.error?.message || 'Không tải được dữ liệu quiz set từ API.' });
    this.api.get<any>('/api/v1/quiz-attempts/me').subscribe({ next: (r: any) => this.attempts = r.data || [], error: () => this.attempts = [] });
  }

  get filteredQuizSets(): any[] {
    const k = this.keyword.toLowerCase().trim();
    return this.quizSets.filter(q =>
      (!k || q.title?.toLowerCase().includes(k)) &&
      (this.level === 'all' || String(q.difficulty || 1) === this.level) &&
      (this.categoryId === 'all' || Number(q.categoryId) === Number(this.categoryId))
    );
  }

  shortTitle(t: string): string { return (t || 'Quiz').split(/\s+/).slice(0, 2).map(x => x[0]).join('').toUpperCase() || 'QZ'; }
  logoClass(q: any): string { const arr = ['blue-bg', 'green-bg', 'yellow-bg', 'purple-bg', 'cyan-bg', 'red-bg']; return arr[(q.id || 0) % arr.length]; }
  difficultyText(d: any): string { return Number(d) === 3 ? 'Advanced' : Number(d) === 2 ? 'Intermediate' : 'Beginner'; }
  difficultyBadge(d: any): string { return Number(d) === 3 ? 'badge-red' : Number(d) === 2 ? 'badge-yellow' : 'badge-green'; }
  categoryName(id: any): string { return this.categories.find(c => Number(c.id) === Number(id))?.name || 'General'; }
  progress(id: number): number { return Number(localStorage.getItem('quiz-progress-' + id) || 0); }
  attemptsFor(q: any): any[] { return this.attempts.filter(a => Number(a.quizSetId) === Number(q.id)); }
  remainingAttempts(q: any): string {
    if (!q.maxAttempts) return 'Không giới hạn';
    const done = this.attemptsFor(q).filter(a => a.submittedAt).length;
    return Math.max(0, q.maxAttempts - done) + ' / ' + q.maxAttempts;
  }
  bestScore(q: any): number | null {
    const list = this.attemptsFor(q);
    if (!list.length) return null;
    return Math.max(...list.map(a => Number(a.score || 0)));
  }
}

