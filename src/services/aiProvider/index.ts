
import { ClientService } from './client';
import { ServerService } from './server';

import { isDesktop } from '@/const/version';

export const aiProviderService =
  process.env.NEXT_PUBLIC_SERVICE_MODE === 'server' || isDesktop
    ? new ServerService()
    : new ClientService();
