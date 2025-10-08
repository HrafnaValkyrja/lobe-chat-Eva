
import Desktop from './_layout/Desktop';
import Mobile from './_layout/Mobile';

import ServerLayout from '@/components/server/ServerLayout';

const MainLayout = ServerLayout({ Desktop, Mobile });

MainLayout.displayName = 'MainLayout';

export default MainLayout;
