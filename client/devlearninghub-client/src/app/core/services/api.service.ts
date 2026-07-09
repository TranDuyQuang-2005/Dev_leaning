import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface ApiResponse<T = any> {
  success?: boolean;
  message?: string;
  data: T;
  errors?: any;
  statusCode?: number;
}

type ApiHttpOptions = {
  headers?: HttpHeaders | { [header: string]: string | string[] };
  params?: HttpParams | { [param: string]: string | number | boolean | ReadonlyArray<string | number | boolean> };
  withCredentials?: boolean;
  responseType?: 'json';
};

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  public readonly baseUrl = 'http://localhost:5000';

  constructor(private http: HttpClient) {}

  private url(endpoint: string): string {
    if (!endpoint) return this.baseUrl;
    if (/^https?:\/\//i.test(endpoint)) return endpoint;

    const path = endpoint.startsWith('/') ? endpoint : `/${endpoint}`;
    return `${this.baseUrl}${path}`;
  }

  get<T = any>(endpoint: string, options?: ApiHttpOptions): Observable<ApiResponse<T>> {
    return this.http.get<ApiResponse<T>>(this.url(endpoint), options as any) as unknown as Observable<ApiResponse<T>>;
  }

  post<T = any>(endpoint: string, body?: any, options?: ApiHttpOptions): Observable<ApiResponse<T>> {
    return this.http.post<ApiResponse<T>>(this.url(endpoint), body ?? {}, options as any) as unknown as Observable<ApiResponse<T>>;
  }

  put<T = any>(endpoint: string, body?: any, options?: ApiHttpOptions): Observable<ApiResponse<T>> {
    return this.http.put<ApiResponse<T>>(this.url(endpoint), body ?? {}, options as any) as unknown as Observable<ApiResponse<T>>;
  }

  patch<T = any>(endpoint: string, body?: any, options?: ApiHttpOptions): Observable<ApiResponse<T>> {
    return this.http.patch<ApiResponse<T>>(this.url(endpoint), body ?? {}, options as any) as unknown as Observable<ApiResponse<T>>;
  }

  delete<T = any>(endpoint: string, options?: ApiHttpOptions): Observable<ApiResponse<T>> {
    return this.http.delete<ApiResponse<T>>(this.url(endpoint), options as any) as unknown as Observable<ApiResponse<T>>;
  }

  upload<T = any>(endpoint: string, formData: FormData, options?: ApiHttpOptions): Observable<ApiResponse<T>> {
    return this.http.post<ApiResponse<T>>(this.url(endpoint), formData, options as any) as unknown as Observable<ApiResponse<T>>;
  }

  download(endpoint: string, options?: any): Observable<Blob> {
    return this.http.get(this.url(endpoint), { ...(options || {}), responseType: 'blob' as const }) as unknown as Observable<Blob>;
  }

  rawGet<T = any>(endpoint: string, options?: any): Observable<T> {
    return this.http.get<T>(this.url(endpoint), options as any) as unknown as Observable<T>;
  }

  rawPost<T = any>(endpoint: string, body?: any, options?: any): Observable<T> {
    return this.http.post<T>(this.url(endpoint), body ?? {}, options as any) as unknown as Observable<T>;
  }

  toAbsoluteUrl(value?: string | null): string {
    if (!value) return '';
    if (/^https?:\/\//i.test(value)) return value;
    return value.startsWith('/') ? `${this.baseUrl}${value}` : `${this.baseUrl}/${value}`;
  }

  errorMessage(error: any, fallback = 'Không thể hoàn tất thao tác.'): string {
    if (error?.status === 429) return 'Bạn thao tác quá nhanh. Vui lòng thử lại sau.';
    if (error?.status === 403) return 'Bạn không có quyền thực hiện thao tác này.';

    const payload = error?.error || error;
    const main = payload?.message || fallback;
    const details = Array.isArray(payload?.errors)
      ? payload.errors.map((item: any) => {
          const field = item?.field ? `${item.field}: ` : '';
          return `${field}${item?.message || item}`;
        })
      : [];

    return [main, ...details].filter(Boolean).join('\n');
  }

  getPracticeBanks() { return this.get<any[]>('/api/v1/me/practice-banks'); }
  uploadPracticeBank(formData: FormData) { return this.upload<any>('/api/v1/me/practice-banks/upload', formData); }
  getPracticeBank(id: number | string) { return this.get<any>(`/api/v1/me/practice-banks/${id}`); }
  deletePracticeBank(id: number | string) { return this.delete<any>(`/api/v1/me/practice-banks/${id}`); }
  startPracticeAttempt(bankId: number | string, body: any) { return this.post<any>(`/api/v1/me/practice-banks/${bankId}/attempts`, body); }
  getPracticeAttempts() { return this.get<any[]>('/api/v1/me/practice-attempts'); }
  getPracticeAttempt(id: number | string) { return this.get<any>(`/api/v1/me/practice-attempts/${id}`); }
  submitPracticeAttempt(id: number | string, body: any) { return this.post<any>(`/api/v1/me/practice-attempts/${id}/submit`, body); }

  forgotPassword(body: any) { return this.post<any>('/api/v1/auth/forgot-password', body); }
  resetPassword(body: any) { return this.post<any>('/api/v1/auth/reset-password', body); }
  verifyEmail(body: any) { return this.post<any>('/api/v1/auth/verify-email', body); }
  resendEmailVerification(body: any) { return this.post<any>('/api/v1/auth/resend-email-verification', body); }
  changePassword(body: any) { return this.put<any>('/api/v1/auth/change-password', body); }

  getSubmissionDetail(id: number | string) { return this.get<any>(`/api/v1/code/submissions/${id}`); }
}
