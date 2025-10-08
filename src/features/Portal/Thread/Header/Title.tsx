import { Skeleton } from 'antd';


import ActiveThread from './Active';
import NewThread from './New';

import { useChatStore } from '@/store/chat';

const Header = () => {
  const isInNew = useChatStore((s) => s.startToForkThread);

  const isInit = useChatStore((s) => s.threadsInit);

  if (!isInit) return <Skeleton.Button active size={'small'} style={{ height: 22, width: 200 }} />;

  return isInNew ? <NewThread /> : <ActiveThread />;
};

export default Header;
