import { HttpErrorResponse, HttpInterceptorFn } from '@angular/common/http';
import { catchError, throwError } from 'rxjs';
export const authInterceptor: HttpInterceptorFn = (req,next)=>{const t=localStorage.getItem('accessToken');const authed=t?req.clone({setHeaders:{Authorization:`Bearer ${t}`}}):req;return next(authed).pipe(catchError(e=>{if(e instanceof HttpErrorResponse&&e.status===401){localStorage.removeItem('accessToken');localStorage.removeItem('refreshToken');localStorage.removeItem('currentUser')}return throwError(()=>e)}))};
