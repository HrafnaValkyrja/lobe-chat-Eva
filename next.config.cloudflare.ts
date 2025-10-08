import type { NextConfig } from 'next';

/**
 * Cloudflare-specific Next.js configuration
 * This configuration is used when building for Cloudflare Workers deployment
 */

const cloudflareConfig: NextConfig = {
  // Use standalone output for Cloudflare Workers
  output: 'standalone',
  
  // Disable features that don't work well with Cloudflare Workers
  experimental: {
    // Disable server minification to avoid dynamic import issues
    serverMinification: false,
    // Disable webpack memory optimizations that can cause issues
    webpackMemoryOptimizations: false,
  },
  
  // Webpack configuration for Cloudflare Workers
  webpack(config, { isServer }) {
    if (isServer) {
      // Exclude problematic modules from server bundle
      config.externals = config.externals || [];
      config.externals.push({
        // Exclude PGlite and related modules that don't work in Cloudflare Workers
        '@electric-sql/pglite': 'commonjs @electric-sql/pglite',
        '@electric-sql/pglite/vector': 'commonjs @electric-sql/pglite/vector',
        // Exclude SystemJS dynamic imports
        'systemjs': 'commonjs systemjs',
      });
      
      // Disable dynamic imports that cause issues
      config.resolve.fallback = {
        ...config.resolve.fallback,
        // Disable problematic fallbacks
        fs: false,
        path: false,
        crypto: false,
        stream: false,
        util: false,
        buffer: false,
        process: false,
        // Disable PGlite specific fallbacks
        'pglite': false,
        'pglite/vector': false,
      };
      
      // Ignore dynamic imports that can't be resolved
      config.module.rules.push({
        test: /\.(js|mjs)$/,
        use: {
          loader: 'ignore-loader',
        },
        include: [
          /node_modules\/@electric-sql\/pglite/,
          /node_modules\/systemjs/,
        ],
      });
    }
    
    return config;
  },
  
  // Disable TypeScript checking during build
  typescript: {
    ignoreBuildErrors: true,
  },
  
  // Disable ESLint during build
  eslint: {
    ignoreDuringBuilds: true,
  },
};

export default cloudflareConfig;
