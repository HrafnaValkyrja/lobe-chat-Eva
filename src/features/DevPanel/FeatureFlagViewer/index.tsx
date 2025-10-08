import FeatureFlagForm from './Form';

import { getServerFeatureFlagsValue } from '@/config/featureFlags';


const FeatureFlagViewer = () => {
  const serverFeatureFlags = getServerFeatureFlagsValue();

  return <FeatureFlagForm flags={serverFeatureFlags} />;
};

export default FeatureFlagViewer;
