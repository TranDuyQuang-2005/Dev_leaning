import { CommonModule } from '@angular/common';
import { Component, HostListener, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../core/services/api.service';

type RunStatus = 'idle' | 'running' | 'success' | 'error';

@Component({
  selector: 'app-playground',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './playground.component.html'
})
export class PlaygroundComponent implements OnInit {
  language = 'javascript';
  languages: any[] = [];
  isRunning = false;
  error = '';
  output = 'Click Run Code hoặc nhấn Ctrl + Enter để chạy.';
  stdin = '';
  executionTimeMs = 0;
  memoryUsedKb = 0;
  verdict = '';
  status: RunStatus = 'idle';
  lastRunAt = '';

  templates: Record<string, string> = {
    javascript: `const fs = require('fs');
const input = fs.readFileSync(0, 'utf8').trim();
console.log(input ? 'Hello, ' + input + '!' : 'Hello, World!');`,
    python: `import sys
name = sys.stdin.read().strip()
print('Hello, ' + name + '!' if name else 'Hello, World!')`,
    java: `import java.io.*;

public class Main {
    public static void main(String[] args) throws Exception {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String name = br.readLine();
        if (name == null || name.isBlank()) name = "World";
        System.out.println("Hello, " + name + "!");
    }
}`,
    cpp: `#include <bits/stdc++.h>
using namespace std;

int main() {
    string name;
    getline(cin, name);
    if (name.empty()) name = "World";
    cout << "Hello, " << name << "!" << endl;
    return 0;
}`
  };

  samples: Record<string, string> = {
    javascript: 'DevLearningHub',
    python: 'DevLearningHub',
    java: 'DevLearningHub',
    cpp: 'DevLearningHub'
  };

  code = this.templates['javascript'];

  constructor(private api: ApiService) {}

  ngOnInit(): void {
    this.api.get<any>('/api/v1/code/languages').subscribe({
      next: (r: any) => {
        const data = r?.data || r || [];
        this.languages = Array.isArray(data) && data.length ? data : this.fallbackLanguages();
      },
      error: () => this.languages = this.fallbackLanguages()
    });
  }

  @HostListener('document:keydown.control.enter', ['$event'])
  handleCtrlEnter(event: KeyboardEvent): void {
    event.preventDefault();
    this.run();
  }

  fallbackLanguages(): any[] {
    return [
      { value: 'javascript', label: 'JavaScript', runtime: 'node main.js' },
      { value: 'python', label: 'Python', runtime: 'python main.py' },
      { value: 'java', label: 'Java', runtime: 'javac + java Main' },
      { value: 'cpp', label: 'C++17', runtime: 'g++ -std=c++17' }
    ];
  }

  currentLanguageLabel(): string {
    return this.languages.find(x => x.value === this.language)?.label || this.language;
  }

  currentRuntime(): string {
    return this.languages.find(x => x.value === this.language)?.runtime || 'Local runtime';
  }

  setLanguage(language: string): void {
    if (this.language === language) return;
    const oldTemplate = this.templates[this.language] || '';
    const canReplace = !this.code.trim() || this.code.trim() === oldTemplate.trim();
    this.language = language;
    if (canReplace) this.code = this.templates[language] || '';
    this.resetResult();
  }

  loadTemplate(): void {
    if (this.code.trim() && !confirm('Thay code hiện tại bằng template mới?')) return;
    this.code = this.templates[this.language] || '';
    this.resetResult();
  }

  loadSampleInput(): void {
    this.stdin = this.samples[this.language] || 'DevLearningHub';
  }

  reset(): void {
    this.code = this.templates[this.language] || '';
    this.stdin = '';
    this.resetResult();
  }

  clearOutput(): void {
    this.output = '';
    this.error = '';
    this.verdict = '';
    this.executionTimeMs = 0;
    this.memoryUsedKb = 0;
    this.status = 'idle';
  }

  private resetResult(): void {
    this.output = 'Click Run Code hoặc nhấn Ctrl + Enter để chạy.';
    this.error = '';
    this.verdict = '';
    this.executionTimeMs = 0;
    this.memoryUsedKb = 0;
    this.status = 'idle';
  }

  run(): void {
    if (this.isRunning) return;
    if (!this.code.trim()) {
      this.error = 'Source code không được để trống.';
      this.output = '';
      this.verdict = 'Invalid Input';
      this.status = 'error';
      return;
    }

    this.error = '';
    this.output = 'Running...';
    this.verdict = 'Running';
    this.status = 'running';
    this.isRunning = true;
    const started = performance.now();

    this.api.post<any>('/api/v1/code/run', {
      language: this.language,
      sourceCode: this.code,
      stdin: this.stdin,
      timeLimitMs: 3000
    }).subscribe({
      next: (r: any) => {
        const data = r?.data || r || {};
        this.output = data.output || '';
        this.error = data.error || '';
        this.verdict = data.verdict || data.status || 'Completed';
        this.executionTimeMs = Number(data.executionTimeMs || Math.round(performance.now() - started));
        this.memoryUsedKb = Number(data.memoryUsedKb || 0);
        this.status = this.error || this.verdict.toLowerCase().includes('error') || this.verdict.toLowerCase().includes('failed') ? 'error' : 'success';
        this.lastRunAt = new Date().toLocaleString('vi-VN');
        this.isRunning = false;
      },
      error: (e: any) => {
        this.output = '';
        this.error = e?.error?.message || e?.error?.title || 'Không chạy được code. Hãy kiểm tra API hoặc runtime trên server.';
        this.verdict = 'Failed';
        this.executionTimeMs = Math.round(performance.now() - started);
        this.status = 'error';
        this.isRunning = false;
      }
    });
  }

  async copyOutput(): Promise<void> {
    const text = [this.output, this.error ? `STDERR:\n${this.error}` : ''].filter(Boolean).join('\n');
    if (!text.trim()) return;
    try {
      await navigator.clipboard.writeText(text);
      this.verdict = this.verdict || 'Copied';
    } catch {
      alert('Trình duyệt không cho phép copy tự động. Bạn có thể bôi đen output để copy thủ công.');
    }
  }
}

