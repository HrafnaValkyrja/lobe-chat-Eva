import { Markdown } from '@lobehub/ui';
import { memo } from 'react';

import Loading from '../Loading';

import { useUserStore } from '@/store/user';
import { userGeneralSettingsSelectors } from '@/store/user/selectors';


export interface PluginMarkdownTypeProps {
  content: string;
  loading?: boolean;
}

const PluginMarkdownType = memo<PluginMarkdownTypeProps>(({ content, loading }) => {
  const fontSize = useUserStore(userGeneralSettingsSelectors.fontSize);
  if (loading) return <Loading />;

  return (
    <Markdown fontSize={fontSize} variant={'chat'}>
      {content}
    </Markdown>
  );
});

export default PluginMarkdownType;
