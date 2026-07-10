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
    const name = this.displayName || 'User';
    return name
      .split(' ')
      .filter(Boolean)
      .slice(0, 2)
      .map((x: string) => x[0])
      .join('')
      .toUpperCase();
  }

  get level(): number {
    return Math.max(1, Math.floor((this.stats.reputation || 0) / 1000) + 1);
  }

  get nextLevelXp(): number {
    return this.level * 1000;
  }

  get xpPercent(): number {
    return Math.min(100, Math.round(((this.stats.reputation || 0) % 1000) / 10));
  }

  get visibleSavedPosts(): any[] {
    return this.showAllSaved ? this.savedPosts : this.savedPosts.slice(0, this.savedLimit);
  }

  ngOnInit(): void {
    this.loadProfile();
    this.loadStats();
    this.loadSavedPosts();
  }

  loadProfile(): void {
    this.api.get('/api/v1/users/me/profile').subscribe({
      next: (r: any) => {
        const data = r?.data || {};
        this.profile = {
          ...data,
          fullName: data.fullName || this.auth.currentUser()?.fullName || ''
        };
      },
      error: () => {
        this.profile = {
          fullName: this.auth.currentUser()?.fullName || ''
        };
      }
    });
  }

  loadStats(): void {
    this.api.get('/api/v1/users/me/stats').subscribe({
      next: (r: any) => this.stats = r?.data || {},
      error: () => this.stats = {}
    });
  }

  loadSavedPosts(): void {
    this.savedLoading = true;
    this.savedError = '';

    this.api.get('/api/v1/forum/posts?pageIndex=1&pageSize=100').subscribe({
      next: (r: any) => {
        const data = r?.data;
        const items = Array.isArray(data) ? data : (data?.items || []);
        this.savedPosts = items
          .filter((post: any) => post?.isBookmarked || post?.isSaved || post?.bookmarked)
          .sort((a: any, b: any) => new Date(b.updatedAt || b.createdAt || 0).getTime() - new Date(a.updatedAt || a.createdAt || 0).getTime());
        this.savedLoading = false;
      },
      error: (e: any) => {
        this.savedError = e?.error?.message || 'Không tải được danh sách bài viết đã lưu.';
        this.savedLoading = false;
      }
    });
  }

  save(): void {
    this.api.put('/api/v1/users/me/profile', this.profile).subscribe({
      next: () => {
        this.message = 'Đã lưu hồ sơ.';
        this.editing = false;
      },
      error: () => this.message = 'Không lưu được hồ sơ.'
    });
  }

  removeSavedPost(post: any): void {
    if (!post?.id || this.removingSavedId) return;

    const oldPosts = [...this.savedPosts];
    this.removingSavedId = post.id;
    this.savedPosts = this.savedPosts.filter((item: any) => item.id !== post.id);

    this.api.delete(`/api/v1/forum/posts/${post.id}/bookmark`).subscribe({
      next: () => {
        this.removingSavedId = null;
        this.message = 'Đã bỏ lưu bài viết.';
      },
      error: (e: any) => {
        this.savedPosts = oldPosts;
        this.removingSavedId = null;
        alert(e?.error?.message || 'Không bỏ lưu được bài viết.');
      }
    });
  }

  date(value: any): string {
    return value ? new Date(value).toLocaleString('vi-VN') : '';
  }

  shortText(value: string, max = 150): string {
    const text = (value || '').replace(/<[^>]*>/g, '').trim();
    return text.length > max ? `${text.slice(0, max)}...` : text;
  }

  postTags(post: any): string[] {
    if (Array.isArray(post?.tags)) {
      return post.tags.map((tag: any) => typeof tag === 'string' ? tag : (tag?.name || tag?.tagName || '')).filter(Boolean);
    }
    if (typeof post?.tagNames === 'string') {
      return post.tagNames.split(',').map((x: string) => x.trim()).filter(Boolean);
    }
    return [];
  }
}
