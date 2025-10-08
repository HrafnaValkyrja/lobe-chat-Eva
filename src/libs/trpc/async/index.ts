import debug from 'debug';


import { asyncAuth } from './asyncAuth';
import { asyncTrpc } from './init';

import { getServerDB } from '@/database/core/db-adaptor';

const log = debug('lobe-async:middleware');

export const publicProcedure = asyncTrpc.procedure;

export const asyncRouter = asyncTrpc.router;

const dbMiddleware = asyncTrpc.middleware(async (opts) => {
  log('Database middleware called');

  try {
    log('Getting server database connection');
    const serverDB = await getServerDB();
    log('Database connection established successfully');

    return opts.next({
      ctx: { serverDB },
    });
  } catch (error) {
    log('Failed to establish database connection: %O', error);
    throw error;
  }
});

export const asyncAuthedProcedure = asyncTrpc.procedure.use(dbMiddleware).use(asyncAuth);

export const createAsyncCallerFactory = asyncTrpc.createCallerFactory;
