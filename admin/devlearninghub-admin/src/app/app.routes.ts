import { Routes } from '@angular/router';
import { LoginComponent } from './features/login.component';
import { DashboardComponent } from './features/dashboard.component';
import { ForumManagementComponent } from './features/forum-management.component';
import { CodeManagementComponent } from './features/code-management.component';
import { adminGuard, permissionGuard, staffGuard } from './core/guards/auth.guard';
export const routes: Routes = [
  { path: '', component: LoginComponent },
  { path: 'login', component: LoginComponent },
  { path: 'dashboard', component: DashboardComponent, canActivate:[adminGuard] },
  { path: 'forum', component: ForumManagementComponent, canActivate:[staffGuard, permissionGuard], data: { permissions: ['forum.moderate'] } },
  { path: 'code', component: CodeManagementComponent, canActivate:[permissionGuard], data: { permissions: ['code.manage'] } },
  { path: 'users', redirectTo:'dashboard' },
  { path: 'categories', redirectTo:'dashboard' },
  { path: 'questions', redirectTo:'dashboard' },
  { path: 'quiz-sets', redirectTo:'dashboard' },
  { path: 'import', redirectTo:'dashboard' },
  { path: '**', redirectTo:'' }
];
