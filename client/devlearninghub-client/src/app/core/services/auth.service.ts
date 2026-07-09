import { Injectable, signal } from '@angular/core';
import { Router } from '@angular/router';
import { tap } from 'rxjs';
import { ApiResponse, AuthResponse, CurrentUser } from '../models/api.models';
import { ApiService } from './api.service';
@Injectable({providedIn:'root'})
export class AuthService{currentUser=signal<CurrentUser|null>(this.stored());constructor(private api:ApiService,private router:Router){}login(emailOrUserName:string,password:string){return this.api.post<ApiResponse<AuthResponse>>('/api/v1/auth/login',{emailOrUserName,password}).pipe(tap(r=>this.save(r.data)))}register(b:any){return this.api.post<ApiResponse<object>>('/api/v1/auth/register',b)}logout(){localStorage.clear();this.currentUser.set(null);this.router.navigate(['/login'])}isLoggedIn(){return !!localStorage.getItem('accessToken')}hasRole(r:string){return this.currentUser()?.roles?.includes(r)||false}private save(d:AuthResponse){localStorage.setItem('accessToken',d.accessToken);localStorage.setItem('refreshToken',d.refreshToken);localStorage.setItem('currentUser',JSON.stringify(d.user));this.currentUser.set(d.user)}private stored(){const r=localStorage.getItem('currentUser');return r?JSON.parse(r):null}}
