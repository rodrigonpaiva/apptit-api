import { OffResolvedConfig } from '../../common/types/off.types';

function toInt(value: string | undefined, fallback: number): number {
  const parsed = parseInt(value ?? '', 10);
  return Number.isFinite(parsed) && parsed > 0 ? parsed : fallback;
}

export function makeOffConfig(): OffResolvedConfig {
  return {
    baseUrl: process.env.OFF_BASE_URL ?? 'https://world.openfoodfacts.org',
    userAgent:
      process.env.OFF_USER_AGENT ??
      'Apptit/0.1 (+https://apptit.io; contact@apptit.io)',
    timeoutMs: toInt(process.env.OFF_REQUEST_TIMEOUT_MS, 8000),
    cacheTtlSec: toInt(process.env.OFF_CACHE_TTL_SEC, 3600),
    locale: process.env.OFF_LOCALE ?? 'fr',
  };
}
