'use client';

import { memo } from 'react';

import Detail from '../../../features/FileDetail';

import { fileManagerSelectors, useFileStore } from '@/store/file';


const FileDetail = memo<{ id: string }>(({ id }) => {
  const file = useFileStore(fileManagerSelectors.getFileById(id));

  if (!file) return;

  return <Detail {...file} />;
});
export default FileDetail;
