// src/auth/auth.module.ts
import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { ConfigModule } from '@nestjs/config';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { JwtStrategy } from './strategies/jwt.strategy';
import { RefreshJwtStrategy } from './strategies/refresh.strategy';
import { PrismaService } from '../prisma/prisma.service'; // adapte o caminho se necessário
import { UserService } from '../user/user.service';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    JwtModule.register({
      secret: process.env.JWT_ACCESS_SECRET
        ? process.env.JWT_ACCESS_SECRET
        : 'dev_access_secret',
      signOptions: { expiresIn: process.env.JWT_EXPIRES_IN ?? '15m' },
    }),
  ],
  controllers: [AuthController],
  providers: [
    PrismaService,
    UserService,
    AuthService,
    JwtStrategy,
    RefreshJwtStrategy,
  ],
  exports: [AuthService],
})
export class AuthModule {}
