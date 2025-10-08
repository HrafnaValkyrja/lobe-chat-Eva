'use client';

import { useTranslation } from 'react-i18next';

import ProviderDetail from '../default';

import { NewAPIProviderCard } from '@/config/modelProviders';


const Page = () => {
  const { t } = useTranslation('modelProvider');

  return (
    <ProviderDetail
      {...NewAPIProviderCard}
      settings={{
        ...NewAPIProviderCard.settings,
        proxyUrl: {
          desc: t('newapi.apiUrl.desc'),
          placeholder: 'https://any-newapi-provider.com/',
          title: t('newapi.apiUrl.title'),
        },
      }}
    />
  );
};

export default Page;
