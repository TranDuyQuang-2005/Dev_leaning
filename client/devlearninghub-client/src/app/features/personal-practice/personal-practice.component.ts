import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { ApiService } from '../../core/services/api.service';

@Component({
  selector: 'app-personal-practice',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './personal-practice.component.html'
})
export class PersonalPracticeComponent implements OnInit {
  banks: any[] = [];
  form = { title: '', description: '' };
  file?: File;
  loading = false;
  uploading = false;
  message = '';
  error = '';
  importErrors: any[] = [];

  constructor(private api: ApiService, private router: Router) {}

  ngOnInit(): void {
    this.load();
  }

  load(): void {
    this.loading = true;
    this.api.getPracticeBanks().subscribe({
      next: r => {
        const data: any = r.data || [];
        this.banks = Array.isArray(data) ? data : data.items || [];
        this.loading = false;
      },
      error: e => {
        this.error = this.api.errorMessage(e, 'Không tải được ngân hàng câu hỏi cá nhân.');
        this.loading = false;
      }
    });
  }

  pick(event: Event): void {
    this.file = (event.target as HTMLInputElement).files?.[0];
  }

  upload(): void {
    this.message = '';
    this.error = '';
    this.importErrors = [];

    if (!this.form.title.trim()) {
      this.error = 'Vui lòng nhập tiêu đề.';
      return;
    }
    if (!this.file) {
      this.error = 'Vui lòng chọn file CSV hoặc JSON.';
      return;
    }

    const fd = new FormData();
    fd.append('title', this.form.title);
    fd.append('description', this.form.description || '');
    fd.append('file', this.file);

    this.uploading = true;
    this.api.uploadPracticeBank(fd).subscribe({
      next: r => {
        this.message = r.message || 'Upload ngân hàng câu hỏi thành công.';
        this.form = { title: '', description: '' };
        this.file = undefined;
        this.uploading = false;
        this.load();
      },
      error: e => {
        this.error = this.api.errorMessage(e, 'Import file thất bại.');
        this.importErrors = e?.error?.errors || e?.error?.data?.errors || [];
        this.uploading = false;
      }
    });
  }

  deleteBank(bank: any): void {
    if (!confirm(`Xóa ngân hàng câu hỏi "${bank.title}"?`)) return;
    this.api.deletePracticeBank(bank.id).subscribe({
      next: () => {
        this.message = 'Đã xóa ngân hàng câu hỏi.';
        this.load();
      },
      error: e => this.error = this.api.errorMessage(e, 'Không xóa được ngân hàng câu hỏi.')
    });
  }

  startQuick(bank: any): void {
    this.api.startPracticeAttempt(bank.id, {
      numberOfQuestions: bank.questionCount || bank.questions?.length || 10,
      shuffleQuestions: true,
      shuffleOptions: true
    }).subscribe({
      next: r => {
        const attemptId = (r.data as any)?.id || (r.data as any)?.attemptId;
        if (attemptId) this.router.navigate(['/learner/practice-attempts', attemptId]);
      },
      error: e => this.error = this.api.errorMessage(e, 'Không bắt đầu được lượt luyện tập.')
    });
  }

  downloadTemplate(): void {
    const header = 'question_text,question_type,option_a,option_b,option_c,option_d,correct_answer,explanation,difficulty,tags';
    const sample = '"API dùng để làm gì?","single_choice","Kết nối frontend với backend","Thiết kế màu sắc","Tạo ảnh nền","Gõ văn bản Word","A","API là lớp trung gian giúp trao đổi dữ liệu.","easy","api,web"';
    const blob = new Blob(['\ufeff' + header + '\r\n' + sample], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'personal_practice_template.csv';
    a.click();
    URL.revokeObjectURL(url);
  }
}
