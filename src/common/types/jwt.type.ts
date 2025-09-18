export type JwtPayload = {
  sub: string;
  tenantId: string;
  role: 'ADMIN' | 'MANAGER' | 'CHEF' | 'STAFF';
  email: string;
};
