import { Injectable, Inject } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import axios, { AxiosInstance } from 'axios';
import axiosRetry, { exponentialDelay } from 'axios-retry';
import { OFF_RESOLVED_CONFIG } from './off.tokens';
import type { AxiosResponse, AxiosRequestConfig } from 'axios';
import type {
  OffResolvedConfig,
  SearchV2Params,
  OffProductResponse,
  OffSearchResponse,
  OffAllergensTaxonomy,
} from '../../common/types/off.types';

type RetryDelayFn = (retryCount: number) => number;
type AxiosRetryFn = (
  instance: AxiosInstance,
  opts?: { retries?: number; retryDelay?: RetryDelayFn },
) => void;

const OFF_DOMAINS = [
  'https://world.openfoodfacts.org',
  'https://world.openbeautyfacts.org',
  'https://world.openpetfoodfacts.org',
  'https://world.openproductsfacts.org',
];

@Injectable()
export class OffClient {
  private readonly ax: AxiosInstance;

  constructor(
    private readonly http: HttpService,
    @Inject(OFF_RESOLVED_CONFIG) cfg: OffResolvedConfig,
  ) {
    this.ax = axios.create({
      baseURL: cfg.baseUrl,
      timeout: cfg.timeoutMs,
      headers: { 'User-Agent': cfg.userAgent, Accept: 'application/json' },
    });

    const applyRetry = axiosRetry as unknown as AxiosRetryFn;
    const retryDelay = exponentialDelay as unknown as RetryDelayFn;

    applyRetry(this.ax, {
      retries: 3,
      retryDelay,
    });
  }

  private request<T = unknown>(
    url: string,
    cfg?: AxiosRequestConfig,
    baseUrlOverride?: string,
  ): Promise<AxiosResponse<T>> {
    if (baseUrlOverride) {
      const adHoc = axios.create({
        baseURL: baseUrlOverride,
        timeout: this.ax.defaults.timeout,
        headers: this.ax.defaults.headers,
      });
      return adHoc.request<T>({ url, method: 'GET', ...(cfg ?? {}) });
    }
    return this.ax.request<T>({ url, method: 'GET', ...(cfg ?? {}) });
  }

  getProductByBarcode(
    barcode: string,
    baseUrlOverride?: string,
  ): Promise<AxiosResponse<OffProductResponse>> {
    return this.request<OffProductResponse>(
      `/api/v2/product/${encodeURIComponent(barcode)}.json`,
      undefined,
      baseUrlOverride,
    );
  }

  async getProductByBarcodeTryDomains(barcode: string): Promise<{
    domain: string;
    response: AxiosResponse<OffProductResponse>;
  } | null> {
    for (const domain of OFF_DOMAINS) {
      const resp = await this.getProductByBarcode(barcode, domain);
      if (resp?.data?.status === 1) return { domain, response: resp };
    }
    return null;
  }

  searchV2(params: SearchV2Params): Promise<AxiosResponse<OffSearchResponse>> {
    return this.request<OffSearchResponse>('/api/v2/search', { params });
  }

  getManyByCodes(
    codes: string[],
    fields?: string,
  ): Promise<AxiosResponse<OffSearchResponse>> {
    return this.request<OffSearchResponse>('/api/v2/search', {
      params: { code: codes.join(','), fields, page_size: codes.length || 20 },
    });
  }

  getTaxonomy<T extends OffAllergensTaxonomy = OffAllergensTaxonomy>(
    name: 'allergens' | 'categories' | 'labels' | 'additives',
    locale = 'fr',
  ): Promise<AxiosResponse<T>> {
    return this.request<T>(`/data/taxonomies/${name}.${locale}.json`);
  }
}
