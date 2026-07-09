import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { ApiService } from '../core/services/api.service';
import { AuthService } from '../core/services/auth.service';

@Component({selector:'app-forum-management',standalone:true,imports:[CommonModule,FormsModule,RouterLink],templateUrl:'./forum-management.component.html'})
export class ForumManagementComponent implements OnInit{
  tab='posts'; posts:any[]=[]; comments:any[]=[]; reports:any[]=[]; tags:any[]=[]; keyword=''; postStatus:any=''; commentStatus:any=''; reportStatus:any=''; message=''; error=''; tagForm:any={name:'',slug:'',description:''}; editingTagId:number|null=null;
  constructor(private api:ApiService,public auth:AuthService){}
  get isAdmin(){return this.auth.hasRole('Admin');}
  get apiRoot(){return this.isAdmin?'/api/v1/admin/forum':'/api/v1/moderator/forum';}
  ngOnInit(){this.loadAll();}
  loadAll(){this.loadPosts();this.loadComments();this.loadReports();this.loadTags();}
  loadPosts(){const q=`?pageSize=100${this.keyword?`&keyword=${encodeURIComponent(this.keyword)}`:''}${this.postStatus!==''?`&status=${this.postStatus}`:''}`;this.api.get<any>(this.apiRoot+'/posts'+q).subscribe({next:r=>this.posts=r.data?.items||[],error:e=>this.error=e?.error?.message||'Không tải được posts'});}
  loadComments(){const q=`?pageSize=100${this.keyword?`&keyword=${encodeURIComponent(this.keyword)}`:''}${this.commentStatus!==''?`&status=${this.commentStatus}`:''}`;this.api.get<any>(this.apiRoot+'/comments'+q).subscribe({next:r=>this.comments=r.data?.items||[]});}
  loadReports(){const q=`?pageSize=100${this.reportStatus!==''?`&status=${this.reportStatus}`:''}`;this.api.get<any>(this.apiRoot+'/reports'+q).subscribe({next:r=>this.reports=r.data?.items||[]});}
  loadTags(){this.api.get<any>(this.apiRoot+'/tags').subscribe({next:r=>this.tags=r.data||[]});}
  statusText(s:any){return Number(s)===1?'Visible/Active':Number(s)===0?'Hidden':'Resolved/Rejected';}
  date(v:any){return v?new Date(v).toLocaleString('vi-VN'):'';}
  hidePost(p:any){const reason=prompt('Lý do ẩn bài viết?')||'';this.api.put<any>(`${this.apiRoot}/posts/${p.id}/hide`,{reason}).subscribe({next:()=>{this.message='Đã ẩn bài viết';this.loadAll();},error:e=>alert(e?.error?.message||'Không ẩn được bài')});}
  restorePost(p:any){const reason=prompt('Lý do khôi phục?')||'';this.api.put<any>(`${this.apiRoot}/posts/${p.id}/restore`,{reason}).subscribe({next:()=>{this.message='Đã khôi phục bài viết';this.loadAll();}});}
  deletePost(p:any){if(!confirm('Xóa bài viết này?'))return;this.api.delete<any>(`${this.apiRoot}/posts/${p.id}`).subscribe({next:()=>{this.message='Đã xóa bài viết';this.loadAll();}});}
  hideComment(c:any){const reason=prompt('Lý do ẩn bình luận?')||'';this.api.put<any>(`${this.apiRoot}/comments/${c.id}/hide`,{reason}).subscribe({next:()=>{this.message='Đã ẩn bình luận';this.loadAll();}});}
  deleteComment(c:any){if(!confirm('Xóa bình luận này?'))return;this.api.delete<any>(`${this.apiRoot}/comments/${c.id}`).subscribe({next:()=>{this.message='Đã xóa bình luận';this.loadAll();}});}
  resolveReport(r:any,hideTarget:boolean,status=2){const reason=prompt('Ghi chú xử lý report?')||'';this.api.put<any>(`${this.apiRoot}/reports/${r.id}/resolve`,{status,reason,hideTarget}).subscribe({next:()=>{this.message='Đã xử lý report';this.loadAll();},error:e=>alert(e?.error?.message||'Không xử lý được report')});}
  slugify(s:string){return(s||'').toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g,'').replace(/đ/g,'d').replace(/[^a-z0-9]+/g,'-').replace(/^-|-$/g,'');}
  autoSlug(){if(!this.tagForm.slug)this.tagForm.slug=this.slugify(this.tagForm.name);}
  saveTag(){this.error='';if(!this.tagForm.name||this.tagForm.name.trim().length<2){this.error='Tên tag phải từ 2 ký tự';return;}if(!this.tagForm.slug)this.tagForm.slug=this.slugify(this.tagForm.name);const req=this.editingTagId?this.api.put<any>(`/api/v1/admin/forum/tags/${this.editingTagId}`,this.tagForm):this.api.post<any>('/api/v1/admin/forum/tags',this.tagForm);req.subscribe({next:()=>{this.message='Đã lưu tag';this.cancelTag();this.loadTags();},error:e=>this.error=e?.error?.message||'Không lưu được tag'});}
  editTag(t:any){this.editingTagId=t.id;this.tagForm={name:t.name,slug:t.slug,description:t.description||''};}
  cancelTag(){this.editingTagId=null;this.tagForm={name:'',slug:'',description:''};}
  deleteTag(t:any){if(!confirm(`Xóa tag ${t.name}?`))return;this.api.delete<any>(`/api/v1/admin/forum/tags/${t.id}`).subscribe({next:()=>{this.message='Đã xóa tag';this.loadTags();},error:e=>alert(e?.error?.message||'Không xóa được tag')});}
}
