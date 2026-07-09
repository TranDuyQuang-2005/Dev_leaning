import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
@Injectable({providedIn:'root'})
export class ApiService{readonly baseUrl='http://localhost:5000';constructor(private http:HttpClient){}get<T>(e:string){return this.http.get<T>(`${this.baseUrl}${e}`)}post<T>(e:string,b:unknown){return this.http.post<T>(`${this.baseUrl}${e}`,b)}put<T>(e:string,b:unknown){return this.http.put<T>(`${this.baseUrl}${e}`,b)}upload<T>(e:string,f:FormData){return this.http.post<T>(`${this.baseUrl}${e}`,f)}delete<T>(e:string){return this.http.delete<T>(`${this.baseUrl}${e}`)}}
