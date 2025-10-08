
import Client from './Client';
import Server from './Server';

import { isServerMode } from '@/const/version';

const ScreenLoading = () => (isServerMode ? <Server /> : <Client />);

ScreenLoading.displayName = 'ScreenLoading';

export default ScreenLoading;
