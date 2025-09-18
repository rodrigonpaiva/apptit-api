import { z } from 'zod';

export const OffProductSchema = z.object({
  code: z.string().optional(),
  product_name: z.string().optional(),
  brands: z.string().optional(),
  categories: z.string().optional(),
  image_url: z.string().url().optional(),
  allergens: z.string().optional(),
  allergens_tags: z.array(z.string()).optional(),
  ecoscore_grade: z.string().optional(),
});

export type OffProduct = z.infer<typeof OffProductSchema>;
