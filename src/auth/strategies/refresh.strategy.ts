import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';

type RefreshPayload = {
  sub: string;
  tenantId: string;
  role: string;
  email: string;
  rt?: string;
};

@Injectable()
export class RefreshJwtStrategy extends PassportStrategy(
  Strategy,
  'jwt-refresh',
) {
  constructor() {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      secretOrKey: process.env.JWT_REFRESH_SECRET ?? 'dev_refresh_secret',
      ignoreExpiration: false,
      passReqToCallback: true,
    });
  }
  validate(req: any, payload: RefreshPayload) {
    const token = ExtractJwt.fromAuthHeaderAsBearerToken()(req);
    if (!token) throw new UnauthorizedException();
    return { ...payload, refreshToken: token };
  }
}
