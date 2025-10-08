import { memo } from 'react';
import { useTranslation } from 'react-i18next';

import InputNumber from '../../../components/SeedNumberInput';

import { useGenerationConfigParam } from '@/store/image/slices/generationConfig/hooks';


const SeedNumberInput = memo(() => {
  const { t } = useTranslation('image');
  const { value, setValue } = useGenerationConfigParam('seed');

  return <InputNumber onChange={setValue} placeholder={t('config.seed.random')} value={value} />;
});

export default SeedNumberInput;
