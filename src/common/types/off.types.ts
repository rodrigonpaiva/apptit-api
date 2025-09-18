export type OffResolvedConfig = {
  baseUrl: string;
  userAgent: string;
  timeoutMs: number;
  cacheTtlSec: number;
  locale: string;
};

export interface OffProductResponse {
  status: number;
  code: string;
  products: OffProduct[];
}

export interface OffProduct {
  code?: string;
  product_name?: string;
  brands?: string;
  categories?: string;
  image_url?: string;
  allergens?: string;
  allergens_tags?: string[];
  ecoscore_grade?: string;
}

export interface OffSearchResponse {
  count?: number;
  page?: number;
  page_size?: number;
  products?: unknown[];
}

export type SearchParams = {
  query?: string;
  code?: string;
  page?: number;
  page_size?: number;
  fields?: string;
  [k: string]: string | number | boolean | undefined;
};

export type SearchV2Params = {
  query?: string;
  code?: string;
  page?: number;
  page_size?: number;
  fields?: string;
  [k: string]: string | number | boolean | undefined;
};

export type OffAllergensTaxonomy = {
  [key: string]: {
    id: number;
    name: string;
  };
};
