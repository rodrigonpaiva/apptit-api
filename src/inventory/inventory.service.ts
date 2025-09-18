import { BadRequestException, Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from 'src/prisma/prisma.service';
import { AddToInventoryDto } from './dto/add-to-inventory.dto';
import { OffService } from 'src/integrations/off/off.service';

@Injectable()
export class InventoryService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly off: OffService,
  ) {}

  async addFromOff(dto: AddToInventoryDto) {
    if (dto.expirationDate) {
      const exp = new Date(dto.expirationDate);
      if (Number.isNaN(+exp)) {
        throw new BadRequestException(
          'expirationDate inválida (ISO esperado).',
        );
      }
      if (exp < new Date()) {
        throw new BadRequestException(
          'expirationDate não pode ser no passado.',
        );
      }
    }

    const offResp = await this.off.scan(dto.barcode);
    const p = offResp.products[0];

    const productPayload = {
      name: p.product_name ?? 'Produit',
      categories: p.categories ?? null,
      imageUrl: p.image_url ?? null,
      ecoScore: p.ecoscore_grade ?? null,
      allergens: p.allergens ?? '',
    } as const;

    const product = await this.prisma.product.upsert({
      where: {
        tenantId_barcode: {
          tenantId: dto.tenantId,
          barcode: dto.barcode,
        },
      },
      update: {
        ...productPayload,
        ...(dto.unit ? { unit: dto.unit } : {}),
      },
      create: {
        tenantId: dto.tenantId,
        barcode: dto.barcode,
        unit: dto.unit ?? 'unit',
        ...productPayload,
      },
    });

    if (!dto.kitchenId) {
      throw new BadRequestException('kitchenId é obrigatório.');
    }

    const item = await this.prisma.stockItem.create({
      data: {
        tenantId: dto.tenantId,
        siteId: dto.kitchenId,
        productId: product.id,
        lot: dto.batch ?? null,
        qty: new Prisma.Decimal(dto.quantity),
        expiresAt: dto.expirationDate ? new Date(dto.expirationDate) : null,
      },
      include: {
        product: true,
      },
    });

    return {
      message: 'Inventaire mis à jour',
      product,
      item,
    };
  }
}
