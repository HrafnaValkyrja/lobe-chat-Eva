import JsonViewer from './JsonViewer';

import { useAiInfraStore } from '@/store/aiInfra';


const AiProviderRuntimeConfig = () => {
  const aiProviderRuntimeConfig = useAiInfraStore((s) => s.aiProviderRuntimeConfig);

  return <JsonViewer data={aiProviderRuntimeConfig} />;
};

export default AiProviderRuntimeConfig;
