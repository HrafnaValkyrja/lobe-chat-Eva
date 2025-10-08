import { PropsWithChildren } from 'react';


import Container from './Container';
import Header from './Header';

import NProgress from '@/components/NProgress';

const Layout = ({ children }: PropsWithChildren) => {
  return (
    <>
      <NProgress />
      <Container>
        <Header />
        {children}
      </Container>
      {/* ↓ cloud slot ↓ */}

      {/* ↑ cloud slot ↑ */}
    </>
  );
};

Layout.displayName = 'DesktopDiscoverStoreLayout';

export default Layout;
