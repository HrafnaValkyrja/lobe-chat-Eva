import { memo } from 'react';

import { RenderMessageExtra } from '../types';

import ExtraContainer from './ExtraContainer';
import Translate from './Translate';
import TTS from './TTS';

import { useChatStore } from '@/store/chat';
import { chatSelectors } from '@/store/chat/selectors';
import { ChatMessage } from '@/types/message';


export const UserMessageExtra: RenderMessageExtra = memo<ChatMessage>(({ extra, id, content }) => {
  const loading = useChatStore(chatSelectors.isMessageGenerating(id));

  const showTranslate = !!extra?.translate;
  const showTTS = !!extra?.tts;

  const showExtra = showTranslate || showTTS;

  if (!showExtra) return;

  return (
    <div style={{ marginTop: 8 }}>
      {extra?.tts && (
        <ExtraContainer>
          <TTS content={content} id={id} loading={loading} {...extra?.tts} />
        </ExtraContainer>
      )}
      {extra?.translate && (
        <ExtraContainer>
          <Translate id={id} {...extra?.translate} loading={loading} />
        </ExtraContainer>
      )}
    </div>
  );
});
