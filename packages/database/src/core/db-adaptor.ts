import { isDesktop } from '@lobechat/const';

import { LobeChatDatabase } from '../type';
import type { D1Database } from '../types/cloudflare';

import { getD1Instance } from './d1';
import { getPgliteInstance } from './electron';
import { getDBInstance } from './web-server';

/**
 * 懒加载数据库实例
 * 避免每次模块导入时都初始化数据库
 */
let cachedDB: LobeChatDatabase | null = null;

export const getServerDB = async (): Promise<LobeChatDatabase> => {
  // 如果已经有缓存的实例，直接返回
  if (cachedDB) return cachedDB;

  try {
    // 检查是否在 Cloudflare Workers 环境中且有 D1 绑定
    if (typeof globalThis !== 'undefined' && 'DB' in globalThis && typeof (globalThis as any).DB === 'object') {
      cachedDB = getD1Instance((globalThis as any).DB as D1Database) as LobeChatDatabase;
      return cachedDB;
    }

    // 根据环境选择合适的数据库实例
    cachedDB = isDesktop ? await getPgliteInstance() : getDBInstance();
    return cachedDB;
  } catch (error) {
    console.error('❌ Failed to initialize database:', error);
    throw error;
  }
};

export const serverDB = getDBInstance();
