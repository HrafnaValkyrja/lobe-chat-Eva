
import Desktop from './_layout/Desktop';
import Mobile from './_layout/Mobile';
import { LayoutProps } from './_layout/type';

import ServerLayout from '@/components/server/ServerLayout';

const ProfileLayout = ServerLayout<LayoutProps>({ Desktop, Mobile });

ProfileLayout.displayName = 'ProfileLayout';

export default ProfileLayout;
