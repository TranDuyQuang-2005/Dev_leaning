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
  lessonId?: number;
  mySubmissions: any[] = [];
  submissionsLoading = false;

  readonly fallbackLanguages = [
    { value: 'python', label: 'Python', fileExtension: 'py' },
    { value: 'javascript', label: 'JavaScript', fileExtension: 'js' },
    { value: 'typescript', label: 'TypeScript', fileExtension: 'ts' },
    { value: 'java', label: 'Java', fileExtension: 'java' },
    { value: 'c', label: 'C', fileExtension: 'c' },
    { value: 'cpp', label: 'C++17', fileExtension: 'cpp' },
    { value: 'csharp', label: 'C#', fileExtension: 'cs' },
    { value: 'go', label: 'Go', fileExtension: 'go' }
  ];

  readonly defaultTemplates: Record<string, string> = {
    python: `print("Hello, World!")`,
    javascript: `console.log("Hello, World!");`,
    typescript: `const message: string = "Hello, World!";
console.log(message);`,
    java: `public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}`,
    c: `#include <stdio.h>
int main() {
    printf("Hello, World!\\n");
    return 0;
}`,
    cpp: `#include <bits/stdc++.h>
using namespace std;
int main() {
    cout << "Hello, World!" << endl;
    return 0;
}`,
    csharp: `using System;
public class Program {
    public static void Main() {
        Console.WriteLine("Hello, World!");
    }
}`,
    go: `package main
import "fmt"
func main() {
    fmt.Println("Hello, World!")
}`
  };

  constructor(private route: ActivatedRoute, private api: ApiService) {}

  ngOnInit(): void {
    this.api.get<any>('/api/v1/code/languages').subscribe({
      next: (r: any) => {
        const source = r?.data || r || [];
        this.languages = Array.isArray(source) && source.length ? source.map((x: any) => ({
          value: x.value || x.languageCode || x.code,
          label: x.label || x.displayName || x.name,
          fileExtension: x.fileExtension,
          defaultTemplate: x.defaultTemplate
        })) : this.fallbackLanguages;
        if (!this.languages.some((x: any) => x.value === this.language)) this.language = this.languages[0]?.value || 'javascript';
        this.setStarterCode();
      },
      error: () => {
        this.languages = this.fallbackLanguages;
        this.setStarterCode();
      }
    });
    const queryLessonId = Number(this.route.snapshot.queryParamMap.get('lessonId') || this.route.snapshot.queryParamMap.get('roadmapLessonId') || 0);
    this.lessonId = queryLessonId > 0 ? queryLessonId : undefined;
    this.route.paramMap.subscribe((params: any) => {
      const id = Number(params.get('id') || 1);
      this.loadProblem(id);
    });
  }

  loadProblem(id: number): void {
    this.loading = true;
    this.error = '';
    const query = this.lessonId ? `?lessonId=${this.lessonId}` : '';
    this.api.get<any>(`/api/v1/code/problems/${id}${query}`).subscribe({
      next: (r: any) => {
        this.problem = r.data;
        this.customInput = this.problem?.testCases?.[0]?.input || '';
        this.setStarterCode();
        this.loadMySubmissions();
        this.loading = false;
      },
      error: (e: any) => { this.error = e?.error?.message || 'Không tải được bài lập trình'; this.loading = false; }
    });
  }

  changeLanguage(): void { this.setStarterCode(); this.runResult = null; this.submitResult = null; }

  setStarterCode(): void {
    if (!this.problem) return;
    const map: any = {
      javascript: this.problem.starterCodeJavaScript,
      python: this.problem.starterCodePython,
      typescript: this.problem.starterCodeTypeScript,
      java: this.problem.starterCodeJava,
      c: this.problem.starterCodeC,
      cpp: this.problem.starterCodeCpp,
      csharp: this.problem.starterCodeCsharp,
      go: this.problem.starterCodeGo
    };
    const languageConfig = this.languages.find((x: any) => x.value === this.language);
    this.code = map[this.language] || languageConfig?.defaultTemplate || this.defaultTemplates[this.language] || '';
  }

  run(): void {
    if (this.running) return;
    this.running = true;
    this.runResult = null;
    this.error = '';
    const body: any = { language: this.language, sourceCode: this.code, stdin: this.customInput, timeLimitMs: this.problem?.timeLimitMs || 3000 };
    if (this.lessonId) {
      body.lessonId = this.lessonId;
      body.codingProblemId = this.problem?.id;
    }
    this.api.post<any>('/api/v1/code/run', body).subscribe({
      next: (r: any) => { this.runResult = r.data || r; this.running = false; },
      error: (e: any) => { this.error = e?.error?.message || 'Không chạy được code'; this.running = false; }
    });
  }

  submit(): void {
    if (this.submitting || !this.problem) return;
    this.submitting = true;
    this.submitResult = null;
    this.error = '';
    const body: any = { language: this.language, sourceCode: this.code };
    if (this.lessonId) body.lessonId = this.lessonId;
    this.api.post<any>(`/api/v1/code/problems/${this.problem.id}/submit`, body).subscribe({
      next: (r: any) => { this.submitResult = r.data || r; this.submitting = false; this.loadMySubmissions(); },
      error: (e: any) => { this.error = this.api.errorMessage(e, 'Không submit được bài'); this.submitting = false; }
    });
  }

  difficultyText(d: any): string { return Number(d) === 3 ? 'Hard' : Number(d) === 2 ? 'Medium' : 'Easy'; }
  difficultyBadge(d: any): string { return Number(d) === 3 ? 'badge-red' : Number(d) === 2 ? 'badge-yellow' : 'badge-green'; }
  tagList(): string[] { return (this.problem?.tags || '').split(',').map((x: string) => x.trim()).filter(Boolean); }

  loadMySubmissions(): void {
    if (!this.problem?.id) return;
    this.submissionsLoading = true;
    this.api.getMyCodeSubmissions({ problemId: this.problem.id, pageIndex: 1, pageSize: 10 }).subscribe({
      next: r => {
        const data: any = r.data || {};
        this.mySubmissions = data.items || (Array.isArray(data) ? data : []);
        this.submissionsLoading = false;
      },
      error: () => {
        this.mySubmissions = [];
        this.submissionsLoading = false;
      }
    });
  }

  verdictText(item: any): string {
    return item.verdict || item.status || '-';
  }

  submittedAt(item: any): any {
    return item.submittedAt || item.createdAt;
  }

  memoryText(item: any): string {
    const memory = item.memoryUsedKb ?? item.memoryKb;
    return memory === null || memory === undefined || memory === '' ? '-' : `${memory} KB`;
  }
}

