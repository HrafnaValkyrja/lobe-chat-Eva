import { memo } from 'react';

import APIKeyForm from './APIKeyForm';

import { ErrorActionContainer } from '@/features/Conversation/Error/style';


interface InvalidAPIKeyProps {
  bedrockDescription: string;
  description: string;
  id: string;
  onClose: () => void;
  onRecreate: () => void;
  provider?: string;
}
const InvalidAPIKey = memo<InvalidAPIKeyProps>(
  ({ id, provider, description, bedrockDescription, onRecreate, onClose }) => (
    <ErrorActionContainer>
      <APIKeyForm
        bedrockDescription={bedrockDescription}
        description={description}
        id={id}
        onClose={onClose}
        onRecreate={onRecreate}
        provider={provider}
      />
    </ErrorActionContainer>
  ),
);

export default InvalidAPIKey;
