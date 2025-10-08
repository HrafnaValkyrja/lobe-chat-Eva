'use client';


import Advanced from './Advanced';
import IndexedDBStorage from './IndexedDBStorage';

import { isServerMode } from '@/const/version';

const StorageEstimate = () => {
  return (
    <>
      {!isServerMode && <IndexedDBStorage />}
      <Advanced />
    </>
  );
};

export default StorageEstimate;
