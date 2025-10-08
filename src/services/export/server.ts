import { IExportService } from './type';

import { lambdaClient } from '@/libs/trpc/client';


export class ServerService implements IExportService {
  exportData: IExportService['exportData'] = async () => {
    return await lambdaClient.exporter.exportData.mutate();
  };
}
