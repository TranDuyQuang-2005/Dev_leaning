import { Routes } from '@angular/router';
import { LandingComponent } from './features/landing.component';
import { LoginComponent } from './features/login.component';
import { RegisterComponent } from './features/register.component';
import { LayoutComponent } from './features/layout.component';
import { DashboardComponent } from './features/dashboard.component';
import { LearningComponent } from './features/learning.component';
import { QuizComponent } from './features/quiz.component';
import { ProfileComponent } from './features/profile.component';
import { RoadmapComponent } from './features/roadmap.component';
import { ForumComponent } from './features/forum.component';
import { ForumPostComponent } from './features/forum-post.component';
import { CreatePostComponent } from './features/create-post.component';
import { PlaygroundComponent } from './features/playground.component';
import { ProblemsComponent } from './features/problems.component';
import { ProblemDetailComponent } from './features/problem-detail.component';
import { LeaderboardComponent } from './features/leaderboard.component';
import { NotificationsComponent } from './features/notifications.component';
import { QuizResultComponent } from './features/quiz-result.component';
import { QuizHistoryComponent } from './features/quiz-history.component';
import { authGuard } from './core/guards/auth.guard';
export const routes: Routes = [
 { path: '', component: LandingComponent },
 { path: 'login', component: LoginComponent },
 { path: 'register', component: RegisterComponent },
 { path: 'learner', component: LayoutComponent, canActivate:[authGuard], children:[
  { path:'', redirectTo:'dashboard', pathMatch:'full' },
  { path:'dashboard', component:DashboardComponent, data:{title:'Dashboard',subtitle:'Dev-Learning Hub workspace'} },
  { path:'learning', component:LearningComponent, data:{title:'Learning',subtitle:'Choose a topic and start practicing'} },
  { path:'quiz-history', component:QuizHistoryComponent, data:{title:'Quiz History',subtitle:'Review your quiz attempts'} },
  { path:'quiz/:id', component:QuizComponent, data:{title:'Quiz',subtitle:'JavaScript practice test'} },
  { path:'profile', component:ProfileComponent, data:{title:'Profile',subtitle:'Your learning profile'} },
  { path:'roadmap', component:RoadmapComponent, data:{title:'Roadmap',subtitle:'Your guided learning path'} },
  { path:'forum', component:ForumComponent, data:{title:'Forum',subtitle:'Community discussions'} },
  { path:'forum-post/:id', component:ForumPostComponent, data:{title:'Forum',subtitle:'Community discussions'} },
  { path:'forum-post', component:ForumComponent, data:{title:'Forum',subtitle:'Community discussions'} },
  { path:'create-post', component:CreatePostComponent, data:{title:'Forum',subtitle:'Create a new discussion'} },
  { path:'edit-post/:id', component:CreatePostComponent, data:{title:'Forum',subtitle:'Edit discussion'} },
  { path:'playground', component:PlaygroundComponent, data:{title:'Playground',subtitle:'Write and run code online'} },
  { path:'problems', component:ProblemsComponent, data:{title:'Problems',subtitle:'Coding challenge library'} },
  { path:'problems/:id', component:ProblemDetailComponent, data:{title:'Problems',subtitle:'Coding challenge detail'} },
  { path:'problem-detail', component:ProblemDetailComponent, data:{title:'Problems',subtitle:'Coding challenge detail'} },
  { path:'leaderboard', component:LeaderboardComponent, data:{title:'Leaderboard',subtitle:'Top learners'} },
  { path:'notifications', component:NotificationsComponent, data:{title:'Notifications',subtitle:'System messages'} },
  { path:'quiz-result/:attemptId', component:QuizResultComponent, data:{title:'Quiz Result',subtitle:'Your result'} },
  { path:'quiz-result', component:QuizResultComponent, data:{title:'Quiz Result',subtitle:'Your result'} }
 ]},
 { path:'**', redirectTo:'' }
];
