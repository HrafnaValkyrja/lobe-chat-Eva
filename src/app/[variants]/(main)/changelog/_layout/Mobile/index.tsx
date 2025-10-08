import { ReactNode } from 'react';


import Hero from '../../features/Hero';

import Header from './Header';

import MobileContentLayout from '@/components/server/MobileNavLayout';

type Props = { children: ReactNode };

const Layout = ({ children }: Props) => {
  return (
    <MobileContentLayout header={<Header />} padding={16}>
      <Hero />
      {children}
    </MobileContentLayout>
  );
};

Layout.displayName = 'MobileChangelogLayout';

export default Layout;
