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

@Injectable({ providedIn: 'root' })
export class ApiService {
  readonly baseUrl = 'http://localhost:5000';

  constructor(private http: HttpClient) {}

  private url(endpoint: string): string {
    if (/^https?:\/\//i.test(endpoint)) return endpoint;
    return `${this.baseUrl}${endpoint.startsWith('/') ? endpoint : `/${endpoint}`}`;
  }

  get<T = any>(endpoint: string, options?: ApiHttpOptions): Observable<ApiResponse<T>> {
    return this.http.get<ApiResponse<T>>(this.url(endpoint), options as any) as unknown as Observable<ApiResponse<T>>;
  }

  post<T = any>(endpoint: string, body?: unknown, options?: ApiHttpOptions): Observable<ApiResponse<T>> {
    return this.http.post<ApiResponse<T>>(this.url(endpoint), body ?? {}, options as any) as unknown as Observable<ApiResponse<T>>;
  }

  put<T = any>(endpoint: string, body?: unknown, options?: ApiHttpOptions): Observable<ApiResponse<T>> {
    return this.http.put<ApiResponse<T>>(this.url(endpoint), body ?? {}, options as any) as unknown as Observable<ApiResponse<T>>;
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

  getPermissionGroups() { return this.get<any[]>('/api/v1/admin/permission-groups'); }
  createPermissionGroup(body: any) { return this.post<any>('/api/v1/admin/permission-groups', body); }
  updatePermissionGroup(id: number | string, body: any) { return this.put<any>(`/api/v1/admin/permission-groups/${id}`, body); }
  deletePermissionGroup(id: number | string) { return this.delete<any>(`/api/v1/admin/permission-groups/${id}`); }
  setPermissionGroupPermissions(id: number | string, permissionIds: number[]) { return this.post<any>(`/api/v1/admin/permission-groups/${id}/permissions`, { permissionIds }); }
  assignPermissionGroupsToUser(userId: number | string, permissionGroupIds: number[]) { return this.post<any>(`/api/v1/admin/users/${userId}/permission-groups`, { permissionGroupIds }); }
  assignPermissionGroupsToRole(roleId: number | string, permissionGroupIds: number[]) { return this.post<any>(`/api/v1/admin/roles/${roleId}/permission-groups`, { permissionGroupIds }); }
  getEffectivePermissions(userId: number | string) { return this.get<any>(`/api/v1/admin/users/${userId}/effective-permissions`); }

  lockUser(userId: number | string, body: any) { return this.post<any>(`/api/v1/admin/users/${userId}/lock`, body); }
  unlockUser(userId: number | string) { return this.post<any>(`/api/v1/admin/users/${userId}/unlock`, {}); }
  getAuditLogs(query: any) { return this.get<any>('/api/v1/admin/audit-logs', { params: query }); }

  getQuizStatisticsOverview() { return this.get<any>('/api/v1/admin/quizzes/statistics/overview'); }
  getQuizStatistics(quizSetId: number | string) { return this.get<any>(`/api/v1/admin/quizzes/${quizSetId}/statistics`); }
  exportQuestionsCsv(query?: any) { return this.download('/api/v1/admin/questions/export.csv', { params: query || {} }); }
  exportQuizCsv(quizSetId: number | string) { return this.download(`/api/v1/admin/quizzes/${quizSetId}/export.csv`); }
  resetAttempt(attemptId: number | string) { return this.post<any>(`/api/v1/admin/quiz-attempts/${attemptId}/reset`, {}); }
  resetUserQuizAttempts(quizSetId: number | string, userId: number | string) { return this.post<any>(`/api/v1/admin/quizzes/${quizSetId}/users/${userId}/reset-attempts`, {}); }

  getAdminSubmissionDetail(id: number | string) { return this.get<any>(`/api/v1/admin/code/submissions/${id}`); }
}
