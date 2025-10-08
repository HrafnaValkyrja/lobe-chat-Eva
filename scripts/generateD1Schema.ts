import { readFileSync, writeFileSync } from 'fs';
import { join } from 'path';
import { glob } from 'glob';

/**
 * Generate a combined SQL schema file for D1 database
 * This script reads all migration files and combines them, adapting for D1 compatibility
 */

const migrationsDir = join(__dirname, '../packages/database/migrations');
const outputFile = join(__dirname, '../packages/database/migrations/combined.sql');

async function generateD1Schema() {
  try {
    // Get all SQL migration files sorted by name
    const migrationFiles = await glob('*.sql', { 
      cwd: migrationsDir,
      ignore: ['combined.sql', 'meta/**']
    });
    
    migrationFiles.sort(); // Sort alphabetically to maintain order
    
    console.log(`Found ${migrationFiles.length} migration files`);
    
    let combinedSQL = `-- Combined D1 Schema for LobeChat Eva
-- Generated from ${migrationFiles.length} migration files
-- Date: ${new Date().toISOString()}

`;

    for (const file of migrationFiles) {
      const filePath = join(migrationsDir, file);
      const content = readFileSync(filePath, 'utf-8');
      
      console.log(`Processing ${file}...`);
      
      // Adapt PostgreSQL-specific syntax for D1
      let adaptedContent = content
        // Remove PostgreSQL-specific extensions
        .replace(/CREATE EXTENSION IF NOT EXISTS vector;[\r\n]*/g, '')
        .replace(/CREATE EXTENSION IF NOT EXISTS "uuid-ossp";[\r\n]*/g, '')
        
        // Replace PostgreSQL-specific types with D1 equivalents
        .replace(/jsonb/g, 'text') // D1 stores JSON as text
        .replace(/uuid/g, 'text') // D1 doesn't have native UUID type
        .replace(/timestamp with time zone/g, 'integer') // D1 uses integer for timestamps
        .replace(/timestamp without time zone/g, 'integer')
        .replace(/varchar\(\d+\)/g, 'text') // D1 doesn't have varchar length limits
        
        // Replace PostgreSQL-specific functions
        .replace(/DEFAULT now\(\)/g, 'DEFAULT (unixepoch())') // Use unixepoch() for timestamps
        .replace(/DEFAULT '{}'::jsonb/g, "DEFAULT '{}'") // Remove PostgreSQL type casting
        
        // Remove statement breakpoints (D1 doesn't need them)
        .replace(/--> statement-breakpoint[\r\n]*/g, '\n')
        
        // Clean up multiple newlines
        .replace(/\n\s*\n\s*\n/g, '\n\n');

      combinedSQL += `-- Migration: ${file}\n${adaptedContent}\n\n`;
    }

    // Add D1-specific optimizations and constraints
    combinedSQL += `-- D1-specific optimizations
-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_messages_user_id_created_at ON messages(user_id, created_at);
CREATE INDEX IF NOT EXISTS idx_messages_topic_id_created_at ON messages(topic_id, created_at);
CREATE INDEX IF NOT EXISTS idx_messages_session_id_created_at ON messages(session_id, created_at);
CREATE INDEX IF NOT EXISTS idx_topics_user_id_created_at ON topics(user_id, created_at);
CREATE INDEX IF NOT EXISTS idx_sessions_user_id_created_at ON sessions(user_id, created_at);

-- Create indexes for client_id lookups
CREATE INDEX IF NOT EXISTS idx_messages_client_id ON messages(client_id);
CREATE INDEX IF NOT EXISTS idx_topics_client_id ON topics(client_id);
CREATE INDEX IF NOT EXISTS idx_sessions_client_id ON sessions(client_id);
`;

    writeFileSync(outputFile, combinedSQL);
    console.log(`✅ Combined D1 schema written to ${outputFile}`);
    console.log(`📊 Total size: ${combinedSQL.length} characters`);
    
  } catch (error) {
    console.error('❌ Error generating D1 schema:', error);
    process.exit(1);
  }
}

generateD1Schema();
