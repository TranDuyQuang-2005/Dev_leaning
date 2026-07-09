import { HttpInterceptorFn } from '@angular/common/http';
export const authInterceptor: HttpInterceptorFn = (req,next)=>{const t=localStorage.getItem('accessToken');return next(t?req.clone({setHeaders:{Authorization:`Bearer ${t}`}}):req)};
