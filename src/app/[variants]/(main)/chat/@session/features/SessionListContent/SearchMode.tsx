import { memo } from 'react';


import SkeletonList from '../SkeletonList';

import SessionList from './List';

import { useSessionStore } from '@/store/session';

const SearchMode = memo(() => {
  const [sessionSearchKeywords, useSearchSessions] = useSessionStore((s) => [
    s.sessionSearchKeywords,
    s.useSearchSessions,
  ]);

  const { data, isLoading } = useSearchSessions(sessionSearchKeywords);

  return isLoading ? <SkeletonList /> : <SessionList dataSource={data} showAddButton={false} />;
});

SearchMode.displayName = 'SessionSearchMode';

export default SearchMode;
