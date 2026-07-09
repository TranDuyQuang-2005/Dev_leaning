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
  problems: any[] = [];
  form: any = this.blank();
  editingId: number | null = null;
  message = '';
  error = '';
  loading = false;

  constructor(private api: ApiService, public auth: AuthService) {}
  ngOnInit(): void { this.load(); }

  blank(): any {
    return {
      title: '', slug: '', description: '', inputFormat: '', outputFormat: '', constraints: '', examplesJson: '', tags: '',
      difficulty: 1, status: 1, timeLimitMs: 2000, memoryLimitKb: 131072,
      starterCodeJavaScript: `const fs = require('fs');\nconst input = fs.readFileSync(0, 'utf8').trim().split(/\\s+/).map(Number);\n// Write your solution here\nconsole.log(input.reduce((a,b)=>a+b,0));`,
      starterCodePython: `import sys\nnums = list(map(int, sys.stdin.read().strip().split()))\n# Write your solution here\nprint(sum(nums))`,
      starterCodeJava: `import java.io.*;\nimport java.util.*;\n\npublic class Main {\n    public static void main(String[] args) throws Exception {\n        Scanner sc = new Scanner(System.in);\n        long sum = 0;\n        while (sc.hasNextLong()) sum += sc.nextLong();\n        System.out.println(sum);\n    }\n}`,
      starterCodeCpp: `#include <bits/stdc++.h>\nusing namespace std;\n\nint main(){\n    long long x, sum = 0;\n    while(cin >> x) sum += x;\n    cout << sum << endl;\n    return 0;\n}`,
      testCases: [ { input: '2 7', expectedOutput: '9', explanation: '2 + 7 = 9', isHidden: false, displayOrder: 1 } ]
    };
  }

  load(): void {
    this.loading = true;
    this.api.get<any>('/api/v1/admin/code/problems').subscribe({
      next: r => { this.problems = r.data || []; this.loading = false; },
      error: e => { this.error = e?.error?.message || 'Không tải được danh sách problem. Kiểm tra script DB v12.'; this.loading = false; }
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
    this.message = ''; this.error = '';
    if (!this.form.slug) this.form.slug = this.slugify(this.form.title);
    this.form.testCases = (this.form.testCases || []).map((x: any, i: number) => ({ ...x, displayOrder: i + 1 }));
    const req = this.editingId
      ? this.api.put<any>(`/api/v1/admin/code/problems/${this.editingId}`, this.form)
      : this.api.post<any>('/api/v1/admin/code/problems', this.form);
    req.subscribe({
      next: r => { this.message = r.message || 'Lưu problem thành công'; this.cancel(); this.load(); },
      error: e => { this.error = e?.error?.message || 'Không lưu được problem'; }
    });
  }

  delete(p: any): void {
    if (!confirm(`Xóa problem "${p.title}"?`)) return;
    this.api.delete<any>(`/api/v1/admin/code/problems/${p.id}`).subscribe({
      next: () => { this.message = 'Đã xóa problem'; this.load(); },
      error: e => { this.error = e?.error?.message || 'Không xóa được problem'; }
    });
  }

  difficultyText(d: any): string { return Number(d) === 3 ? 'Hard' : Number(d) === 2 ? 'Medium' : 'Easy'; }
  difficultyBadge(d: any): string { return Number(d) === 3 ? 'badge-red' : Number(d) === 2 ? 'badge-yellow' : 'badge-green'; }
}
