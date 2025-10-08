
import { mcpRouter } from './mcp';
import { searchRouter } from './search';

import { publicProcedure, router } from '@/libs/trpc/lambda';

export const toolsRouter = router({
  healthcheck: publicProcedure.query(() => "i'm live!"),
  mcp: mcpRouter,
  search: searchRouter,
});

export type ToolsRouter = typeof toolsRouter;
