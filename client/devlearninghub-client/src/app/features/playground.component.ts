import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../core/services/api.service';

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
  output = 'Click Run Code to see output.';
  stdin = '';
  executionTimeMs = 0;
  verdict = '';

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

  code = this.templates['javascript'];

  constructor(private api: ApiService) {}

  ngOnInit(): void {
    this.api.get<any>('/api/v1/code/languages').subscribe({
      next: r => this.languages = r.data || [],
      error: () => this.languages = [
        { value: 'javascript', label: 'JavaScript' },
        { value: 'python', label: 'Python' },
        { value: 'java', label: 'Java' },
        { value: 'cpp', label: 'C++17' }
      ]
    });
  }

  setLanguage(language: string): void {
    this.language = language;
    this.code = this.templates[language] || '';
    this.output = 'Click Run Code to see output.';
    this.verdict = '';
    this.error = '';
  }

  reset(): void {
    this.code = this.templates[this.language] || '';
    this.stdin = '';
    this.output = 'Click Run Code to see output.';
    this.verdict = '';
    this.error = '';
  }

  run(): void {
    if (this.isRunning) return;
    this.error = '';
    this.output = 'Running...';
    this.verdict = 'Running';
    this.isRunning = true;
    this.api.post<any>('/api/v1/code/run', {
      language: this.language,
      sourceCode: this.code,
      stdin: this.stdin,
      timeLimitMs: 3000
    }).subscribe({
      next: r => {
        const data = r.data || r;
        this.output = data.output || '';
        this.error = data.error || '';
        this.verdict = data.verdict || data.status || 'Completed';
        this.executionTimeMs = data.executionTimeMs || 0;
        this.isRunning = false;
      },
      error: e => {
        this.output = '';
        this.error = e?.error?.message || e?.error?.title || 'Không chạy được code. Hãy kiểm tra API hoặc runtime trên server.';
        this.verdict = 'Failed';
        this.isRunning = false;
      }
    });
  }
}
