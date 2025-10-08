import { notFound } from 'next/navigation';
import { PropsWithChildren } from 'react';

import Desktop from './_layout/Desktop';
import Mobile from './_layout/Mobile';

import ServerLayout from '@/components/server/ServerLayout';
import { serverFeatureFlags } from '@/config/featureFlags';


const SessionSettingsLayout = ServerLayout({ Desktop, Mobile });

const Layout = ({ children, ...res }: PropsWithChildren) => {
  const isAgentEditable = serverFeatureFlags().isAgentEditable;
  if (!isAgentEditable) return notFound();

  return <SessionSettingsLayout {...res}>{children}</SessionSettingsLayout>;
};

Layout.displayName = 'SessionSettingsLayout';

export default Layout;
