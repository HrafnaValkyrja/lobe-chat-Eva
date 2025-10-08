import { ModelProvider } from 'model-bank';

import { API_ENDPOINTS } from './_url';

import { createHeaderWithAuth } from '@/services/_auth';
import { OpenAIImagePayload } from '@/types/openai/image';


interface FetchOptions {
  signal?: AbortSignal | undefined;
}

class ImageGenerationService {
  generateImage = async (
    params: Omit<OpenAIImagePayload, 'model' | 'n'>,
    options?: FetchOptions,
  ) => {
    const payload: OpenAIImagePayload = { ...params, model: 'dall-e-3', n: 1 };

    const provider = ModelProvider.OpenAI;

    const headers = await createHeaderWithAuth({
      headers: { 'Content-Type': 'application/json' },
      provider,
    });

    const res = await fetch(API_ENDPOINTS.images(provider), {
      body: JSON.stringify(payload),
      headers: headers,
      method: 'POST',
      signal: options?.signal,
    });
    if (!res.ok) {
      throw await res.json();
    }

    const urls = await res.json();

    return urls[0] as string;
  };
}

export const imageGenerationService = new ImageGenerationService();
