// src/integrations/off/off.service.ts
import { Injectable, Inject, NotFoundException } from '@nestjs/common';
import { OffClient } from './off.client';
import { OffProductSchema } from '../../common/validation/off.schema';
import type {
  OffProductResponse,
  OffResolvedConfig,
} from '../../common/types/off.types';
import { OFF_RESOLVED_CONFIG } from './off.tokens';

@Injectable()
export class OffService {
  constructor(
    private readonly client: OffClient,
    @Inject(OFF_RESOLVED_CONFIG) private readonly cfg: OffResolvedConfig,
  ) {}

  async scan(
    barcode: string,
    codes: string[] = [],
  ): Promise<OffProductResponse> {
    const { data } = await this.client.getManyByCodes([barcode, ...codes]);

    if (!data.products || !data.products.length) {
      throw new NotFoundException(
        `Produit non trouvé pour le code-barres ${barcode}`,
      );
    }

    const prodRaw = data.products[0];
    const parsed = OffProductSchema.safeParse(prodRaw);

    if (!parsed.success) {
      throw new NotFoundException(
        `Produit non valide pour le code-barres ${barcode}`,
      );
    }

    return {
      status: 1,
      code: barcode,
      products: [parsed.data],
    };
  }
}
