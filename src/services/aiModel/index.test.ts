
import { ClientService } from './client';
import { ServerService } from './server';

import { testService } from '~test-utils';

describe('aiModelService', () => {
  testService(ServerService);

  testService(ClientService);
});
