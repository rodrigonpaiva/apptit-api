import { Module, Global } from '@nestjs/common';
import { OffClient } from './off.client';
import { OffService } from './off.service';
import { HttpModule } from '@nestjs/axios';
import { ConfigModule } from '@nestjs/config';
import { makeOffConfig } from './off.config';
import { OffController } from './off.controller';
import { OFF_RESOLVED_CONFIG } from './off.tokens';

@Global()
@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    HttpModule,
  ],
  controllers: [OffController],
  providers: [
    OffClient,
    OffService,
    { provide: OFF_RESOLVED_CONFIG, useFactory: makeOffConfig },
  ],
  exports: [OffService],
})
export class OffModule {}
