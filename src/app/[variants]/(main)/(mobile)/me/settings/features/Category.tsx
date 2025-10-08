'use client';

import { memo } from 'react';

import { useCategory } from './useCategory';

import Cell from '@/components/Cell';


const Category = memo(() => {
  const items = useCategory();

  return items?.map(({ key, ...item }, index) => <Cell key={key || index} {...item} />);
});

export default Category;
