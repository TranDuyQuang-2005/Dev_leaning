import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../core/services/auth.service';
@Component({selector:'app-register',standalone:true,imports:[CommonModule,FormsModule,RouterLink],templateUrl:'./register.component.html'})
export class RegisterComponent{firstName='';lastName='';model={fullName:'',userName:'',email:'',password:'',confirmPassword:''};loading=false;errorMessage='';constructor(private auth:AuthService,private router:Router){}onSubmit(){this.errorMessage='';this.model.fullName=`${this.firstName} ${this.lastName}`.trim();if(this.model.password!==this.model.confirmPassword){this.errorMessage='Mật khẩu xác nhận không khớp.';return;}this.loading=true;this.auth.register(this.model).subscribe({next:()=>{this.loading=false;alert('Đăng ký thành công.');this.router.navigate(['/login']);},error:e=>{this.loading=false;this.errorMessage=e?.error?.message||e?.error?.errors?.[0]?.message||'Đăng ký thất bại. Kiểm tra lại dữ liệu hoặc email/userName đã tồn tại.';}})}}
