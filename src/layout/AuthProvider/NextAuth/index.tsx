import { SessionProvider } from 'next-auth/react';
import { PropsWithChildren } from 'react';

import UserUpdater from './UserUpdater';

import { API_ENDPOINTS } from '@/services/_url';


const NextAuth = ({ children }: PropsWithChildren) => {
  return (
    <SessionProvider basePath={API_ENDPOINTS.oauth}>
      {children}
      <UserUpdater />
    </SessionProvider>
  );
};

export default NextAuth;
