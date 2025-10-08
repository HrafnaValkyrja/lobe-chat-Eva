import { Suspense } from 'react';

import CategoryContent from './features/CategoryContent';

import SkeletonLoading from '@/components/Loading/SkeletonLoading';


const Category = () => {
  return (
    <Suspense fallback={<SkeletonLoading paragraph={{ rows: 7 }} title={false} />}>
      <CategoryContent />
    </Suspense>
  );
};

Category.displayName = 'SettingCategory';

export default Category;
