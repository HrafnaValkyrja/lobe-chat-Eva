import { Suspense, memo } from 'react';
import { Flexbox } from 'react-layout-kit';


import ChatInput from './ChatInput';
import ChatList from './ChatList';

import { SkeletonList } from '@/features/Conversation';

interface ConversationProps {
  mobile?: boolean;
}

const Conversation = memo<ConversationProps>(({ mobile }) => (
  <>
    <Suspense
      fallback={
        <Flexbox flex={1} height={'100%'}>
          <SkeletonList mobile={mobile} />
        </Flexbox>
      }
    >
      <ChatList mobile={mobile} />
    </Suspense>
    <ChatInput />
  </>
));

export default Conversation;
