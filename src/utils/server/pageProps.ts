import { RouteVariants } from './routeVariants';

import { translation } from '@/server/translation';
import { DynamicLayoutProps } from '@/types/next';


export const parsePageMetaProps = async (props: DynamicLayoutProps) => {
  const { locale: hl, isMobile } = await RouteVariants.getVariantsFromProps(props);
  const { t, locale } = await translation('metadata', hl);
  return { isMobile, locale, t };
};
