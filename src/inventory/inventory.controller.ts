// src/modules/inventory/inventory.controller.ts
import { Body, Controller, Post, UseInterceptors } from '@nestjs/common';
import { InventoryService } from './inventory.service';
import { AddToInventoryDto } from './dto/add-to-inventory.dto';
import { LoggerInterceptor } from 'src/common/interceptors/logger.interceptor';

@Controller('inventory')
@UseInterceptors(LoggerInterceptor)
export class InventoryController {
  constructor(private readonly inventory: InventoryService) {}

  @Post('add-from-off')
  async addFromOff(@Body() dto: AddToInventoryDto) {
    return this.inventory.addFromOff(dto);
  }
}
