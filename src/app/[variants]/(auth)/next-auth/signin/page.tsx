import { Suspense } from 'react';

import AuthSignInBox from './AuthSignInBox';

import Loading from '@/components/Loading/BrandTextLoading';


export default () => (
  <Suspense fallback={<Loading />}>
    <AuthSignInBox />
  </Suspense>
);
