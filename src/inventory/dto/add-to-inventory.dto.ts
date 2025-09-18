import {
  IsString,
  IsInt,
  Min,
  IsOptional,
  IsDateString,
  IsUUID,
} from 'class-validator';
import { Type } from 'class-transformer';

export class AddToInventoryDto {
  @IsString()
  barcode!: string;

  @Type(() => Number)
  @IsInt()
  @Min(1)
  quantity!: number;

  @IsOptional()
  @IsDateString()
  expirationDate?: string;

  @IsOptional()
  @IsString()
  unit?: string;

  @IsOptional()
  @IsString()
  location?: string;

  @IsOptional()
  @IsString()
  batch?: string;

  @IsUUID()
  tenantId!: string;

  @IsOptional()
  @IsUUID()
  kitchenId?: string;
}
