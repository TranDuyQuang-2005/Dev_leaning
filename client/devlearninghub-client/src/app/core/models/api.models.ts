export interface ApiResponse<T> { success: boolean; message: string; data: T; errors?: { field: string; message: string }[] | null; }
export interface PagedResult<T> { items: T[]; pageIndex: number; pageSize: number; totalItems: number; totalPages: number; }
export interface CurrentUser { id: number; fullName: string; userName: string; email: string; avatarUrl?: string | null; roles: string[]; permissions: string[]; }
export interface AuthResponse { accessToken: string; refreshToken: string; expiresIn: number; user: CurrentUser; }
export interface Category { id: number; parentId?: number | null; name: string; slug: string; description?: string | null; iconUrl?: string | null; displayOrder: number; status: number; }
export interface QuizSet { id: number; categoryId?: number | null; title: string; slug: string; questionCount: number; }
