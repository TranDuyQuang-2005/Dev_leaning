import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ApiResponse, ApiService } from '../core/services/api.service';

interface PlaygroundLanguage {
  value: string;
  label: string;
  runtime?: string;
  enabled?: boolean;
  fileExtension?: string;
  defaultTemplate?: string;
  compileCommand?: string;
  runCommand?: string;
  requiredRuntime?: string;
}

interface PlaygroundResult {
  status?: string;
  verdict?: string;
  output?: string;
  stdout?: string;
  error?: string;
  stderr?: string;
  compileOutput?: string;
  executionTimeMs?: number;
  memoryUsedKb?: number;
  language?: string;
  submissionId?: number;
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
  output = 'Bấm Run để xem kết quả chương trình.';
  stdin = '';
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
    { value: 'python', label: 'Python', runtime: 'Python 3', enabled: true },
    { value: 'javascript', label: 'JavaScript', runtime: 'Node.js', enabled: true },
    { value: 'typescript', label: 'TypeScript', runtime: 'Node.js + TypeScript', enabled: true },
    { value: 'java', label: 'Java', runtime: 'JDK', enabled: true },
    { value: 'c', label: 'C', runtime: 'GCC', enabled: true },
    { value: 'cpp', label: 'C++17', runtime: 'G++', enabled: true },
    { value: 'csharp', label: 'C#', runtime: '.NET SDK', enabled: true },
    { value: 'go', label: 'Go', runtime: 'Go', enabled: true }
  ];

  readonly templates: Record<string, string> = {
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

  readonly sampleInputs: Record<string, string> = {
    python: '',
    javascript: '',
    typescript: '',
    java: '',
    c: '',
    cpp: '',
    csharp: '',
    go: ''
  };

  readonly ioTemplates: Record<string, string> = {
    javascript: `const fs = require('fs');
const input = fs.readFileSync(0, 'utf8').trim();
console.log(input || 'Hello, World!');`,
    python: `import sys
text = sys.stdin.read().strip()
print(text or "Hello, World!")`,
    java: `import java.io.*;
public class Main {
    public static void main(String[] args) throws Exception {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String value = br.readLine();
        System.out.println(value == null || value.isBlank() ? "Hello, World!" : value);
    }
}`,
    typescript: `import * as fs from 'fs';
const input = fs.readFileSync(0, 'utf8').trim();
console.log(input || 'Hello, World!');`,
    c: `#include <stdio.h>
int main() {
    char buffer[1024];
    if (fgets(buffer, sizeof(buffer), stdin)) printf("%s", buffer);
    else printf("Hello, World!\\n");
    return 0;
}`,
    cpp: `#include <bits/stdc++.h>
using namespace std;
int main() {
    string value;
    getline(cin, value);
    cout << (value.empty() ? "Hello, World!" : value) << endl;
    return 0;
}`,
    csharp: `using System;
public class Program {
    public static void Main() {
        var value = Console.ReadLine();
        Console.WriteLine(string.IsNullOrWhiteSpace(value) ? "Hello, World!" : value);
    }
}`,
    go: `package main
import (
    "bufio"
    "fmt"
    "os"
)
func main() {
    scanner := bufio.NewScanner(os.Stdin)
    if scanner.Scan() && scanner.Text() != "" {
        fmt.Println(scanner.Text())
        return
    }
    fmt.Println("Hello, World!")
}`
  };

  constructor(private api: ApiService) {
    this.code = this.templates[this.language];
  }

  ngOnInit(): void {
    this.loadLanguages();
  }

  loadLanguages(): void {
    this.api.get<PlaygroundLanguage[]>('/api/v1/code/languages').subscribe({
      next: (response: ApiResponse<PlaygroundLanguage[]> | any) => {
        const source = response?.data ?? response;
        const items = Array.isArray(source) ? source : [];
        const mapped = items
          .map((item: any) => this.mapLanguage(item))
          .filter((item: PlaygroundLanguage) => !!item.value);

        this.languages = mapped.length ? mapped : this.fallbackLanguages;
        if (!this.languages.some((item: PlaygroundLanguage) => item.value === this.language)) {
          this.setLanguage(this.languages[0]?.value || 'javascript');
        } else {
          this.code = this.templateFor(this.language);
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

    const value = String(item?.value || item?.id || item?.language || item?.name || '').trim();
    const label = String(item?.label || item?.displayName || item?.name || this.prettyLanguage(value)).trim();

    return {
      value,
      label,
      runtime: item?.runtime || item?.requiredRuntime || item?.version || '',
      enabled: item?.enabled !== false && item?.isActive !== false,
      fileExtension: item?.fileExtension || '',
      defaultTemplate: item?.defaultTemplate || '',
      compileCommand: item?.compileCommand || '',
      runCommand: item?.runCommand || '',
      requiredRuntime: item?.requiredRuntime || item?.runtime || ''
    };
  }

  trackByLanguage(_: number, item: PlaygroundLanguage): string {
    return item.value;
  }

  prettyLanguage(value: string): string {
    const map: Record<string, string> = {
      javascript: 'JavaScript',
      js: 'JavaScript',
      python: 'Python',
      py: 'Python',
      java: 'Java',
      typescript: 'TypeScript',
      ts: 'TypeScript',
      c: 'C',
      cpp: 'C++17',
      cplusplus: 'C++17',
      csharp: 'C#',
      cs: 'C#',
      go: 'Go'
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
    this.code = this.templateFor(language);
    this.stdin = this.sampleInputs[language] || '';
    this.resetResult('Đã đổi ngôn ngữ. Bấm Run để chạy code mới.');
  }

  useSampleInput(): void {
    const sample = this.sampleInputs[this.language] ?? '';
    this.stdin = sample || 'DevLearningHub';
    if (!sample && this.ioTemplates[this.language]) {
      this.stdin = 'DevLearningHub';
      this.code = this.ioTemplates[this.language];
    }
  }

  reset(): void {
    this.code = this.templateFor(this.language);
    this.stdin = this.sampleInputs[this.language] || '';
    this.resetResult('Đã reset template. Bấm Run để chạy lại.');
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

    this.api.post<PlaygroundResult>('/api/v1/code/run', {
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
    this.error = data.error ?? data.stderr ?? data.compileOutput ?? '';
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

  fileExtension(language = this.language): string {
    const current = this.languages.find((item: PlaygroundLanguage) => item.value === language);
    return current?.fileExtension || ({ python: 'py', javascript: 'js', typescript: 'ts', java: 'java', c: 'c', cpp: 'cpp', csharp: 'cs', go: 'go' } as Record<string, string>)[language] || 'txt';
  }

  private templateFor(language: string): string {
    const current = this.languages.find((item: PlaygroundLanguage) => item.value === language);
    return current?.defaultTemplate || this.templates[language] || '';
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
    if (navigator?.clipboard?.writeText) {
      await navigator.clipboard.writeText(text || '');
    }
  }

  private formatTime(date: Date): string {
    return date.toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit', second: '2-digit' });
  }
}
