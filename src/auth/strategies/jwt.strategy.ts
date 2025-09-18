// src/auth/strategies/jwt.strategy.ts
import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import type { Role } from '../../common/types/role.type';
import type { JwtPayload } from '../../common/types/jwt.type';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, 'jwt') {
  constructor() {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      secretOrKey: process.env.JWT_ACCESS_SECRET ?? 'dev_access_secret',
      ignoreExpiration: false,
    });
  }
  async validate(payload: JwtPayload) {
    return payload;
  }
}
