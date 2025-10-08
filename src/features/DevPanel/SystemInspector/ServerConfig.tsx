import JsonViewer from './JsonViewer';

import { useServerConfigStore } from '@/store/serverConfig';


export const ServerConfig = () => {
  const serverConfig = useServerConfigStore((s) => s.serverConfig);

  return <JsonViewer data={serverConfig} />;
};

export const SystemAgent = () => {
  const serverConfig = useServerConfigStore((s) => s.serverConfig);

  return <JsonViewer data={serverConfig.systemAgent || {}} />;
};

export const DefaultAgentConfig = () => {
  const serverConfig = useServerConfigStore((s) => s.serverConfig);

  return <JsonViewer data={serverConfig.defaultAgent || {}} />;
};

export const AIProvider = () => {
  const serverConfig = useServerConfigStore((s) => s.serverConfig);

  return <JsonViewer data={serverConfig.aiProvider || {}} />;
};
