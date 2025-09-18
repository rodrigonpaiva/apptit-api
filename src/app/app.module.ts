import {
  MiddlewareConsumer,
  Module,
  RequestMethod,
  NestModule,
} from '@nestjs/common';

import { AuthModule } from '../auth/auth.module';
import { UserModule } from '../user/user.module';
import { PrismaModule } from '../prisma/prisma.module';
import { OffModule } from 'src/integrations/off/off.module';
import { ConfigModule } from '@nestjs/config';
import { LoggerMiddleware } from 'src/common/middlewares/logger.middleware';
import { InventoryModule } from 'src/inventory/inventory.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    AuthModule,
    UserModule,
    PrismaModule,
    OffModule,
    InventoryModule,
  ],
  providers: [],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer.apply(LoggerMiddleware).forRoutes({
      path: '*',
      method: RequestMethod.ALL,
    });
  }
}
