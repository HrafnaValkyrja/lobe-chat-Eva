import { LobeHub, LobeHubProps } from '@lobehub/ui/brand';
import { memo } from 'react';

import CustomLogo from './Custom';

import { isCustomBranding } from '@/const/version';


interface ProductLogoProps extends LobeHubProps {
  height?: number;
  width?: number;
}

export const ProductLogo = memo<ProductLogoProps>((props) => {
  if (isCustomBranding) {
    return <CustomLogo {...props} />;
  }

  return <LobeHub {...props} />;
});
