'use client';

import { PropsWithChildren } from 'react';

import Header from './Header';

import MobileContentLayout from '@/components/server/MobileNavLayout';
import Footer from '@/features/Setting/Footer';


const Layout = ({ children }: PropsWithChildren) => (
  <MobileContentLayout header={<Header />}>
    {children}
    <Footer />
  </MobileContentLayout>
);

Layout.displayName = 'MobileSessionSettingsLayout';

export default Layout;
