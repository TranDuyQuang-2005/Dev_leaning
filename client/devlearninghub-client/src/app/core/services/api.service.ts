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
}
