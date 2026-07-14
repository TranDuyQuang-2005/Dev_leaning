import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { ApiService } from '../core/services/api.service';

@Component({
  selector: 'app-leaderboard',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './leaderboard.component.html'
})
export class LeaderboardComponent implements OnInit {
  leaders: any[] = [];
  loading = false;
  error = '';

  constructor(private api: ApiService) {}

  ngOnInit(): void {
    this.load();
  }

  load(): void {
    this.loading = true;
    this.error = '';
    this.api.get<any[]>('/api/v1/leaderboard?limit=50').subscribe({
      next: (r: any) => {
        this.leaders = r?.data || [];
        this.loading = false;
      },
      error: (e: any) => {
        this.error = this.api.errorMessage(e, 'Không tải được leaderboard.');
        this.loading = false;
      }
    });
  }

  initials(item: any): string {
    const name = item?.name || 'U';
    return name.split(' ').filter(Boolean).slice(0, 2).map((x: string) => x[0]).join('').toUpperCase() || 'U';
  }
}
