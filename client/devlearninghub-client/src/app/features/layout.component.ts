import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, NavigationEnd, Router, RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';
import { filter } from 'rxjs';
import { AuthService } from '../core/services/auth.service';

@Component({
  selector: 'app-layout',
  standalone: true,
  imports: [RouterOutlet, RouterLink, RouterLinkActive],
  templateUrl: './layout.component.html'
})
export class LayoutComponent implements OnInit {
  pageTitle = 'Dashboard';
  pageSubtitle = 'Dev-Learning Hub workspace';
  themeLabel = 'Light';

  constructor(private router: Router, private route: ActivatedRoute, public auth: AuthService) {}

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
    return this.auth.currentUser()?.fullName || this.auth.currentUser()?.userName || 'TÃ i khoáº£n';
  }

  ngOnInit(): void {
    this.themeLabel = (localStorage.getItem('dlh-theme') || 'light') === 'dark' ? 'Dark' : 'Light';
    document.documentElement.dataset['theme'] = localStorage.getItem('dlh-theme') || 'light';
    this.updateTitle();
    this.router.events.pipe(filter(e => e instanceof NavigationEnd)).subscribe(() => this.updateTitle());
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
}

