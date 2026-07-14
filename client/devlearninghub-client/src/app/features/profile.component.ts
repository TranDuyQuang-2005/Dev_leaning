import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { AuthService } from '../core/services/auth.service';
import { ApiService } from '../core/services/api.service';

@Component({
  selector: 'app-profile',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './profile.component.html'
})
export class ProfileComponent implements OnInit {
  profile: any = {};
  stats: any = {};
  editing = false;
  message = '';
  error = '';
  passwordMessage = '';
  passwordError = '';
  passwordForm = { currentPassword: '', newPassword: '', confirmPassword: '' };

  savedPosts: any[] = [];
  savedLoading = false;
  savedError = '';
  savedLimit = 6;
  showAllSaved = false;
  removingSavedId: number | null = null;

  constructor(public auth: AuthService, private api: ApiService) {}

  get displayName(): string {
    return this.auth.currentUser()?.fullName || this.profile.fullName || 'User';
  }

  get initials(): string {
    return this.displayName.split(' ').filter(Boolean).slice(0, 2)
      .map((part: string) => part[0]).join('').toUpperCase();
  }

  get level(): number { return Math.max(1, Math.floor((this.stats.reputation || 0) / 1000) + 1); }
  get nextLevelXp(): number { return this.level * 1000; }
  get xpPercent(): number { return Math.min(100, Math.round(((this.stats.reputation || 0) % 1000) / 10)); }
  get visibleSavedPosts(): any[] { return this.showAllSaved ? this.savedPosts : this.savedPosts.slice(0, this.savedLimit); }

  ngOnInit(): void {
    this.loadProfile();
    this.loadStats();
    this.loadSavedPosts();
  }

  loadProfile(): void {
    this.api.get<any>('/api/v1/users/me/profile').subscribe({
      next: (response: any) => {
        const data = response?.data || {};
        this.profile = { ...data, fullName: data.fullName || this.auth.currentUser()?.fullName || '' };
      },
      error: () => this.profile = { fullName: this.auth.currentUser()?.fullName || '' }
    });
  }

  loadStats(): void {
    this.api.get<any>('/api/v1/users/me/stats').subscribe({
      next: (response: any) => this.stats = response?.data || {},
      error: () => this.stats = {}
    });
  }

  loadSavedPosts(): void {
    this.savedLoading = true;
    this.savedError = '';
    this.api.get<any>('/api/v1/forum/posts?pageIndex=1&pageSize=100').subscribe({
      next: (response: any) => {
        const data = response?.data;
        const items = Array.isArray(data) ? data : (data?.items || []);
        this.savedPosts = items
          .filter((post: any) => post?.isBookmarked || post?.isSaved || post?.bookmarked)
          .sort((a: any, b: any) => new Date(b.updatedAt || b.createdAt || 0).getTime() - new Date(a.updatedAt || a.createdAt || 0).getTime());
        this.savedLoading = false;
      },
      error: (e: any) => {
        this.savedError = this.api.errorMessage(e, 'Không tải được danh sách bài viết đã lưu.');
        this.savedLoading = false;
      }
    });
  }

  save(): void {
    this.message = '';
    this.error = '';
    this.api.put<any>('/api/v1/users/me/profile', this.profile).subscribe({
      next: () => {
        this.message = 'Đã lưu hồ sơ.';
        this.editing = false;
      },
      error: e => this.error = this.api.errorMessage(e, 'Không lưu được hồ sơ.')
    });
  }

  changePassword(): void {
    this.passwordMessage = '';
    this.passwordError = '';
    if (this.passwordForm.newPassword !== this.passwordForm.confirmPassword) {
      this.passwordError = 'Mật khẩu xác nhận không khớp.';
      return;
    }

    this.api.changePassword(this.passwordForm).subscribe({
      next: () => {
        this.passwordMessage = 'Đổi mật khẩu thành công.';
        this.passwordForm = { currentPassword: '', newPassword: '', confirmPassword: '' };
      },
      error: e => this.passwordError = this.api.errorMessage(e, 'Không đổi được mật khẩu.')
    });
  }

  removeSavedPost(post: any): void {
    if (!post?.id || this.removingSavedId !== null) return;
    const previousPosts = [...this.savedPosts];
    this.removingSavedId = post.id;
    this.savedPosts = this.savedPosts.filter(item => item.id !== post.id);

    this.api.delete<any>(`/api/v1/forum/posts/${post.id}/bookmark`).subscribe({
      next: () => {
        this.removingSavedId = null;
        this.message = 'Đã bỏ lưu bài viết.';
      },
      error: (e: any) => {
        this.savedPosts = previousPosts;
        this.removingSavedId = null;
        this.savedError = this.api.errorMessage(e, 'Không bỏ lưu được bài viết.');
      }
    });
  }

  date(value: any): string { return value ? new Date(value).toLocaleString('vi-VN') : ''; }

  shortText(value: string, max = 150): string {
    const text = (value || '').replace(/<[^>]*>/g, '').trim();
    return text.length > max ? `${text.slice(0, max)}...` : text;
  }

  postTags(post: any): string[] {
    if (Array.isArray(post?.tags)) {
      return post.tags.map((tag: any) => typeof tag === 'string' ? tag : (tag?.name || tag?.tagName || '')).filter(Boolean);
    }
    if (typeof post?.tagNames === 'string') {
      return post.tagNames.split(',').map((tag: string) => tag.trim()).filter(Boolean);
    }
    return [];
  }
}
