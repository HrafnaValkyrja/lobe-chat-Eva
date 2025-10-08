
import { ClientService } from './client';
import { ServerService } from './server';

import { isServerMode } from '@/const/version';

export const exportService = isServerMode ? new ServerService() : new ClientService();
