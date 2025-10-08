import { ReactNode, memo } from 'react';

import { Provider, createStore } from './store';
import StoreUpdater, { StoreUpdaterProps } from './StoreUpdater';

interface AgentSettingsProps extends StoreUpdaterProps {
  children: ReactNode;
}

export const AgentSettingsProvider = memo<AgentSettingsProps>(({ children, ...props }) => {
  return (
    <Provider createStore={createStore}>
      <StoreUpdater {...props} />
      {children}
    </Provider>
  );
});
