import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { ApiService } from '../core/services/api.service';
import { AuthService } from '../core/services/auth.service';

@Component({
  selector: 'app-code-management',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './code-management.component.html'
})
export class CodeManagementComponent implements OnInit {
  tab = 'problems';
  problems: any[] = [];
  languages: any[] = [];
  form: any = this.blank();
  editingId: number | null = null;
  message = '';
  error = '';
  loading = false;
  submissionId = '';
  submissionDetail: any = null;

  constructor(private api: ApiService, public auth: AuthService) {}

  ngOnInit(): void {
    this.load();
    this.loadLanguages();
  }

  blank(): any {
    return {
      title: '', slug: '', description: '', inputFormat: '', outputFormat: '', constraints: '', examplesJson: '', tags: '',
      difficulty: 1, status: 1, timeLimitMs: 2000, memoryLimitKb: 131072,
      starterCodeJavaScript: `const fs = require('fs');\nconst input = fs.readFileSync(0, 'utf8').trim().split(/\\s+/).map(Number);\n// Write your solution here\nconsole.log(input.reduce((a,b)=>a+b,0));`,
      starterCodePython: `import sys\nnums = list(map(int, sys.stdin.read().strip().split()))\n# Write your solution here\nprint(sum(nums))`,
      starterCodeTypeScript: `const message: string = "Hello, World!";\nconsole.log(message);`,
      starterCodeJava: `import java.io.*;\nimport java.util.*;\n\npublic class Main {\n    public static void main(String[] args) throws Exception {\n        Scanner sc = new Scanner(System.in);\n        long sum = 0;\n        while (sc.hasNextLong()) sum += sc.nextLong();\n        System.out.println(sum);\n    }\n}`,
      starterCodeC: `#include <stdio.h>\nint main() {\n    printf("Hello, World!\\n");\n    return 0;\n}`,
      starterCodeCpp: `#include <bits/stdc++.h>\nusing namespace std;\n\nint main(){\n    long long x, sum = 0;\n    while(cin >> x) sum += x;\n    cout << sum << endl;\n    return 0;\n}`,
      starterCodeCsharp: `using System;\npublic class Program {\n    public static void Main() {\n        Console.WriteLine("Hello, World!");\n    }\n}`,
      starterCodeGo: `package main\nimport "fmt"\nfunc main() {\n    fmt.Println("Hello, World!")\n}`,
      testCases: [{ input: '2 7', expectedOutput: '9', explanation: '2 + 7 = 9', isHidden: false, displayOrder: 1 }]
    };
  }

  load(): void {
    this.loading = true;
    this.api.get<any>('/api/v1/admin/code/problems').subscribe({
      next: r => { this.problems = r.data || []; this.loading = false; },
      error: e => { this.error = this.api.errorMessage(e, 'Không tải được danh sách problem. Kiểm tra script DB v12.'); this.loading = false; }
    });
  }

  loadLanguages(): void {
    this.api.get<any[]>('/api/v1/code/languages').subscribe({
      next: r => this.languages = r.data || [],
      error: () => this.languages = []
    });
  }

  slugify(s: string): string {
    return (s || '').toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/đ/g, 'd').replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
  }

  autoSlug(): void { if (!this.form.slug) this.form.slug = this.slugify(this.form.title); }
  addTestCase(): void { this.form.testCases.push({ input: '', expectedOutput: '', explanation: '', isHidden: false, displayOrder: this.form.testCases.length + 1 }); }
  removeTestCase(i: number): void { this.form.testCases.splice(i, 1); this.form.testCases.forEach((x: any, idx: number) => x.displayOrder = idx + 1); }

  edit(p: any): void {
    this.editingId = p.id;
    this.form = JSON.parse(JSON.stringify(p));
    this.form.testCases = (p.testCases || []).map((x: any, i: number) => ({ ...x, displayOrder: x.displayOrder || i + 1 }));
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  cancel(): void { this.editingId = null; this.form = this.blank(); this.message = ''; this.error = ''; }

  save(): void {
    this.message = '';
    this.error = '';
    if (!this.form.slug) this.form.slug = this.slugify(this.form.title);
    this.form.testCases = (this.form.testCases || []).map((x: any, i: number) => ({ ...x, displayOrder: i + 1 }));
    const req = this.editingId
      ? this.api.put<any>(`/api/v1/admin/code/problems/${this.editingId}`, this.form)
      : this.api.post<any>('/api/v1/admin/code/problems', this.form);
    req.subscribe({
      next: r => { this.message = r.message || 'Lưu problem thành công'; this.cancel(); this.load(); },
      error: e => { this.error = this.api.errorMessage(e, 'Không lưu được problem'); }
    });
  }

  delete(p: any): void {
    if (!confirm(`Xóa problem "${p.title}"?`)) return;
    this.api.delete<any>(`/api/v1/admin/code/problems/${p.id}`).subscribe({
      next: () => { this.message = 'Đã xóa problem'; this.load(); },
      error: e => { this.error = this.api.errorMessage(e, 'Không xóa được problem'); }
    });
  }

  loadSubmission(): void {
    this.message = '';
    this.error = '';
    this.submissionDetail = null;
    if (!this.submissionId) {
      this.error = 'Nhập submissionId trước.';
      return;
    }
    this.api.getAdminSubmissionDetail(this.submissionId).subscribe({
      next: r => this.submissionDetail = r.data,
      error: e => this.error = this.api.errorMessage(e, 'Không tải được submission.')
    });
  }

  get submissionTests(): any[] {
    return this.submissionDetail?.testcaseResults || this.submissionDetail?.testCaseResults || [];
  }

  difficultyText(d: any): string { return Number(d) === 3 ? 'Hard' : Number(d) === 2 ? 'Medium' : 'Easy'; }
  difficultyBadge(d: any): string { return Number(d) === 3 ? 'badge-red' : Number(d) === 2 ? 'badge-yellow' : 'badge-green'; }
  languageStatus(l: any): string { return l.enabled === false || l.isActive === false ? 'Inactive' : 'Active'; }
}
