import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { RouterLink } from '@angular/router';
import { ApiService } from '../core/services/api.service';

type NotificationItem = {
  id: number;
  type: string;
  title: string;
  content?: string;
  message: string;
  linkUrl?: string;
  isRead: boolean;
  readAt?: string;
  createdAt: string;
};

@Component({
  selector: 'app-notifications',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './notifications.component.html'
})
export class NotificationsComponent implements OnInit {
  notifications: NotificationItem[] = [];
  unreadCount = 0;
  loading = false;
  error = '';

  constructor(private api: ApiService) {}

  ngOnInit(): void {
    this.load();
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
    if (item.type.startsWith('quiz')) return 'yellow-bg';
    if (item.type.startsWith('forum')) return 'blue-bg';
    if (item.type.startsWith('code')) return 'green-bg';
    return 'blue-bg';
  }

  date(value: string): string {
    return value ? new Date(value).toLocaleString('vi-VN') : '';
  }
}
