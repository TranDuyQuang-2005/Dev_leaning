import { CommonModule } from '@angular/common';
import { Component, OnDestroy, OnInit } from '@angular/core';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { Subscription } from 'rxjs';
import { ApiService } from '../core/services/api.service';

@Component({
  selector: 'app-roadmap-track',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './roadmap-track.component.html'
})
export class RoadmapTrackComponent implements OnInit, OnDestroy {
  track: any = null;
  loading = false;
  error = '';
  private sub?: Subscription;

  constructor(private route: ActivatedRoute, private api: ApiService) {}

  ngOnInit(): void {
    this.sub = this.route.paramMap.subscribe(params => {
      const slug = params.get('slug') || '';
      if (slug) this.load(slug);
    });
  }

  ngOnDestroy(): void {
    this.sub?.unsubscribe();
  }

  load(slug: string): void {
    this.loading = true;
    this.error = '';
    this.api.get<any>(`/api/v1/roadmaps/${slug}`).subscribe({
      next: r => {
        this.track = r.data;
        this.loading = false;
      },
      error: e => {
        this.error = this.api.errorMessage(e, 'Không tải được chi tiết lộ trình.');
        this.loading = false;
      }
    });
  }

  progressWidth(value: any): string {
    return `${Math.max(0, Math.min(100, Number(value) || 0))}%`;
  }

  statusClass(course: any): string {
    if (course?.isCompleted) return 'badge-green';
    if (course?.isLocked) return 'badge-gray';
    return Number(course?.progressPercent) > 0 ? 'badge-blue' : 'badge-yellow';
  }

  buttonText(course: any): string {
    if (course?.isLocked) return 'Đang khóa';
    return Number(course?.progressPercent) > 0 ? 'Tiếp tục học' : 'Bắt đầu học';
  }
}
