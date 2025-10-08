# Discord Bot Integration Guide for LobeChat Eva

## Overview

This guide outlines how to integrate Discord bot functionality with LobeChat Eva using the existing topic-based message isolation system. The integration leverages D1 database for shared message persistence between the web app and Discord bot.

## Architecture

### Database Structure

LobeChat Eva already has a robust topic-based message isolation system that's perfect for Discord integration:

- **Messages Table**: Contains all messages with `topicId` for isolation
- **Topics Table**: Organizes conversations with metadata
- **Users Table**: Shared user identity across web and Discord

### Integration Approach

1. **Shared Database**: Both web app and Discord bot access the same D1 database
2. **Topic Isolation**: Discord conversations create separate topics with metadata
3. **Cross-Context Memory**: AI can access messages across topics for better context
4. **Separate Instances**: Discord bot can run as separate Cloudflare Worker or same Worker with different routes

## Implementation Plan

### Phase 1: Database Schema Extensions

The existing schema already supports Discord integration, but we can add Discord-specific metadata:

```sql
-- Add Discord metadata to topics table (if not already present)
ALTER TABLE topics ADD COLUMN metadata TEXT DEFAULT '{}';

-- Example topic metadata for Discord:
-- {
--   "source": "discord",
--   "channelId": "123456789",
--   "guildId": "987654321",
--   "discordUserId": "discord_user_123"
-- }
```

### Phase 2: Discord Bot Worker

Create a new Cloudflare Worker for Discord bot functionality:

**File Structure:**

```
src/app/(backend)/webhook/discord/
├── route.ts                    # Discord webhook endpoint
├── handlers/
│   ├── messageCreate.ts        # Handle new Discord messages
│   ├── messageUpdate.ts        # Handle message edits
│   └── messageDelete.ts        # Handle message deletions
├── services/
│   ├── discordApi.ts           # Discord API interactions
│   ├── topicManager.ts         # Topic creation/management
│   └── aiResponse.ts           # Generate AI responses
└── types/
    └── discord.ts              # Discord-specific types
```

### Phase 3: Topic Management

**Topic Creation Strategy:**

1. **Per-Channel Topics**: Create one topic per Discord channel
2. **Per-Thread Topics**: If Discord thread support is needed
3. **User-Specific Topics**: For DM conversations

**Topic Metadata Structure:**

```typescript
interface DiscordTopicMetadata {
  source: 'discord';
  channelId: string;
  guildId?: string;  // null for DMs
  discordUserId: string;
  channelName?: string;
  guildName?: string;
  createdAt: number;
  lastActivity: number;
}
```

### Phase 4: Message Flow

**Incoming Discord Message:**

1. Receive webhook from Discord
2. Validate webhook signature
3. Extract message content and metadata
4. Find or create topic for the channel
5. Store message in D1 database with topic association
6. Generate AI response (optional)
7. Send response back to Discord

**AI Response Generation:**

1. Query recent messages from the topic
2. Optionally query related topics for context
3. Generate response using LobeChat's AI infrastructure
4. Send response to Discord channel
5. Store AI response as new message

## Code Examples

### Discord Webhook Handler

```typescript
// src/app/(backend)/webhook/discord/route.ts
import { NextRequest } from 'next/server';
import { verifyDiscordWebhook } from './utils/verification';
import { handleMessageCreate } from './handlers/messageCreate';

export async function POST(req: NextRequest) {
  try {
    // Verify Discord webhook signature
    const isValid = await verifyDiscordWebhook(req);
    if (!isValid) {
      return new Response('Unauthorized', { status: 401 });
    }

    const interaction = await req.json();

    // Handle different Discord interaction types
    switch (interaction.type) {
      case 1: // PING
        return new Response(JSON.stringify({ type: 1 }), {
          headers: { 'Content-Type': 'application/json' }
        });
      
      case 2: // APPLICATION_COMMAND
        return await handleSlashCommand(interaction);
      
      default:
        return new Response('Unknown interaction type', { status: 400 });
    }
  } catch (error) {
    console.error('Discord webhook error:', error);
    return new Response('Internal Server Error', { status: 500 });
  }
}
```

### Topic Manager

```typescript
// src/app/(backend)/webhook/discord/services/topicManager.ts
import { getServerDB } from '@/database/core/db-adaptor';
import { topics } from '@/database/schemas/topic';
import { eq, and } from 'drizzle-orm';

export class DiscordTopicManager {
  private db = getServerDB();

  async findOrCreateDiscordTopic(
    channelId: string,
    guildId: string | null,
    discordUserId: string,
    channelName?: string
  ): Promise<string> {
    // Look for existing topic
    const existingTopic = await this.db
      .select()
      .from(topics)
      .where(
        and(
          eq(topics.userId, discordUserId),
          // Check if metadata contains this channel
          // This would need a custom query for JSON field matching
        )
      )
      .limit(1);

    if (existingTopic.length > 0) {
      return existingTopic[0].id;
    }

    // Create new topic
    const topicMetadata = {
      source: 'discord',
      channelId,
      guildId,
      discordUserId,
      channelName,
      createdAt: Date.now(),
      lastActivity: Date.now()
    };

    const newTopic = await this.db
      .insert(topics)
      .values({
        id: generateId(),
        userId: discordUserId,
        title: `Discord: ${channelName || 'Direct Message'}`,
        metadata: JSON.stringify(topicMetadata),
        createdAt: Date.now(),
        updatedAt: Date.now()
      })
      .returning();

    return newTopic[0].id;
  }
}
```

### AI Response Generator

```typescript
// src/app/(backend)/webhook/discord/services/aiResponse.ts
import { getServerDB } from '@/database/core/db-adaptor';
import { messages } from '@/database/schemas/message';
import { eq, desc } from 'drizzle-orm';

export class DiscordAIResponse {
  private db = getServerDB();

  async generateResponse(topicId: string, userMessage: string): Promise<string> {
    // Get recent message history for context
    const messageHistory = await this.db
      .select()
      .from(messages)
      .where(eq(messages.topicId, topicId))
      .orderBy(desc(messages.createdAt))
      .limit(10); // Last 10 messages for context

    // Use LobeChat's existing AI infrastructure
    // This would integrate with your existing chat generation logic
    const response = await this.callAIService({
      messages: messageHistory,
      newMessage: userMessage,
      context: 'discord'
    });

    return response;
  }

  private async callAIService(params: any): Promise<string> {
    // Integrate with existing LobeChat AI services
    // This would use your existing chat generation infrastructure
    return "AI response here";
  }
}
```

## Environment Variables

Add these to your `.dev.vars` and Cloudflare Workers environment:

```bash
# Discord Bot Configuration
DISCORD_APPLICATION_ID=your_discord_app_id
DISCORD_PUBLIC_KEY=your_discord_public_key
DISCORD_TOKEN=your_discord_bot_token
DISCORD_WEBHOOK_SECRET=your_webhook_secret

# Optional: Discord-specific settings
DISCORD_MAX_RESPONSE_LENGTH=2000
DISCORD_RESPONSE_TIMEOUT=3000
DISCORD_ENABLE_TYPING=true
```

## Deployment Steps

### 1. Set up Discord Application

1. Go to [Discord Developer Portal](https://discord.com/developers/applications)
2. Create new application
3. Add bot to application
4. Set up slash commands (optional)
5. Get bot token and application ID

### 2. Configure Cloudflare Workers

1. Add Discord environment variables to Cloudflare Workers
2. Set up webhook URL in Discord application
3. Deploy the Discord bot Worker

### 3. Database Setup

1. Ensure D1 database is set up and migrated
2. Test topic creation and message storage
3. Verify cross-topic message queries work

### 4. Testing

1. Test webhook verification
2. Test message storage in D1
3. Test AI response generation
4. Test Discord API integration

## Advanced Features

### Cross-Context Memory

To enable the AI to remember conversations across Discord and web:

```typescript
async getCrossContextMessages(userId: string, currentTopicId: string) {
  // Get messages from related topics (Discord + web)
  const relatedTopics = await this.db
    .select()
    .from(topics)
    .where(eq(topics.userId, userId))
    .limit(5); // Recent topics

  const allMessages = [];
  for (const topic of relatedTopics) {
    const messages = await this.getTopicMessages(topic.id);
    allMessages.push(...messages);
  }

  // Sort by timestamp and limit for context
  return allMessages
    .sort((a, b) => b.createdAt - a.createdAt)
    .slice(0, 20); // Last 20 messages across all contexts
}
```

### Thread Support

For Discord thread conversations:

```typescript
interface DiscordThreadMetadata extends DiscordTopicMetadata {
  threadId: string;
  parentChannelId: string;
  isThread: true;
}
```

### File Attachments

Handle Discord file attachments by storing them in R2 and referencing in messages:

```typescript
async handleDiscordAttachment(attachment: DiscordAttachment) {
  // Upload to R2 bucket
  const fileUrl = await uploadToR2(attachment.url, attachment.filename);
  
  // Store file reference in database
  await this.db.insert(files).values({
    id: generateId(),
    userId: discordUserId,
    fileType: attachment.content_type,
    name: attachment.filename,
    size: attachment.size,
    url: fileUrl,
    metadata: JSON.stringify({ discordAttachmentId: attachment.id })
  });

  return fileUrl;
}
```

## Security Considerations

1. **Webhook Verification**: Always verify Discord webhook signatures
2. **Rate Limiting**: Implement rate limiting for Discord API calls
3. **User Authentication**: Link Discord users to your user system
4. **Content Filtering**: Filter inappropriate content before AI processing
5. **Permission Checks**: Verify bot has necessary permissions in Discord channels

## Monitoring and Analytics

1. **Message Metrics**: Track messages per topic/channel
2. **Response Times**: Monitor AI response generation time
3. **Error Tracking**: Log and monitor Discord API errors
4. **User Engagement**: Track active Discord users and channels

This integration leverages LobeChat Eva's existing topic-based architecture to provide seamless Discord bot functionality with shared memory context between web and Discord interactions.
