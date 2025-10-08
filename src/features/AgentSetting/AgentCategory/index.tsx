'use client';

import { memo } from 'react';

import { useCategory } from './useCategory';

import Menu from '@/components/Menu';
import { ChatSettingsTabs } from '@/store/global/initialState';


interface CategoryContentProps {
  setTab: (tab: ChatSettingsTabs) => void;
  tab: string;
}
const AgentCategory = memo<CategoryContentProps>(({ setTab, tab }) => {
  const cateItems = useCategory();
  return (
    <Menu
      compact
      items={cateItems}
      onClick={({ key }) => {
        setTab(key as ChatSettingsTabs);
      }}
      selectable
      selectedKeys={[tab as any]}
    />
  );
});

export default AgentCategory;
