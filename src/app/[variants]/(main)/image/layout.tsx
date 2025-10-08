
import Desktop from './_layout/Desktop';
import Mobile from './_layout/Mobile';
import { LayoutProps } from './_layout/type';
import NotSupportClient from './NotSupportClient';

import ServerLayout from '@/components/server/ServerLayout';
import { isServerMode } from '@/const/version';

const AiImageLayout = ServerLayout({ Desktop, Mobile });

AiImageLayout.displayName = 'AiImageLayout';

const Layout = (props: LayoutProps) => {
  if (!isServerMode) return <NotSupportClient />;

  return <AiImageLayout {...props} />;
};

export default Layout;
