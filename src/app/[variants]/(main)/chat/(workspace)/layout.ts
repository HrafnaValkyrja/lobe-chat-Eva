
import Desktop from './_layout/Desktop';
import Mobile from './_layout/Mobile';
import { LayoutProps } from './_layout/type';

import ServerLayout from '@/components/server/ServerLayout';

const Layout = ServerLayout<LayoutProps>({ Desktop, Mobile });

Layout.displayName = 'ChatConversationLayout';

export default Layout;
