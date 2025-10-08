<!-- 755f77e1-accb-469f-9274-e88cc01da8d5 659c4880-3b0e-4202-9914-5feb14e2260a -->
# Cloudflare Workers + D1 Migration Plan

## Current Issues

The `preview:cloudflare` error occurs because OpenNext Cloudflare doesn't support mixed edge/Node.js runtime routes. Five routes currently use `runtime = 'edge'`:

- `src/app/(backend)/webapi/chat/azureai/route.ts`
- `src/app/(backend)/webapi/tts/openai/route.ts`
- `src/app/(backend)/webapi/tts/edge/route.ts`
- `src/app/(backend)/webapi/tts/microsoft/route.ts`
- `src/app/(backend)/webapi/stt/openai/route.ts`

## Solution Overview

1. **Fix edge runtime incompatibility** - Remove or convert edge runtime declarations
2. **Add D1 database driver support** - Extend Drizzle configuration for D1
3. **Create Wrangler configuration** - Enable local D1 testing
4. **Update database adapter** - Add D1 as a database driver option
5. **Configure environment variables** - Set up Cloudflare-specific env handling
6. **Prepare Discord integration structure** - Design topic-based isolation for Discord context

## Implementation Steps

### 1. Fix Edge Runtime Routes

Remove `export const runtime = 'edge'` from the five routes listed above. Cloudflare Workers already runs on edge infrastructure, so these declarations are redundant and cause OpenNext build failures.

**Files to modify:**

- `src/app/(backend)/webapi/chat/azureai/route.ts`
- `src/app/(backend)/webapi/tts/openai/route.ts`
- `src/app/(backend)/webapi/tts/edge/route.ts`
- `src/app/(backend)/webapi/tts/microsoft/route.ts`
- `src/app/(backend)/webapi/stt/openai/route.ts`

### 2. Add D1 Database Support

**Create D1 driver in** `packages/database/src/core/d1.ts`:

```typescript
import { drizzle } from 'drizzle-orm/d1';
import * as schema from '../schemas';
import { LobeChatDatabase } from '../type';

export const getD1Instance = (d1Binding: D1Database): LobeChatDatabase => {
  return drizzle(d1Binding, { schema });
};
```

**Update** `src/config/db.ts`:

- Add `'d1'` to the `DATABASE_DRIVER` enum
- Add D1-specific configuration validation

**Update** `packages/database/src/core/db-adaptor.ts`:

- Add logic to detect Cloudflare Workers environment
- Initialize D1 binding when available

### 3. Create Wrangler Configuration

**Create** `wrangler.toml` in project root:

```toml
name = "lobe-chat-eva"
main = ".worker-next/index.mjs"
compatibility_date = "2025-10-08"

[[d1_databases]]
binding = "DB"
database_name = "lobe-chat-eva"
database_id = "local-db-for-testing"

[[r2_buckets]]
binding = "ASSETS"
bucket_name = "lobe-chat-assets"
```

This enables local D1 testing with `wrangler dev` or `wrangler pages dev`.

### 4. Create Local D1 Schema

Run locally to create D1 database structure:

```bash
wrangler d1 create lobe-chat-eva --local
wrangler d1 execute lobe-chat-eva --local --file=packages/database/migrations/combined.sql
```

**Generate combined migration file** from existing Drizzle migrations in `packages/database/migrations/`.

### 5. Update Open-Next Configuration

**Update** `open-next.config.ts`:

- Configure D1 binding access
- Set up proper environment variable handling for Cloudflare
- Ensure R2 bucket binding for file storage

### 6. Environment Variable Strategy

**Cloudflare-specific considerations:**

- Environment variables set via `wrangler.toml` for local dev
- Production vars set via Cloudflare dashboard or `wrangler secret put`
- Update `.env.example` with Cloudflare-specific variables

**Key variables needed:**

- `DATABASE_DRIVER=d1`
- `NEXT_PUBLIC_SERVICE_MODE=server`
- `KEY_VAULTS_SECRET` (for encryption)
- Model API keys (OpenAI, Anthropic, etc.)

### 7. Discord Bot Integration Preparation

**Database structure already supports this:**

- Messages are isolated by `topicId` in the `messages` table
- Discord bot will create separate topics for Discord conversations
- Shared `userId` enables cross-context memory access

**Implementation approach:**

- Discord bot runs as separate Worker (or same Worker, different route)
- Bot creates topics with metadata: `{ source: 'discord', channelId, guildId }`
- When generating responses, can query messages across topics for context
- D1 enables both instances to read/write same database

### 8. Testing Strategy

**Local testing:**

```bash
pnpm run build:cloudflare
wrangler pages dev .worker-next --d1 DB=local-db --compatibility-date=2025-10-08
```

**Validation checklist:**

- ✓ Chat message creation persists to D1
- ✓ Topic creation/switching works
- ✓ Message history loads correctly
- ✓ Environment variables accessible
- ✓ API routes respond correctly

## Migration Deployment Steps

1. Create D1 database in Cloudflare dashboard
2. Run migrations against production D1
3. Set environment secrets via `wrangler secret put`
4. Deploy: `pnpm run deploy:cloudflare`
5. Verify deployment in Cloudflare dashboard

## Discord Bot Next Steps (Future)

After core migration:

1. Create Discord bot endpoint in `src/app/(backend)/webhook/discord/route.ts`
2. Implement message event handlers
3. Create topic on first Discord message in a channel
4. Store Discord messages with proper metadata
5. Generate AI responses using shared message context from D1

## Files to Create/Modify

**New files:**

- `wrangler.toml` - Cloudflare Workers configuration
- `packages/database/src/core/d1.ts` - D1 database driver
- `packages/database/migrations/combined.sql` - Combined migration for D1
- `.dev.vars` - Local Wrangler environment variables

**Modified files:**

- `src/config/db.ts` - Add D1 driver support
- `packages/database/src/core/db-adaptor.ts` - Add D1 detection
- `open-next.config.ts` - Configure bindings
- 5 edge runtime route files - Remove edge runtime declarations

### To-dos

- [ ] Remove edge runtime declarations from 5 API routes to fix OpenNext build error
- [ ] Create D1 database driver and integrate with db-adaptor
- [ ] Create wrangler.toml and .dev.vars for local D1 testing
- [ ] Update database configuration to support D1 driver option
- [ ] Generate combined SQL migration file and initialize D1 schema
- [ ] Test build:cloudflare and preview:cloudflare commands
- [ ] Document Discord bot integration approach with topic-based isolation