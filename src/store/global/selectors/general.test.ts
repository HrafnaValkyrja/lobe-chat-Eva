import { globalGeneralSelectors } from './general';

import { GlobalState, initialState } from '@/store/global/initialState';
import { merge } from '@/utils/merge';


describe('settingsSelectors', () => {
  describe('currentLanguage', () => {
    it('should return the correct language setting', () => {
      const s: GlobalState = merge(initialState, {
        status: { language: 'fr' },
      });

      const result = globalGeneralSelectors.currentLanguage(s);

      expect(result).toBe('fr');
    });
  });
});
