'use client';

import { memo } from 'react';

import Toast from './Toast';

import { useGlobalStore } from '@/store/global';
import { systemStatusSelectors } from '@/store/global/selectors';


const ZenModeToast = memo(() => {
  const inZenMode = useGlobalStore(systemStatusSelectors.inZenMode);

  return inZenMode && <Toast />;
});

export default ZenModeToast;
