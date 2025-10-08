/**
 * This file contains the edge router of Lobe Chat tRPC-backend
 */
import { uploadRouter } from './upload';

import { publicProcedure, router } from '@/libs/trpc/edge';


export const edgeRouter = router({
  healthcheck: publicProcedure.query(() => "i'm live!"),
  upload: uploadRouter,
});

export type EdgeRouter = typeof edgeRouter;
