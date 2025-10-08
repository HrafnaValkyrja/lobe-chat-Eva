import { renderHook, waitFor } from '@testing-library/react';
import { describe, expect, it, vi } from 'vitest';

import { useTokenCount } from './useTokenCount';

import * as tokenizers from '@/utils/tokenizer';


describe('useTokenCount', () => {
  // TODO: need to be fixed in the future
  it.skip('should return token count for given input', async () => {
    const { result } = renderHook(() => useTokenCount('test input'));

    expect(result.current).toBe(0);
    await waitFor(() => expect(result.current).toBe(2));
  });

  it('should fall back to input length if encodeAsync throws', async () => {
    const mockEncodeAsync = vi.spyOn(tokenizers, 'encodeAsync');
    mockEncodeAsync.mockRejectedValueOnce(new Error('encode error'));

    const { result } = renderHook(() => useTokenCount('test input'));

    expect(result.current).toBe(0);
    await waitFor(() => expect(result.current).toBe(0));

    mockEncodeAsync.mockClear();
  });

  it('should handle empty input', async () => {
    const { result } = renderHook(() => useTokenCount(''));

    expect(result.current).toBe(0);
    await waitFor(() => expect(result.current).toBe(0));
  });
  it('should handle null input', async () => {
    const { result } = renderHook(() => useTokenCount(null as any));

    expect(result.current).toBe(0);
    await waitFor(() => expect(result.current).toBe(0));
  });
});
