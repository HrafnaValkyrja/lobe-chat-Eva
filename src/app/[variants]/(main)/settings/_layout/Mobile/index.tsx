'use client';

import { useQueryState } from 'nuqs';

import SettingsContent from '../SettingsContent';

import Header from './Header';

import MobileContentLayout from '@/components/server/MobileNavLayout';
import InitClientDB from '@/features/InitClientDB';
import Footer from '@/features/Setting/Footer';
import { SettingsTabs } from '@/store/global/initialState';


const Layout = () => {
  const [activeTab] = useQueryState('active', {
    defaultValue: SettingsTabs.Common,
  });

  return (
    <MobileContentLayout header={<Header />}>
      <SettingsContent activeTab={activeTab} mobile={true} />
      <Footer />
      <InitClientDB />
    </MobileContentLayout>
  );
};

Layout.displayName = 'MobileSettingsLayout';

export default Layout;
