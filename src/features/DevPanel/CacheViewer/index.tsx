import { Empty } from 'antd';
import { Center } from 'react-layout-kit';

import { CachePanelContextProvider } from './cacheProvider';
import DataTable from './DataTable';
import { getCacheFiles } from './getCacheEntries';

const CacheViewer = async () => {
  const files = await getCacheFiles();

  if (!files || files.length === 0)
    return (
      <Center height={'80%'}>
        <Empty image={Empty.PRESENTED_IMAGE_SIMPLE} />
      </Center>
    );

  return (
    <CachePanelContextProvider entries={files}>
      <DataTable />
    </CachePanelContextProvider>
  );
};

export default CacheViewer;
