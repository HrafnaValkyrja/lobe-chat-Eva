import { StateCreator } from 'zustand/vanilla';


import { RAGEvalDatasetAction, createRagEvalDatasetSlice } from './dataset';
import { RAGEvalEvaluationAction, createRagEvalEvaluationSlice } from './evaluation';

import { KnowledgeBaseStore } from '@/store/knowledgeBase/store';

export interface RAGEvalAction extends RAGEvalDatasetAction, RAGEvalEvaluationAction {
  // empty
}

export const createRagEvalSlice: StateCreator<
  KnowledgeBaseStore,
  [['zustand/devtools', never]],
  [],
  RAGEvalAction
> = (...params) => ({
  ...createRagEvalDatasetSlice(...params),
  ...createRagEvalEvaluationSlice(...params),
});
