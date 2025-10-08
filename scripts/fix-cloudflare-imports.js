/**
 * Webpack plugin to fix dynamic import issues for Cloudflare Workers
 * This plugin replaces problematic dynamic imports with empty modules
 */

class CloudflareImportFixPlugin {
  constructor() {
    this.name = 'CloudflareImportFixPlugin';
  }

  apply(compiler) {
    compiler.hooks.compilation.tap(this.name, (compilation) => {
      compilation.hooks.optimizeChunkAssets.tap(this.name, (chunks) => {
        for (const chunk of chunks) {
          if (!chunk.canBeInitial()) continue;

          for (const file of chunk.files) {
            if (!file.endsWith('.js')) continue;

            const asset = compilation.assets[file];
            if (!asset) continue;

            let source = asset.source();
            
            // Replace problematic dynamic imports with empty modules
            const importReplacements = [
              // PDF.js dynamic imports
              { pattern: /await import\("\.\/empty-[^"]+\.js"\)/g, replacement: 'Promise.resolve({})' },
              { pattern: /await import\("\.\/index-[^"]+\.js"\)\.then\([^)]+\)/g, replacement: 'Promise.resolve({})' },
              { pattern: /await import\("\.\/url-[^"]+\.js"\)\.then\([^)]+\)/g, replacement: 'Promise.resolve({})' },
              
              // SystemJS dynamic imports
              { pattern: /system\.import\([^)]+\)/g, replacement: 'Promise.resolve({})' },
              
              // Other problematic dynamic imports
              { pattern: /import\([^)]*pglite[^)]*\)/g, replacement: 'Promise.resolve({})' },
              { pattern: /import\([^)]*systemjs[^)]*\)/g, replacement: 'Promise.resolve({})' },
            ];

            let modified = false;
            for (const { pattern, replacement } of importReplacements) {
              if (pattern.test(source)) {
                source = source.replace(pattern, replacement);
                modified = true;
              }
            }

            if (modified) {
              compilation.assets[file] = {
                source: () => source,
                size: () => source.length,
              };
            }
          }
        }
      });
    });
  }
}

module.exports = CloudflareImportFixPlugin;
