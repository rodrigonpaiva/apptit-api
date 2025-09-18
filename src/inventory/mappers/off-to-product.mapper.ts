// src/modules/inventory/mappers/off-to-product.mapper.ts
import type { OffProduct } from 'src/common/types/off.types';

export const mapOffToProduct = (p: OffProduct) => ({
  name: p.product_name ?? 'Produit',
  brand: p.brands ?? null,
  categories: p.categories ?? null,
  imageUrl: p.image_url ?? null,
  allergens: p.allergens ?? null,
  allergensTags: p.allergens_tags ?? [],
  ecoscore: p.ecoscore_grade ?? null,
  barcode: p.code ?? null,
  createdAt: new Date(),
  updatedAt: new Date(),
  deletedAt: null,
});
