import ClientMode from './ClientMode';
import ServerMode from './ServerMode';

import { isServerMode } from '@/const/version';
import { featureFlagsSelectors, useServerConfigStore } from '@/store/serverConfig';


const Upload = () => {
  const { enableKnowledgeBase } = useServerConfigStore(featureFlagsSelectors);
  return isServerMode && enableKnowledgeBase ? <ServerMode /> : <ClientMode />;
};

export default Upload;
