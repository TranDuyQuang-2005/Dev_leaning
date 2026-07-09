import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { ApiService } from '../core/services/api.service';

type ForumAttachment = {
  id?: number;
  fileId?: number;
  originalFileName?: string;
  fileName?: string;
  fileType?: string;
  mimeType?: string;
  storageProvider?: string;
  fileUrl?: string;
  isImage?: boolean;
  size?: number;
  sizeBytes?: number;
};

@Component({
  selector: 'app-create-post',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './create-post.component.html'
})
export class CreatePostComponent implements OnInit {
  postId: number | null = null;
  form: { title: string; content: string; tags: string[]; attachmentIds: number[] } = {
    title: '',
    content: '',
    tags: [],
    attachmentIds: []
  };

  tagInput = '';
  suggested = ['Angular', 'C#', 'SQL', 'Flutter', 'API', 'JWT', 'Database', 'DevOps'];
  attachments: ForumAttachment[] = [];
  uploading = false;
  error = '';
  loading = false;

  constructor(
    private api: ApiService,
    private route: ActivatedRoute,
    private router: Router
  ) {}

  ngOnInit(): void {
    const id = this.route.snapshot.paramMap.get('id');
    if (!id) return;

    this.postId = Number(id);
    this.loading = true;

    this.api.get<any>(`/api/v1/forum/posts/${this.postId}`).subscribe({
      next: (r: any) => {
        const p = r?.data || r;
        this.attachments = p?.attachments || [];
        this.form = {
          title: p?.title || '',
          content: p?.content || '',
          tags: (p?.tags || []).map((x: any) => x?.name || x).filter(Boolean),
          attachmentIds: this.attachments.map((x: ForumAttachment) => Number(x.fileId || x.id)).filter(Boolean)
        };
        this.loading = false;
      },
      error: (e: any) => {
        this.loading = false;
        this.error = e?.error?.message || 'Không tải được bài viết.';
      }
    });
  }

  get isEditMode(): boolean {
    return !!this.postId;
  }

  get titleLength(): number {
    return (this.form.title || '').trim().length;
  }

  get contentLength(): number {
    return (this.form.content || '').trim().length;
  }

  get remainingFiles(): number {
    return Math.max(0, 5 - this.attachments.length);
  }

  get progressPercent(): number {
    const titleScore = Math.min(this.titleLength / 10, 1);
    const contentScore = Math.min(this.contentLength / 20, 1);
    const tagScore = this.form.tags.length ? 1 : 0;
    return Math.round(((titleScore + contentScore + tagScore) / 3) * 100);
  }

  get canSubmit(): boolean {
    return this.titleLength >= 10 && this.contentLength >= 20 && this.form.tags.length > 0 && !this.loading && !this.uploading;
  }

  get primaryActionLabel(): string {
    if (this.loading) return this.isEditMode ? 'Đang cập nhật...' : 'Đang đăng...';
    return this.isEditMode ? 'Cập nhật bài viết' : 'Đăng bài viết';
  }

  addTag(tag?: string): void {
    const value = (tag || this.tagInput || '').trim();
    if (!value) return;

    const existed = this.form.tags.some((x: string) => x.toLowerCase() === value.toLowerCase());
    if (existed) {
      this.tagInput = '';
      return;
    }

    if (this.form.tags.length >= 5) {
      this.error = 'Tối đa 5 tag cho mỗi bài viết.';
      return;
    }

    this.form.tags.push(value);
    this.tagInput = '';
    this.error = '';
  }

  onTagKeydown(event: KeyboardEvent): void {
    if (event.key !== 'Enter') return;
    event.preventDefault();
    this.addTag();
  }

  removeTag(tag: string): void {
    this.form.tags = this.form.tags.filter((x: string) => x !== tag);
  }

  onFilesSelected(event: Event): void {
    const input = event.target as HTMLInputElement;
    const files = input.files;
    if (!files || !files.length) return;

    if (this.attachments.length + files.length > 5) {
      this.error = 'Tối đa 5 file/hình cho mỗi bài viết.';
      input.value = '';
      return;
    }

    this.error = '';
    this.uploading = true;
    let done = 0;

    Array.from(files).forEach((file: File) => {
      const formData = new FormData();
      formData.append('file', file);

      this.api.upload<ForumAttachment>('/api/v1/forum/uploads', formData).subscribe({
        next: (r: any) => {
          const attachment = r?.data || r;
          this.attachments.push(attachment);
          this.syncAttachmentIds();
        },
        error: (e: any) => {
          this.error = e?.error?.message || `Upload thất bại: ${file.name}`;
        },
        complete: () => {
          done++;
          if (done === files.length) {
            this.uploading = false;
            input.value = '';
          }
        }
      });
    });
  }

  removeAttachment(attachment: ForumAttachment): void {
    const id = attachment.fileId || attachment.id;
    this.attachments = this.attachments.filter((x: ForumAttachment) => (x.fileId || x.id) !== id);
    this.syncAttachmentIds();
  }

  isImage(attachment: ForumAttachment): boolean {
    return !!attachment?.isImage || (attachment?.mimeType || attachment?.fileType || '').startsWith('image/');
  }

  fileViewUrl(attachment: ForumAttachment): string {
    const id = attachment?.fileId || attachment?.id;
    if (id) return `${this.api.baseUrl}/api/v1/files/${id}/view`;

    const url = attachment?.fileUrl || '';
    return url.startsWith('/') ? `${this.api.baseUrl}${url}` : url;
  }

  attachmentName(attachment: ForumAttachment): string {
    return attachment.originalFileName || attachment.fileName || `File #${attachment.fileId || attachment.id || ''}`;
  }

  attachmentMeta(attachment: ForumAttachment): string {
    const type = attachment.fileType || attachment.mimeType || 'File';
    const provider = attachment.storageProvider ? ` · ${attachment.storageProvider}` : '';
    return `${type}${provider}`;
  }

  save(): void {
    this.error = '';

    if (this.titleLength < 10) {
      this.error = 'Tiêu đề phải từ 10 ký tự.';
      return;
    }

    if (this.contentLength < 20) {
      this.error = 'Nội dung phải từ 20 ký tự.';
      return;
    }

    if (!this.form.tags.length) {
      this.error = 'Cần ít nhất 1 tag.';
      return;
    }

    this.syncAttachmentIds();
    this.loading = true;

    const request = this.postId
      ? this.api.put<any>(`/api/v1/forum/posts/${this.postId}`, this.form)
      : this.api.post<any>('/api/v1/forum/posts', this.form);

    request.subscribe({
      next: (r: any) => {
        this.loading = false;
        const post = r?.data || r;
        this.router.navigate(['/learner/forum-post', post?.id || this.postId]);
      },
      error: (e: any) => {
        this.loading = false;
        this.error = e?.error?.message || 'Không lưu được bài viết.';
      }
    });
  }

  private syncAttachmentIds(): void {
    this.form.attachmentIds = this.attachments
      .map((x: ForumAttachment) => Number(x.fileId || x.id))
      .filter((id: number) => !!id);
  }
}
