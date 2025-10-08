
import { ClientService } from './client';
import { DesktopService } from './desktop';

import { isDesktop } from '@/const/version';

export const tableViewerService = isDesktop ? new DesktopService() : new ClientService();
