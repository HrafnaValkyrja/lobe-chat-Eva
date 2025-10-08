
import Conversation from './features/Conversation';
import Desktop from './features/Desktop';
import Essential from './features/Essential';

import { isDesktop } from '@/const/version';

const Page = () => {
  return (
    <>
      {isDesktop && <Desktop />}
      <Essential />
      <Conversation />
    </>
  );
};

Page.displayName = 'HotkeySetting';

export default Page;
