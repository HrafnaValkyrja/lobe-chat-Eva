import { PropsWithChildren } from 'react';

import Body from '../features/Body';

import { PortalHeader } from '@/features/Portal/router';


const Layout = ({ children }: PropsWithChildren) => {
  return (
    <>
      <PortalHeader />
      <Body>{children}</Body>
    </>
  );
};

export default Layout;
