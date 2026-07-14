import { CommonModule } from '@angular/common';
import { Component, OnDestroy, OnInit } from '@angular/core';
import { ActivatedRoute, NavigationEnd, Router, RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';
import { filter, Subject, takeUntil } from 'rxjs';
import { ApiService } from '../core/services/api.service';
import { AuthService } from '../core/services/auth.service';
import { NotificationRealtimeService } from '../core/services/notification-realtime.service';

@Component({
  selector: 'app-layout',
  standalone: true,
  imports: [CommonModule, RouterOutlet, RouterLink, RouterLinkActive],
  templateUrl: './layout.component.html'
})
export class LayoutComponent implements OnInit, OnDestroy {
  pageTitle = 'Dashboard';
  pageSubtitle = 'Dev-Learning Hub workspace';
  themeLabel = 'Light';
  unreadCount = 0;
  private destroy$ = new Subject<void>();

  constructor(
    private router: Router,
    private route: ActivatedRoute,
    public auth: AuthService,
    private api: ApiService,
    private realtime: NotificationRealtimeService) {}

  get initials(): string {
    const name = this.auth.currentUser()?.fullName || this.auth.currentUser()?.userName || 'User';
    return name
      .split(' ')
      .filter(Boolean)
      .slice(0, 2)
      .map(x => x[0])
      .join('')
      .toUpperCase() || 'U';
  }

  get displayName(): string {
    return this.auth.currentUser()?.fullName || this.auth.currentUser()?.userName || 'Tài khoản';
  }

  ngOnInit(): void {
    this.themeLabel = (localStorage.getItem('dlh-theme') || 'light') === 'dark' ? 'Dark' : 'Light';
    document.documentElement.dataset['theme'] = localStorage.getItem('dlh-theme') || 'light';
    this.updateTitle();
    this.loadUnreadCount();
    void this.realtime.start();

    this.realtime.unreadCountChanged$
      .pipe(takeUntil(this.destroy$))
      .subscribe(count => this.unreadCount = Math.max(0, Number(count || 0)));

    this.realtime.notificationCreated$
      .pipe(takeUntil(this.destroy$))
      .subscribe(() => this.unreadCount += 1);

    this.router.events.pipe(filter(e => e instanceof NavigationEnd), takeUntil(this.destroy$)).subscribe(() => {
      this.updateTitle();
      this.loadUnreadCount();
    });
  }

  ngOnDestroy(): void {
    this.destroy$.next();
    this.destroy$.complete();
  }

  updateTitle(): void {
    let route = this.route.firstChild;
    while (route?.firstChild) route = route.firstChild;
    this.pageTitle = route?.snapshot.data['title'] || 'Dashboard';
    this.pageSubtitle = route?.snapshot.data['subtitle'] || 'Dev-Learning Hub workspace';
  }

  toggleTheme(): void {
    const next = document.documentElement.dataset['theme'] === 'dark' ? 'light' : 'dark';
    document.documentElement.dataset['theme'] = next;
    localStorage.setItem('dlh-theme', next);
    this.themeLabel = next === 'dark' ? 'Dark' : 'Light';
  }

  logout(): void {
    void this.realtime.stop();
    this.auth.logout();
  }

  private loadUnreadCount(): void {
    this.api.get<any>('/api/v1/notifications/unread-count').subscribe({
      next: (res: any) => this.unreadCount = Number(res?.data?.unreadCount || 0),
      error: () => this.unreadCount = 0
    });
  }
}
