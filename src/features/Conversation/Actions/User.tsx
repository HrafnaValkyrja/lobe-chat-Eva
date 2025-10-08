import { ActionIconGroup } from '@lobehub/ui';
import { ActionIconGroupItemType } from '@lobehub/ui/es/ActionIconGroup';
import { memo, useContext, useMemo } from 'react';


import { InPortalThreadContext } from '../components/ChatItem/InPortalThreadContext';
import { useChatListActionsBar } from '../hooks/useChatListActionsBar';
import { RenderAction } from '../types';

import { useCustomActions } from './customAction';

import { useChatStore } from '@/store/chat';
import { threadSelectors } from '@/store/chat/slices/thread/selectors';

export const UserActionsBar: RenderAction = memo(({ onActionClick, id }) => {
  const [isThreadMode, hasThread] = useChatStore((s) => [
    !!s.activeThreadId,
    threadSelectors.hasThreadBySourceMsgId(id)(s),
  ]);
  const { regenerate, edit, copy, divider, del, branching } = useChatListActionsBar({ hasThread });
  const { translate, tts } = useCustomActions();

  const inPortalThread = useContext(InPortalThreadContext);
  const inThread = isThreadMode || inPortalThread;

  const items = useMemo(
    () =>
      [regenerate, edit, inThread ? null : branching].filter(Boolean) as ActionIconGroupItemType[],
    [inThread],
  );

  return (
    <ActionIconGroup
      items={items}
      menu={{
        items: [edit, copy, divider, tts, translate, divider, regenerate, del],
      }}
      onActionClick={onActionClick}
    />
  );
});
