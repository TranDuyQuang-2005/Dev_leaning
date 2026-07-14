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
  tab = '';
  readonly tabPermissions: Record<string, string[]> = {
    questions: ['question.manage'],
    categories: ['category.manage'],
    quizsets: ['quiz.manage'],
    users: ['user.manage'],
    access: ['permission.manage'],
    roadmaps: ['roadmap.manage'],
    audit: ['audit.view'],
    analytics: ['quiz.manage'],
    import: ['question.manage']
  };
  readonly tabMeta: Record<string, { label: string; eyebrow: string; description: string; icon: string }> = {
    questions: { label: 'Questions', eyebrow: 'Question Bank', description: 'Quản lý ngân hàng câu hỏi, đáp án và nội dung giải thích.', icon: 'Q' },
    categories: { label: 'Categories', eyebrow: 'Learning Taxonomy', description: 'Tổ chức chủ đề và cấu trúc nội dung học tập.', icon: 'C' },
    quizsets: { label: 'Quiz Sets', eyebrow: 'Quiz Builder', description: 'Xây dựng bộ đề, cấu hình điểm và gắn câu hỏi.', icon: 'QS' },
    users: { label: 'Users', eyebrow: 'Account Security', description: 'Quản lý tài khoản, role, quyền trực tiếp và trạng thái khóa.', icon: 'U' },
    access: { label: 'Access Control', eyebrow: 'RBAC & Permission Groups', description: 'Quản lý nhóm quyền và quyền hiệu lực theo user hoặc role.', icon: 'AC' },
    roadmaps: { label: 'Roadmaps', eyebrow: 'Learning Operations', description: 'Quản lý learning track, course, module và lesson.', icon: 'R' },
    audit: { label: 'Audit Logs', eyebrow: 'Security & Compliance', description: 'Theo dõi hoạt động quản trị và lịch sử thay đổi dữ liệu.', icon: 'AL' },
    analytics: { label: 'Quiz Analytics', eyebrow: 'Learning Insights', description: 'Theo dõi hiệu quả quiz và quản lý lịch sử attempt.', icon: 'QA' },
    import: { label: 'Import Questions', eyebrow: 'Bulk Operations', description: 'Nhập ngân hàng câu hỏi bằng CSV hoặc JSON.', icon: 'IM' }
  };
  users: any[] = [];
  roles: any[] = [];
  permissions: any[] = [];
  categories: any[] = [];
  questions: any[] = [];
  quizSets: any[] = [];
  roadmapTracks: any[] = [];
  roadmapCourses: any[] = [];

  searchQuestion = '';
  questionCategoryFilter: any = 'all';
  quizSetCategoryFilter: any = 'all';
  showQuestionForm = false;
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
  roadmapTrackForm: any = this.blankRoadmapTrack();
  roadmapCourseForm: any = this.blankRoadmapCourse();
  roadmapModuleForm: any = this.blankRoadmapModule();
  roadmapLessonForm: any = this.blankRoadmapLesson();
  editingRoadmapTrackId: number | null = null;
  editingRoadmapCourseId: number | null = null;
  editingRoadmapModuleId: number | null = null;
  editingRoadmapLessonId: number | null = null;
  selectedRoadmapTrackId: any = '';
  selectedRoadmapCourseId: any = '';
  selectedRoadmapModuleId: any = '';
  roadmapVideoFile?: File;
  roadmapVideoUploading = false;

  userPermissionDetail: any = null;
  permissionSaving = false;

  permissionGroups: any[] = [];
  groupForm: any = this.blankGroup();
  editingGroupId: number | null = null;
  managingGroup: any = null;
  selectedGroupPermissionIds: number[] = [];
  selectedUserForGroups: any = null;
  selectedUserGroupIds: number[] = [];
  selectedRoleId: any = null;
  selectedRoleGroupIds: number[] = [];
  effectiveUser: any = null;
  effectivePermissions: any = null;

  lockUserTarget: any = null;
  lockForm = { reason: '', lockUntil: '' };

  auditFilters: any = { actorUserId: '', action: '', targetType: '', fromDate: '', toDate: '', pageIndex: 1, pageSize: 20 };
  auditLogs: any[] = [];
  auditDetail: any = null;

  quizOverview: any = null;
  quizStats: any = null;
  selectedStatsQuizSetId: any = '';
  resetAttemptId = '';
  resetQuizSetId = '';
  resetUserId = '';

  constructor(private api: ApiService, public auth: AuthService) {}

  get activeTabMeta(): { label: string; eyebrow: string; description: string; icon: string } {
    return this.tabMeta[this.tab] || { label: 'Admin Workspace', eyebrow: 'DevLearningHub', description: 'Chọn một khu vực quản trị để bắt đầu.', icon: 'DLH' };
  }

  ngOnInit(): void {
    this.tab = this.firstAllowedTab();
    this.loadAll();
  }

  loadAll(): void {
    if (this.can('user.manage')) this.api.get<any>('/api/v1/admin/users').subscribe({ next: r => this.users = r.data || [] });
    if (this.canAny(['user.manage', 'permission.manage'])) this.api.get<any>('/api/v1/admin/roles').subscribe({ next: r => this.roles = r.data || [] });
    if (this.canAny(['user.manage', 'permission.manage'])) this.api.get<any>('/api/v1/admin/permissions').subscribe({ next: r => this.permissions = r.data || [] });
    if (this.canAny(['category.manage', 'question.manage', 'quiz.manage'])) this.api.get<any>('/api/v1/categories?pageSize=100').subscribe({ next: r => this.categories = r.data?.items || r.data || [] });
    if (this.canAny(['question.manage', 'quiz.manage'])) this.api.get<any>('/api/v1/questions?pageSize=100').subscribe({ next: r => this.questions = r.data?.items || r.data || [] });
    if (this.can('quiz.manage')) this.api.get<any>('/api/v1/quiz-sets?pageSize=100').subscribe({ next: r => this.quizSets = r.data?.items || r.data || [] });
    if (this.can('permission.manage')) this.loadPermissionGroups();
    if (this.can('roadmap.manage')) this.loadRoadmaps();
  }

  setTab(next: string): void {
    if (!this.canSeeTab(next)) return;
    this.tab = next;
    if (next === 'access') this.loadPermissionGroups();
    if (next === 'audit') this.loadAuditLogs();
    if (next === 'analytics') this.loadQuizOverview();
    if (next === 'roadmaps') this.loadRoadmaps();
  }

  can(permission: string): boolean {
    return this.auth.hasRole('Admin') || this.auth.hasPermission(permission);
  }

  canAny(permissions: string[]): boolean {
    return this.auth.hasRole('Admin') || this.auth.hasAnyPermission(permissions);
  }

  canSeeTab(tab: string): boolean {
    const permissions = this.tabPermissions[tab] || [];
    return !permissions.length || this.canAny(permissions);
  }

  firstAllowedTab(): string {
    return ['questions', 'categories', 'quizsets', 'users', 'access', 'roadmaps', 'audit', 'analytics', 'import']
      .find(tab => this.canSeeTab(tab)) || '';
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

  get filteredRoadmapCourses(): any[] {
    return this.roadmapCourses.filter(c => !this.selectedRoadmapTrackId || Number(c.trackId) === Number(this.selectedRoadmapTrackId));
  }

  get selectedRoadmapCourse(): any {
    return this.roadmapCourses.find(c => Number(c.id) === Number(this.selectedRoadmapCourseId));
  }

  get selectedRoadmapModule(): any {
    return (this.selectedRoadmapCourse?.modules || []).find((m: any) => Number(m.id) === Number(this.selectedRoadmapModuleId));
  }

  get selectedRoadmapModules(): any[] {
    return this.selectedRoadmapCourse?.modules || [];
  }

  get selectedRoadmapLessons(): any[] {
    return this.selectedRoadmapModule?.lessons || [];
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

  blankRoadmapTrack(): any {
    return { title: '', slug: '', description: '', level: 'Beginner', estimatedHours: 80, thumbnailUrl: '', sortOrder: 10, isPublished: true };
  }

  blankRoadmapCourse(): any {
    return {
      trackId: this.selectedRoadmapTrackId || this.roadmapTracks[0]?.id || '',
      title: '',
      slug: '',
      shortDescription: '',
      description: '',
      level: 'Beginner',
      estimatedHours: 40,
      requirementsText: '',
      learningOutcomesText: '',
      relatedCourseIdsText: '',
      prerequisiteCourseIdsText: '',
      thumbnailUrl: '',
      sortOrder: 10,
      isPublished: true,
      requiresSequentialCompletion: true,
      unlockAfterCourseId: null
    };
  }

  blankRoadmapModule(): any {
    return { title: '', description: '', sortOrder: 1, estimatedMinutes: 60, requiresPreviousModuleCompletion: true, isLockedByDefault: false, isPublished: true };
  }

  blankRoadmapLesson(): any {
    return {
      title: '',
      type: 'Reading',
      content: '',
      videoUrl: '',
      videoFileId: null,
      videoFileUrl: '',
      quizSetId: null,
      codingProblemId: null,
      estimatedMinutes: 12,
      sortOrder: 1,
      isPreview: false,
      isPublished: true,
      requiresPreviousLessonCompletion: true,
      isRequired: true,
      unlockAfterLessonId: null
    };
  }

  blankGroup(): any {
    return { name: '', code: '', description: '', permissionIds: [] as number[] };
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
  notifyErr(error: any, fallback = 'Không thể hoàn tất thao tác.'): void { this.error = this.api.errorMessage(error, fallback); this.message = ''; }

  categoryName(id: any): string { return this.categories.find(c => Number(c.id) === Number(id))?.name || id || 'N/A'; }
  difficultyText(d: any): string { return Number(d) === 3 ? 'Advanced' : Number(d) === 2 ? 'Intermediate' : 'Beginner'; }
  difficultyBadge(d: any): string { return Number(d) === 3 ? 'badge-red' : Number(d) === 2 ? 'badge-yellow' : 'badge-green'; }
  statusText(s: any): string { return Number(s) === 0 ? 'Inactive' : Number(s) === 1 ? 'Active' : 'Published'; }
  statusBadge(s: any): string { return Number(s) === 0 ? 'badge-red' : 'badge-green'; }

  autoCategorySlug(): void { if (!this.categoryForm.slug) this.categoryForm.slug = this.slugify(this.categoryForm.name); }
  autoQuizSlug(): void { if (!this.quizSetForm.slug) this.quizSetForm.slug = this.slugify(this.quizSetForm.title); }
  autoRoadmapTrackSlug(): void { if (!this.roadmapTrackForm.slug) this.roadmapTrackForm.slug = this.slugify(this.roadmapTrackForm.title); }
  autoRoadmapCourseSlug(): void { if (!this.roadmapCourseForm.slug) this.roadmapCourseForm.slug = this.slugify(this.roadmapCourseForm.title); }

  createOrUpdateCategory(): void {
    this.clearMessages();
    if (!this.categoryForm.slug) this.categoryForm.slug = this.slugify(this.categoryForm.name);
    const req = this.editingCategoryId
      ? this.api.put<any>(`/api/v1/categories/${this.editingCategoryId}`, this.categoryForm)
      : this.api.post<any>('/api/v1/categories', this.categoryForm);
    req.subscribe({
      next: () => { this.notifyOk(this.editingCategoryId ? 'Cập nhật category thành công' : 'Tạo category thành công'); this.cancelCategoryEdit(); this.loadAll(); },
      error: e => this.notifyErr(e, 'Không lưu được category')
    });
  }

  editCategory(c: any): void { this.editingCategoryId = c.id; this.categoryForm = { ...c }; }
  cancelCategoryEdit(): void { this.editingCategoryId = null; this.categoryForm = this.blankCategory(); }

  deleteCategory(c: any): void {
    if (!confirm(`Xóa category "${c.name}"?`)) return;
    this.api.delete<any>(`/api/v1/categories/${c.id}`).subscribe({
      next: () => { this.notifyOk('Đã xóa category'); this.loadAll(); },
      error: e => this.notifyErr(e, 'Không xóa được category')
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
      next: () => { this.notifyOk(this.editingQuestionId ? 'Cập nhật question thành công' : 'Tạo question thành công'); this.cancelQuestionEdit(); this.loadAll(); },
      error: e => this.notifyErr(e, 'Không lưu được question')
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

  cancelQuestionEdit(): void { this.editingQuestionId = null; this.showQuestionForm = false; this.questionForm = this.blankQuestion(); }

  deleteQuestion(q: any): void {
    if (!confirm(`Xóa câu hỏi #${q.id}? Câu hỏi sẽ được gỡ khỏi các bộ đề.`)) return;
    this.api.delete<any>(`/api/v1/questions/${q.id}`).subscribe({
      next: () => { this.notifyOk('Đã xóa câu hỏi'); this.loadAll(); },
      error: e => this.notifyErr(e, 'Không xóa được câu hỏi')
    });
  }

  isQuestionSelected(qid: number): boolean {
    return (this.quizSetForm.questions || []).some((q: any) => Number(q.questionId) === Number(qid));
  }

  toggleQuestion(q: any, checked: boolean): void {
    if (checked) {
      if (!this.isQuestionSelected(q.id)) this.quizSetForm.questions.push({ questionId: q.id, displayOrder: this.quizSetForm.questions.length + 1, score: 1 });
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
      next: () => { this.notifyOk(this.editingQuizSetId ? 'Cập nhật quiz set thành công' : 'Tạo quiz set thành công'); this.cancelQuizSetEdit(); this.loadAll(); },
      error: e => this.notifyErr(e, 'Không lưu được quiz set')
    });
  }

  editQuizSet(qs: any): void {
    this.api.get<any>(`/api/v1/quiz-sets/${qs.id}`).subscribe({
      next: r => {
        const q = r.data;
        this.editingQuizSetId = q.id;
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
      error: e => this.notifyErr(e, 'Không tải được quiz set')
    });
  }

  cancelQuizSetEdit(): void { this.editingQuizSetId = null; this.quizSetForm = this.blankQuizSet(); }

  deleteQuizSet(q: any): void {
    if (!confirm(`Xóa quiz set "${q.title}"?`)) return;
    this.api.delete<any>(`/api/v1/quiz-sets/${q.id}`).subscribe({
      next: () => { this.notifyOk('Đã xóa quiz set'); this.loadAll(); },
      error: e => this.notifyErr(e, 'Không xóa được quiz set')
    });
  }

  loadRoadmaps(): void {
    this.api.get<any[]>('/api/v1/admin/roadmaps').subscribe({
      next: r => {
        this.roadmapTracks = r.data || [];
        if (!this.selectedRoadmapTrackId && this.roadmapTracks.length) this.selectedRoadmapTrackId = this.roadmapTracks[0].id;
      },
      error: e => this.notifyErr(e, 'Không tải được roadmap tracks')
    });
    this.api.get<any[]>('/api/v1/admin/courses').subscribe({
      next: r => {
        this.roadmapCourses = r.data || [];
        if (!this.selectedRoadmapCourseId && this.roadmapCourses.length) this.selectedRoadmapCourseId = this.roadmapCourses[0].id;
        if (!this.selectedRoadmapModuleId && this.selectedRoadmapModules.length) this.selectedRoadmapModuleId = this.selectedRoadmapModules[0].id;
      },
      error: e => this.notifyErr(e, 'Không tải được roadmap courses')
    });
  }

  saveRoadmapTrack(): void {
    this.clearMessages();
    if (!this.roadmapTrackForm.slug) this.roadmapTrackForm.slug = this.slugify(this.roadmapTrackForm.title);
    const req = this.editingRoadmapTrackId
      ? this.api.put<any>(`/api/v1/admin/roadmaps/${this.editingRoadmapTrackId}`, this.roadmapTrackForm)
      : this.api.post<any>('/api/v1/admin/roadmaps', this.roadmapTrackForm);
    req.subscribe({
      next: () => { this.notifyOk(this.editingRoadmapTrackId ? 'Cập nhật lộ trình thành công' : 'Tạo lộ trình thành công'); this.cancelRoadmapTrackEdit(); this.loadRoadmaps(); },
      error: e => this.notifyErr(e, 'Không lưu được lộ trình')
    });
  }

  editRoadmapTrack(track: any): void {
    this.editingRoadmapTrackId = track.id;
    this.roadmapTrackForm = { title: track.title, slug: track.slug, description: track.description || '', level: track.level || 'Beginner', estimatedHours: track.estimatedHours || 0, thumbnailUrl: track.thumbnailUrl || '', sortOrder: track.sortOrder || 0, isPublished: !!track.isPublished };
  }

  cancelRoadmapTrackEdit(): void { this.editingRoadmapTrackId = null; this.roadmapTrackForm = this.blankRoadmapTrack(); }

  deleteRoadmapTrack(track: any): void {
    if (!confirm(`Xóa lộ trình "${track.title}"?`)) return;
    this.api.delete<any>(`/api/v1/admin/roadmaps/${track.id}`).subscribe({
      next: () => { this.notifyOk('Đã xóa lộ trình'); this.loadRoadmaps(); },
      error: e => this.notifyErr(e, 'Không xóa được lộ trình')
    });
  }

  saveRoadmapCourse(): void {
    this.clearMessages();
    if (!this.roadmapCourseForm.slug) this.roadmapCourseForm.slug = this.slugify(this.roadmapCourseForm.title);
    const body = {
      ...this.roadmapCourseForm,
      trackId: Number(this.roadmapCourseForm.trackId || this.selectedRoadmapTrackId),
      requirements: this.lines(this.roadmapCourseForm.requirementsText),
      learningOutcomes: this.lines(this.roadmapCourseForm.learningOutcomesText),
      relatedCourseIds: this.ids(this.roadmapCourseForm.relatedCourseIdsText),
      prerequisiteCourseIds: this.ids(this.roadmapCourseForm.prerequisiteCourseIdsText),
      unlockAfterCourseId: this.roadmapCourseForm.unlockAfterCourseId ? Number(this.roadmapCourseForm.unlockAfterCourseId) : null
    };
    const req = this.editingRoadmapCourseId
      ? this.api.put<any>(`/api/v1/admin/courses/${this.editingRoadmapCourseId}`, body)
      : this.api.post<any>('/api/v1/admin/courses', body);
    req.subscribe({
      next: () => { this.notifyOk(this.editingRoadmapCourseId ? 'Cập nhật khóa học thành công' : 'Tạo khóa học thành công'); this.cancelRoadmapCourseEdit(); this.loadRoadmaps(); },
      error: e => this.notifyErr(e, 'Không lưu được khóa học')
    });
  }

  editRoadmapCourse(course: any): void {
    this.editingRoadmapCourseId = course.id;
    this.selectedRoadmapCourseId = course.id;
    this.roadmapCourseForm = {
      trackId: course.trackId,
      title: course.title,
      slug: course.slug,
      shortDescription: course.shortDescription || '',
      description: course.description || '',
      level: course.level || 'Beginner',
      estimatedHours: course.estimatedHours || 0,
      requirementsText: (course.requirements || []).join('\n'),
      learningOutcomesText: (course.learningOutcomes || []).join('\n'),
      relatedCourseIdsText: (course.relatedCourseIds || []).join(','),
      prerequisiteCourseIdsText: (course.prerequisiteCourseIds || []).join(','),
      thumbnailUrl: course.thumbnailUrl || '',
      sortOrder: course.sortOrder || 0,
      isPublished: !!course.isPublished,
      requiresSequentialCompletion: course.requiresSequentialCompletion !== false,
      unlockAfterCourseId: course.unlockAfterCourseId || null
    };
  }

  cancelRoadmapCourseEdit(): void { this.editingRoadmapCourseId = null; this.roadmapCourseForm = this.blankRoadmapCourse(); }

  deleteRoadmapCourse(course: any): void {
    if (!confirm(`Xóa khóa học "${course.title}"?`)) return;
    this.api.delete<any>(`/api/v1/admin/courses/${course.id}`).subscribe({
      next: () => { this.notifyOk('Đã xóa khóa học'); this.loadRoadmaps(); },
      error: e => this.notifyErr(e, 'Không xóa được khóa học')
    });
  }

  saveRoadmapModule(): void {
    this.clearMessages();
    const courseId = Number(this.selectedRoadmapCourseId);
    if (!courseId) { this.error = 'Chọn khóa học trước.'; return; }
    const req = this.editingRoadmapModuleId
      ? this.api.put<any>(`/api/v1/admin/modules/${this.editingRoadmapModuleId}`, this.roadmapModuleForm)
      : this.api.post<any>(`/api/v1/admin/courses/${courseId}/modules`, this.roadmapModuleForm);
    req.subscribe({
      next: () => { this.notifyOk(this.editingRoadmapModuleId ? 'Cập nhật chương thành công' : 'Tạo chương thành công'); this.cancelRoadmapModuleEdit(); this.loadRoadmaps(); },
      error: e => this.notifyErr(e, 'Không lưu được chương')
    });
  }

  editRoadmapModule(module: any): void {
    this.editingRoadmapModuleId = module.id;
    this.selectedRoadmapModuleId = module.id;
    this.roadmapModuleForm = { title: module.title, description: module.description || '', sortOrder: module.sortOrder || 0, estimatedMinutes: module.estimatedMinutes || 0, requiresPreviousModuleCompletion: module.requiresPreviousModuleCompletion !== false, isLockedByDefault: !!module.isLockedByDefault, isPublished: module.isPublished !== false };
  }

  cancelRoadmapModuleEdit(): void { this.editingRoadmapModuleId = null; this.roadmapModuleForm = this.blankRoadmapModule(); }

  deleteRoadmapModule(module: any): void {
    if (!confirm(`Xóa chương "${module.title}"?`)) return;
    this.api.delete<any>(`/api/v1/admin/modules/${module.id}`).subscribe({
      next: () => { this.notifyOk('Đã xóa chương'); this.loadRoadmaps(); },
      error: e => this.notifyErr(e, 'Không xóa được chương')
    });
  }

  saveRoadmapLesson(): void {
    this.clearMessages();
    const moduleId = Number(this.selectedRoadmapModuleId);
    if (!moduleId) { this.error = 'Chọn chương trước.'; return; }
    const body = {
      ...this.roadmapLessonForm,
      quizSetId: this.roadmapLessonForm.type === 'Quiz' && this.roadmapLessonForm.quizSetId ? Number(this.roadmapLessonForm.quizSetId) : null,
      codingProblemId: this.roadmapLessonForm.type === 'CodePractice' && this.roadmapLessonForm.codingProblemId ? Number(this.roadmapLessonForm.codingProblemId) : null,
      unlockAfterLessonId: this.roadmapLessonForm.unlockAfterLessonId ? Number(this.roadmapLessonForm.unlockAfterLessonId) : null
    };
    const req = this.editingRoadmapLessonId
      ? this.api.put<any>(`/api/v1/admin/lessons/${this.editingRoadmapLessonId}`, body)
      : this.api.post<any>(`/api/v1/admin/modules/${moduleId}/lessons`, body);
    req.subscribe({
      next: r => {
        const lessonId = r.data?.id || this.editingRoadmapLessonId;
        const success = this.editingRoadmapLessonId ? 'Cập nhật bài học thành công' : 'Tạo bài học thành công';
        if (this.roadmapVideoFile && body.type === 'Video' && lessonId) {
          this.uploadRoadmapLessonVideo(lessonId, success);
          return;
        }
        this.notifyOk(success);
        this.cancelRoadmapLessonEdit();
        this.loadRoadmaps();
      },
      error: e => this.notifyErr(e, 'Không lưu được bài học')
    });
  }

  editRoadmapLesson(lesson: any): void {
    this.editingRoadmapLessonId = lesson.id;
    this.roadmapLessonForm = { ...this.blankRoadmapLesson(), ...lesson };
    this.roadmapVideoFile = undefined;
  }

  cancelRoadmapLessonEdit(): void {
    this.editingRoadmapLessonId = null;
    this.roadmapLessonForm = this.blankRoadmapLesson();
    this.roadmapVideoFile = undefined;
    this.roadmapVideoUploading = false;
  }

  pickRoadmapVideo(e: Event): void {
    this.roadmapVideoFile = (e.target as HTMLInputElement).files?.[0];
  }

  uploadRoadmapLessonVideo(lessonId: number, successMessage: string): void {
    if (!this.roadmapVideoFile) return;
    const fd = new FormData();
    fd.append('file', this.roadmapVideoFile);
    this.roadmapVideoUploading = true;
    this.api.upload<any>(`/api/v1/admin/lessons/${lessonId}/video`, fd).subscribe({
      next: () => {
        this.roadmapVideoUploading = false;
        this.notifyOk(`${successMessage}. Video uploaded.`);
        this.cancelRoadmapLessonEdit();
        this.loadRoadmaps();
      },
      error: e => {
        this.roadmapVideoUploading = false;
        this.notifyErr(e, 'Không upload được video bài học');
      }
    });
  }

  deleteRoadmapLesson(lesson: any): void {
    if (!confirm(`Xóa bài học "${lesson.title}"?`)) return;
    this.api.delete<any>(`/api/v1/admin/lessons/${lesson.id}`).subscribe({
      next: () => { this.notifyOk('Đã xóa bài học'); this.loadRoadmaps(); },
      error: e => this.notifyErr(e, 'Không xóa được bài học')
    });
  }

  lines(value: string): string[] {
    return (value || '').split('\n').map(x => x.trim()).filter(Boolean);
  }

  ids(value: string): number[] {
    return (value || '').split(',').map(x => Number(x.trim())).filter(x => Number.isFinite(x) && x > 0);
  }

  pick(e: Event): void { this.file = (e.target as HTMLInputElement).files?.[0]; }

  downloadCsvTemplate(): void {
    const rows = [
      ['CategoryId', 'CategorySlug', 'CategoryName', 'Title', 'Content', 'QuestionExplanation', 'Difficulty', 'CorrectOption', 'OptionA', 'OptionAExplanation', 'OptionB', 'OptionBExplanation', 'OptionC', 'OptionCExplanation', 'OptionD', 'OptionDExplanation', 'Source'],
      [this.categories[0]?.id || 1, this.categories[0]?.slug || '', this.categories[0]?.name || '', 'API dùng để làm gì?', 'API trong hệ thống web thường dùng để làm gì?', 'API là lớp trung gian giúp frontend gửi yêu cầu và nhận dữ liệu từ backend.', 1, 'A', 'Kết nối frontend với backend để trao đổi dữ liệu', 'Đúng, frontend gọi API để lấy hoặc gửi dữ liệu.', 'Chỉ dùng để thiết kế màu sắc giao diện', '', 'Chỉ dùng để tạo ảnh nền', '', 'Chỉ dùng để gõ văn bản Word', '', 'Excel/CSV Import']
    ];
    const csv = rows.map(r => r.map(v => `"${String(v ?? '').replace(/"/g, '""')}"`).join(',')).join('\r\n');
    this.saveBlob(new Blob(['\ufeff' + csv], { type: 'text/csv;charset=utf-8;' }), 'devlearninghub_questions_template.csv');
  }

  importFile(): void {
    this.clearMessages();
    if (!this.file) { this.error = 'Chọn file CSV trước.'; return; }
    const fd = new FormData();
    fd.append('file', this.file);
    this.api.upload<any>('/api/v1/questions/import-csv', fd).subscribe({
      next: r => { this.importResult = r; this.notifyOk('Import CSV hoàn tất. Hãy kiểm tra tab Questions và gắn câu hỏi vào Quiz Set.'); this.loadAll(); },
      error: e => { this.importResult = e?.error; this.notifyErr(e, 'Import CSV thất bại'); }
    });
  }

  importJsonFile(): void {
    this.clearMessages();
    if (!this.file) { this.error = 'Chọn file JSON trước.'; return; }
    const fd = new FormData();
    fd.append('file', this.file);
    this.api.upload<any>('/api/v1/questions/import-json', fd).subscribe({
      next: r => { this.importResult = r; this.notifyOk('Import JSON hoàn tất. Hãy kiểm tra tab Questions và gắn câu hỏi vào Quiz Set.'); this.loadAll(); },
      error: e => { this.importResult = e?.error; this.notifyErr(e, 'Import JSON thất bại'); }
    });
  }

  openPermissionPanel(user: any): void {
    this.clearMessages();
    this.api.get<any>(`/api/v1/admin/users/${user.id}/permissions`).subscribe({
      next: r => this.userPermissionDetail = r.data,
      error: e => this.notifyErr(e, 'Không tải được quyền lẻ của tài khoản')
    });
  }

  closePermissionPanel(): void { this.userPermissionDetail = null; }

  toggleUserPermission(permission: any, checked: boolean): void {
    if (!this.userPermissionDetail || this.permissionSaving) return;
    permission.assigned = checked;
    const selectedPermissionIds = (this.userPermissionDetail.permissions || []).filter((p: any) => p.assigned).map((p: any) => p.id);
    this.permissionSaving = true;
    this.api.put<any>(`/api/v1/admin/users/${this.userPermissionDetail.user.id}/permissions`, { permissionIds: selectedPermissionIds }).subscribe({
      next: r => { this.userPermissionDetail = r.data; this.notifyOk('Cập nhật quyền lẻ thành công'); this.loadAll(); this.permissionSaving = false; },
      error: e => { this.notifyErr(e, 'Không cập nhật được quyền lẻ'); this.permissionSaving = false; this.openPermissionPanel(this.userPermissionDetail.user); }
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

  loadPermissionGroups(): void {
    this.api.getPermissionGroups().subscribe({
      next: r => {
        const data: any = r.data || [];
        this.permissionGroups = Array.isArray(data) ? data : data.items || [];
      },
      error: () => this.permissionGroups = []
    });
  }

  groupPermissionIds(group: any): number[] {
    return (group?.permissions || group?.permissionIds || []).map((p: any) => Number(p.id || p.permissionId || p));
  }

  toggleArrayValue(list: number[], id: any, checked: boolean): void {
    const n = Number(id);
    if (checked && !list.includes(n)) list.push(n);
    if (!checked) {
      const idx = list.indexOf(n);
      if (idx >= 0) list.splice(idx, 1);
    }
  }

  savePermissionGroup(): void {
    this.clearMessages();
    const body = { ...this.groupForm, permissionIds: this.groupForm.permissionIds || [] };
    const req = this.editingGroupId ? this.api.updatePermissionGroup(this.editingGroupId, body) : this.api.createPermissionGroup(body);
    req.subscribe({
      next: () => { this.notifyOk(this.editingGroupId ? 'Cập nhật nhóm quyền thành công' : 'Tạo nhóm quyền thành công'); this.cancelGroupEdit(); this.loadPermissionGroups(); },
      error: e => this.notifyErr(e, 'Không lưu được nhóm quyền')
    });
  }

  editPermissionGroup(group: any): void {
    this.editingGroupId = group.id;
    this.groupForm = { name: group.name, code: group.code, description: group.description || '', permissionIds: this.groupPermissionIds(group) };
  }

  cancelGroupEdit(): void {
    this.editingGroupId = null;
    this.groupForm = this.blankGroup();
  }

  deletePermissionGroup(group: any): void {
    if (group.isSystem) return;
    if (!confirm(`Xóa nhóm quyền "${group.name}"?`)) return;
    this.api.deletePermissionGroup(group.id).subscribe({
      next: () => { this.notifyOk('Đã xóa nhóm quyền'); this.loadPermissionGroups(); },
      error: e => this.notifyErr(e, 'Không xóa được nhóm quyền')
    });
  }

  openManageGroup(group: any): void {
    this.managingGroup = group;
    this.selectedGroupPermissionIds = this.groupPermissionIds(group);
  }

  saveGroupPermissions(): void {
    if (!this.managingGroup) return;
    this.api.setPermissionGroupPermissions(this.managingGroup.id, this.selectedGroupPermissionIds).subscribe({
      next: () => { this.notifyOk('Cập nhật quyền trong nhóm thành công'); this.managingGroup = null; this.loadPermissionGroups(); },
      error: e => this.notifyErr(e, 'Không cập nhật được quyền trong nhóm')
    });
  }

  openAssignGroups(user: any): void {
    this.selectedUserForGroups = user;
    this.selectedUserGroupIds = (user.permissionGroups || user.permissionGroupIds || []).map((g: any) => Number(g.id || g.permissionGroupId || g));
  }

  saveUserGroups(): void {
    if (!this.selectedUserForGroups) return;
    this.api.assignPermissionGroupsToUser(this.selectedUserForGroups.id, this.selectedUserGroupIds).subscribe({
      next: () => { this.notifyOk('Gán nhóm quyền cho user thành công'); this.selectedUserForGroups = null; this.loadAll(); },
      error: e => this.notifyErr(e, 'Không gán được nhóm quyền cho user')
    });
  }

  loadRoleGroups(): void {
    const role = this.roles.find(r => Number(r.id) === Number(this.selectedRoleId));
    this.selectedRoleGroupIds = (role?.permissionGroups || role?.permissionGroupIds || []).map((g: any) => Number(g.id || g.permissionGroupId || g));
  }

  saveRoleGroups(): void {
    if (!this.selectedRoleId) return;
    this.api.assignPermissionGroupsToRole(this.selectedRoleId, this.selectedRoleGroupIds).subscribe({
      next: () => { this.notifyOk('Gán nhóm quyền cho role thành công'); this.loadAll(); },
      error: e => this.notifyErr(e, 'Không gán được nhóm quyền cho role')
    });
  }

  viewEffectivePermissions(user: any): void {
    this.effectiveUser = user;
    this.api.getEffectivePermissions(user.id).subscribe({
      next: r => this.effectivePermissions = r.data,
      error: e => this.notifyErr(e, 'Không tải được quyền hiệu lực')
    });
  }

  permissionCode(item: any): string {
    return item?.code || item?.permissionCode || item?.name || String(item);
  }

  permissionArray(value: any): any[] {
    if (!value) return [];
    return Array.isArray(value) ? value : Object.values(value).flat() as any[];
  }

  userStatus(user: any): string {
    if (user.disabled || user.isDisabled) return 'Disabled';
    const until = user.lockedUntil || user.lockUntil;
    if (until) return `Locked until ${new Date(until).toLocaleString()}`;
    if (user.isLocked || user.locked) return 'Locked';
    return 'Active';
  }

  openLockUser(user: any): void {
    this.lockUserTarget = user;
    this.lockForm = { reason: '', lockUntil: '' };
  }

  lockUser(): void {
    if (!this.lockUserTarget) return;
    this.api.lockUser(this.lockUserTarget.id, this.lockForm).subscribe({
      next: () => { this.notifyOk('Đã khóa tài khoản'); this.lockUserTarget = null; this.loadAll(); },
      error: e => this.notifyErr(e, 'Không khóa được tài khoản')
    });
  }

  unlockUser(user: any): void {
    this.api.unlockUser(user.id).subscribe({
      next: () => { this.notifyOk('Đã mở khóa tài khoản'); this.loadAll(); },
      error: e => this.notifyErr(e, 'Không mở khóa được tài khoản')
    });
  }

  loadAuditLogs(): void {
    const query = Object.fromEntries(Object.entries(this.auditFilters).filter(([, value]) => value !== '' && value !== null && value !== undefined));
    this.api.getAuditLogs(query).subscribe({
      next: r => {
        const data: any = r.data || [];
        this.auditLogs = Array.isArray(data) ? data : data.items || [];
      },
      error: e => this.notifyErr(e, 'Không tải được audit logs')
    });
  }

  prettyJson(value: any): string {
    if (!value) return '';
    try {
      return JSON.stringify(typeof value === 'string' ? JSON.parse(value) : value, null, 2);
    } catch {
      return String(value);
    }
  }

  loadQuizOverview(): void {
    this.api.getQuizStatisticsOverview().subscribe({
      next: r => this.quizOverview = r.data,
      error: e => this.notifyErr(e, 'Không tải được thống kê tổng quan')
    });
  }

  loadQuizStats(): void {
    if (!this.selectedStatsQuizSetId) return;
    this.api.getQuizStatistics(this.selectedStatsQuizSetId).subscribe({
      next: r => this.quizStats = r.data,
      error: e => this.notifyErr(e, 'Không tải được thống kê quiz set')
    });
  }

  exportQuestions(): void {
    this.api.exportQuestionsCsv().subscribe({
      next: blob => this.saveBlob(blob, 'questions_export.csv'),
      error: e => this.notifyErr(e, 'Không export được questions CSV')
    });
  }

  exportQuiz(q: any): void {
    this.api.exportQuizCsv(q.id).subscribe({
      next: blob => this.saveBlob(blob, `quiz_${q.id}_export.csv`),
      error: e => this.notifyErr(e, 'Không export được quiz CSV')
    });
  }

  resetAttempt(): void {
    if (!this.resetAttemptId) return;
    this.api.resetAttempt(this.resetAttemptId).subscribe({
      next: () => { this.notifyOk('Đã reset attempt'); this.loadQuizOverview(); this.loadQuizStats(); },
      error: e => this.notifyErr(e, 'Không reset được attempt')
    });
  }

  resetUserQuizAttempts(): void {
    if (!this.resetQuizSetId || !this.resetUserId) return;
    this.api.resetUserQuizAttempts(this.resetQuizSetId, this.resetUserId).subscribe({
      next: () => { this.notifyOk('Đã reset attempts của user trong quiz'); this.loadQuizOverview(); this.loadQuizStats(); },
      error: e => this.notifyErr(e, 'Không reset được attempts')
    });
  }

  saveBlob(blob: Blob, filename: string): void {
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    a.click();
    URL.revokeObjectURL(url);
  }

  openUserWorkspace(): void {
    this.auth.openUserApp('/learner/forum');
  }
}
