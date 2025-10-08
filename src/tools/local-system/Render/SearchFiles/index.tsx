import { LocalSearchFilesParams } from '@lobechat/electron-client-ipc';
import { memo } from 'react';

import SearchResult from './Result';
import SearchQuery from './SearchQuery';

import { LocalFileSearchState } from '@/tools/local-system/type';
import { ChatMessagePluginError } from '@/types/message';


interface SearchFilesProps {
  args: LocalSearchFilesParams;
  messageId: string;
  pluginError: ChatMessagePluginError;
  pluginState?: LocalFileSearchState;
}

const SearchFiles = memo<SearchFilesProps>(({ messageId, pluginError, args, pluginState }) => {
  return (
    <>
      <SearchQuery args={args} messageId={messageId} pluginState={pluginState} />
      <SearchResult
        messageId={messageId}
        pluginError={pluginError}
        searchResults={pluginState?.searchResults}
      />
    </>
  );
});

SearchFiles.displayName = 'SearchFiles';

export default SearchFiles;
