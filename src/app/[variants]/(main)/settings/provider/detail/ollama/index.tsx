'use client';

import { useTranslation } from 'react-i18next';


import ProviderDetail from '../default';

import CheckError from './CheckError';

import { OllamaProviderCard } from '@/config/modelProviders';

const Page = () => {
  const { t } = useTranslation('modelProvider');

  return (
    <ProviderDetail
      {...OllamaProviderCard}
      checkErrorRender={CheckError}
      settings={{
        ...OllamaProviderCard.settings,
        proxyUrl: {
          desc: t('ollama.endpoint.desc'),
          placeholder: 'http://127.0.0.1:11434',
          title: t('ollama.endpoint.title'),
        },
      }}
    />
  );
};

export default Page;
