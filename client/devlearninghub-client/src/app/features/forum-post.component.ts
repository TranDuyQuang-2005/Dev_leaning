import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { ApiService } from '../core/services/api.service';

@Component({
  selector: 'app-forum-post',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './forum-post.component.html'
})
export class ForumPostComponent implements OnInit {
  post: any;
  postId = 0;
  answers: any[] = [];
  answerCount = 0;
  totalCommentCount = 0;
  answer = '';
  replyTo: number | null = null;
  replyContent = '';
  reportReason = '';
  reportTarget: any = null;
  error = '';
  message = '';
  acceptingId: number | null = null;

  visibleAnswerLimit = 6;
  visibleReplyLimit = 4;
  showAllAnswers = false;
  expandedReplyThreads = new Set<number>();

  constructor(private api: ApiService, private route: ActivatedRoute, private router: Router) {}

  ngOnInit() {
    this.postId = Number(this.route.snapshot.paramMap.get('id') || 0);
    if (!this.postId) this.router.navigate(['/learner/forum']);
    else this.load();
  }

  get visibleAnswers(): any[] {
    return this.showAllAnswers ? this.answers : this.answers.slice(0, this.visibleAnswerLimit);
  }

  get hiddenAnswersCount(): number {
    return Math.max((this.answers?.length || 0) - this.visibleAnswerLimit, 0);
  }

  load() {
    this.error = '';
    this.api.get<any>(`/api/v1/forum/posts/${this.postId}`).subscribe({
      next: (r: any) => {
        this.post = r?.data;
        this.normalizeComments();
      },
      error: (e: any) => this.error = e?.error?.message || 'Không tải được bài viết'
    });
  }

  private getParentId(comment: any): number | null {
    const raw = comment?.parentCommentId ?? comment?.parentId ?? comment?.parentComment?.id ?? null;
    const id = Number(raw || 0);
    return id > 0 ? id : null;
  }

  private flattenReplies(items: any[], rootAnswerId: number, level = 1, result: any[] = []): any[] {
    items.forEach((reply: any) => {
      reply.replyDepth = Math.min(level, 4);
      reply.rootAnswerId = rootAnswerId;
      result.push(reply);
      this.flattenReplies(reply.replies || [], rootAnswerId, level + 1, result);
    });
    return result;
  }

  private normalizeComments() {
    const source = Array.isArray(this.post?.comments) ? this.post.comments : [];
    const map = new Map<number, any>();
    const acceptedId = Number(this.post?.acceptedCommentId || 0);

    const add = (comment: any, parentOverride: number | null = null) => {
      const id = Number(comment?.id ?? comment?.commentId ?? 0);
      if (!id) return;

      const parentCommentId = parentOverride ?? this.getParentId(comment);
      const current = map.get(id) || {};
      map.set(id, {
        ...current,
        ...comment,
        id,
        parentCommentId,
        isAcceptedAnswer: !!comment?.isAcceptedAnswer || (!!acceptedId && acceptedId === id),
        replies: [],
        threadReplies: []
      });

      if (Array.isArray(comment?.replies)) {
        comment.replies.forEach((reply: any) => add(reply, id));
      }
    };

    source.forEach((comment: any) => add(comment));

    const roots: any[] = [];
    map.forEach(comment => {
      comment.replies = [];
      comment.threadReplies = [];
    });

    map.forEach(comment => {
      const parentId = this.getParentId(comment);
      if (parentId && map.has(parentId)) {
        map.get(parentId).replies.push(comment);
      } else {
        comment.parentCommentId = null;
        roots.push(comment);
      }
    });

    const sortComments = (items: any[]) => {
      items.sort((a: any, b: any) => {
        const aAccepted = this.hasAcceptedInTree(a) ? 1 : 0;
        const bAccepted = this.hasAcceptedInTree(b) ? 1 : 0;
        if (aAccepted !== bAccepted) return bAccepted - aAccepted;
        const scoreDiff = Number(b.voteScore || 0) - Number(a.voteScore || 0);
        if (scoreDiff) return scoreDiff;
        return new Date(a.createdAt || 0).getTime() - new Date(b.createdAt || 0).getTime();
      });
      items.forEach((item: any) => sortComments(item.replies || []));
    };

    sortComments(roots);

    roots.forEach((root: any) => {
      root.rootAnswerId = root.id;
      root.threadReplies = this.flattenReplies(root.replies || [], root.id);
    });

    this.answers = roots;
    this.answerCount = roots.length;
    this.totalCommentCount = map.size;
    if (this.answers.length <= this.visibleAnswerLimit) this.showAllAnswers = true;
  }

  private hasAcceptedInTree(comment: any): boolean {
    if (comment?.isAcceptedAnswer) return true;
    return Array.isArray(comment?.replies) && comment.replies.some((r: any) => this.hasAcceptedInTree(r));
  }

  likeCount(item: any): number {
    const direct = item?.likeCount ?? item?.likes ?? item?.upvoteCount ?? item?.upVotes;
    if (direct !== undefined && direct !== null) return Number(direct) || 0;
    const score = Number(item?.voteScore || 0);
    return score > 0 ? score : 0;
  }

  dislikeCount(item: any): number {
    const direct = item?.dislikeCount ?? item?.dislikes ?? item?.downvoteCount ?? item?.downVotes;
    if (direct !== undefined && direct !== null) return Number(direct) || 0;
    const score = Number(item?.voteScore || 0);
    return score < 0 ? Math.abs(score) : 0;
  }

  votePost(voteType: number) {
    this.api.post<any>(`/api/v1/forum/posts/${this.postId}/vote`, { voteType }).subscribe({
      next: () => this.load(),
      error: (e: any) => alert(e?.error?.message || 'Vote thất bại')
    });
  }

  voteComment(comment: any, voteType: number) {
    this.api.post<any>(`/api/v1/forum/comments/${comment.id}/vote`, { voteType }).subscribe({
      next: () => this.load(),
      error: (e: any) => alert(e?.error?.message || 'Vote thất bại')
    });
  }

  bookmark() {
    const request = this.post?.isBookmarked
      ? this.api.delete<any>(`/api/v1/forum/posts/${this.postId}/bookmark`)
      : this.api.post<any>(`/api/v1/forum/posts/${this.postId}/bookmark`, {});

    request.subscribe({ next: () => this.load() });
  }

  startReply(comment: any) {
    this.replyTo = comment?.id || null;
    this.replyContent = '';
  }

  cancelReply() {
    this.replyTo = null;
    this.replyContent = '';
  }

  addComment(parentId?: number) {
    const rawContent = parentId ? this.replyContent : this.answer;
    const content = (rawContent || '').trim();

    if (content.length < 2) {
      alert(parentId ? 'Phản hồi phải có ít nhất 2 ký tự' : 'Câu trả lời phải có ít nhất 2 ký tự');
      return;
    }

    this.api.post<any>(`/api/v1/forum/posts/${this.postId}/comments`, {
      content,
      parentCommentId: parentId ?? null
    }).subscribe({
      next: () => {
        this.answer = '';
        this.replyContent = '';
        this.replyTo = null;
        const root = this.findRootAnswerId(parentId || 0);
        if (root) this.expandedReplyThreads.add(root);
        this.load();
      },
      error: (e: any) => alert(e?.error?.message || 'Bình luận thất bại')
    });
  }

  private findRootAnswerId(commentId: number): number | null {
    if (!commentId) return null;
    for (const answer of this.answers) {
      if (answer.id === commentId) return answer.id;
      const found = (answer.threadReplies || []).find((x: any) => x.id === commentId);
      if (found) return found.rootAnswerId || answer.id;
    }
    return null;
  }

  deletePost() {
    if (!confirm('Xóa bài viết này?')) return;
    this.api.delete<any>(`/api/v1/forum/posts/${this.postId}`).subscribe({
      next: () => this.router.navigate(['/learner/forum']),
      error: (e: any) => alert(e?.error?.message || 'Không xóa được bài')
    });
  }

  deleteComment(comment: any) {
    if (!confirm('Xóa bình luận này?')) return;
    this.api.delete<any>(`/api/v1/forum/comments/${comment.id}`).subscribe({
      next: () => this.load(),
      error: (e: any) => alert(e?.error?.message || 'Không xóa được bình luận')
    });
  }

  canAccept(comment: any) {
    return !!this.post?.canAcceptAnswer && !!comment?.id && !comment?.isAcceptedAnswer;
  }

  acceptAnswer(comment: any) {
    if (!this.canAccept(comment)) return;
    this.acceptingId = comment.id;
    this.api.post<any>(`/api/v1/forum/posts/${this.postId}/comments/${comment.id}/accept`, {}).subscribe({
      next: (r: any) => {
        this.message = r?.message || 'Đã đánh dấu câu trả lời đúng';
        this.acceptingId = null;
        const root = comment.rootAnswerId || this.findRootAnswerId(comment.id) || comment.id;
        this.expandedReplyThreads.add(root);
        this.load();
      },
      error: (e: any) => {
        this.acceptingId = null;
        alert(e?.error?.message || 'Không đánh dấu được câu trả lời đúng');
      }
    });
  }

  clearAcceptedAnswer() {
    if (!this.post?.canAcceptAnswer || !this.post?.acceptedCommentId) return;
    this.api.delete<any>(`/api/v1/forum/posts/${this.postId}/accepted-answer`).subscribe({
      next: (r: any) => {
        this.message = r?.message || 'Đã bỏ đánh dấu câu trả lời đúng';
        this.load();
      },
      error: (e: any) => alert(e?.error?.message || 'Không bỏ đánh dấu được')
    });
  }

  openReport(type: string, id: number) {
    this.reportTarget = { targetType: type, targetId: id };
    this.reportReason = '';
  }

  sendReport() {
    if (!this.reportTarget || !this.reportReason.trim()) {
      alert('Nhập lý do report');
      return;
    }

    this.api.post<any>('/api/v1/forum/reports', {
      ...this.reportTarget,
      reason: this.reportReason.trim()
    }).subscribe({
      next: () => {
        this.message = 'Đã gửi report cho Moderator/Admin';
        this.reportTarget = null;
      },
      error: (e: any) => alert(e?.error?.message || 'Report thất bại')
    });
  }

  isImage(attachment: any) {
    return attachment?.isImage || (attachment?.mimeType || '').startsWith('image/');
  }

  fileViewUrl(attachment: any) {
    const id = attachment?.fileId || attachment?.id;
    if (id) return `${this.api.baseUrl}/api/v1/files/${id}/view`;
    const url = attachment?.fileUrl || '';
    return url.startsWith('/') ? `${this.api.baseUrl}${url}` : url;
  }

  date(value: any) {
    return value ? new Date(value).toLocaleString('vi-VN') : '';
  }

  replyIndent(comment: any) {
    return Math.min(Math.max(Number(comment?.replyDepth || 1) - 1, 0), 2) * 14;
  }

  getVisibleReplies(answer: any): any[] {
    const replies = Array.isArray(answer?.threadReplies) ? answer.threadReplies : [];
    if (this.isReplyThreadExpanded(answer) || replies.length <= this.visibleReplyLimit) return replies;

    const accepted = replies.filter((r: any) => r.isAcceptedAnswer);
    const others = replies.filter((r: any) => !r.isAcceptedAnswer);
    return [...accepted, ...others].slice(0, this.visibleReplyLimit);
  }

  hiddenRepliesCount(answer: any): number {
    const replies = Array.isArray(answer?.threadReplies) ? answer.threadReplies : [];
    if (this.isReplyThreadExpanded(answer)) return 0;
    return Math.max(replies.length - this.getVisibleReplies(answer).length, 0);
  }

  isReplyThreadExpanded(answer: any): boolean {
    return this.expandedReplyThreads.has(Number(answer?.id || 0));
  }

  toggleReplyThread(answer: any) {
    const id = Number(answer?.id || 0);
    if (!id) return;
    if (this.expandedReplyThreads.has(id)) this.expandedReplyThreads.delete(id);
    else this.expandedReplyThreads.add(id);
    this.expandedReplyThreads = new Set(this.expandedReplyThreads);
  }

  showMoreAnswers() {
    this.showAllAnswers = true;
  }

  collapseAnswers() {
    this.showAllAnswers = false;
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  trackByComment(_: number, comment: any) {
    return comment.id;
  }
}

