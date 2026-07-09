import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { ApiService } from '../core/services/api.service';

@Component({selector:'app-problem-detail',standalone:true,imports:[CommonModule, FormsModule, RouterLink],templateUrl:'./problem-detail.component.html'})
export class ProblemDetailComponent implements OnInit {
  problem: any;
  languages: any[] = [];
  language = 'javascript';
  code = '';
  customInput = '';
  runResult: any;
  submitResult: any;
  error = '';
  loading = false;
  running = false;
  submitting = false;

  constructor(private route: ActivatedRoute, private api: ApiService) {}

  ngOnInit(): void {
    this.api.get<any>('/api/v1/code/languages').subscribe({ next: (r: any) => this.languages = r.data || [] });
    this.route.paramMap.subscribe((params: any) => {
      const id = Number(params.get('id') || 1);
      this.loadProblem(id);
    });
  }

  loadProblem(id: number): void {
    this.loading = true;
    this.error = '';
    this.api.get<any>(`/api/v1/code/problems/${id}`).subscribe({
      next: (r: any) => {
        this.problem = r.data;
        this.customInput = this.problem?.testCases?.[0]?.input || '';
        this.setStarterCode();
        this.loading = false;
      },
      error: (e: any) => { this.error = e?.error?.message || 'KhÃ´ng táº£i Ä‘Æ°á»£c bÃ i láº­p trÃ¬nh'; this.loading = false; }
    });
  }

  changeLanguage(): void { this.setStarterCode(); this.runResult = null; this.submitResult = null; }

  setStarterCode(): void {
    if (!this.problem) return;
    const map: any = {
      javascript: this.problem.starterCodeJavaScript,
      python: this.problem.starterCodePython,
      java: this.problem.starterCodeJava,
      cpp: this.problem.starterCodeCpp
    };
    this.code = map[this.language] || '';
  }

  run(): void {
    if (this.running) return;
    this.running = true;
    this.runResult = null;
    this.error = '';
    this.api.post<any>('/api/v1/code/run', { language: this.language, sourceCode: this.code, stdin: this.customInput, timeLimitMs: this.problem?.timeLimitMs || 3000 }).subscribe({
      next: (r: any) => { this.runResult = r.data || r; this.running = false; },
      error: (e: any) => { this.error = e?.error?.message || 'KhÃ´ng cháº¡y Ä‘Æ°á»£c code'; this.running = false; }
    });
  }

  submit(): void {
    if (this.submitting || !this.problem) return;
    this.submitting = true;
    this.submitResult = null;
    this.error = '';
    this.api.post<any>(`/api/v1/code/problems/${this.problem.id}/submit`, { language: this.language, sourceCode: this.code }).subscribe({
      next: (r: any) => { this.submitResult = r.data || r; this.submitting = false; },
      error: (e: any) => { this.error = e?.error?.message || 'KhÃ´ng submit Ä‘Æ°á»£c bÃ i'; this.submitting = false; }
    });
  }

  difficultyText(d: any): string { return Number(d) === 3 ? 'Hard' : Number(d) === 2 ? 'Medium' : 'Easy'; }
  difficultyBadge(d: any): string { return Number(d) === 3 ? 'badge-red' : Number(d) === 2 ? 'badge-yellow' : 'badge-green'; }
  tagList(): string[] { return (this.problem?.tags || '').split(',').map((x: string) => x.trim()).filter(Boolean); }
}

