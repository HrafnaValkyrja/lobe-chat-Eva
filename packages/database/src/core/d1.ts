import { drizzle } from 'drizzle-orm/d1';

import * as schema from '../schemas';
import { LobeChatDatabase } from '../type';
import type { D1Database } from '../types/cloudflare';

/**
 * Create a D1 database instance for Cloudflare Workers
 * @param d1Binding The D1 database binding from Cloudflare Workers environment
 * @returns Drizzle database instance configured for D1
 */
export const getD1Instance = (d1Binding: D1Database): any => {
  // D1 returns a different type than Neon/PostgreSQL, so we use any for now
  // This will be properly typed once we have full D1 integration
  return drizzle(d1Binding, { schema });
};
