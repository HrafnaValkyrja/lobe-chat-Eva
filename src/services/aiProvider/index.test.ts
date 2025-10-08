
import { ClientService } from './client';
import { ServerService } from './server';

import { testService } from '~test-utils';

describe('aiProviderService', () => {
  testService(ServerService);

  testService(ClientService);
});
