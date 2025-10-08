'use client';

import { ProviderItem } from '../../type';

import { OpenAIProviderCard } from '@/config/modelProviders';
import { featureFlagsSelectors, useServerConfigStore } from '@/store/serverConfig';


export const useOpenAIProvider = (): ProviderItem => {
  const { showOpenAIProxyUrl, showOpenAIApiKey } = useServerConfigStore(featureFlagsSelectors);
  return {
    ...OpenAIProviderCard,
    proxyUrl: showOpenAIProxyUrl && {
      placeholder: 'https://api.openai.com/v1',
    },
    showApiKey: showOpenAIApiKey,
  };
};
