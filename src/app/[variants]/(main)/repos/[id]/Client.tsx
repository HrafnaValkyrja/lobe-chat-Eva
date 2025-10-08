'use client';

import { memo } from 'react';
import { Flexbox } from 'react-layout-kit';

import Menu from './features/Menu';
import { useKnowledgeBaseItem } from './hooks/useKnowledgeItem';

import FileManager from '@/features/FileManager';
import FilePanel from '@/features/FileSidePanel';
import { knowledgeBaseSelectors, useKnowledgeBaseStore } from '@/store/knowledgeBase';


const RepoClientPage = memo<{ id: string }>(({ id }) => {
  useKnowledgeBaseItem(id);
  const name = useKnowledgeBaseStore(knowledgeBaseSelectors.getKnowledgeBaseNameById(id));

  return (
    <>
      <FilePanel>
        <Menu id={id} />
      </FilePanel>
      <Flexbox flex={1} style={{ overflow: 'hidden', position: 'relative' }}>
        <FileManager knowledgeBaseId={id} title={name} />
      </Flexbox>
    </>
  );
});

export default RepoClientPage;
