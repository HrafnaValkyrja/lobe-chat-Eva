
import { RenderAction } from '../types';

import { AssistantActionsBar } from './Assistant';
import { DefaultActionsBar } from './Fallback';
import { ToolActionsBar } from './Tool';
import { UserActionsBar } from './User';

import { MessageRoleType } from '@/types/message';

export const renderActions: Record<MessageRoleType, RenderAction> = {
  assistant: AssistantActionsBar,
  system: DefaultActionsBar,
  tool: ToolActionsBar,
  user: UserActionsBar,
};
