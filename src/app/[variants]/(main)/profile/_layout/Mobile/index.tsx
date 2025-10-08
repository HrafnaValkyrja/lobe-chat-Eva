import { LayoutProps } from '../type';

import Header from './Header';

import MobileContentLayout from '@/components/server/MobileNavLayout';
import InitClientDB from '@/features/InitClientDB';
import Footer from '@/features/Setting/Footer';


const Layout = ({ children }: LayoutProps) => {
  return (
    <>
      <MobileContentLayout header={<Header />}>
        {children}
        <div style={{ flex: 1 }} />
        <Footer />
      </MobileContentLayout>
      <InitClientDB />
    </>
  );
};

Layout.displayName = 'MobileProfileLayout';

export default Layout;
