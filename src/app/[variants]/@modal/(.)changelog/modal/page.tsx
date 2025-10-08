import { notFound } from 'next/navigation';
import { Suspense } from 'react';

import Post from './features/Post';
import UpdateChangelogStatus from './features/UpdateChangelogStatus';
import Loading from './loading';

import { serverFeatureFlags } from '@/config/featureFlags';
import { ChangelogService } from '@/server/services/changelog';
import { DynamicLayoutProps } from '@/types/next';
import { RouteVariants } from '@/utils/server/routeVariants';


const Page = async (props: DynamicLayoutProps) => {
  const hideDocs = serverFeatureFlags().hideDocs;
  if (hideDocs) return notFound();

  const { locale, isMobile } = await RouteVariants.getVariantsFromProps(props);

  const changelogService = new ChangelogService();
  const data = await changelogService.getChangelogIndex();

  if (!data) return notFound();

  return (
    <>
      {data?.map((item) => (
        <Suspense fallback={<Loading />} key={item.id}>
          <Post locale={locale as any} mobile={isMobile} {...item} />
        </Suspense>
      ))}
      <UpdateChangelogStatus currentId={data[0]?.id} />
    </>
  );
};

Page.displayName = 'ChangelogModal';

export default Page;
