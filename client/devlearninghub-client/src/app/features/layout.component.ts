import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, NavigationEnd, Router, RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';
import { filter } from 'rxjs';
import { ApiService } from '../core/services/api.service';
import { AuthService } from '../core/services/auth.service';

@Component({
  selector: 'app-layout',
  standalone: true,
  imports: [CommonModule, RouterOutlet, RouterLink, RouterLinkActive],
  templateUrl: './layout.component.html'
})
export class LayoutComponent implements OnInit {
  pageTitle = 'Dashboard';
  pageSubtitle = 'Dev-Learning Hub workspace';
  themeLabel = 'Light';
  unreadCount = 0;

  constructor(private router: Router, private route: ActivatedRoute, public auth: AuthService, private api: ApiService) {}

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
    this.router.events.pipe(filter(e => e instanceof NavigationEnd)).subscribe(() => {
      this.updateTitle();
      this.loadUnreadCount();
    });
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
    this.auth.logout();
  }

  private loadUnreadCount(): void {
    this.api.get<any>('/api/v1/notifications/unread-count').subscribe({
      next: (res: any) => this.unreadCount = Number(res?.data?.unreadCount || 0),
      error: () => this.unreadCount = 0
    });
  }
}
