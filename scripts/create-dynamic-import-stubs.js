/**
 * Script to create stub files for problematic dynamic imports
 * This runs after the Next.js build but before the OpenNext Cloudflare build
 */

const fs = require('fs');
const path = require('path');

// List of problematic dynamic import files
const stubFiles = [
  'empty-GlqisfcO.js',
  'index-B0Gk_P0t.js', 
  'index-rMqNZYyA.js',
  'url-Bs332b_7.js'
];

// Create empty stub files
const chunksDir = path.join(__dirname, '..', '.open-next', 'server-functions', 'default', '.next', 'server', 'chunks');

// Ensure directory exists
if (!fs.existsSync(chunksDir)) {
  fs.mkdirSync(chunksDir, { recursive: true });
}

// Create stub files
for (const fileName of stubFiles) {
  const filePath = path.join(chunksDir, fileName);
  if (!fs.existsSync(filePath)) {
    // Create a minimal stub that exports empty objects
    const stubContent = `// Stub file for Cloudflare Workers compatibility
export default {};
export const i = {};
export const u = {};
`;
    fs.writeFileSync(filePath, stubContent);
    console.log(`Created stub file: ${fileName}`);
  }
}

console.log('Dynamic import stubs created successfully');
