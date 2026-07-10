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
import { RoadmapTrackComponent } from './features/roadmap-track.component';
import { CourseDetailComponent } from './features/course-detail.component';
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
import { ForgotPasswordComponent } from './features/forgot-password.component';
import { ResetPasswordComponent } from './features/reset-password.component';
import { VerifyEmailComponent } from './features/verify-email.component';
import { ResendVerificationComponent } from './features/resend-verification.component';
import { SubmissionDetailComponent } from './features/submission-detail.component';
import { SubmissionsComponent } from './features/submissions.component';
import { PersonalPracticeComponent } from './features/personal-practice/personal-practice.component';
import { PersonalPracticeDetailComponent } from './features/personal-practice/personal-practice-detail.component';
import { PersonalPracticeAttemptComponent } from './features/personal-practice/personal-practice-attempt.component';
import { PersonalPracticeHistoryComponent } from './features/personal-practice/personal-practice-history.component';
import { PersonalPracticeResultComponent } from './features/personal-practice/personal-practice-result.component';
import { authGuard } from './core/guards/auth.guard'; import { SsoLoginComponent } from './features/sso-login.component';
export const routes: Routes = [
 { path: '', component: LandingComponent },
 { path: 'login', component: LoginComponent },
 { path: 'register', component: RegisterComponent }, { path: 'sso-login', component: SsoLoginComponent },
 { path: 'forgot-password', component: ForgotPasswordComponent },
 { path: 'reset-password', component: ResetPasswordComponent },
 { path: 'verify-email', component: VerifyEmailComponent },
 { path: 'resend-verification', component: ResendVerificationComponent },
 { path: 'practice-banks', redirectTo: 'learner/practice-banks', pathMatch: 'full' },
 { path: 'practice-banks/:id', redirectTo: 'learner/practice-banks/:id' },
 { path: 'practice-attempts', redirectTo: 'learner/practice-attempts', pathMatch: 'full' },
 { path: 'practice-attempts/:attemptId', redirectTo: 'learner/practice-attempts/:attemptId' },
 { path: 'submissions/:submissionId', redirectTo: 'learner/submissions/:submissionId' },
 { path: 'learner', component: LayoutComponent, canActivate:[authGuard], children:[
  { path:'', redirectTo:'dashboard', pathMatch:'full' },
  { path:'dashboard', component:DashboardComponent, data:{title:'Dashboard',subtitle:'Dev-Learning Hub workspace'} },
  { path:'learning', component:LearningComponent, data:{title:'Learning',subtitle:'Choose a topic and start practicing'} },
  { path:'practice-banks', component:PersonalPracticeComponent, data:{title:'Tự luyện',subtitle:'Upload file câu hỏi cá nhân và luyện tập'} },
  { path:'practice-banks/:id', component:PersonalPracticeDetailComponent, data:{title:'Tự luyện',subtitle:'Cấu hình lượt luyện tập'} },
  { path:'practice-attempts', component:PersonalPracticeHistoryComponent, data:{title:'Lịch sử tự luyện',subtitle:'Review your personal practice attempts'} },
  { path:'practice-attempts/:attemptId', component:PersonalPracticeAttemptComponent, data:{title:'Làm bài tự luyện',subtitle:'Answer questions from your personal bank'} },
  { path:'practice-attempts/:attemptId/result', component:PersonalPracticeResultComponent, data:{title:'Kết quả tự luyện',subtitle:'Review answers and explanations'} },
  { path:'quiz-history', component:QuizHistoryComponent, data:{title:'Quiz History',subtitle:'Review your quiz attempts'} },
  { path:'quiz/:id', component:QuizComponent, data:{title:'Quiz',subtitle:'JavaScript practice test'} },
  { path:'profile', component:ProfileComponent, data:{title:'Profile',subtitle:'Your learning profile'} },
  { path:'roadmap', component:RoadmapComponent, data:{title:'Roadmap',subtitle:'Your guided learning path'} },
  { path:'roadmaps/:slug', component:RoadmapTrackComponent, data:{title:'Roadmap',subtitle:'Track detail'} },
  { path:'courses/:slug', component:CourseDetailComponent, data:{title:'Course',subtitle:'Course detail'} },
  { path:'forum', component:ForumComponent, data:{title:'Forum',subtitle:'Community discussions'} },
  { path:'forum-post/:id', component:ForumPostComponent, data:{title:'Forum',subtitle:'Community discussions'} },
  { path:'forum-post', component:ForumComponent, data:{title:'Forum',subtitle:'Community discussions'} },
  { path:'create-post', component:CreatePostComponent, data:{title:'Forum',subtitle:'Create a new discussion'} },
  { path:'edit-post/:id', component:CreatePostComponent, data:{title:'Forum',subtitle:'Edit discussion'} },
  { path:'playground', component:PlaygroundComponent, data:{title:'Playground',subtitle:'Write and run code online'} },
  { path:'problems', component:ProblemsComponent, data:{title:'Problems',subtitle:'Coding challenge library'} },
  { path:'problems/:id', component:ProblemDetailComponent, data:{title:'Problems',subtitle:'Coding challenge detail'} },
  { path:'problem-detail', component:ProblemDetailComponent, data:{title:'Problems',subtitle:'Coding challenge detail'} },
  { path:'submissions', component:SubmissionsComponent, data:{title:'Bài nộp của tôi',subtitle:'Lịch sử Code Problems'} },
  { path:'submissions/:submissionId', component:SubmissionDetailComponent, data:{title:'Submission Detail',subtitle:'Code submission verdict and testcase results'} },
  { path:'leaderboard', component:LeaderboardComponent, data:{title:'Leaderboard',subtitle:'Top learners'} },
  { path:'notifications', component:NotificationsComponent, data:{title:'Notifications',subtitle:'System messages'} },
  { path:'quiz-result/:attemptId', component:QuizResultComponent, data:{title:'Quiz Result',subtitle:'Your result'} },
  { path:'quiz-result', component:QuizResultComponent, data:{title:'Quiz Result',subtitle:'Your result'} }
 ]},
 { path:'**', redirectTo:'' }
];

