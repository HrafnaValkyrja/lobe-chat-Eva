
import { createRemarkCustomTagPlugin } from '../remarkPlugins/createRemarkCustomTagPlugin';
import { MarkdownElement } from '../type';

import Component from './Render';

import { ARTIFACT_THINKING_TAG } from '@/const/plugin';

const LobeThinkingElement: MarkdownElement = {
  Component,
  remarkPlugin: createRemarkCustomTagPlugin(ARTIFACT_THINKING_TAG),
  tag: ARTIFACT_THINKING_TAG,
};

export default LobeThinkingElement;
