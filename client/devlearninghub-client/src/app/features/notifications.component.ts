import { CommonModule } from '@angular/common';
import { Component, OnDestroy, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Subject, takeUntil } from 'rxjs';
import { ApiService } from '../core/services/api.service';
import { NotificationRealtimeService, RealtimeNotification } from '../core/services/notification-realtime.service';

type NotificationItem = {
  id: number;
  type: string;
  notificationType?: string;
  title: string;
  content?: string;
  message: string;
  linkUrl?: string;
  isRead: boolean;
  readAt?: string;
  createdAt: string;
  metadataJson?: string | null;
};

@Component({
  selector: 'app-notifications',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './notifications.component.html'
})
export class NotificationsComponent implements OnInit, OnDestroy {
  notifications: NotificationItem[] = [];
  unreadCount = 0;
  loading = false;
  error = '';
  private destroy$ = new Subject<void>();
  private wasDisconnected = false;

  constructor(private api: ApiService, private realtime: NotificationRealtimeService, private router: Router) {}

  ngOnInit(): void {
    this.load();
    void this.realtime.start();

    this.realtime.notificationCreated$
      .pipe(takeUntil(this.destroy$))
      .subscribe(item => this.prependNotification(item));

    this.realtime.unreadCountChanged$
      .pipe(takeUntil(this.destroy$))
      .subscribe(count => this.unreadCount = Math.max(0, Number(count || 0)));

    this.realtime.connectionState$
      .pipe(takeUntil(this.destroy$))
      .subscribe(state => {
        if (state === 'disconnected' || state === 'reconnecting') this.wasDisconnected = true;
        if (state === 'connected' && this.wasDisconnected) {
          this.wasDisconnected = false;
          this.load();
        }
      });
  }

  ngOnDestroy(): void {
    this.destroy$.next();
    this.destroy$.complete();
  }

  load(): void {
    this.loading = true;
    this.error = '';
    this.api.get<any>('/api/v1/notifications?pageIndex=1&pageSize=50').subscribe({
      next: (res: any) => {
        this.notifications = res?.data?.items || [];
        this.unreadCount = this.notifications.filter(x => !x.isRead).length;
        this.loading = false;
      },
      error: (err: any) => {
        this.error = this.api.errorMessage(err, 'Không tải được thông báo.');
        this.loading = false;
      }
    });
  }

  markRead(item: NotificationItem): void {
    if (item.isRead) return;
    this.api.post<any>(`/api/v1/notifications/${item.id}/read`, {}).subscribe({
      next: () => {
        item.isRead = true;
        item.readAt = new Date().toISOString();
        this.unreadCount = Math.max(0, this.unreadCount - 1);
      },
      error: (err: any) => this.error = this.api.errorMessage(err, 'Không đánh dấu đã đọc được.')
    });
  }

  open(item: NotificationItem): void {
    const navigate = () => {
      if (item.linkUrl) this.router.navigateByUrl(item.linkUrl);
    };

    if (item.isRead) {
      navigate();
      return;
    }

    this.api.post<any>(`/api/v1/notifications/${item.id}/read`, {}).subscribe({
      next: () => {
        item.isRead = true;
        item.readAt = new Date().toISOString();
        this.unreadCount = Math.max(0, this.unreadCount - 1);
        navigate();
      },
      error: (err: any) => {
        this.error = this.api.errorMessage(err, 'Không đánh dấu đã đọc được.');
        navigate();
      }
    });
  }

  markAllRead(): void {
    this.api.post<any>('/api/v1/notifications/read-all', {}).subscribe({
      next: () => {
        this.notifications = this.notifications.map(x => ({ ...x, isRead: true, readAt: x.readAt || new Date().toISOString() }));
        this.unreadCount = 0;
      },
      error: (err: any) => this.error = this.api.errorMessage(err, 'Không đánh dấu tất cả đã đọc được.')
    });
  }

  delete(item: NotificationItem): void {
    this.api.delete<any>(`/api/v1/notifications/${item.id}`).subscribe({
      next: () => {
        this.notifications = this.notifications.filter(x => x.id !== item.id);
        if (!item.isRead) this.unreadCount = Math.max(0, this.unreadCount - 1);
      },
      error: (err: any) => this.error = this.api.errorMessage(err, 'Không xóa được thông báo.')
    });
  }

  typeClass(item: NotificationItem): string {
    const type = this.typeOf(item);
    if (type.startsWith('quiz')) return 'yellow-bg';
    if (type.startsWith('forum')) return 'blue-bg';
    if (type.startsWith('code')) return 'green-bg';
    return 'blue-bg';
  }

  typeLabel(item: NotificationItem): string {
    const labels: Record<string, string> = {
      'forum.post_reply': 'Phản hồi bài viết',
      'forum.comment_reply': 'Trả lời bình luận',
      'forum.post_liked': 'Thích bài viết',
      'forum.post_disliked': 'Không thích bài viết',
      'forum.comment_liked': 'Thích bình luận',
      'forum.comment_disliked': 'Không thích bình luận',
      'forum.accepted_answer': 'Câu trả lời được chấp nhận'
    };
    const type = this.typeOf(item);
    return labels[type] || type || 'Thông báo';
  }

  date(value: string): string {
    return value ? new Date(value).toLocaleString('vi-VN') : '';
  }

  private prependNotification(item: RealtimeNotification): void {
    if (!item?.id || this.notifications.some(x => x.id === item.id)) return;
    const next: NotificationItem = {
      id: item.id,
      type: item.type || item.notificationType || 'general',
      notificationType: item.notificationType || item.type || 'general',
      title: item.title,
      content: item.content,
      message: item.message || item.content || '',
      linkUrl: item.linkUrl,
      isRead: item.isRead,
      readAt: item.readAt || undefined,
      createdAt: item.createdAt,
      metadataJson: item.metadataJson || null
    };
    this.notifications = [next, ...this.notifications];
    if (!next.isRead) this.unreadCount += 1;
  }

  private typeOf(item: NotificationItem): string {
    return item.notificationType || item.type || 'general';
  }
}
