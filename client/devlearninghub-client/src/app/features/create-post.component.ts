import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { ApiService } from '../core/services/api.service';

@Component({selector:'app-create-post',standalone:true,imports:[CommonModule,FormsModule,RouterLink],templateUrl:'./create-post.component.html'})
export class CreatePostComponent implements OnInit{
  postId:number|null=null;
  form:any={title:'',content:'',tags:[],attachmentIds:[]};
  tagInput='';
  suggested=['Angular','C#','SQL','Flutter','API','JWT','Database','DevOps'];
  attachments:any[]=[];
  uploading=false;
  error='';
  loading=false;
  constructor(private api:ApiService,private route:ActivatedRoute,private router:Router){}
  ngOnInit(){
    const id=this.route.snapshot.paramMap.get('id');
    if(id){
      this.postId=Number(id);
      this.api.get<any>(`/api/v1/forum/posts/${this.postId}`).subscribe({
        next:r=>{const p=r.data;this.attachments=p.attachments||[];this.form={title:p.title,content:p.content,tags:(p.tags||[]).map((x:any)=>x.name),attachmentIds:this.attachments.map((x:any)=>x.fileId)};},
        error:e=>this.error=e?.error?.message||'Không tải được bài viết'
      });
    }
  }
  addTag(tag?:string){const value=(tag||this.tagInput||'').trim();if(!value)return;if(!this.form.tags.some((x:string)=>x.toLowerCase()===value.toLowerCase())&&this.form.tags.length<5)this.form.tags.push(value);this.tagInput='';}
  removeTag(tag:string){this.form.tags=this.form.tags.filter((x:string)=>x!==tag);}
  onFilesSelected(event:any){
    const files:FileList=event.target.files;
    if(!files||!files.length)return;
    if(this.attachments.length+files.length>5){this.error='Tối đa 5 file/hình cho mỗi bài viết';event.target.value='';return;}
    this.error='';this.uploading=true;
    let done=0;
    Array.from(files).forEach(file=>{
      const formData=new FormData();
      formData.append('file',file);
      this.api.upload<any>('/api/v1/forum/uploads',formData).subscribe({
        next:r=>{const a=r.data;this.attachments.push(a);this.form.attachmentIds=this.attachments.map(x=>x.fileId);},
        error:e=>{this.error=e?.error?.message||`Upload thất bại: ${file.name}`;},
        complete:()=>{done++;if(done===files.length){this.uploading=false;event.target.value='';}}
      });
    });
  }
  removeAttachment(a:any){this.attachments=this.attachments.filter(x=>x.fileId!==a.fileId);this.form.attachmentIds=this.attachments.map(x=>x.fileId);}
  isImage(a:any){return a?.isImage || (a?.mimeType||'').startsWith('image/');}
  fileViewUrl(a:any){const id=a?.fileId||a?.id; if(id) return `${this.api.baseUrl}/api/v1/files/${id}/view`; const u=a?.fileUrl||''; return u.startsWith('/')?`${this.api.baseUrl}${u}`:u;}
  save(){
    this.error='';
    if(!this.form.title||this.form.title.trim().length<10){this.error='Tiêu đề phải từ 10 ký tự';return;}
    if(!this.form.content||this.form.content.trim().length<20){this.error='Nội dung phải từ 20 ký tự';return;}
    if(!this.form.tags.length){this.error='Cần ít nhất 1 tag';return;}
    this.form.attachmentIds=this.attachments.map(x=>x.fileId);
    this.loading=true;
    const req=this.postId?this.api.put<any>(`/api/v1/forum/posts/${this.postId}`,this.form):this.api.post<any>('/api/v1/forum/posts',this.form);
    req.subscribe({next:r=>{this.loading=false;this.router.navigate(['/learner/forum-post',r.data.id]);},error:e=>{this.loading=false;this.error=e?.error?.message||'Không lưu được bài viết';}})
  }
}
