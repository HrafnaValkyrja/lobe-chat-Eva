import { PropsWithChildren } from 'react';

import Header from './features/Header';

import MobileContentLayout from '@/components/server/MobileNavLayout';


const Layout = ({ children }: PropsWithChildren) => {
  return <MobileContentLayout header={<Header />}>{children}</MobileContentLayout>;
};

Layout.displayName = 'MeSettingsLayout';

export default Layout;
