import Client from './Client';

import { PagePropsWithId } from '@/types/next';


export default async (props: PagePropsWithId) => {
  const params = await props.params;

  return <Client id={params.id} />;
};
