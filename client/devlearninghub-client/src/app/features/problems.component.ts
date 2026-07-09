import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { ApiService } from '../core/services/api.service';

@Component({selector:'app-problems',standalone:true,imports:[CommonModule, FormsModule, RouterLink],templateUrl:'./problems.component.html'})
export class ProblemsComponent implements OnInit {
  problems: any[] = [];
  keyword = '';
  difficulty = 'all';
  loading = false;
  error = '';

  constructor(private api: ApiService) {}

  ngOnInit(): void { this.load(); }

  load(): void {
    this.loading = true;
    this.error = '';
    const q = `?pageSize=100&keyword=${encodeURIComponent(this.keyword || '')}&difficulty=${encodeURIComponent(this.difficulty || 'all')}`;
    this.api.get<any>(`/api/v1/code/problems${q}`).subscribe({
      next: r => { this.problems = r.data?.items || []; this.loading = false; },
      error: e => { this.error = e?.error?.message || 'Không tải được danh sách bài lập trình. Kiểm tra API và script DB v12.'; this.loading = false; }
    });
  }

  difficultyText(d: any): string { return Number(d) === 3 ? 'Hard' : Number(d) === 2 ? 'Medium' : 'Easy'; }
  difficultyBadge(d: any): string { return Number(d) === 3 ? 'badge-red' : Number(d) === 2 ? 'badge-yellow' : 'badge-green'; }
  tagList(p: any): string[] { return (p.tags || '').split(',').map((x: string) => x.trim()).filter(Boolean); }
}
