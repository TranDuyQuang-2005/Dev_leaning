import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../core/services/auth.service';
@Component({selector:'app-login',standalone:true,imports:[CommonModule,FormsModule,RouterLink],templateUrl:'./login.component.html'})
export class LoginComponent{model={emailOrUserName:'admin@example.com',password:'123456Aa'};loading=false;errorMessage='';constructor(private auth:AuthService,private router:Router){}onSubmit(){this.errorMessage='';this.loading=true;this.auth.login(this.model.emailOrUserName,this.model.password).subscribe({next:(r:any)=>{this.loading=false;const roles=r?.data?.user?.roles||[];if(roles.includes('Admin')){window.location.href='http://localhost:4300/dashboard';return;}this.router.navigate(['/learner/dashboard']);},error:e=>{this.loading=false;this.errorMessage=e?.error?.message||'Đăng nhập thất bại. Kiểm tra API, database hoặc tài khoản.';}})}}
