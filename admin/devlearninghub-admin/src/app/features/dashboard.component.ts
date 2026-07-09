import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { ApiService } from '../core/services/api.service';
import { AuthService } from '../core/services/auth.service';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './dashboard.component.html'
})
export class DashboardComponent implements OnInit {
  tab = 'questions';
  users: any[] = [];
  roles: any[] = [];
  permissions: any[] = [];
  userRoleDetail: any = null;
  userPermissionDetail: any = null;
  roleSaving = false;
  permissionSaving = false;
  categories: any[] = [];
  questions: any[] = [];
  quizSets: any[] = [];

  searchQuestion = '';
  questionCategoryFilter: any = 'all';
  quizSetCategoryFilter: any = 'all';
  showQuestionForm = false;
  showCategoryForm = true;
  showQuizSetForm = true;
  message = '';
  error = '';
  file?: File;
  importResult: any;

  editingCategoryId: number | null = null;
  editingQuestionId: number | null = null;
  editingQuizSetId: number | null = null;

  categoryForm: any = this.blankCategory();
  questionForm: any = this.blankQuestion();
  quizSetForm: any = this.blankQuizSet();

  constructor(private api: ApiService, public auth: AuthService) {}

  ngOnInit(): void { this.loadAll(); }

  loadAll(): void {
    this.api.get<any>('/api/v1/admin/users').subscribe({ next: r => this.users = r.data || [] });
    this.api.get<any>('/api/v1/admin/roles').subscribe({ next: r => this.roles = r.data || [] });
    this.api.get<any>('/api/v1/admin/permissions').subscribe({ next: r => this.permissions = r.data || [] });
    this.api.get<any>('/api/v1/categories?pageSize=100').subscribe({ next: r => this.categories = r.data?.items || [] });
    this.api.get<any>('/api/v1/questions?pageSize=100').subscribe({ next: r => this.questions = r.data?.items || [] });
    this.api.get<any>('/api/v1/quiz-sets?pageSize=100').subscribe({ next: r => this.quizSets = r.data?.items || [] });
  }

  get filteredQuestions(): any[] {
    const keyword = this.searchQuestion.toLowerCase().trim();
    return this.questions.filter(q => {
      const okKeyword = !keyword || (q.title || q.content || '').toLowerCase().includes(keyword);
      const okCategory = this.questionCategoryFilter === 'all' || Number(q.categoryId) === Number(this.questionCategoryFilter);
      return okKeyword && okCategory;
    });
  }

  get filteredQuizSets(): any[] {
    return this.quizSets.filter(q => this.quizSetCategoryFilter === 'all' || Number(q.categoryId) === Number(this.quizSetCategoryFilter));
  }

  get selectableQuestions(): any[] {
    const cid = this.quizSetForm.categoryId;
    return this.questions.filter(q => !cid || Number(q.categoryId) === Number(cid));
  }

  blankCategory(): any {
    return { parentId: null, name: '', slug: '', description: '', iconUrl: '', displayOrder: 1, status: 1 };
  }

  blankQuestion(): any {
    return {
      categoryId: this.categories[0]?.id || 1,
      title: '',
      content: '',
      explanation: '',
      difficulty: 1,
      questionType: 1,
      status: 2,
      source: 'Admin',
      options: [1, 2, 3, 4].map(i => ({ content: '', isCorrect: i === 1, explanation: '', displayOrder: i }))
    };
  }

  blankQuizSet(): any {
    return {
      categoryId: this.categories[0]?.id || 1,
      title: '',
      slug: '',
      description: '',
      difficulty: 1,
      quizType: 1,
      timeLimitMinutes: 15,
      passingScore: 5,
      allowReview: true,
      shuffleQuestions: false,
      shuffleOptions: false,
      maxAttempts: 3,
      status: 1,
      questions: []
    };
  }

  slugify(s: string): string {
    return (s || '')
      .toLowerCase()
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '')
      .replace(/đ/g, 'd')
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-|-$/g, '');
  }

  clearMessages(): void { this.message = ''; this.error = ''; }
  notifyOk(msg: string): void { this.message = msg; this.error = ''; }
  notifyErr(msg: string): void { this.error = msg; this.message = ''; }

  categoryName(id: any): string { return this.categories.find(c => Number(c.id) === Number(id))?.name || id || 'N/A'; }
  difficultyText(d: any): string { return Number(d) === 3 ? 'Advanced' : Number(d) === 2 ? 'Intermediate' : 'Beginner'; }
  difficultyBadge(d: any): string { return Number(d) === 3 ? 'badge-red' : Number(d) === 2 ? 'badge-yellow' : 'badge-green'; }
  statusText(s: any): string { return Number(s) === 0 ? 'Inactive' : Number(s) === 1 ? 'Active' : 'Published'; }
  statusBadge(s: any): string { return Number(s) === 0 ? 'badge-red' : 'badge-green'; }


  roleNames(user: any): string {
    const roles = user?.roles || [];
    return roles.length ? roles.map((r: any) => r.name).join(', ') : 'Chưa có quyền';
  }

  openRolePanel(user: any): void {
    this.clearMessages();
    this.api.get<any>(`/api/v1/admin/users/${user.id}/roles`).subscribe({
      next: r => this.userRoleDetail = r.data,
      error: e => this.notifyErr(e?.error?.message || 'Không tải được quyền tài khoản')
    });
  }

  closeRolePanel(): void { this.userRoleDetail = null; }

  openPermissionPanel(user: any): void {
    this.clearMessages();
    this.api.get<any>(`/api/v1/admin/users/${user.id}/permissions`).subscribe({
      next: r => this.userPermissionDetail = r.data,
      error: e => this.notifyErr(e?.error?.message || 'Không tải được quyền lẻ của tài khoản')
    });
  }

  closePermissionPanel(): void { this.userPermissionDetail = null; }

  toggleUserPermission(permission: any, checked: boolean): void {
    if (!this.userPermissionDetail || this.permissionSaving) return;
    permission.assigned = checked;
    const selectedPermissionIds = (this.userPermissionDetail.permissions || [])
      .filter((p: any) => p.assigned)
      .map((p: any) => p.id);
    this.permissionSaving = true;
    this.api.put<any>(`/api/v1/admin/users/${this.userPermissionDetail.user.id}/permissions`, { permissionIds: selectedPermissionIds }).subscribe({
      next: r => {
        this.userPermissionDetail = r.data;
        this.notifyOk(r.message || 'Cập nhật quyền lẻ thành công');
        this.loadAll();
        this.permissionSaving = false;
      },
      error: e => {
        this.notifyErr(e?.error?.message || 'Không cập nhật được quyền lẻ');
        this.permissionSaving = false;
        this.openPermissionPanel(this.userPermissionDetail.user);
      }
    });
  }

  get permissionModules(): string[] {
    const items = this.userPermissionDetail?.permissions || [];
    return [...new Set(items.map((p: any) => p.module || 'Other'))] as string[];
  }

  permissionsForModule(module: string): any[] {
    return (this.userPermissionDetail?.permissions || []).filter((p: any) => (p.module || 'Other') === module);
  }

  sourceRoleText(permission: any): string {
    const roles = permission?.sourceRoles || [];
    return roles.length ? roles.join(', ') : '';
  }

  toggleUserRole(role: any, checked: boolean): void {
    if (!this.userRoleDetail || this.roleSaving) return;
    role.assigned = checked;
    const selectedRoleIds = (this.userRoleDetail.roles || [])
      .filter((r: any) => r.assigned)
      .map((r: any) => r.id);
    this.roleSaving = true;
    this.api.put<any>(`/api/v1/admin/users/${this.userRoleDetail.user.id}/roles`, { roleIds: selectedRoleIds }).subscribe({
      next: r => {
        this.userRoleDetail = r.data;
        this.notifyOk(r.message || 'Cập nhật quyền thành công');
        this.loadAll();
        this.roleSaving = false;
      },
      error: e => {
        this.notifyErr(e?.error?.message || 'Không cập nhật được quyền');
        this.roleSaving = false;
        this.openRolePanel(this.userRoleDetail.user);
      }
    });
  }

  rolePermissionText(role: any): string {
    const permissions = role?.permissions || [];
    return permissions.length ? permissions.join(', ') : 'Không có permission riêng';
  }

  autoCategorySlug(): void { if (!this.categoryForm.slug) this.categoryForm.slug = this.slugify(this.categoryForm.name); }
  autoQuizSlug(): void { if (!this.quizSetForm.slug) this.quizSetForm.slug = this.slugify(this.quizSetForm.title); }

  createOrUpdateCategory(): void {
    this.clearMessages();
    if (!this.categoryForm.slug) this.categoryForm.slug = this.slugify(this.categoryForm.name);
    const req = this.editingCategoryId
      ? this.api.put<any>(`/api/v1/categories/${this.editingCategoryId}`, this.categoryForm)
      : this.api.post<any>('/api/v1/categories', this.categoryForm);
    req.subscribe({
      next: () => {
        this.notifyOk(this.editingCategoryId ? 'Cập nhật category thành công' : 'Tạo category thành công');
        this.cancelCategoryEdit();
        this.loadAll();
      },
      error: e => this.notifyErr(e?.error?.message || 'Không lưu được category')
    });
  }

  editCategory(c: any): void {
    this.editingCategoryId = c.id;
    this.showCategoryForm = true;
    this.categoryForm = { ...c };
  }

  cancelCategoryEdit(): void {
    this.editingCategoryId = null;
    this.categoryForm = this.blankCategory();
  }

  deleteCategory(c: any): void {
    if (!confirm(`Xóa category "${c.name}"?`)) return;
    this.api.delete<any>(`/api/v1/categories/${c.id}`).subscribe({
      next: () => { this.notifyOk('Đã xóa category'); this.loadAll(); },
      error: e => this.notifyErr(e?.error?.message || 'Không xóa được category')
    });
  }

  markCorrect(i: number): void {
    this.questionForm.options.forEach((o: any, idx: number) => o.isCorrect = idx === i);
  }

  createOrUpdateQuestion(): void {
    this.clearMessages();
    const options = (this.questionForm.options || []).filter((o: any) => (o.content || '').trim());
    this.questionForm.options = options.map((o: any, i: number) => ({ ...o, displayOrder: i + 1 }));
    const req = this.editingQuestionId
      ? this.api.put<any>(`/api/v1/questions/${this.editingQuestionId}`, this.questionForm)
      : this.api.post<any>('/api/v1/questions', this.questionForm);
    req.subscribe({
      next: () => {
        this.notifyOk(this.editingQuestionId ? 'Cập nhật question thành công' : 'Tạo question thành công');
        this.cancelQuestionEdit();
        this.loadAll();
      },
      error: e => this.notifyErr(e?.error?.message || 'Không lưu được question')
    });
  }

  editQuestion(q: any): void {
    this.editingQuestionId = q.id;
    this.showQuestionForm = true;
    this.questionForm = {
      categoryId: q.categoryId,
      title: q.title,
      content: q.content,
      explanation: q.explanation || '',
      difficulty: q.difficulty || 1,
      questionType: q.questionType || 1,
      status: q.status || 2,
      source: q.source || 'Admin',
      options: (q.options || []).map((o: any, i: number) => ({ content: o.content, isCorrect: o.isCorrect, explanation: o.explanation || '', displayOrder: i + 1 }))
    };
  }

  cancelQuestionEdit(): void {
    this.editingQuestionId = null;
    this.showQuestionForm = false;
    this.questionForm = this.blankQuestion();
  }

  deleteQuestion(q: any): void {
    if (!confirm(`Xóa câu hỏi #${q.id}? Câu hỏi sẽ được gỡ khỏi các bộ đề.`)) return;
    this.api.delete<any>(`/api/v1/questions/${q.id}`).subscribe({
      next: () => { this.notifyOk('Đã xóa câu hỏi'); this.loadAll(); },
      error: e => this.notifyErr(e?.error?.message || 'Không xóa được câu hỏi')
    });
  }

  isQuestionSelected(qid: number): boolean {
    return (this.quizSetForm.questions || []).some((q: any) => Number(q.questionId) === Number(qid));
  }

  toggleQuestion(q: any, checked: boolean): void {
    if (checked) {
      if (!this.isQuestionSelected(q.id)) {
        this.quizSetForm.questions.push({ questionId: q.id, displayOrder: this.quizSetForm.questions.length + 1, score: 1 });
      }
    } else {
      this.quizSetForm.questions = this.quizSetForm.questions.filter((x: any) => Number(x.questionId) !== Number(q.id));
      this.quizSetForm.questions.forEach((x: any, i: number) => x.displayOrder = i + 1);
    }
  }

  selectedQuestionScore(qid: number): number {
    return this.quizSetForm.questions.find((x: any) => Number(x.questionId) === Number(qid))?.score || 1;
  }

  setQuestionScore(qid: number, score: any): void {
    const item = this.quizSetForm.questions.find((x: any) => Number(x.questionId) === Number(qid));
    if (item) item.score = Number(score) || 1;
  }

  createOrUpdateQuizSet(): void {
    this.clearMessages();
    if (!this.quizSetForm.slug) this.quizSetForm.slug = this.slugify(this.quizSetForm.title);
    this.quizSetForm.questions = (this.quizSetForm.questions || []).map((q: any, i: number) => ({ ...q, displayOrder: i + 1, score: Number(q.score) || 1 }));
    const req = this.editingQuizSetId
      ? this.api.put<any>(`/api/v1/quiz-sets/${this.editingQuizSetId}`, this.quizSetForm)
      : this.api.post<any>('/api/v1/quiz-sets', this.quizSetForm);
    req.subscribe({
      next: () => {
        this.notifyOk(this.editingQuizSetId ? 'Cập nhật quiz set thành công' : 'Tạo quiz set thành công');
        this.cancelQuizSetEdit();
        this.loadAll();
      },
      error: e => this.notifyErr(e?.error?.message || 'Không lưu được quiz set')
    });
  }

  editQuizSet(qs: any): void {
    this.api.get<any>(`/api/v1/quiz-sets/${qs.id}`).subscribe({
      next: r => {
        const q = r.data;
        this.editingQuizSetId = q.id;
        this.showQuizSetForm = true;
        this.quizSetForm = {
          categoryId: q.categoryId,
          title: q.title,
          slug: q.slug,
          description: q.description || '',
          difficulty: q.difficulty || 1,
          quizType: q.quizType || 1,
          timeLimitMinutes: q.timeLimitMinutes || 15,
          passingScore: q.passingScore ?? 5,
          allowReview: q.allowReview ?? true,
          shuffleQuestions: q.shuffleQuestions || false,
          shuffleOptions: q.shuffleOptions || false,
          maxAttempts: q.maxAttempts || null,
          status: q.status || 1,
          questions: q.questions || []
        };
      },
      error: e => this.notifyErr(e?.error?.message || 'Không tải được quiz set')
    });
  }

  cancelQuizSetEdit(): void {
    this.editingQuizSetId = null;
    this.quizSetForm = this.blankQuizSet();
  }

  deleteQuizSet(q: any): void {
    if (!confirm(`Xóa quiz set "${q.title}"?`)) return;
    this.api.delete<any>(`/api/v1/quiz-sets/${q.id}`).subscribe({
      next: () => { this.notifyOk('Đã xóa quiz set'); this.loadAll(); },
      error: e => this.notifyErr(e?.error?.message || 'Không xóa được quiz set')
    });
  }

  pick(e: any): void { this.file = e.target.files?.[0]; }

  downloadCsvTemplate(): void {
    const rows = [
      [
        'CategoryId', 'CategorySlug', 'CategoryName', 'Title', 'Content', 'QuestionExplanation',
        'Difficulty', 'CorrectOption',
        'OptionA', 'OptionAExplanation',
        'OptionB', 'OptionBExplanation',
        'OptionC', 'OptionCExplanation',
        'OptionD', 'OptionDExplanation',
        'Source'
      ],
      [
        this.categories[0]?.id || 1,
        this.categories[0]?.slug || '',
        this.categories[0]?.name || '',
        'API dùng để làm gì?',
        'API trong hệ thống web thường dùng để làm gì?',
        'API là lớp trung gian giúp frontend gửi yêu cầu và nhận dữ liệu từ backend.',
        1,
        'A',
        'Kết nối frontend với backend để trao đổi dữ liệu',
        'Đúng, frontend gọi API để lấy hoặc gửi dữ liệu.',
        'Chỉ dùng để thiết kế màu sắc giao diện',
        '',
        'Chỉ dùng để tạo ảnh nền',
        '',
        'Chỉ dùng để gõ văn bản Word',
        '',
        'Excel/CSV Import'
      ]
    ];

    const csv = rows.map(r => r.map(v => `"${String(v ?? '').replace(/"/g, '""')}"`).join(',')).join('\r\n');
    const blob = new Blob(['\ufeff' + csv], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'devlearninghub_questions_template.csv';
    a.click();
    URL.revokeObjectURL(url);
  }

  importFile(): void {
    this.clearMessages();
    if (!this.file) { this.notifyErr('Chọn file CSV trước.'); return; }
    const fd = new FormData();
    fd.append('file', this.file);
    this.api.upload<any>('/api/v1/questions/import-csv', fd).subscribe({
      next: r => { this.importResult = r; this.notifyOk('Import CSV hoàn tất. Hãy kiểm tra tab Questions và gắn câu hỏi vào Quiz Set.'); this.loadAll(); },
      error: e => { this.importResult = e?.error; this.notifyErr(e?.error?.message || 'Import CSV thất bại'); }
    });
  }

  importJsonFile(): void {
    this.clearMessages();
    if (!this.file) { this.notifyErr('Chọn file JSON trước.'); return; }
    const fd = new FormData();
    fd.append('file', this.file);
    this.api.upload<any>('/api/v1/questions/import-json', fd).subscribe({
      next: r => { this.importResult = r; this.notifyOk('Import JSON hoàn tất. Hãy kiểm tra tab Questions và gắn câu hỏi vào Quiz Set.'); this.loadAll(); },
      error: e => { this.importResult = e?.error; this.notifyErr(e?.error?.message || 'Import JSON thất bại'); }
    });
  }
}
