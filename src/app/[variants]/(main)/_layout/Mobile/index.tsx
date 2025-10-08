'use client';

import dynamic from 'next/dynamic';
import { usePathname } from 'next/navigation';
import { PropsWithChildren, memo } from 'react';

import NavBar from './NavBar';

import { withSuspense } from '@/components/withSuspense';
import { useShowMobileWorkspace } from '@/hooks/useShowMobileWorkspace';
import { featureFlagsSelectors, useServerConfigStore } from '@/store/serverConfig';


const CloudBanner = dynamic(() => import('@/features/AlertBanner/CloudBanner'));
const MOBILE_NAV_ROUTES = new Set([
  '/chat',
  '/discover',
  '/discover/assistant',
  '/discover/mcp',
  '/discover/plugin',
  '/discover/model',
  '/discover/provider',
  '/me',
]);

const Layout = memo(({ children }: PropsWithChildren) => {
  const showMobileWorkspace = useShowMobileWorkspace();
  const pathname = usePathname();
  const showNav = !showMobileWorkspace && MOBILE_NAV_ROUTES.has(pathname);

  const { showCloudPromotion } = useServerConfigStore(featureFlagsSelectors);

  return (
    <>
      {showCloudPromotion && <CloudBanner mobile />}
      {children}
      {showNav && <NavBar />}
    </>
  );
});

Layout.displayName = 'MobileMainLayout';

export default withSuspense(Layout);
