import { Drawer } from 'antd';
import { useTheme } from 'antd-style';
import dynamic from 'next/dynamic';
import { memo } from 'react';
import { Flexbox } from 'react-layout-kit';

import Content from './Content';

import { fileManagerSelectors, useFileStore } from '@/store/file';


const FileViewer = dynamic(() => import('@/features/FileViewer'), { ssr: false });

const ChunkDrawer = memo(() => {
  const [fileId, open, closeChunkDrawer] = useFileStore((s) => [
    s.chunkDetailId,
    !!s.chunkDetailId,
    s.closeChunkDrawer,
  ]);
  const file = useFileStore(fileManagerSelectors.getFileById(fileId));

  const theme = useTheme();
  return (
    <Drawer
      onClose={() => {
        closeChunkDrawer();
      }}
      open={open}
      styles={{
        body: { padding: 0 },
      }}
      title={file?.name}
      width={'90%'}
    >
      <Flexbox height={'100%'} horizontal style={{ overflow: 'hidden' }}>
        {file && (
          <Flexbox flex={2} style={{ overflow: 'scroll' }}>
            <FileViewer {...file} />
          </Flexbox>
        )}
        <Flexbox flex={1} style={{ borderInlineStart: `1px solid ${theme.colorSplit}` }}>
          <Content />
        </Flexbox>
      </Flexbox>
    </Drawer>
  );
});

export default ChunkDrawer;
