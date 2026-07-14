import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { RouterLink } from '@angular/router';
import { ApiService } from '../core/services/api.service';

@Component({
  selector: 'app-roadmap',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './roadmap.component.html'
})
export class RoadmapComponent implements OnInit {
  tracks: any[] = [];
  recommendation: any = null;
  loading = false;
  error = '';

  constructor(private api: ApiService) {}

  ngOnInit(): void {
    this.load();
  }

  load(): void {
    this.loading = true;
    this.error = '';
    this.api.get<any[]>('/api/v1/roadmaps').subscribe({
      next: r => {
        this.tracks = r.data || [];
        this.loading = false;
      },
      error: e => {
        this.error = this.api.errorMessage(e, 'Không tải được lộ trình học.');
        this.loading = false;
      }
    });

    this.api.get<any>('/api/v1/me/progress/roadmap').subscribe({
      next: r => this.recommendation = r.data,
      error: () => this.recommendation = null
    });
  }

  progressWidth(value: any): string {
    return `${Math.max(0, Math.min(100, Number(value) || 0))}%`;
  }

  trackTone(index: number): string {
    return ['blue', 'green', 'purple', 'orange', 'cyan'][index % 5];
  }
}
