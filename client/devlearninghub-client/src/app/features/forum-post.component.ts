import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { ApiService } from '../core/services/api.service';

@Component({selector:'app-forum-post',standalone:true,imports:[CommonModule,FormsModule,RouterLink],templateUrl:'./forum-post.component.html'})
export class ForumPostComponent implements OnInit{
  post:any; postId=0; answer=''; replyTo:number|null=null; replyContent=''; reportReason=''; reportTarget:any=null; error=''; message=''; acceptingId:number|null=null;
  constructor(private api:ApiService,private route:ActivatedRoute,private router:Router){}
  ngOnInit(){this.postId=Number(this.route.snapshot.paramMap.get('id')||0);if(!this.postId)this.router.navigate(['/learner/forum']);else this.load();}
  load(){this.api.get<any>(`/api/v1/forum/posts/${this.postId}`).subscribe({next:r=>this.post=r.data,error:e=>this.error=e?.error?.message||'Không tải được bài viết'});}
  votePost(voteType:number){this.api.post<any>(`/api/v1/forum/posts/${this.postId}/vote`,{voteType}).subscribe({next:()=>this.load(),error:e=>alert(e?.error?.message||'Vote thất bại')});}
  voteComment(c:any,voteType:number){this.api.post<any>(`/api/v1/forum/comments/${c.id}/vote`,{voteType}).subscribe({next:()=>this.load(),error:e=>alert(e?.error?.message||'Vote thất bại')});}
  bookmark(){const req=this.post?.isBookmarked?this.api.delete<any>(`/api/v1/forum/posts/${this.postId}/bookmark`):this.api.post<any>(`/api/v1/forum/posts/${this.postId}/bookmark`,{});req.subscribe({next:()=>this.load()});}
  addComment(parentId?:number){const content=parentId?this.replyContent:this.answer;if(!content||content.trim().length<2){alert('Bình luận phải có ít nhất 2 ký tự');return;}this.api.post<any>(`/api/v1/forum/posts/${this.postId}/comments`,{content,parentCommentId:parentId||null}).subscribe({next:()=>{this.answer='';this.replyContent='';this.replyTo=null;this.load();},error:e=>alert(e?.error?.message||'Bình luận thất bại')});}
  deletePost(){if(!confirm('Xóa bài viết này?'))return;this.api.delete<any>(`/api/v1/forum/posts/${this.postId}`).subscribe({next:()=>this.router.navigate(['/learner/forum']),error:e=>alert(e?.error?.message||'Không xóa được bài')});}
  deleteComment(c:any){if(!confirm('Xóa bình luận này?'))return;this.api.delete<any>(`/api/v1/forum/comments/${c.id}`).subscribe({next:()=>this.load(),error:e=>alert(e?.error?.message||'Không xóa được bình luận')});}
  acceptAnswer(c:any){if(!this.post?.canAcceptAnswer||c?.isAcceptedAnswer)return;this.acceptingId=c.id;this.api.post<any>(`/api/v1/forum/posts/${this.postId}/comments/${c.id}/accept`,{}).subscribe({next:r=>{this.message=r?.message||'Đã đánh dấu câu trả lời đúng';this.acceptingId=null;this.load();},error:e=>{this.acceptingId=null;alert(e?.error?.message||'Không đánh dấu được câu trả lời đúng');}});}
  clearAcceptedAnswer(){if(!this.post?.canAcceptAnswer||!this.post?.acceptedCommentId)return;this.api.delete<any>(`/api/v1/forum/posts/${this.postId}/accepted-answer`).subscribe({next:r=>{this.message=r?.message||'Đã bỏ đánh dấu câu trả lời đúng';this.load();},error:e=>alert(e?.error?.message||'Không bỏ đánh dấu được')});}
  openReport(type:string,id:number){this.reportTarget={targetType:type,targetId:id};this.reportReason='';}
  sendReport(){if(!this.reportTarget||!this.reportReason.trim()){alert('Nhập lý do report');return;}this.api.post<any>('/api/v1/forum/reports',{...this.reportTarget,reason:this.reportReason}).subscribe({next:()=>{this.message='Đã gửi report cho Moderator/Admin';this.reportTarget=null;},error:e=>alert(e?.error?.message||'Report thất bại')});}
  isImage(a:any){return a?.isImage || (a?.mimeType||'').startsWith('image/');}
  fileViewUrl(a:any){const id=a?.fileId||a?.id; if(id) return `${this.api.baseUrl}/api/v1/files/${id}/view`; const u=a?.fileUrl||''; return u.startsWith('/')?`${this.api.baseUrl}${u}`:u;}
  date(v:any){return v?new Date(v).toLocaleString('vi-VN'):'';}
}
