import { Injectable } from '@angular/core';
import * as signalR from '@microsoft/signalr';
import { BehaviorSubject, Subject } from 'rxjs';
import { ApiService } from './api.service';

export type NotificationRealtimeState = 'disconnected' | 'connecting' | 'connected' | 'reconnecting';

export type RealtimeNotification = {
  id: number;
  userId?: number;
  type: string;
  notificationType?: string;
  title: string;
  content?: string;
  message?: string;
  linkUrl?: string;
  isRead: boolean;
  readAt?: string | null;
  createdAt: string;
  metadataJson?: string | null;
};

@Injectable({ providedIn: 'root' })
export class NotificationRealtimeService {
  private connection?: signalR.HubConnection;
  private starting = false;

  private notificationCreatedSubject = new Subject<RealtimeNotification>();
  private unreadCountChangedSubject = new Subject<number>();
  private connectionStateSubject = new BehaviorSubject<NotificationRealtimeState>('disconnected');

  readonly notificationCreated$ = this.notificationCreatedSubject.asObservable();
  readonly unreadCountChanged$ = this.unreadCountChangedSubject.asObservable();
  readonly connectionState$ = this.connectionStateSubject.asObservable();

  constructor(private api: ApiService) {}

  async start(): Promise<void> {
    const token = this.getToken();
    if (!token || this.starting || this.isActive()) return;

    this.starting = true;
    this.connectionStateSubject.next('connecting');

    this.connection = new signalR.HubConnectionBuilder()
      .withUrl(`${this.api.baseUrl}/hubs/notifications`, {
        accessTokenFactory: () => this.getToken() || ''
      })
      .withAutomaticReconnect()
      .build();

    this.connection.on('notification.created', (payload: RealtimeNotification) => {
      this.notificationCreatedSubject.next(payload);
    });

    this.connection.on('notification.unreadCountChanged', (payload: { unreadCount?: number } | number) => {
      const unreadCount = typeof payload === 'number' ? payload : Number(payload?.unreadCount || 0);
      this.unreadCountChangedSubject.next(unreadCount);
    });

    this.connection.onreconnecting(() => this.connectionStateSubject.next('reconnecting'));
    this.connection.onreconnected(() => this.connectionStateSubject.next('connected'));
    this.connection.onclose(() => this.connectionStateSubject.next('disconnected'));

    try {
      await this.connection.start();
      this.connectionStateSubject.next('connected');
    } catch (error) {
      console.warn('SignalR notifications connection failed.', error);
      this.connectionStateSubject.next('disconnected');
      this.connection = undefined;
    } finally {
      this.starting = false;
    }
  }

  async stop(): Promise<void> {
    this.starting = false;
    const current = this.connection;
    this.connection = undefined;
    if (!current) {
      this.connectionStateSubject.next('disconnected');
      return;
    }

    try {
      await current.stop();
    } catch (error) {
      console.warn('SignalR notifications disconnect failed.', error);
    } finally {
      this.connectionStateSubject.next('disconnected');
    }
  }

  async reconnect(): Promise<void> {
    await this.stop();
    await this.start();
  }

  private isActive(): boolean {
    return this.connection?.state === signalR.HubConnectionState.Connected
      || this.connection?.state === signalR.HubConnectionState.Connecting
      || this.connection?.state === signalR.HubConnectionState.Reconnecting;
  }

  private getToken(): string | null {
    return localStorage.getItem('accessToken');
  }
}
