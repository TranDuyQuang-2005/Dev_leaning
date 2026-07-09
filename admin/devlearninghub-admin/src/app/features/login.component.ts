import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from '../core/services/auth.service';

@Component({selector:'app-login',standalone:true,imports:[CommonModule,FormsModule],templateUrl:'./login.component.html'})
export class LoginComponent{
  emailOrUserName='admin@example.com';
  password='123456Aa';
  error='';
  loading=false;
  constructor(private auth:AuthService,private router:Router){}
  submit(){
    this.error='';this.loading=true;
    this.auth.login(this.emailOrUserName,this.password).subscribe({
      next:r=>{
        this.loading=false;
        const roles=r.data.user.roles||[];
        if(roles.includes('Admin')) this.router.navigate(['/dashboard']);
        else if(roles.includes('Moderator')) this.router.navigate(['/forum']);
        else this.error='Tài khoản này không có quyền Admin/Moderator';
      },
      error:e=>{this.loading=false;this.error=e?.error?.message||'Đăng nhập thất bại'}
    })
  }
}
