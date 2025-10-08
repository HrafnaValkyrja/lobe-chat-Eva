import { LOBE_CHAT_ACCESS_CODE, OPENAI_API_KEY_HEADER_KEY, OPENAI_END_POINT } from '@/const/fetch';
import { useUserStore } from '@/store/user';
import { keyVaultsConfigSelectors } from '@/store/user/selectors';

/**
 * TODO: Need to be removed after tts refactor
 * @deprecated
 */
 
export const createHeaderWithOpenAI = (header?: HeadersInit): HeadersInit => {
  const openai = keyVaultsConfigSelectors.openAIConfig(useUserStore.getState());

  const apiKey = openai.apiKey || '';
  const endpoint = openai.baseURL || '';

   
  return {
    ...header,
    [LOBE_CHAT_ACCESS_CODE]: keyVaultsConfigSelectors.password(useUserStore.getState()),
    [OPENAI_API_KEY_HEADER_KEY]: apiKey,
    [OPENAI_END_POINT]: endpoint,
  };
};
