import type { LobeCustomStylish, LobeCustomToken } from '@lobehub/ui';
import 'antd-style';
import { AntdToken } from 'antd-style/lib/types/theme';

declare module 'antd-style' {
   
  export interface CustomToken extends LobeCustomToken {}
   
  export interface CustomStylish extends LobeCustomStylish {}
}

declare module 'styled-components' {
  export interface DefaultTheme extends AntdToken, LobeCustomToken {}
}
