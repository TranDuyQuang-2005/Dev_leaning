import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from '../services/auth.service';
export const authGuard:CanActivateFn=()=>inject(AuthService).isLoggedIn()?true:inject(Router).createUrlTree(['/login']);
export const adminGuard:CanActivateFn=()=>{const a=inject(AuthService);return a.isLoggedIn()&&a.hasRole('Admin')?true:inject(Router).createUrlTree(['/login'])};
