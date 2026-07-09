import { Component,OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { AuthService } from '../core/services/auth.service';
import { ApiService } from '../core/services/api.service';
@Component({selector:'app-dashboard',standalone:true,imports:[CommonModule,RouterLink],templateUrl:'./dashboard.component.html'})
export class DashboardComponent implements OnInit{stats:any={};attempts:any[]=[];constructor(public auth:AuthService,private api:ApiService){}get firstName(){return (this.auth.currentUser()?.fullName||'John').split(' ')[0]}ngOnInit(){this.api.get<any>('/api/v1/users/me/stats').subscribe({next:r=>this.stats=r.data||{},error:()=>this.stats={}});this.api.get<any>('/api/v1/quiz-attempts/me').subscribe({next:r=>this.attempts=r.data||[],error:()=>this.attempts=[]})}}
