import { EPubLoader as Loader } from '@langchain/community/document_loaders/fs/epub';
import { RecursiveCharacterTextSplitter } from 'langchain/text_splitter';

import { loaderConfig } from '../config';

import { TempFileManager } from '@/server/utils/tempFileManager';
import { nanoid } from '@/utils/uuid';


export const EPubLoader = async (content: Uint8Array) => {
  const tempManager = new TempFileManager('epub-');

  try {
    const tempPath = await tempManager.writeTempFile(content, `${nanoid()}.epub`);
    const loader = new Loader(tempPath);
    const documents = await loader.load();

    const splitter = new RecursiveCharacterTextSplitter(loaderConfig);
    return await splitter.splitDocuments(documents);
  } catch (e) {
    throw new Error(`EPubLoader error: ${(e as Error).message}`);
  } finally {
    tempManager.cleanup(); // 确保清理
  }
};
