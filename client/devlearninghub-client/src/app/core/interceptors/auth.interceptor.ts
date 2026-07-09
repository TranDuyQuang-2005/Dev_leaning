import { HttpErrorResponse, HttpInterceptorFn } from '@angular/common/http';
import { catchError, throwError } from 'rxjs';

export const authInterceptor: HttpInterceptorFn = (req, next) => {
  const token = localStorage.getItem('accessToken');
  const authReq = token
    ? req.clone({ setHeaders: { Authorization: `Bearer ${token}` } })
    : req;

  return next(authReq).pipe(
    catchError((error: HttpErrorResponse) => {
      const isAuthRequest =
        req.url.includes('/api/v1/auth/login') ||
        req.url.includes('/api/v1/auth/register') ||
        req.url.includes('/api/v1/auth/refresh-token') ||
        req.url.includes('/api/v1/auth/logout');

      if (error.status === 401 && !isAuthRequest) {
        localStorage.removeItem('accessToken');
        localStorage.removeItem('refreshToken');
        localStorage.removeItem('currentUser');

        if (!window.location.pathname.includes('/login')) {
          window.location.href = '/login';
        }
      }

      return throwError(() => error);
    })
  );
};
