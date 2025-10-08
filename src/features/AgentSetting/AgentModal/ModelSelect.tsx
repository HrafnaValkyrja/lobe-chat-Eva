import { memo } from 'react';

import { useStore } from '../store';

import Select from '@/features/ModelSelect';


const ModelSelect = memo(() => {
  const [model, provider, updateConfig] = useStore((s) => [
    s.config.model,
    s.config.provider,
    s.setAgentConfig,
  ]);

  return (
    <Select
      onChange={(props) => {
        updateConfig(props);
      }}
      value={{ model, provider }}
    />
  );
});

export default ModelSelect;
