import { Suspense } from 'react';

import AuthErrorPage from './AuthErrorPage';

import Loading from '@/components/Loading/BrandTextLoading';


export default () => (
  <Suspense fallback={<Loading />}>
    <AuthErrorPage />
  </Suspense>
);
