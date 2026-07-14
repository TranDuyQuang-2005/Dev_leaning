import { CommonModule } from '@angular/common';
import { Component, OnDestroy, OnInit } from '@angular/core';
import { DomSanitizer, SafeResourceUrl } from '@angular/platform-browser';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { Subscription } from 'rxjs';
import { ApiService } from '../core/services/api.service';

@Component({
  selector: 'app-course-detail',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './course-detail.component.html'
})
export class CourseDetailComponent implements OnInit, OnDestroy {
  course: any = null;
  selectedLesson: any = null;
  expanded: Record<number, boolean> = {};
  loading = false;
  saving = false;
  error = '';
  actionError = '';
  private sub?: Subscription;

  constructor(private route: ActivatedRoute, private router: Router, private api: ApiService, private sanitizer: DomSanitizer) {}

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
    this.actionError = '';
    this.api.get<any>(`/api/v1/courses/${slug}`).subscribe({
      next: r => {
        this.course = r.data;
        this.loading = false;
        this.openDefaultModule();
        if (this.selectedLesson) this.refreshSelectedLesson();
      },
      error: e => {
        this.error = this.api.errorMessage(e, 'Không tải được khóa học.');
        this.loading = false;
      }
    });
  }

  openDefaultModule(): void {
    this.expanded = {};
    const firstOpen = (this.course?.modules || []).find((m: any) => !m.isLocked) || this.course?.modules?.[0];
    if (firstOpen) this.expanded[firstOpen.id] = true;
  }

  toggleModule(module: any): void {
    if (module.isLocked) return;
    this.expanded[module.id] = !this.expanded[module.id];
  }

  selectLesson(lesson: any): void {
    this.actionError = '';
    if (lesson.isLocked && !lesson.isPreview) {
      this.actionError = lesson.lockReason || 'Bài học đang bị khóa.';
      return;
    }

    const open = () => {
      if (lesson.type === 'Quiz' && lesson.quizSetId) {
        this.router.navigate(['/learner/quiz', lesson.quizSetId], { queryParams: { lessonId: lesson.id } });
        return;
      }
      if (lesson.type === 'CodePractice' && lesson.codingProblemId) {
        this.router.navigate(['/learner/problems', lesson.codingProblemId], { queryParams: { lessonId: lesson.id } });
        return;
      }
      this.selectedLesson = lesson;
    };

    if (lesson.status === 'NotStarted' || lesson.isPreview) {
      this.api.post<any>(`/api/v1/lessons/${lesson.id}/start`, {}).subscribe({
        next: () => open(),
        error: e => this.actionError = this.api.errorMessage(e, 'Không mở được bài học.')
      });
      return;
    }

    open();
  }

  completeSelectedLesson(): void {
    if (!this.selectedLesson || this.saving) return;
    this.saving = true;
    this.actionError = '';
    this.api.post<any>(`/api/v1/lessons/${this.selectedLesson.id}/complete`, {}).subscribe({
      next: () => {
        this.saving = false;
        this.load(this.course.slug);
      },
      error: e => {
        this.saving = false;
        this.actionError = this.api.errorMessage(e, 'Không đánh dấu hoàn thành được bài học.');
      }
    });
  }

  closeLesson(): void {
    this.selectedLesson = null;
    this.actionError = '';
  }

  startNextLesson(): void {
    if (this.course?.isLocked || !this.course?.nextUnlockedLesson) return;
    this.selectLesson(this.course.nextUnlockedLesson);
  }

  refreshSelectedLesson(): void {
    const next = (this.course?.modules || [])
      .flatMap((m: any) => m.lessons || [])
      .find((lesson: any) => lesson.id === this.selectedLesson.id);
    if (next) this.selectedLesson = next;
  }

  progressWidth(value: any): string {
    return `${Math.max(0, Math.min(100, Number(value) || 0))}%`;
  }

  lessonKind(lesson: any): string {
    return lesson?.type === 'CodePractice' ? 'Code' : lesson?.type || 'Reading';
  }

  isVideoLesson(lesson: any): boolean {
    return String(lesson?.type || '').toLowerCase() === 'video';
  }

  absoluteUrl(url?: string | null): string {
    return this.api.toAbsoluteUrl(url);
  }

  safeYouTubeUrl(url?: string | null): SafeResourceUrl | null {
    const embed = this.youtubeEmbedUrl(url);
    return embed ? this.sanitizer.bypassSecurityTrustResourceUrl(embed) : null;
  }

  youtubeEmbedUrl(url?: string | null): string | null {
    if (!url) return null;
    const id = this.youtubeId(url);
    return id ? `https://www.youtube.com/embed/${id}` : null;
  }

  isDirectVideoUrl(url?: string | null): boolean {
    return !!url && /\.(mp4|webm|mov)(\?|#|$)/i.test(url);
  }

  externalVideoUrl(url?: string | null): string {
    return url ? url.trim() : '';
  }

  private youtubeId(url: string): string | null {
    const trimmed = url.trim();
    if (/^[a-zA-Z0-9_-]{11}$/.test(trimmed)) return trimmed;

    try {
      const parsed = new URL(trimmed);
      if (parsed.hostname.includes('youtu.be')) return parsed.pathname.split('/').filter(Boolean)[0] || null;
      if (parsed.hostname.includes('youtube.com')) {
        if (parsed.pathname.startsWith('/embed/')) return parsed.pathname.split('/').filter(Boolean)[1] || null;
        return parsed.searchParams.get('v');
      }
    } catch {
      return null;
    }

    return null;
  }

  nextLessonTitle(): string {
    return this.course?.nextUnlockedLesson?.title || 'Hoàn thành bài hiện tại';
  }
}
