import { memo } from 'react';

import Select from '../../../components/SizeSelect';

import { useGenerationConfigParam } from '@/store/image/slices/generationConfig/hooks';


const SizeSelect = memo(() => {
  const { value, setValue, enumValues } = useGenerationConfigParam('size');
  const options = enumValues!.map((size) => ({
    label: size,
    value: size,
  }));

  return <Select onChange={setValue} options={options} value={value} />;
});

export default SizeSelect;
