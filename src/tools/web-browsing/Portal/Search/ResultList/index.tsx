import React, { memo, useCallback } from 'react';
import { Virtuoso } from 'react-virtuoso';

import Item from './SearchItem';

import { UniformSearchResult } from '@/types/tool/search';


interface ResultListProps {
  dataSources: UniformSearchResult[];
}

const ResultList = memo<ResultListProps>(({ dataSources }) => {
  const itemContent = useCallback(
    (index: number, result: UniformSearchResult) => <Item {...result} highlight={index < 15} />,
    [],
  );

  return <Virtuoso data={dataSources} height={'100%'} itemContent={itemContent} />;
});

export default ResultList;
