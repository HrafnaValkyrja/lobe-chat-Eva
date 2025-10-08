import { ControllerModule, ipcClientEvent } from '.';

import { ShortcutUpdateResult } from '@/core/ui/ShortcutManager';


export default class ShortcutController extends ControllerModule {
  /**
   * 获取所有快捷键配置
   */
  @ipcClientEvent('getShortcutsConfig')
  getShortcutsConfig() {
    return this.app.shortcutManager.getShortcutsConfig();
  }

  /**
   * 更新单个快捷键配置
   */
  @ipcClientEvent('updateShortcutConfig')
  updateShortcutConfig({
    id,
    accelerator,
  }: {
    accelerator: string;
    id: string;
  }): ShortcutUpdateResult {
    return this.app.shortcutManager.updateShortcutConfig(id, accelerator);
  }
}
