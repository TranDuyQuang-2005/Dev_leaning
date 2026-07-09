import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ApiResponse, ApiService } from '../core/services/api.service';

interface PlaygroundLanguage {
  value: string;
  label: string;
  runtime?: string;
  enabled?: boolean;
}

interface PlaygroundResult {
  status?: string;
  verdict?: string;
  output?: string;
  stdout?: string;
  error?: string;
  stderr?: string;
  executionTimeMs?: number;
  memoryUsedKb?: number;
}

@Component({
  selector: 'app-playground',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './playground.component.html'
})
export class PlaygroundComponent implements OnInit {
  language = 'javascript';
  languages: PlaygroundLanguage[] = [];
  isRunning = false;
  error = '';
  output = 'Bấm Run Code để xem kết quả chương trình.';
  stdin = 'DevLearningHub';
  code = '';
  executionTimeMs = 0;
  memoryUsedKb = 0;
  verdict = '';
  status = '';
  lastRunAt = '';
  timeLimitMs = 3000;
  copiedCode = false;
  copiedOutput = false;

  readonly fallbackLanguages: PlaygroundLanguage[] = [
    { value: 'javascript', label: 'JavaScript', runtime: 'Node.js', enabled: true },
    { value: 'python', label: 'Python', runtime: 'Python 3', enabled: true },
    { value: 'cpp', label: 'C++17', runtime: 'G++', enabled: true },
    { value: 'java', label: 'Java', runtime: 'JDK', enabled: true }
  ];

  readonly templates: Record<string, string> = {
    javascript: `const fs = require('fs');
const input = fs.readFileSync(0, 'utf8').trim();
const name = input || 'World';
console.log('Hello, ' + name + '!');`,
    python: `import sys

name = sys.stdin.read().strip() or 'World'
print(f'Hello, {name}!')`,
    cpp: `#include <bits/stdc++.h>
using namespace std;

int main() {
    string name;
    getline(cin, name);
    if (name.empty()) name = "World";
    cout << "Hello, " << name << "!" << endl;
    return 0;
}`,
    java: `import java.io.*;

public class Main {
    public static void main(String[] args) throws Exception {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String name = br.readLine();
        if (name == null || name.isBlank()) name = "World";
        System.out.println("Hello, " + name + "!");
    }
}`
  };

  readonly sampleInputs: Record<string, string> = {
    javascript: 'DevLearningHub',
    python: 'DevLearningHub',
    cpp: 'DevLearningHub',
    java: 'DevLearningHub'
  };

  constructor(private api: ApiService) {
    this.code = this.templates[this.language];
  }

  ngOnInit(): void {
    this.loadLanguages();
  }

  loadLanguages(): void {
    this.api.get('/api/v1/code/languages').subscribe({
      next: (response: ApiResponse<any> | any) => {
        const source = response?.data ?? response;
        const items = Array.isArray(source) ? source : [];
        const mapped = items
          .map((item: any) => this.mapLanguage(item))
          .filter((item: PlaygroundLanguage) => !!item.value);

        this.languages = mapped.length ? mapped : this.fallbackLanguages;

        if (!this.languages.some((item: PlaygroundLanguage) => item.value === this.language)) {
          this.setLanguage(this.languages[0]?.value || 'javascript');
        }
      },
      error: () => {
        this.languages = this.fallbackLanguages;
      }
    });
  }

  private mapLanguage(item: any): PlaygroundLanguage {
    if (typeof item === 'string') {
      return { value: item, label: this.prettyLanguage(item), enabled: true };
    }

    const rawValue = item?.value || item?.id || item?.language || item?.name || '';
    const value = String(rawValue).trim().toLowerCase();
    const label = String(item?.label || item?.displayName || item?.name || this.prettyLanguage(value)).trim();

    return {
      value,
      label: label || this.prettyLanguage(value),
      runtime: item?.runtime || item?.version || '',
      enabled: item?.enabled !== false
    };
  }

  trackByLanguage(_: number, item: PlaygroundLanguage): string {
    return item.value;
  }

  prettyLanguage(value: string): string {
    const map: Record<string, string> = {
      javascript: 'JavaScript',
      js: 'JavaScript',
      node: 'JavaScript',
      python: 'Python',
      py: 'Python',
      cpp: 'C++17',
      cplusplus: 'C++17',
      'c++': 'C++17',
      java: 'Java'
    };

    return map[value?.toLowerCase()] || value || 'Language';
  }

  currentLanguage(): PlaygroundLanguage {
    return this.languages.find((item: PlaygroundLanguage) => item.value === this.language)
      || this.fallbackLanguages.find((item: PlaygroundLanguage) => item.value === this.language)
      || this.fallbackLanguages[0];
  }

  setLanguage(language: string): void {
    if (!language || this.isRunning) return;

    this.language = language;
    this.code = this.templates[language] || this.code || '';
    this.stdin = this.sampleInputs[language] || '';
    this.resetResult('Đã đổi ngôn ngữ. Bấm Run Code để chạy chương trình mới.');
  }

  useSampleInput(): void {
    this.stdin = this.sampleInputs[this.language] || 'DevLearningHub';
  }

  reset(): void {
    this.code = this.templates[this.language] || '';
    this.stdin = this.sampleInputs[this.language] || '';
    this.resetResult('Đã reset template. Bấm Run Code để chạy lại.');
  }

  clearOutput(): void {
    this.resetResult('Output đã được xóa.');
  }

  private resetResult(message: string): void {
    this.output = message;
    this.error = '';
    this.verdict = '';
    this.status = '';
    this.executionTimeMs = 0;
    this.memoryUsedKb = 0;
    this.lastRunAt = '';
  }

  onEditorKeydown(event: KeyboardEvent): void {
    if ((event.ctrlKey || event.metaKey) && event.key === 'Enter') {
      event.preventDefault();
      this.run();
    }
  }

  run(): void {
    if (this.isRunning) return;

    const sourceCode = (this.code || '').trimEnd();
    if (!sourceCode.trim()) {
      this.output = '';
      this.error = 'Bạn chưa nhập code để chạy.';
      this.verdict = 'Failed';
      this.status = 'Empty source';
      return;
    }

    this.error = '';
    this.output = 'Đang gửi code đến Judge API...';
    this.verdict = 'Running';
    this.status = 'Running';
    this.executionTimeMs = 0;
    this.memoryUsedKb = 0;
    this.isRunning = true;

    this.api.post('/api/v1/code/run', {
      language: this.language,
      sourceCode,
      stdin: this.stdin,
      timeLimitMs: this.timeLimitMs
    }).subscribe({
      next: (response: ApiResponse<PlaygroundResult> | any) => {
        const data: PlaygroundResult = response?.data ?? response ?? {};
        this.applyResult(data);
        this.isRunning = false;
      },
      error: (err: any) => {
        this.output = '';
        this.error = err?.error?.message
          || err?.error?.title
          || err?.message
          || 'Không chạy được code. Hãy kiểm tra API hoặc runtime trên server.';
        this.verdict = 'Failed';
        this.status = 'API Error';
        this.lastRunAt = this.formatTime(new Date());
        this.isRunning = false;
      }
    });
  }

  private applyResult(data: PlaygroundResult): void {
    this.output = data.output ?? data.stdout ?? '';
    this.error = data.error ?? data.stderr ?? '';
    this.status = data.status || '';
    this.verdict = data.verdict || data.status || (this.error ? 'Failed' : 'Completed');
    this.executionTimeMs = Number(data.executionTimeMs || 0);
    this.memoryUsedKb = Number(data.memoryUsedKb || 0);
    this.lastRunAt = this.formatTime(new Date());

    if (!this.output && !this.error) {
      this.output = '(Chương trình không in ra dữ liệu.)';
    }
  }

  get lineCount(): number {
    return Math.max((this.code || '').split('\n').length, 1);
  }

  get codeLength(): number {
    return (this.code || '').length;
  }

  get fileName(): string {
    const map: Record<string, string> = {
      javascript: 'main.js',
      python: 'main.py',
      cpp: 'main.cpp',
      java: 'Main.java'
    };

    return map[this.language] || `main.${this.language}`;
  }

  get statusClass(): string {
    const text = `${this.verdict} ${this.status}`.toLowerCase();
    if (this.isRunning) return 'running';
    if (text.includes('accept') || text.includes('success') || text.includes('complete') || text.includes('ok')) return 'success';
    if (text.includes('wrong') || text.includes('fail') || text.includes('error') || text.includes('time')) return 'danger';
    return 'neutral';
  }

  async copyCode(): Promise<void> {
    await this.copyText(this.code || '');
    this.copiedCode = true;
    setTimeout(() => this.copiedCode = false, 1200);
  }

  async copyOutput(): Promise<void> {
    const text = [this.output, this.error ? `\nSTDERR:\n${this.error}` : ''].join('').trim();
    await this.copyText(text);
    this.copiedOutput = true;
    setTimeout(() => this.copiedOutput = false, 1200);
  }

  private async copyText(text: string): Promise<void> {
    try {
      if (navigator?.clipboard?.writeText) {
        await navigator.clipboard.writeText(text || '');
      }
    } catch {
      // Clipboard may be blocked by browser settings. Ignore silently.
    }
  }

  private formatTime(date: Date): string {
    return date.toLocaleTimeString('vi-VN', {
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit'
    });
  }
}