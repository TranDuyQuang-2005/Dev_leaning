import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { ApiService } from '../core/services/api.service';

@Component({
  selector: 'app-forum',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './forum.component.html'
})
export class ForumComponent implements OnInit {
  posts: any[] = [];
  tags: any[] = [];
  keyword = '';
  tag = 'all';
  loading = false;
  error = '';
  pageIndex = 1;
  totalPages = 1;

  constructor(private api: ApiService) {}

  ngOnInit() {
    this.loadTags();
    this.loadPosts();
  }

  loadTags() {
    this.api.get<any>('/api/v1/forum/tags').subscribe({
      next: (r: any) => this.tags = r?.data || [],
      error: () => this.tags = []
    });
  }

  loadPosts() {
    this.loading = true;
    this.error = '';

    const query = [
      `pageIndex=${this.pageIndex}`,
      'pageSize=10',
      this.keyword.trim() ? `keyword=${encodeURIComponent(this.keyword.trim())}` : '',
      this.tag && this.tag !== 'all' ? `tag=${encodeURIComponent(this.tag)}` : ''
    ].filter(Boolean).join('&');

    this.api.get<any>(`/api/v1/forum/posts?${query}`).subscribe({
      next: (r: any) => {
        this.posts = r?.data?.items || [];
        this.totalPages = r?.data?.totalPages || 1;
        this.loading = false;
      },
      error: (e: any) => {
        this.error = e?.error?.message || 'Không tải được diễn đàn';
        this.loading = false;
      }
    });
  }

  search() {
    this.pageIndex = 1;
    this.loadPosts();
  }

  clearFilters() {
    this.keyword = '';
    this.tag = 'all';
    this.search();
  }

  nextPage() {
    if (this.pageIndex >= this.totalPages) return;
    this.pageIndex++;
    this.loadPosts();
  }

  prevPage() {
    if (this.pageIndex <= 1) return;
    this.pageIndex--;
    this.loadPosts();
  }

  vote(post: any, voteType: number) {
    this.api.post<any>(`/api/v1/forum/posts/${post.id}/vote`, { voteType }).subscribe({
      next: () => this.loadPosts(),
      error: (e: any) => alert(e?.error?.message || 'Vote thất bại')
    });
  }

  bookmark(post: any) {
    const req = post.isBookmarked
      ? this.api.delete<any>(`/api/v1/forum/posts/${post.id}/bookmark`)
      : this.api.post<any>(`/api/v1/forum/posts/${post.id}/bookmark`, {});

    req.subscribe({
      next: () => this.loadPosts(),
      error: (e: any) => alert(e?.error?.message || 'Bookmark thất bại')
    });
  }

  likeCount(item: any): number {
    const direct = item?.likeCount ?? item?.likes ?? item?.upvoteCount ?? item?.upVotes;
    if (direct !== undefined && direct !== null) return Number(direct) || 0;
    const score = Number(item?.voteScore || 0);
    return score > 0 ? score : 0;
  }

  dislikeCount(item: any): number {
    const direct = item?.dislikeCount ?? item?.dislikes ?? item?.downvoteCount ?? item?.downVotes;
    if (direct !== undefined && direct !== null) return Number(direct) || 0;
    const score = Number(item?.voteScore || 0);
    return score < 0 ? Math.abs(score) : 0;
  }

  date(value: any) {
    return value ? new Date(value).toLocaleString('vi-VN') : '';
  }

  initials(post: any) {
    return post?.authorInitials || (post?.authorName || 'U').trim().charAt(0).toUpperCase();
  }

  fileViewUrl(url: any) {
    const value = url || '';
    return value.startsWith('/') ? `${this.api.baseUrl}${value}` : value;
  }

  trackByPost(_: number, post: any) {
    return post.id;
  }
}

