import { trpc } from '../init';

import { getServerDB } from '@/database/core/db-adaptor';


export const serverDatabase = trpc.middleware(async (opts) => {
  const serverDB = await getServerDB();

  return opts.next({
    ctx: { serverDB },
  });
});
