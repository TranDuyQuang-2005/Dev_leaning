import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { ApiService } from '../core/services/api.service';
import { AuthService } from '../core/services/auth.service';

type ForumTab = 'posts' | 'comments' | 'reports' | 'tags';

@Component({
  selector: 'app-forum-management',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './forum-management.component.html'
})
export class ForumManagementComponent implements OnInit {
  tab: ForumTab = 'posts';
  posts: any[] = [];
  comments: any[] = [];
  reports: any[] = [];
  tags: any[] = [];

  keyword = '';
  postStatus: any = '';
  commentStatus: any = '';
  reportStatus: any = '';
  message = '';
  error = '';
  loading = false;

  tagForm: any = { name: '', slug: '', description: '' };
  editingTagId: number | null = null;

  readonly Number = Number;

  constructor(private api: ApiService, public auth: AuthService) {}

  get isAdmin(): boolean {
    return this.auth.hasRole('Admin');
  }

  get apiRoot(): string {
    return this.isAdmin ? '/api/v1/admin/forum' : '/api/v1/moderator/forum';
  }

  get pendingReports(): number {
    return this.reports.filter((r: any) => Number(r.status) === 0 || Number(r.status) === 1 || String(r.status).toLowerCase() === 'pending').length;
  }

  ngOnInit(): void {
    this.loadAll();
  }

  setTab(tab: ForumTab): void {
    if (tab === 'tags' && !this.isAdmin) return;
    this.tab = tab;
    this.message = '';
    this.error = '';
    this.reloadCurrent();
  }

  clearFilters(): void {
    this.keyword = '';
    this.postStatus = '';
    this.commentStatus = '';
    this.reportStatus = '';
    this.reloadCurrent();
  }

  reloadCurrent(): void {
    if (this.tab === 'posts') this.loadPosts();
    if (this.tab === 'comments') this.loadComments();
    if (this.tab === 'reports') this.loadReports();
    if (this.tab === 'tags') this.loadTags();
  }

  loadAll(): void {
    this.loadPosts();
    this.loadComments();
    this.loadReports();
    this.loadTags();
  }

  loadPosts(): void {
    this.loading = true;
    const q = `?pageSize=100${this.keyword ? `&keyword=${encodeURIComponent(this.keyword)}` : ''}${this.postStatus !== '' ? `&status=${this.postStatus}` : ''}`;
    (this.api.get(this.apiRoot + '/posts' + q) as any).subscribe({
      next: (r: any) => { this.posts = r?.data?.items || []; this.loading = false; },
      error: (e: any) => { this.error = e?.error?.message || 'Không tải được posts'; this.loading = false; }
    });
  }

  loadComments(): void {
    const q = `?pageSize=100${this.keyword ? `&keyword=${encodeURIComponent(this.keyword)}` : ''}${this.commentStatus !== '' ? `&status=${this.commentStatus}` : ''}`;
    (this.api.get(this.apiRoot + '/comments' + q) as any).subscribe({
      next: (r: any) => this.comments = r?.data?.items || [],
      error: (e: any) => this.error = e?.error?.message || 'Không tải được comments'
    });
  }

  loadReports(): void {
    const q = `?pageSize=100${this.reportStatus !== '' ? `&status=${this.reportStatus}` : ''}`;
    (this.api.get(this.apiRoot + '/reports' + q) as any).subscribe({
      next: (r: any) => this.reports = r?.data?.items || [],
      error: (e: any) => this.error = e?.error?.message || 'Không tải được reports'
    });
  }

  loadTags(): void {
    (this.api.get(this.apiRoot + '/tags') as any).subscribe({
      next: (r: any) => this.tags = r?.data || [],
      error: () => this.tags = []
    });
  }

  trackById(_: number, item: any): number {
    return item?.id || 0;
  }

  statusText(status: any): string {
    return Number(status) === 0 ? 'Hidden' : 'Visible';
  }

  statusClass(status: any): string {
    return Number(status) === 0 ? 'is-hidden' : 'is-visible';
  }

  reportStatusText(status: any): string {
    const s = Number(status);
    if (s === 2) return 'Resolved';
    if (s === 3) return 'Rejected';
    return 'Pending';
  }

  reportStatusClass(status: any): string {
    const s = Number(status);
    if (s === 2) return 'is-visible';
    if (s === 3) return 'is-hidden';
    return 'is-pending';
  }

  date(value: any): string {
    return value ? new Date(value).toLocaleString('vi-VN') : '-';
  }

  stripHtml(value: any): string {
    return String(value || '').replace(/<[^>]+>/g, ' ').replace(/\s+/g, ' ').trim();
  }

  truncate(value: any, max = 100): string {
    const text = String(value || '').trim();
    return text.length > max ? text.slice(0, max - 1) + '…' : text;
  }

  private notify(message: string): void {
    this.message = message;
    this.error = '';
  }

  hidePost(post: any): void {
    const reason = prompt('Lý do ẩn bài viết?') || '';
    (this.api.put(`${this.apiRoot}/posts/${post.id}/hide`, { reason }) as any).subscribe({
      next: () => { this.notify('Đã ẩn bài viết'); this.loadAll(); },
      error: (e: any) => alert(e?.error?.message || 'Không ẩn được bài')
    });
  }

  restorePost(post: any): void {
    const reason = prompt('Lý do khôi phục?') || '';
    (this.api.put(`${this.apiRoot}/posts/${post.id}/restore`, { reason }) as any).subscribe({
      next: () => { this.notify('Đã khôi phục bài viết'); this.loadAll(); },
      error: (e: any) => alert(e?.error?.message || 'Không khôi phục được bài')
    });
  }

  deletePost(post: any): void {
    if (!confirm('Xóa bài viết này?')) return;
    (this.api.delete(`${this.apiRoot}/posts/${post.id}`) as any).subscribe({
      next: () => { this.notify('Đã xóa bài viết'); this.loadAll(); },
      error: (e: any) => alert(e?.error?.message || 'Không xóa được bài')
    });
  }

  hideComment(comment: any): void {
    const reason = prompt('Lý do ẩn bình luận?') || '';
    (this.api.put(`${this.apiRoot}/comments/${comment.id}/hide`, { reason }) as any).subscribe({
      next: () => { this.notify('Đã ẩn bình luận'); this.loadAll(); },
      error: (e: any) => alert(e?.error?.message || 'Không ẩn được bình luận')
    });
  }

  deleteComment(comment: any): void {
    if (!confirm('Xóa bình luận này?')) return;
    (this.api.delete(`${this.apiRoot}/comments/${comment.id}`) as any).subscribe({
      next: () => { this.notify('Đã xóa bình luận'); this.loadAll(); },
      error: (e: any) => alert(e?.error?.message || 'Không xóa được bình luận')
    });
  }

  resolveReport(report: any, hideTarget: boolean, status = 2): void {
    const reason = prompt('Ghi chú xử lý report?') || '';
    (this.api.put(`${this.apiRoot}/reports/${report.id}/resolve`, { status, reason, hideTarget }) as any).subscribe({
      next: () => { this.notify('Đã xử lý report'); this.loadAll(); },
      error: (e: any) => alert(e?.error?.message || 'Không xử lý được report')
    });
  }

  slugify(value: string): string {
    return (value || '')
      .toLowerCase()
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '')
      .replace(/đ/g, 'd')
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-|-$/g, '');
  }

  autoSlug(): void {
    if (!this.tagForm.slug) this.tagForm.slug = this.slugify(this.tagForm.name);
  }

  saveTag(): void {
    this.error = '';
    if (!this.isAdmin) return;
    if (!this.tagForm.name || this.tagForm.name.trim().length < 2) {
      this.error = 'Tên tag phải từ 2 ký tự';
      return;
    }
    if (!this.tagForm.slug) this.tagForm.slug = this.slugify(this.tagForm.name);

    const request = this.editingTagId
      ? (this.api.put(`/api/v1/admin/forum/tags/${this.editingTagId}`, this.tagForm) as any)
      : (this.api.post('/api/v1/admin/forum/tags', this.tagForm) as any);

    request.subscribe({
      next: () => { this.notify('Đã lưu tag'); this.cancelTag(); this.loadTags(); },
      error: (e: any) => this.error = e?.error?.message || 'Không lưu được tag'
    });
  }

  editTag(tag: any): void {
    this.editingTagId = tag.id;
    this.tagForm = { name: tag.name, slug: tag.slug, description: tag.description || '' };
  }

  cancelTag(): void {
    this.editingTagId = null;
    this.tagForm = { name: '', slug: '', description: '' };
  }

  deleteTag(tag: any): void {
    if (!confirm(`Xóa tag ${tag.name}?`)) return;
    (this.api.delete(`/api/v1/admin/forum/tags/${tag.id}`) as any).subscribe({
      next: () => { this.notify('Đã xóa tag'); this.loadTags(); },
      error: (e: any) => alert(e?.error?.message || 'Không xóa được tag')
    });
  }

  openUserForum(): void {
    this.auth.openUserApp('/learner/forum');
  }
}

