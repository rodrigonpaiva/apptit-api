// src/integrations/off/off.controller.ts
import { BadRequestException, Controller, Get, Query } from '@nestjs/common';
import { OffService } from './off.service';
import type { OffProductResponse } from '../../common/types/off.types';

@Controller('off')
export class OffController {
  constructor(private readonly off: OffService) {}

  @Get('scan')
  async scan(
    @Query('barcode') barcode: string,
    @Query('codes') codes?: string | string[],
  ): Promise<OffProductResponse> {
    if (!barcode || !barcode.trim()) {
      throw new BadRequestException('Le paramètre "barcode" est requis.');
    }
    const list = (Array.isArray(codes) ? codes.join(',') : (codes ?? ''))
      .split(',')
      .map((s) => s.trim())
      .filter(Boolean);

    return this.off.scan(barcode.trim(), list);
  }
}
