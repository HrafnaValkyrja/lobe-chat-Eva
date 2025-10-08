import { PropsWithChildren } from 'react';


import Desktop from './_layout/Desktop';
import Mobile from './_layout/Mobile';

import ServerLayout from '@/components/server/ServerLayout';

const MainLayout = ServerLayout<PropsWithChildren>({ Desktop, Mobile });

MainLayout.displayName = 'DiscoverToolsLayout';

export default MainLayout;
