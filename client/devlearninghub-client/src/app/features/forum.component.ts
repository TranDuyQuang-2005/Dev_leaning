import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { ApiService } from '../core/services/api.service';

@Component({selector:'app-forum',standalone:true,imports:[CommonModule,FormsModule,RouterLink],templateUrl:'./forum.component.html'})
export class ForumComponent implements OnInit{
  posts:any[]=[]; tags:any[]=[]; keyword=''; tag='all'; loading=false; error=''; pageIndex=1; totalPages=1;
  constructor(private api:ApiService){}
  ngOnInit(){this.loadTags();this.loadPosts();}
  loadTags(){this.api.get<any>('/api/v1/forum/tags').subscribe({next:r=>this.tags=r.data||[]});}
  loadPosts(){this.loading=true;this.error='';const q=`?pageIndex=${this.pageIndex}&pageSize=10${this.keyword?`&keyword=${encodeURIComponent(this.keyword)}`:''}${this.tag&&this.tag!=='all'?`&tag=${encodeURIComponent(this.tag)}`:''}`;this.api.get<any>('/api/v1/forum/posts'+q).subscribe({next:r=>{this.posts=r.data?.items||[];this.totalPages=r.data?.totalPages||1;this.loading=false;},error:e=>{this.error=e?.error?.message||'Không tải được diễn đàn';this.loading=false;}})}
  search(){this.pageIndex=1;this.loadPosts();}
  vote(post:any,voteType:number){this.api.post<any>(`/api/v1/forum/posts/${post.id}/vote`,{voteType}).subscribe({next:()=>this.loadPosts(),error:e=>alert(e?.error?.message||'Vote thất bại')});}
  bookmark(post:any){const req=post.isBookmarked?this.api.delete<any>(`/api/v1/forum/posts/${post.id}/bookmark`):this.api.post<any>(`/api/v1/forum/posts/${post.id}/bookmark`,{});req.subscribe({next:()=>this.loadPosts(),error:e=>alert(e?.error?.message||'Bookmark thất bại')});}
  date(v:any){return v?new Date(v).toLocaleString('vi-VN'):'';}
  initials(p:any){return p.authorInitials||'U';}
  fileViewUrl(url:any){const u=url||''; return u.startsWith('/')?`${this.api.baseUrl}${u}`:u;}
}
