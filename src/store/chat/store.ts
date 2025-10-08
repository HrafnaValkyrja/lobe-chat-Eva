// sort-imports-ignore
import { subscribeWithSelector } from 'zustand/middleware';
import { shallow } from 'zustand/shallow';
import { createWithEqualityFn } from 'zustand/traditional';
import { StateCreator } from 'zustand/vanilla';

import { createDevtools } from '../middleware/createDevtools';

import { ChatStoreState, initialState } from './initialState';
import { ChatAIChatAction, chatAiChat } from './slices/aiChat/actions';
import { ChatBuiltinToolAction, chatToolSlice } from './slices/builtinTool/actions';
import { ChatMessageAction, chatMessage } from './slices/message/action';
import { ChatPluginAction, chatPlugin } from './slices/plugin/action';
import { ChatPortalAction, chatPortalSlice } from './slices/portal/action';
import { ShareAction, chatShare } from './slices/share/action';
import { ChatThreadAction, chatThreadMessage } from './slices/thread/action';
import { ChatTopicAction, chatTopic } from './slices/topic/action';
import { ChatTranslateAction, chatTranslate } from './slices/translate/action';
import { ChatTTSAction, chatTTS } from './slices/tts/action';

export interface ChatStoreAction
  extends ChatMessageAction,
    ChatThreadAction,
    ChatAIChatAction,
    ChatTopicAction,
    ShareAction,
    ChatTranslateAction,
    ChatTTSAction,
    ChatPluginAction,
    ChatBuiltinToolAction,
    ChatPortalAction {}

export type ChatStore = ChatStoreAction & ChatStoreState;

//  ===============  聚合 createStoreFn ============ //

const createStore: StateCreator<ChatStore, [['zustand/devtools', never]]> = (...params) => ({
  ...initialState,

  ...chatMessage(...params),
  ...chatThreadMessage(...params),
  ...chatAiChat(...params),
  ...chatTopic(...params),
  ...chatShare(...params),
  ...chatTranslate(...params),
  ...chatTTS(...params),
  ...chatToolSlice(...params),
  ...chatPlugin(...params),
  ...chatPortalSlice(...params),

  // cloud
});

//  ===============  实装 useStore ============ //
const devtools = createDevtools('chat');

export const useChatStore = createWithEqualityFn<ChatStore>()(
  subscribeWithSelector(devtools(createStore)),
  shallow,
);

export const getChatStoreState = () => useChatStore.getState();
