-- Combined D1 Schema for LobeChat Eva
-- Generated from 37 migration files
-- Date: 2025-10-08T02:04:15.603Z

-- Migration: 0000_init.sql
CREATE TABLE IF NOT EXISTS "agents" (
	"id" text PRIMARY KEY NOT NULL,
	"slug" text,
	"title" text,
	"description" text,
	"tags" text DEFAULT '[]'::text,
	"avatar" text,
	"background_color" text,
	"plugins" text DEFAULT '[]'::text,
	"user_id" text NOT NULL,
	"chat_config" text,
	"few_shots" text,
	"model" text,
	"params" text DEFAULT '{}'::text,
	"provider" text,
	"system_role" text,
	"tts" text,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL,
	CONSTRAINT "agents_slug_unique" UNIQUE("slug")
);

CREATE TABLE IF NOT EXISTS "agents_tags" (
	"agent_id" text NOT NULL,
	"tag_id" integer NOT NULL,
	CONSTRAINT "agents_tags_agent_id_tag_id_pk" PRIMARY KEY("agent_id","tag_id")
);

CREATE TABLE IF NOT EXISTS "agents_to_sessions" (
	"agent_id" text NOT NULL,
	"session_id" text NOT NULL,
	CONSTRAINT "agents_to_sessions_agent_id_session_id_pk" PRIMARY KEY("agent_id","session_id")
);

CREATE TABLE IF NOT EXISTS "files" (
	"id" text PRIMARY KEY NOT NULL,
	"user_id" text NOT NULL,
	"file_type" text NOT NULL,
	"name" text NOT NULL,
	"size" integer NOT NULL,
	"url" text NOT NULL,
	"metadata" text,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL
);

CREATE TABLE IF NOT EXISTS "files_to_agents" (
	"file_id" text NOT NULL,
	"agent_id" text NOT NULL,
	CONSTRAINT "files_to_agents_file_id_agent_id_pk" PRIMARY KEY("file_id","agent_id")
);

CREATE TABLE IF NOT EXISTS "files_to_messages" (
	"file_id" text NOT NULL,
	"message_id" text NOT NULL,
	CONSTRAINT "files_to_messages_file_id_message_id_pk" PRIMARY KEY("file_id","message_id")
);

CREATE TABLE IF NOT EXISTS "files_to_sessions" (
	"file_id" text NOT NULL,
	"session_id" text NOT NULL,
	CONSTRAINT "files_to_sessions_file_id_session_id_pk" PRIMARY KEY("file_id","session_id")
);

CREATE TABLE IF NOT EXISTS "user_installed_plugins" (
	"user_id" text NOT NULL,
	"identifier" text NOT NULL,
	"type" text NOT NULL,
	"manifest" text,
	"settings" text,
	"custom_params" text,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL,
	CONSTRAINT "user_installed_plugins_user_id_identifier_pk" PRIMARY KEY("user_id","identifier")
);

CREATE TABLE IF NOT EXISTS "market" (
	"id" serial PRIMARY KEY NOT NULL,
	"agent_id" text,
	"plugin_id" integer,
	"type" text NOT NULL,
	"view" integer DEFAULT 0,
	"like" integer DEFAULT 0,
	"used" integer DEFAULT 0,
	"user_id" text NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL
);

CREATE TABLE IF NOT EXISTS "message_plugins" (
	"id" text PRIMARY KEY NOT NULL,
	"tool_call_id" text,
	"type" text DEFAULT 'default',
	"api_name" text,
	"arguments" text,
	"identifier" text,
	"state" text,
	"error" text
);

CREATE TABLE IF NOT EXISTS "message_tts" (
	"id" text PRIMARY KEY NOT NULL,
	"content_md5" text,
	"file_id" text,
	"voice" text
);

CREATE TABLE IF NOT EXISTS "message_translates" (
	"id" text PRIMARY KEY NOT NULL,
	"content" text,
	"from" text,
	"to" text
);

CREATE TABLE IF NOT EXISTS "messages" (
	"id" text PRIMARY KEY NOT NULL,
	"role" text NOT NULL,
	"content" text,
	"model" text,
	"provider" text,
	"favorite" boolean DEFAULT false,
	"error" text,
	"tools" text,
	"trace_id" text,
	"observation_id" text,
	"user_id" text NOT NULL,
	"session_id" text,
	"topic_id" text,
	"parent_id" text,
	"quota_id" text,
	"agent_id" text,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL
);

CREATE TABLE IF NOT EXISTS "plugins" (
	"id" serial PRIMARY KEY NOT NULL,
	"identifier" text NOT NULL,
	"title" text NOT NULL,
	"description" text,
	"avatar" text,
	"author" text,
	"manifest" text NOT NULL,
	"locale" text NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL,
	CONSTRAINT "plugins_identifier_unique" UNIQUE("identifier")
);

CREATE TABLE IF NOT EXISTS "plugins_tags" (
	"plugin_id" integer NOT NULL,
	"tag_id" integer NOT NULL,
	CONSTRAINT "plugins_tags_plugin_id_tag_id_pk" PRIMARY KEY("plugin_id","tag_id")
);

CREATE TABLE IF NOT EXISTS "session_groups" (
	"id" text PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"sort" integer,
	"user_id" text NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL
);

CREATE TABLE IF NOT EXISTS "sessions" (
	"id" text PRIMARY KEY NOT NULL,
	"slug" text NOT NULL,
	"title" text,
	"description" text,
	"avatar" text,
	"background_color" text,
	"type" text DEFAULT 'agent',
	"user_id" text NOT NULL,
	"group_id" text,
	"pinned" boolean DEFAULT false,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL
);

CREATE TABLE IF NOT EXISTS "tags" (
	"id" serial PRIMARY KEY NOT NULL,
	"slug" text NOT NULL,
	"name" text,
	"user_id" text NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL,
	CONSTRAINT "tags_slug_unique" UNIQUE("slug")
);

CREATE TABLE IF NOT EXISTS "topics" (
	"id" text PRIMARY KEY NOT NULL,
	"session_id" text,
	"user_id" text NOT NULL,
	"favorite" boolean DEFAULT false,
	"title" text,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL
);

CREATE TABLE IF NOT EXISTS "user_settings" (
	"id" text PRIMARY KEY NOT NULL,
	"tts" text,
	"key_vaults" text,
	"general" text,
	"language_model" text,
	"system_agent" text,
	"default_agent" text,
	"tool" text
);

CREATE TABLE IF NOT EXISTS "users" (
	"id" text PRIMARY KEY NOT NULL,
	"username" text,
	"email" text,
	"avatar" text,
	"phone" text,
	"first_name" text,
	"last_name" text,
	"is_onboarded" boolean DEFAULT false,
	"clerk_created_at" integer,
	"preference" text DEFAULT '{"guide":{"moveSettingsToAvatar":true,"topic":true},"telemetry":null,"useCmdEnterToSend":false}'::text,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL,
	"key" text,
	CONSTRAINT "users_username_unique" UNIQUE("username")
);

DO $$ BEGIN
 ALTER TABLE "agents" ADD CONSTRAINT "agents_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "agents_tags" ADD CONSTRAINT "agents_tags_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "agents_tags" ADD CONSTRAINT "agents_tags_tag_id_tags_id_fk" FOREIGN KEY ("tag_id") REFERENCES "public"."tags"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "agents_to_sessions" ADD CONSTRAINT "agents_to_sessions_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "agents_to_sessions" ADD CONSTRAINT "agents_to_sessions_session_id_sessions_id_fk" FOREIGN KEY ("session_id") REFERENCES "public"."sessions"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "files" ADD CONSTRAINT "files_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "files_to_agents" ADD CONSTRAINT "files_to_agents_file_id_files_id_fk" FOREIGN KEY ("file_id") REFERENCES "public"."files"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "files_to_agents" ADD CONSTRAINT "files_to_agents_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "files_to_messages" ADD CONSTRAINT "files_to_messages_file_id_files_id_fk" FOREIGN KEY ("file_id") REFERENCES "public"."files"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "files_to_messages" ADD CONSTRAINT "files_to_messages_message_id_messages_id_fk" FOREIGN KEY ("message_id") REFERENCES "public"."messages"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "files_to_sessions" ADD CONSTRAINT "files_to_sessions_file_id_files_id_fk" FOREIGN KEY ("file_id") REFERENCES "public"."files"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "files_to_sessions" ADD CONSTRAINT "files_to_sessions_session_id_sessions_id_fk" FOREIGN KEY ("session_id") REFERENCES "public"."sessions"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "user_installed_plugins" ADD CONSTRAINT "user_installed_plugins_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "market" ADD CONSTRAINT "market_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "market" ADD CONSTRAINT "market_plugin_id_plugins_id_fk" FOREIGN KEY ("plugin_id") REFERENCES "public"."plugins"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "market" ADD CONSTRAINT "market_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "message_plugins" ADD CONSTRAINT "message_plugins_id_messages_id_fk" FOREIGN KEY ("id") REFERENCES "public"."messages"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "message_tts" ADD CONSTRAINT "message_tts_id_messages_id_fk" FOREIGN KEY ("id") REFERENCES "public"."messages"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "message_tts" ADD CONSTRAINT "message_tts_file_id_files_id_fk" FOREIGN KEY ("file_id") REFERENCES "public"."files"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "message_translates" ADD CONSTRAINT "message_translates_id_messages_id_fk" FOREIGN KEY ("id") REFERENCES "public"."messages"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "messages" ADD CONSTRAINT "messages_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "messages" ADD CONSTRAINT "messages_session_id_sessions_id_fk" FOREIGN KEY ("session_id") REFERENCES "public"."sessions"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "messages" ADD CONSTRAINT "messages_topic_id_topics_id_fk" FOREIGN KEY ("topic_id") REFERENCES "public"."topics"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "messages" ADD CONSTRAINT "messages_parent_id_messages_id_fk" FOREIGN KEY ("parent_id") REFERENCES "public"."messages"("id") ON DELETE set null ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "messages" ADD CONSTRAINT "messages_quota_id_messages_id_fk" FOREIGN KEY ("quota_id") REFERENCES "public"."messages"("id") ON DELETE set null ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "messages" ADD CONSTRAINT "messages_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents"("id") ON DELETE set null ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "plugins_tags" ADD CONSTRAINT "plugins_tags_plugin_id_plugins_id_fk" FOREIGN KEY ("plugin_id") REFERENCES "public"."plugins"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "plugins_tags" ADD CONSTRAINT "plugins_tags_tag_id_tags_id_fk" FOREIGN KEY ("tag_id") REFERENCES "public"."tags"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "session_groups" ADD CONSTRAINT "session_groups_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "sessions" ADD CONSTRAINT "sessions_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "sessions" ADD CONSTRAINT "sessions_group_id_session_groups_id_fk" FOREIGN KEY ("group_id") REFERENCES "public"."session_groups"("id") ON DELETE set null ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "tags" ADD CONSTRAINT "tags_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "topics" ADD CONSTRAINT "topics_session_id_sessions_id_fk" FOREIGN KEY ("session_id") REFERENCES "public"."sessions"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "topics" ADD CONSTRAINT "topics_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "user_settings" ADD CONSTRAINT "user_settings_id_users_id_fk" FOREIGN KEY ("id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

CREATE INDEX IF NOT EXISTS "messages_created_at_idx" ON "messages" ("created_at");
CREATE UNIQUE INDEX IF NOT EXISTS "slug_user_id_unique" ON "sessions" ("slug","user_id");


-- Migration: 0001_add_client_id.sql
ALTER TABLE "messages" ADD COLUMN "client_id" text;
ALTER TABLE "session_groups" ADD COLUMN "client_id" text;
ALTER TABLE "sessions" ADD COLUMN "client_id" text;
ALTER TABLE "topics" ADD COLUMN "client_id" text;
CREATE INDEX IF NOT EXISTS "messages_client_id_idx" ON "messages" ("client_id");
ALTER TABLE "messages" ADD CONSTRAINT "messages_client_id_unique" UNIQUE("client_id");
ALTER TABLE "session_groups" ADD CONSTRAINT "session_groups_client_id_unique" UNIQUE("client_id");
ALTER TABLE "sessions" ADD CONSTRAINT "sessions_client_id_unique" UNIQUE("client_id");
ALTER TABLE "topics" ADD CONSTRAINT "topics_client_id_unique" UNIQUE("client_id");


-- Migration: 0002_amusing_puma.sql
ALTER TABLE "messages" DROP CONSTRAINT "messages_client_id_unique";
ALTER TABLE "session_groups" DROP CONSTRAINT "session_groups_client_id_unique";
ALTER TABLE "sessions" DROP CONSTRAINT "sessions_client_id_unique";
ALTER TABLE "topics" DROP CONSTRAINT "topics_client_id_unique";
DROP INDEX IF EXISTS "messages_client_id_idx";
CREATE UNIQUE INDEX IF NOT EXISTS "message_client_id_user_unique" ON "messages" ("client_id","user_id");
ALTER TABLE "session_groups" ADD CONSTRAINT "session_group_client_id_user_unique" UNIQUE("client_id","user_id");
ALTER TABLE "sessions" ADD CONSTRAINT "sessions_client_id_user_id_unique" UNIQUE("client_id","user_id");
ALTER TABLE "topics" ADD CONSTRAINT "topic_client_id_user_id_unique" UNIQUE("client_id","user_id");

-- Migration: 0003_naive_echo.sql
CREATE TABLE IF NOT EXISTS "user_budgets" (
	"id" text PRIMARY KEY NOT NULL,
	"free_budget_id" text,
	"free_budget_key" text,
	"subscription_budget_id" text,
	"subscription_budget_key" text,
	"package_budget_id" text,
	"package_budget_key" text,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL
);

CREATE TABLE IF NOT EXISTS "user_subscriptions" (
	"id" text PRIMARY KEY NOT NULL,
	"user_id" text NOT NULL,
	"stripe_id" text,
	"currency" text,
	"pricing" integer,
	"billing_paid_at" integer,
	"billing_cycle_start" integer,
	"billing_cycle_end" integer,
	"cancel_at_period_end" boolean,
	"cancel_at" integer,
	"next_billing" text,
	"plan" text,
	"recurring" text,
	"storage_limit" integer,
	"status" integer,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL
);

ALTER TABLE "users" ALTER COLUMN "preference" DROP DEFAULT;
DO $$ BEGIN
 ALTER TABLE "user_budgets" ADD CONSTRAINT "user_budgets_id_users_id_fk" FOREIGN KEY ("id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "user_subscriptions" ADD CONSTRAINT "user_subscriptions_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

ALTER TABLE "users" DROP COLUMN IF EXISTS "key";


-- Migration: 0004_add_next_auth.sql
CREATE TABLE IF NOT EXISTS "nextauth_accounts" (
	"access_token" text,
	"expires_at" integer,
	"id_token" text,
	"provider" text NOT NULL,
	"providerAccountId" text NOT NULL,
	"refresh_token" text,
	"scope" text,
	"session_state" text,
	"token_type" text,
	"type" text NOT NULL,
	"userId" text NOT NULL,
	CONSTRAINT "nextauth_accounts_provider_providerAccountId_pk" PRIMARY KEY("provider","providerAccountId")
);

CREATE TABLE IF NOT EXISTS "nextauth_authenticators" (
	"counter" integer NOT NULL,
	"credentialBackedUp" boolean NOT NULL,
	"credentialDeviceType" text NOT NULL,
	"credentialID" text NOT NULL,
	"credentialPublicKey" text NOT NULL,
	"providerAccountId" text NOT NULL,
	"transports" text,
	"userId" text NOT NULL,
	CONSTRAINT "nextauth_authenticators_userId_credentialID_pk" PRIMARY KEY("userId","credentialID"),
	CONSTRAINT "nextauth_authenticators_credentialID_unique" UNIQUE("credentialID")
);

CREATE TABLE IF NOT EXISTS "nextauth_sessions" (
	"expires" timestamp NOT NULL,
	"sessionToken" text PRIMARY KEY NOT NULL,
	"userId" text NOT NULL
);

CREATE TABLE IF NOT EXISTS "nextauth_verificationtokens" (
	"expires" timestamp NOT NULL,
	"identifier" text NOT NULL,
	"token" text NOT NULL,
	CONSTRAINT "nextauth_verificationtokens_identifier_token_pk" PRIMARY KEY("identifier","token")
);

ALTER TABLE "users" ADD COLUMN "full_name" text;
ALTER TABLE "users" ADD COLUMN "email_verified_at" integer;
DO $$ BEGIN
 ALTER TABLE "nextauth_accounts" ADD CONSTRAINT "nextauth_accounts_userId_users_id_fk" FOREIGN KEY ("userId") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "nextauth_authenticators" ADD CONSTRAINT "nextauth_authenticators_userId_users_id_fk" FOREIGN KEY ("userId") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "nextauth_sessions" ADD CONSTRAINT "nextauth_sessions_userId_users_id_fk" FOREIGN KEY ("userId") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;


-- Migration: 0005_pgvector.sql
-- Custom SQL migration file, put you code below! --


-- Migration: 0006_add_knowledge_base.sql
CREATE TABLE IF NOT EXISTS "agents_files" (
	"file_id" text NOT NULL,
	"agent_id" text NOT NULL,
	"enabled" boolean DEFAULT true,
	"user_id" text NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL,
	CONSTRAINT "agents_files_file_id_agent_id_user_id_pk" PRIMARY KEY("file_id","agent_id","user_id")
);

CREATE TABLE IF NOT EXISTS "agents_knowledge_bases" (
	"agent_id" text NOT NULL,
	"knowledge_base_id" text NOT NULL,
	"user_id" text NOT NULL,
	"enabled" boolean DEFAULT true,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL,
	CONSTRAINT "agents_knowledge_bases_agent_id_knowledge_base_id_pk" PRIMARY KEY("agent_id","knowledge_base_id")
);

CREATE TABLE IF NOT EXISTS "async_tasks" (
	"id" text PRIMARY KEY DEFAULT gen_random_text() NOT NULL,
	"type" text,
	"status" text,
	"error" text,
	"user_id" text NOT NULL,
	"duration" integer,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL
);

CREATE TABLE IF NOT EXISTS "file_chunks" (
	"file_id" varchar,
	"chunk_id" text,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	CONSTRAINT "file_chunks_file_id_chunk_id_pk" PRIMARY KEY("file_id","chunk_id")
);

CREATE TABLE IF NOT EXISTS "global_files" (
	"hash_id" text PRIMARY KEY NOT NULL,
	"file_type" text NOT NULL,
	"size" integer NOT NULL,
	"url" text NOT NULL,
	"metadata" text,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL
);

CREATE TABLE IF NOT EXISTS "knowledge_base_files" (
	"knowledge_base_id" text NOT NULL,
	"file_id" text NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	CONSTRAINT "knowledge_base_files_knowledge_base_id_file_id_pk" PRIMARY KEY("knowledge_base_id","file_id")
);

CREATE TABLE IF NOT EXISTS "knowledge_bases" (
	"id" text PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"description" text,
	"avatar" text,
	"type" text,
	"user_id" text NOT NULL,
	"is_public" boolean DEFAULT false,
	"settings" text,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL
);

CREATE TABLE IF NOT EXISTS "message_chunks" (
	"message_id" text,
	"chunk_id" text,
	CONSTRAINT "message_chunks_chunk_id_message_id_pk" PRIMARY KEY("chunk_id","message_id")
);

CREATE TABLE IF NOT EXISTS "message_queries" (
	"id" text PRIMARY KEY DEFAULT gen_random_text() NOT NULL,
	"message_id" text NOT NULL,
	"rewrite_query" text,
	"user_query" text,
	"embeddings_id" text
);

CREATE TABLE IF NOT EXISTS "message_query_chunks" (
	"id" text,
	"query_id" text,
	"chunk_id" text,
	"similarity" numeric(6, 5),
	CONSTRAINT "message_query_chunks_chunk_id_id_query_id_pk" PRIMARY KEY("chunk_id","id","query_id")
);

CREATE TABLE IF NOT EXISTS "chunks" (
	"id" text PRIMARY KEY DEFAULT gen_random_text() NOT NULL,
	"text" text,
	"abstract" text,
	"metadata" text,
	"index" integer,
	"type" varchar,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL,
	"user_id" text
);

CREATE TABLE IF NOT EXISTS "embeddings" (
	"id" text PRIMARY KEY DEFAULT gen_random_text() NOT NULL,
	"chunk_id" text,
	"embeddings" vector(1024),
	"model" text,
	"user_id" text
);

CREATE TABLE IF NOT EXISTS "unstructured_chunks" (
	"id" text PRIMARY KEY DEFAULT gen_random_text() NOT NULL,
	"text" text,
	"metadata" text,
	"index" integer,
	"type" varchar,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL,
	"parent_id" varchar,
	"composite_id" text,
	"user_id" text,
	"file_id" varchar
);

ALTER TABLE "files_to_messages" RENAME TO "messages_files";
DROP TABLE "files_to_agents";
ALTER TABLE "files" ADD COLUMN "file_hash" text;
ALTER TABLE "files" ADD COLUMN "chunk_task_id" text;
ALTER TABLE "files" ADD COLUMN "embedding_task_id" text;
DO $$ BEGIN
 ALTER TABLE "agents_files" ADD CONSTRAINT "agents_files_file_id_files_id_fk" FOREIGN KEY ("file_id") REFERENCES "public"."files"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "agents_files" ADD CONSTRAINT "agents_files_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "agents_files" ADD CONSTRAINT "agents_files_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "agents_knowledge_bases" ADD CONSTRAINT "agents_knowledge_bases_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "agents_knowledge_bases" ADD CONSTRAINT "agents_knowledge_bases_knowledge_base_id_knowledge_bases_id_fk" FOREIGN KEY ("knowledge_base_id") REFERENCES "public"."knowledge_bases"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "agents_knowledge_bases" ADD CONSTRAINT "agents_knowledge_bases_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "async_tasks" ADD CONSTRAINT "async_tasks_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "file_chunks" ADD CONSTRAINT "file_chunks_file_id_files_id_fk" FOREIGN KEY ("file_id") REFERENCES "public"."files"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "file_chunks" ADD CONSTRAINT "file_chunks_chunk_id_chunks_id_fk" FOREIGN KEY ("chunk_id") REFERENCES "public"."chunks"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "knowledge_base_files" ADD CONSTRAINT "knowledge_base_files_knowledge_base_id_knowledge_bases_id_fk" FOREIGN KEY ("knowledge_base_id") REFERENCES "public"."knowledge_bases"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "knowledge_base_files" ADD CONSTRAINT "knowledge_base_files_file_id_files_id_fk" FOREIGN KEY ("file_id") REFERENCES "public"."files"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "knowledge_bases" ADD CONSTRAINT "knowledge_bases_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "message_chunks" ADD CONSTRAINT "message_chunks_message_id_messages_id_fk" FOREIGN KEY ("message_id") REFERENCES "public"."messages"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "message_chunks" ADD CONSTRAINT "message_chunks_chunk_id_chunks_id_fk" FOREIGN KEY ("chunk_id") REFERENCES "public"."chunks"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "message_queries" ADD CONSTRAINT "message_queries_message_id_messages_id_fk" FOREIGN KEY ("message_id") REFERENCES "public"."messages"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "message_queries" ADD CONSTRAINT "message_queries_embeddings_id_embeddings_id_fk" FOREIGN KEY ("embeddings_id") REFERENCES "public"."embeddings"("id") ON DELETE set null ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "message_query_chunks" ADD CONSTRAINT "message_query_chunks_id_messages_id_fk" FOREIGN KEY ("id") REFERENCES "public"."messages"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "message_query_chunks" ADD CONSTRAINT "message_query_chunks_query_id_message_queries_id_fk" FOREIGN KEY ("query_id") REFERENCES "public"."message_queries"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "message_query_chunks" ADD CONSTRAINT "message_query_chunks_chunk_id_chunks_id_fk" FOREIGN KEY ("chunk_id") REFERENCES "public"."chunks"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "messages_files" ADD CONSTRAINT "messages_files_file_id_files_id_fk" FOREIGN KEY ("file_id") REFERENCES "public"."files"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "messages_files" ADD CONSTRAINT "messages_files_message_id_messages_id_fk" FOREIGN KEY ("message_id") REFERENCES "public"."messages"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "chunks" ADD CONSTRAINT "chunks_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "embeddings" ADD CONSTRAINT "embeddings_chunk_id_chunks_id_fk" FOREIGN KEY ("chunk_id") REFERENCES "public"."chunks"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "embeddings" ADD CONSTRAINT "embeddings_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "unstructured_chunks" ADD CONSTRAINT "unstructured_chunks_composite_id_chunks_id_fk" FOREIGN KEY ("composite_id") REFERENCES "public"."chunks"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "unstructured_chunks" ADD CONSTRAINT "unstructured_chunks_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "unstructured_chunks" ADD CONSTRAINT "unstructured_chunks_file_id_files_id_fk" FOREIGN KEY ("file_id") REFERENCES "public"."files"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "files" ADD CONSTRAINT "files_file_hash_global_files_hash_id_fk" FOREIGN KEY ("file_hash") REFERENCES "public"."global_files"("hash_id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "files" ADD CONSTRAINT "files_chunk_task_id_async_tasks_id_fk" FOREIGN KEY ("chunk_task_id") REFERENCES "public"."async_tasks"("id") ON DELETE set null ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "files" ADD CONSTRAINT "files_embedding_task_id_async_tasks_id_fk" FOREIGN KEY ("embedding_task_id") REFERENCES "public"."async_tasks"("id") ON DELETE set null ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;


-- Migration: 0007_fix_embedding_table.sql
-- step 1: create a temporary table to store the rows we want to keep
CREATE TEMP TABLE embeddings_temp AS
SELECT DISTINCT ON (chunk_id) *
FROM embeddings
ORDER BY chunk_id, random();

-- step 2: delete all rows from the original table
DELETE FROM embeddings;

-- step 3: insert the rows we want to keep back into the original table
INSERT INTO embeddings
SELECT * FROM embeddings_temp;

-- step 4: drop the temporary table
DROP TABLE embeddings_temp;

-- step 5: now it's safe to add the unique constraint
ALTER TABLE "embeddings" ADD CONSTRAINT "embeddings_chunk_id_unique" UNIQUE("chunk_id");


-- Migration: 0008_add_rag_evals.sql
CREATE TABLE IF NOT EXISTS "rag_eval_dataset_records" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "rag_eval_dataset_records_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1),
	"dataset_id" integer NOT NULL,
	"ideal" text,
	"question" text,
	"reference_files" text[],
	"metadata" text,
	"user_id" text,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL
);

CREATE TABLE IF NOT EXISTS "rag_eval_datasets" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "rag_eval_datasets_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 30000 CACHE 1),
	"description" text,
	"name" text NOT NULL,
	"knowledge_base_id" text,
	"user_id" text,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL
);

CREATE TABLE IF NOT EXISTS "rag_eval_evaluations" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "rag_eval_evaluations_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1),
	"name" text NOT NULL,
	"description" text,
	"eval_records_url" text,
	"status" text,
	"error" text,
	"dataset_id" integer NOT NULL,
	"knowledge_base_id" text,
	"language_model" text,
	"embedding_model" text,
	"user_id" text,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL
);

CREATE TABLE IF NOT EXISTS "rag_eval_evaluation_records" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "rag_eval_evaluation_records_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1),
	"question" text NOT NULL,
	"answer" text,
	"context" text[],
	"ideal" text,
	"status" text,
	"error" text,
	"language_model" text,
	"embedding_model" text,
	"question_embedding_id" text,
	"duration" integer,
	"dataset_record_id" integer NOT NULL,
	"evaluation_id" integer NOT NULL,
	"user_id" text,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL
);

DO $$ BEGIN
 ALTER TABLE "rag_eval_dataset_records" ADD CONSTRAINT "rag_eval_dataset_records_dataset_id_rag_eval_datasets_id_fk" FOREIGN KEY ("dataset_id") REFERENCES "public"."rag_eval_datasets"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "rag_eval_dataset_records" ADD CONSTRAINT "rag_eval_dataset_records_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "rag_eval_datasets" ADD CONSTRAINT "rag_eval_datasets_knowledge_base_id_knowledge_bases_id_fk" FOREIGN KEY ("knowledge_base_id") REFERENCES "public"."knowledge_bases"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "rag_eval_datasets" ADD CONSTRAINT "rag_eval_datasets_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "rag_eval_evaluations" ADD CONSTRAINT "rag_eval_evaluations_dataset_id_rag_eval_datasets_id_fk" FOREIGN KEY ("dataset_id") REFERENCES "public"."rag_eval_datasets"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "rag_eval_evaluations" ADD CONSTRAINT "rag_eval_evaluations_knowledge_base_id_knowledge_bases_id_fk" FOREIGN KEY ("knowledge_base_id") REFERENCES "public"."knowledge_bases"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "rag_eval_evaluations" ADD CONSTRAINT "rag_eval_evaluations_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "rag_eval_evaluation_records" ADD CONSTRAINT "rag_eval_evaluation_records_question_embedding_id_embeddings_id_fk" FOREIGN KEY ("question_embedding_id") REFERENCES "public"."embeddings"("id") ON DELETE set null ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "rag_eval_evaluation_records" ADD CONSTRAINT "rag_eval_evaluation_records_dataset_record_id_rag_eval_dataset_records_id_fk" FOREIGN KEY ("dataset_record_id") REFERENCES "public"."rag_eval_dataset_records"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "rag_eval_evaluation_records" ADD CONSTRAINT "rag_eval_evaluation_records_evaluation_id_rag_eval_evaluations_id_fk" FOREIGN KEY ("evaluation_id") REFERENCES "public"."rag_eval_evaluations"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "rag_eval_evaluation_records" ADD CONSTRAINT "rag_eval_evaluation_records_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;


-- Migration: 0009_remove_unused_user_tables.sql
DROP TABLE "user_budgets";
DROP TABLE "user_subscriptions";

-- Migration: 0010_add_accessed_at_and_clean_tables.sql
DROP TABLE "agents_tags" CASCADE;
DROP TABLE "market" CASCADE;
DROP TABLE "plugins" CASCADE;
DROP TABLE "plugins_tags" CASCADE;
DROP TABLE "tags" CASCADE;
ALTER TABLE "agents" ADD COLUMN "accessed_at" integer DEFAULT (unixepoch()) NOT NULL;
ALTER TABLE "agents_files" ADD COLUMN "accessed_at" integer DEFAULT (unixepoch()) NOT NULL;
ALTER TABLE "agents_knowledge_bases" ADD COLUMN "accessed_at" integer DEFAULT (unixepoch()) NOT NULL;
ALTER TABLE "async_tasks" ADD COLUMN "accessed_at" integer DEFAULT (unixepoch()) NOT NULL;
ALTER TABLE "files" ADD COLUMN "accessed_at" integer DEFAULT (unixepoch()) NOT NULL;
ALTER TABLE "global_files" ADD COLUMN "accessed_at" integer DEFAULT (unixepoch()) NOT NULL;
ALTER TABLE "knowledge_bases" ADD COLUMN "accessed_at" integer DEFAULT (unixepoch()) NOT NULL;
ALTER TABLE "messages" ADD COLUMN "accessed_at" integer DEFAULT (unixepoch()) NOT NULL;
ALTER TABLE "chunks" ADD COLUMN "accessed_at" integer DEFAULT (unixepoch()) NOT NULL;
ALTER TABLE "unstructured_chunks" ADD COLUMN "accessed_at" integer DEFAULT (unixepoch()) NOT NULL;
ALTER TABLE "rag_eval_dataset_records" ADD COLUMN "accessed_at" integer DEFAULT (unixepoch()) NOT NULL;
ALTER TABLE "rag_eval_dataset_records" ADD COLUMN "updated_at" integer DEFAULT (unixepoch()) NOT NULL;
ALTER TABLE "rag_eval_datasets" ADD COLUMN "accessed_at" integer DEFAULT (unixepoch()) NOT NULL;
ALTER TABLE "rag_eval_evaluations" ADD COLUMN "accessed_at" integer DEFAULT (unixepoch()) NOT NULL;
ALTER TABLE "rag_eval_evaluation_records" ADD COLUMN "accessed_at" integer DEFAULT (unixepoch()) NOT NULL;
ALTER TABLE "rag_eval_evaluation_records" ADD COLUMN "updated_at" integer DEFAULT (unixepoch()) NOT NULL;
ALTER TABLE "session_groups" ADD COLUMN "accessed_at" integer DEFAULT (unixepoch()) NOT NULL;
ALTER TABLE "sessions" ADD COLUMN "accessed_at" integer DEFAULT (unixepoch()) NOT NULL;
ALTER TABLE "topics" ADD COLUMN "accessed_at" integer DEFAULT (unixepoch()) NOT NULL;
ALTER TABLE "user_installed_plugins" ADD COLUMN "accessed_at" integer DEFAULT (unixepoch()) NOT NULL;
ALTER TABLE "users" ADD COLUMN "accessed_at" integer DEFAULT (unixepoch()) NOT NULL;

-- Migration: 0011_add_topic_history_summary.sql
ALTER TABLE "topics" ADD COLUMN "history_summary" text;
ALTER TABLE "topics" ADD COLUMN "metadata" text;


-- Migration: 0012_add_thread.sql
CREATE TABLE IF NOT EXISTS "threads" (
	"id" text PRIMARY KEY NOT NULL,
	"title" text,
	"type" text NOT NULL,
	"status" text DEFAULT 'active',
	"topic_id" text NOT NULL,
	"source_message_id" text NOT NULL,
	"parent_thread_id" text,
	"user_id" text NOT NULL,
	"last_active_at" integer DEFAULT (unixepoch()),
	"accessed_at" integer DEFAULT (unixepoch()) NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL
);

ALTER TABLE "messages" ADD COLUMN "thread_id" text;
DO $$ BEGIN
 ALTER TABLE "threads" ADD CONSTRAINT "threads_topic_id_topics_id_fk" FOREIGN KEY ("topic_id") REFERENCES "public"."topics"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "threads" ADD CONSTRAINT "threads_parent_thread_id_threads_id_fk" FOREIGN KEY ("parent_thread_id") REFERENCES "public"."threads"("id") ON DELETE set null ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "threads" ADD CONSTRAINT "threads_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "messages" ADD CONSTRAINT "messages_thread_id_threads_id_fk" FOREIGN KEY ("thread_id") REFERENCES "public"."threads"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;


-- Migration: 0013_add_ai_infra.sql
CREATE TABLE "ai_models" (
	"id" text NOT NULL,
	"display_name" text,
	"description" text,
	"organization" text,
	"enabled" boolean,
	"provider_id" text NOT NULL,
	"type" text DEFAULT 'chat' NOT NULL,
	"sort" integer,
	"user_id" text NOT NULL,
	"pricing" text,
	"parameters" text DEFAULT '{}'::text,
	"config" text,
	"abilities" text DEFAULT '{}'::text,
	"context_window_tokens" integer,
	"source" text,
	"released_at" text,
	"accessed_at" integer DEFAULT (unixepoch()) NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL,
	CONSTRAINT "ai_models_id_provider_id_user_id_pk" PRIMARY KEY("id","provider_id","user_id")
);

CREATE TABLE "ai_providers" (
	"id" text NOT NULL,
	"name" text,
	"user_id" text NOT NULL,
	"sort" integer,
	"enabled" boolean,
	"fetch_on_client" boolean,
	"check_model" text,
	"logo" text,
	"description" text,
	"key_vaults" text,
	"source" text,
	"settings" text,
	"accessed_at" integer DEFAULT (unixepoch()) NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL,
	CONSTRAINT "ai_providers_id_user_id_pk" PRIMARY KEY("id","user_id")
);

ALTER TABLE "ai_models" ADD CONSTRAINT "ai_models_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "ai_providers" ADD CONSTRAINT "ai_providers_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;

-- Migration: 0014_add_message_reasoning.sql
ALTER TABLE "messages" ADD COLUMN "reasoning" text;

-- Migration: 0015_add_message_search_metadata.sql
ALTER TABLE "messages" ADD COLUMN "search" text;
ALTER TABLE "messages" ADD COLUMN "metadata" text;

-- Migration: 0016_add_message_index.sql
CREATE INDEX IF NOT EXISTS "messages_topic_id_idx" ON "messages" USING btree ("topic_id");
CREATE INDEX IF NOT EXISTS "messages_parent_id_idx" ON "messages" USING btree ("parent_id");
CREATE INDEX IF NOT EXISTS "messages_quota_id_idx" ON "messages" USING btree ("quota_id");


-- Migration: 0017_add_user_id_to_tables.sql
-- Complete User ID Migration Script
-- Includes adding columns to all tables, populating data, and setting constraints

BEGIN;
CREATE INDEX "file_hash_idx" ON "files" USING btree ("file_hash");
-- Step 1: Add nullable user_id columns to all required tables
ALTER TABLE "global_files" ADD COLUMN IF NOT EXISTS "creator" text;
ALTER TABLE "knowledge_base_files" ADD COLUMN IF NOT EXISTS "user_id" text;
ALTER TABLE "message_chunks" ADD COLUMN IF NOT EXISTS "user_id" text;
ALTER TABLE "message_plugins" ADD COLUMN IF NOT EXISTS "user_id" text;
ALTER TABLE "message_queries" ADD COLUMN IF NOT EXISTS "user_id" text;
ALTER TABLE "message_query_chunks" ADD COLUMN IF NOT EXISTS "user_id" text;
ALTER TABLE "message_tts" ADD COLUMN IF NOT EXISTS "user_id" text;
ALTER TABLE "message_translates" ADD COLUMN IF NOT EXISTS "user_id" text;
ALTER TABLE "messages_files" ADD COLUMN IF NOT EXISTS "user_id" text;
ALTER TABLE "agents_to_sessions" ADD COLUMN IF NOT EXISTS "user_id" text;
ALTER TABLE "file_chunks" ADD COLUMN IF NOT EXISTS "user_id" text;
ALTER TABLE "files_to_sessions" ADD COLUMN IF NOT EXISTS "user_id" text;
-- Step 2: Populate user_id fields
-- Retrieve user_id from associated tables

-- Populate user_id for knowledge_base_files
UPDATE "knowledge_base_files" AS kbf
SET "user_id" = kb."user_id"
  FROM "knowledge_bases" AS kb
WHERE kbf."knowledge_base_id" = kb."id";
-- Populate user_id for message_chunks
UPDATE "message_chunks" AS mc
SET "user_id" = m."user_id"
  FROM "messages" AS m
WHERE mc."message_id" = m."id";
-- Populate user_id for message_plugins (directly from messages table)
UPDATE "message_plugins" AS mp
SET "user_id" = m."user_id"
  FROM "messages" AS m
WHERE mp."id" = m."id";
-- Populate user_id for message_queries
UPDATE "message_queries" AS mq
SET "user_id" = m."user_id"
  FROM "messages" AS m
WHERE mq."message_id" = m."id";
-- Populate user_id for message_query_chunks
UPDATE "message_query_chunks" AS mqc
SET "user_id" = mq."user_id"
  FROM "message_queries" AS mq
WHERE mqc."query_id" = mq."id";
-- Populate user_id for message_tts
UPDATE "message_tts" AS mt
SET "user_id" = m."user_id"
  FROM "messages" AS m
WHERE mt."id" = m."id";
-- Populate user_id for message_translates
UPDATE "message_translates" AS mt
SET "user_id" = m."user_id"
  FROM "messages" AS m
WHERE mt."id" = m."id";
-- Populate user_id for messages_files
UPDATE "messages_files" AS mf
SET "user_id" = m."user_id"
  FROM "messages" AS m
WHERE mf."message_id" = m."id";
-- Populate creator for global_files (get the first user who created the file from files table)
UPDATE "global_files" AS gf
SET "creator" = (
  SELECT f."user_id"
  FROM "files" AS f
  WHERE f."file_hash" = gf."hash_id"
  ORDER BY f."created_at" ASC
  LIMIT 1
  );
-- Delete global_files records where no user has used the file in the files table
DELETE FROM "global_files"
WHERE "creator" IS NULL;
-- Populate user_id for agents_to_sessions
UPDATE "agents_to_sessions" AS ats
SET "user_id" = a."user_id"
  FROM "agents" AS a
WHERE ats."agent_id" = a."id";
-- Populate user_id for file_chunks
UPDATE "file_chunks" AS fc
SET "user_id" = f."user_id"
  FROM "files" AS f
WHERE fc."file_id" = f."id";
-- Populate user_id for files_to_sessions
UPDATE "files_to_sessions" AS fts
SET "user_id" = f."user_id"
  FROM "files" AS f
WHERE fts."file_id" = f."id";
-- Get user_id from sessions table (handle potential NULL values)
UPDATE "files_to_sessions" AS fts
SET "user_id" = s."user_id"
  FROM "sessions" AS s
WHERE fts."session_id" = s."id" AND fts."user_id" IS NULL;
UPDATE "agents_to_sessions" AS ats
SET "user_id" = s."user_id"
  FROM "sessions" AS s
WHERE ats."session_id" = s."id" AND ats."user_id" IS NULL;
-- Step 3: Check for any unpopulated records
DO $$
DECLARE
kb_files_count INTEGER;
    msg_chunks_count INTEGER;
    msg_plugins_count INTEGER;
    msg_queries_count INTEGER;
    msg_query_chunks_count INTEGER;
    msg_tts_count INTEGER;
    msg_translates_count INTEGER;
    msgs_files_count INTEGER;
    agents_sessions_count INTEGER;
    file_chunks_count INTEGER;
    files_sessions_count INTEGER;
BEGIN
SELECT COUNT(*) INTO kb_files_count FROM "knowledge_base_files" WHERE "user_id" IS NULL;
SELECT COUNT(*) INTO msg_chunks_count FROM "message_chunks" WHERE "user_id" IS NULL;
SELECT COUNT(*) INTO msg_plugins_count FROM "message_plugins" WHERE "user_id" IS NULL;
SELECT COUNT(*) INTO msg_queries_count FROM "message_queries" WHERE "user_id" IS NULL;
SELECT COUNT(*) INTO msg_query_chunks_count FROM "message_query_chunks" WHERE "user_id" IS NULL;
SELECT COUNT(*) INTO msg_tts_count FROM "message_tts" WHERE "user_id" IS NULL;
SELECT COUNT(*) INTO msg_translates_count FROM "message_translates" WHERE "user_id" IS NULL;
SELECT COUNT(*) INTO msgs_files_count FROM "messages_files" WHERE "user_id" IS NULL;
SELECT COUNT(*) INTO agents_sessions_count FROM "agents_to_sessions" WHERE "user_id" IS NULL;
SELECT COUNT(*) INTO file_chunks_count FROM "file_chunks" WHERE "user_id" IS NULL;
SELECT COUNT(*) INTO files_sessions_count FROM "files_to_sessions" WHERE "user_id" IS NULL;

IF kb_files_count > 0 OR msg_chunks_count > 0 OR msg_plugins_count > 0 OR
       msg_queries_count > 0 OR msg_query_chunks_count > 0 OR msg_tts_count > 0 OR
       msg_translates_count > 0 OR msgs_files_count > 0 OR agents_sessions_count > 0 OR
       file_chunks_count > 0 OR files_sessions_count > 0 THEN
        RAISE EXCEPTION 'There are records with NULL user_id values that could not be populated';
END IF;
END $$;
-- Step 4: Add NOT NULL constraints and foreign keys
ALTER TABLE "knowledge_base_files" ALTER COLUMN "user_id" SET NOT NULL;
ALTER TABLE "message_chunks" ALTER COLUMN "user_id" SET NOT NULL;
ALTER TABLE "message_plugins" ALTER COLUMN "user_id" SET NOT NULL;
ALTER TABLE "message_queries" ALTER COLUMN "user_id" SET NOT NULL;
ALTER TABLE "message_query_chunks" ALTER COLUMN "user_id" SET NOT NULL;
ALTER TABLE "message_tts" ALTER COLUMN "user_id" SET NOT NULL;
ALTER TABLE "message_translates" ALTER COLUMN "user_id" SET NOT NULL;
ALTER TABLE "messages_files" ALTER COLUMN "user_id" SET NOT NULL;
ALTER TABLE "agents_to_sessions" ALTER COLUMN "user_id" SET NOT NULL;
ALTER TABLE "file_chunks" ALTER COLUMN "user_id" SET NOT NULL;
ALTER TABLE "files_to_sessions" ALTER COLUMN "user_id" SET NOT NULL;
-- Add foreign key constraints
ALTER TABLE "global_files"
  ADD CONSTRAINT "global_files_creator_users_id_fk"
    FOREIGN KEY ("creator") REFERENCES "public"."users"("id")
      ON DELETE SET NULL ON UPDATE NO ACTION;
ALTER TABLE "knowledge_base_files"
  ADD CONSTRAINT "knowledge_base_files_user_id_users_id_fk"
    FOREIGN KEY ("user_id") REFERENCES "public"."users"("id")
      ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "message_chunks"
  ADD CONSTRAINT "message_chunks_user_id_users_id_fk"
    FOREIGN KEY ("user_id") REFERENCES "public"."users"("id")
      ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "message_plugins"
  ADD CONSTRAINT "message_plugins_user_id_users_id_fk"
    FOREIGN KEY ("user_id") REFERENCES "public"."users"("id")
      ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "message_queries"
  ADD CONSTRAINT "message_queries_user_id_users_id_fk"
    FOREIGN KEY ("user_id") REFERENCES "public"."users"("id")
      ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "message_query_chunks"
  ADD CONSTRAINT "message_query_chunks_user_id_users_id_fk"
    FOREIGN KEY ("user_id") REFERENCES "public"."users"("id")
      ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "message_tts"
  ADD CONSTRAINT "message_tts_user_id_users_id_fk"
    FOREIGN KEY ("user_id") REFERENCES "public"."users"("id")
      ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "message_translates"
  ADD CONSTRAINT "message_translates_user_id_users_id_fk"
    FOREIGN KEY ("user_id") REFERENCES "public"."users"("id")
      ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "messages_files"
  ADD CONSTRAINT "messages_files_user_id_users_id_fk"
    FOREIGN KEY ("user_id") REFERENCES "public"."users"("id")
      ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "agents_to_sessions"
  ADD CONSTRAINT "agents_to_sessions_user_id_users_id_fk"
    FOREIGN KEY ("user_id") REFERENCES "public"."users"("id")
      ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "file_chunks"
  ADD CONSTRAINT "file_chunks_user_id_users_id_fk"
    FOREIGN KEY ("user_id") REFERENCES "public"."users"("id")
      ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "files_to_sessions"
  ADD CONSTRAINT "files_to_sessions_user_id_users_id_fk"
    FOREIGN KEY ("user_id") REFERENCES "public"."users"("id")
      ON DELETE CASCADE ON UPDATE NO ACTION;
COMMIT;


-- Migration: 0018_add_client_id_for_entities.sql
ALTER TABLE "session_groups" DROP CONSTRAINT IF EXISTS "session_group_client_id_user_unique";
ALTER TABLE "sessions" DROP CONSTRAINT IF EXISTS "sessions_client_id_user_id_unique";
ALTER TABLE "topics" DROP CONSTRAINT IF EXISTS "topic_client_id_user_id_unique";
-- add client_id column
ALTER TABLE "agents" ADD COLUMN IF NOT EXISTS "client_id" text;
ALTER TABLE "files" ADD COLUMN IF NOT EXISTS "client_id" text;
ALTER TABLE "knowledge_bases" ADD COLUMN IF NOT EXISTS "client_id" text;
ALTER TABLE "message_plugins" ADD COLUMN IF NOT EXISTS "client_id" text;
ALTER TABLE "message_queries" ADD COLUMN IF NOT EXISTS "client_id" text;
ALTER TABLE "message_tts" ADD COLUMN IF NOT EXISTS "client_id" text;
ALTER TABLE "message_translates" ADD COLUMN IF NOT EXISTS "client_id" text;
ALTER TABLE "chunks" ADD COLUMN IF NOT EXISTS "client_id" text;
ALTER TABLE "embeddings" ADD COLUMN IF NOT EXISTS "client_id" text;
ALTER TABLE "unstructured_chunks" ADD COLUMN IF NOT EXISTS "client_id" text;
ALTER TABLE "threads" ADD COLUMN IF NOT EXISTS "client_id" text;
-- Create unique index（using IF NOT EXISTS）
CREATE UNIQUE INDEX IF NOT EXISTS "client_id_user_id_unique" ON "agents" USING btree ("client_id","user_id");
CREATE UNIQUE INDEX IF NOT EXISTS "files_client_id_user_id_unique" ON "files" USING btree ("client_id","user_id");
CREATE UNIQUE INDEX IF NOT EXISTS "knowledge_bases_client_id_user_id_unique" ON "knowledge_bases" USING btree ("client_id","user_id");
CREATE UNIQUE INDEX IF NOT EXISTS "message_plugins_client_id_user_id_unique" ON "message_plugins" USING btree ("client_id","user_id");
CREATE UNIQUE INDEX IF NOT EXISTS "message_queries_client_id_user_id_unique" ON "message_queries" USING btree ("client_id","user_id");
CREATE UNIQUE INDEX IF NOT EXISTS "message_tts_client_id_user_id_unique" ON "message_tts" USING btree ("client_id","user_id");
CREATE UNIQUE INDEX IF NOT EXISTS "message_translates_client_id_user_id_unique" ON "message_translates" USING btree ("client_id","user_id");
CREATE UNIQUE INDEX IF NOT EXISTS "chunks_client_id_user_id_unique" ON "chunks" USING btree ("client_id","user_id");
CREATE UNIQUE INDEX IF NOT EXISTS "embeddings_client_id_user_id_unique" ON "embeddings" USING btree ("client_id","user_id");
CREATE UNIQUE INDEX IF NOT EXISTS "unstructured_chunks_client_id_user_id_unique" ON "unstructured_chunks" USING btree ("client_id","user_id");
CREATE UNIQUE INDEX IF NOT EXISTS "session_groups_client_id_user_id_unique" ON "session_groups" USING btree ("client_id","user_id");
CREATE UNIQUE INDEX IF NOT EXISTS "sessions_client_id_user_id_unique" ON "sessions" USING btree ("client_id","user_id");
CREATE UNIQUE INDEX IF NOT EXISTS "threads_client_id_user_id_unique" ON "threads" USING btree ("client_id","user_id");
CREATE UNIQUE INDEX IF NOT EXISTS "topics_client_id_user_id_unique" ON "topics" USING btree ("client_id","user_id");


-- Migration: 0019_add_hotkey_user_settings.sql
-- Add hotkey column to user_settings table
ALTER TABLE "user_settings" ADD COLUMN IF NOT EXISTS "hotkey" text;


-- Migration: 0020_add_oidc.sql
CREATE TABLE IF NOT EXISTS "oidc_access_tokens" (
	"id" text PRIMARY KEY NOT NULL,
	"data" text NOT NULL,
	"expires_at" integer NOT NULL,
	"consumed_at" integer,
	"user_id" text NOT NULL,
	"client_id" text NOT NULL,
	"grant_id" text,
	"accessed_at" integer DEFAULT (unixepoch()) NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL
);

CREATE TABLE IF NOT EXISTS "oidc_authorization_codes" (
	"id" text PRIMARY KEY NOT NULL,
	"data" text NOT NULL,
	"expires_at" integer NOT NULL,
	"consumed_at" integer,
	"user_id" text NOT NULL,
	"client_id" text NOT NULL,
	"grant_id" text,
	"accessed_at" integer DEFAULT (unixepoch()) NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL
);

CREATE TABLE IF NOT EXISTS "oidc_clients" (
	"id" text PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"description" text,
	"client_secret" text,
	"redirect_uris" text[] NOT NULL,
	"grants" text[] NOT NULL,
	"response_types" text[] NOT NULL,
	"scopes" text[] NOT NULL,
	"token_endpoint_auth_method" text,
	"application_type" text,
	"client_uri" text,
	"logo_uri" text,
	"policy_uri" text,
	"tos_uri" text,
	"is_first_party" boolean DEFAULT false,
	"accessed_at" integer DEFAULT (unixepoch()) NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL
);

CREATE TABLE IF NOT EXISTS "oidc_consents" (
	"user_id" text NOT NULL,
	"client_id" text NOT NULL,
	"scopes" text[] NOT NULL,
	"expires_at" integer,
	"accessed_at" integer DEFAULT (unixepoch()) NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL,
	CONSTRAINT "oidc_consents_user_id_client_id_pk" PRIMARY KEY("user_id","client_id")
);

CREATE TABLE IF NOT EXISTS "oidc_device_codes" (
	"id" text PRIMARY KEY NOT NULL,
	"data" text NOT NULL,
	"expires_at" integer NOT NULL,
	"consumed_at" integer,
	"user_id" text,
	"client_id" text NOT NULL,
	"grant_id" text,
	"user_code" text,
	"accessed_at" integer DEFAULT (unixepoch()) NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL
);

CREATE TABLE IF NOT EXISTS "oidc_grants" (
	"id" text PRIMARY KEY NOT NULL,
	"data" text NOT NULL,
	"expires_at" integer NOT NULL,
	"consumed_at" integer,
	"user_id" text NOT NULL,
	"client_id" text NOT NULL,
	"accessed_at" integer DEFAULT (unixepoch()) NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL
);

CREATE TABLE IF NOT EXISTS "oidc_interactions" (
	"id" text PRIMARY KEY NOT NULL,
	"data" text NOT NULL,
	"expires_at" integer NOT NULL,
	"accessed_at" integer DEFAULT (unixepoch()) NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL
);

CREATE TABLE IF NOT EXISTS "oidc_refresh_tokens" (
	"id" text PRIMARY KEY NOT NULL,
	"data" text NOT NULL,
	"expires_at" integer NOT NULL,
	"consumed_at" integer,
	"user_id" text NOT NULL,
	"client_id" text NOT NULL,
	"grant_id" text,
	"accessed_at" integer DEFAULT (unixepoch()) NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL
);

CREATE TABLE IF NOT EXISTS "oidc_sessions" (
	"id" text PRIMARY KEY NOT NULL,
	"data" text NOT NULL,
	"expires_at" integer NOT NULL,
	"user_id" text NOT NULL,
	"accessed_at" integer DEFAULT (unixepoch()) NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL
);

ALTER TABLE "oidc_access_tokens" ADD CONSTRAINT "oidc_access_tokens_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "oidc_authorization_codes" ADD CONSTRAINT "oidc_authorization_codes_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "oidc_consents" ADD CONSTRAINT "oidc_consents_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "oidc_consents" ADD CONSTRAINT "oidc_consents_client_id_oidc_clients_id_fk" FOREIGN KEY ("client_id") REFERENCES "public"."oidc_clients"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "oidc_device_codes" ADD CONSTRAINT "oidc_device_codes_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "oidc_grants" ADD CONSTRAINT "oidc_grants_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "oidc_refresh_tokens" ADD CONSTRAINT "oidc_refresh_tokens_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "oidc_sessions" ADD CONSTRAINT "oidc_sessions_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;


-- Migration: 0021_add_agent_opening_settings.sql
ALTER TABLE "agents" ADD COLUMN IF NOT EXISTS "opening_message" text;
ALTER TABLE "agents" ADD COLUMN IF NOT EXISTS "opening_questions" text[] DEFAULT '{}';

-- Migration: 0022_add_documents.sql
CREATE TABLE IF NOT EXISTS "document_chunks" (
	"document_id" text NOT NULL,
	"chunk_id" text NOT NULL,
	"page_index" integer,
	"user_id" text NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	CONSTRAINT "document_chunks_document_id_chunk_id_pk" PRIMARY KEY("document_id","chunk_id")
);

CREATE TABLE IF NOT EXISTS "documents" (
	"id" text PRIMARY KEY NOT NULL,
	"title" text,
	"content" text,
	"file_type" text NOT NULL,
	"filename" text,
	"total_char_count" integer NOT NULL,
	"total_line_count" integer NOT NULL,
	"metadata" text,
	"pages" text,
	"source_type" text NOT NULL,
	"source" text NOT NULL,
	"file_id" text,
	"user_id" text NOT NULL,
	"client_id" text,
	"accessed_at" integer DEFAULT (unixepoch()) NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL
);

CREATE TABLE IF NOT EXISTS "topic_documents" (
	"document_id" text NOT NULL,
	"topic_id" text NOT NULL,
	"user_id" text NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	CONSTRAINT "topic_documents_document_id_topic_id_pk" PRIMARY KEY("document_id","topic_id")
);

ALTER TABLE "document_chunks" ADD CONSTRAINT "document_chunks_document_id_documents_id_fk" FOREIGN KEY ("document_id") REFERENCES "public"."documents"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "document_chunks" ADD CONSTRAINT "document_chunks_chunk_id_chunks_id_fk" FOREIGN KEY ("chunk_id") REFERENCES "public"."chunks"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "document_chunks" ADD CONSTRAINT "document_chunks_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "documents" ADD CONSTRAINT "documents_file_id_files_id_fk" FOREIGN KEY ("file_id") REFERENCES "public"."files"("id") ON DELETE set null ON UPDATE no action;
ALTER TABLE "documents" ADD CONSTRAINT "documents_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "topic_documents" ADD CONSTRAINT "topic_documents_document_id_documents_id_fk" FOREIGN KEY ("document_id") REFERENCES "public"."documents"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "topic_documents" ADD CONSTRAINT "topic_documents_topic_id_topics_id_fk" FOREIGN KEY ("topic_id") REFERENCES "public"."topics"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "topic_documents" ADD CONSTRAINT "topic_documents_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
CREATE INDEX "documents_source_idx" ON "documents" USING btree ("source");
CREATE INDEX "documents_file_type_idx" ON "documents" USING btree ("file_type");
CREATE INDEX "documents_file_id_idx" ON "documents" USING btree ("file_id");
CREATE UNIQUE INDEX "documents_client_id_user_id_unique" ON "documents" USING btree ("client_id","user_id");


-- Migration: 0023_remove_param_and_doubao.sql
-- Custom SQL migration file, put your code below! --
UPDATE agents SET chat_config = text_set(chat_config, '{enableReasoningEffort}', 'false') WHERE chat_config ->> 'enableReasoningEffort' = 'true';

UPDATE agents SET params = params - 'reasoning_effort' WHERE params ? 'reasoning_effort';

DELETE FROM ai_providers WHERE id = 'doubao';

-- Migration: 0024_add_rbac_tables.sql
CREATE TABLE "rbac_permissions" (
	"id" integer PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY (sequence name "rbac_permissions_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1),
	"code" text NOT NULL,
	"name" text NOT NULL,
	"description" text,
	"category" text NOT NULL,
	"is_active" boolean DEFAULT true NOT NULL,
	"accessed_at" integer DEFAULT (unixepoch()) NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL,
	CONSTRAINT "rbac_permissions_code_unique" UNIQUE("code")
);

CREATE TABLE "rbac_role_permissions" (
	"role_id" integer NOT NULL,
	"permission_id" integer NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	CONSTRAINT "rbac_role_permissions_role_id_permission_id_pk" PRIMARY KEY("role_id","permission_id")
);

CREATE TABLE "rbac_roles" (
	"id" integer PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY (sequence name "rbac_roles_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1),
	"name" text NOT NULL,
	"display_name" text NOT NULL,
	"description" text,
	"is_system" boolean DEFAULT false NOT NULL,
	"is_active" boolean DEFAULT true NOT NULL,
	"accessed_at" integer DEFAULT (unixepoch()) NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL,
	CONSTRAINT "rbac_roles_name_unique" UNIQUE("name")
);

CREATE TABLE "rbac_user_roles" (
	"user_id" text NOT NULL,
	"role_id" integer NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"expires_at" integer,
	CONSTRAINT "rbac_user_roles_user_id_role_id_pk" PRIMARY KEY("user_id","role_id")
);

ALTER TABLE "rbac_role_permissions" ADD CONSTRAINT "rbac_role_permissions_role_id_rbac_roles_id_fk" FOREIGN KEY ("role_id") REFERENCES "public"."rbac_roles"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "rbac_role_permissions" ADD CONSTRAINT "rbac_role_permissions_permission_id_rbac_permissions_id_fk" FOREIGN KEY ("permission_id") REFERENCES "public"."rbac_permissions"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "rbac_user_roles" ADD CONSTRAINT "rbac_user_roles_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "rbac_user_roles" ADD CONSTRAINT "rbac_user_roles_role_id_rbac_roles_id_fk" FOREIGN KEY ("role_id") REFERENCES "public"."rbac_roles"("id") ON DELETE cascade ON UPDATE no action;
CREATE INDEX "rbac_role_permissions_role_id_idx" ON "rbac_role_permissions" USING btree ("role_id");
CREATE INDEX "rbac_role_permissions_permission_id_idx" ON "rbac_role_permissions" USING btree ("permission_id");
CREATE INDEX "rbac_user_roles_user_id_idx" ON "rbac_user_roles" USING btree ("user_id");
CREATE INDEX "rbac_user_roles_role_id_idx" ON "rbac_user_roles" USING btree ("role_id");

-- Migration: 0025_add_provider_config.sql
ALTER TABLE "ai_providers" ADD COLUMN "config" text;

-- Migration: 0026_add_autovacuum_tuning.sql
-- Migration to apply specific autovacuum settings to high-traffic tables
-- This is crucial to prevent table and TOAST bloat for 'embeddings' and 'chunks'
-- https://github.com/lobehub/lobe-chat/issues/8316

-- Tuning for the 'embeddings' table
-- Default scale factor (0.2) is too high, leading to infrequent vacuuming.
-- Lowering to 2% to ensure frequent cleanup.
ALTER TABLE "embeddings" SET (autovacuum_vacuum_scale_factor = 0.02, autovacuum_vacuum_threshold = 1000);

-- Tuning for the 'chunks' table
-- This table also experiences many updates/deletes and requires similar tuning.
ALTER TABLE "chunks" SET (autovacuum_vacuum_scale_factor = 0.02, autovacuum_vacuum_threshold = 1000);


-- Migration: 0027_ai_image.sql
CREATE TABLE "generation_batches" (
	"id" text PRIMARY KEY NOT NULL,
	"user_id" text NOT NULL,
	"generation_topic_id" text NOT NULL,
	"provider" text NOT NULL,
	"model" text NOT NULL,
	"prompt" text NOT NULL,
	"width" integer,
	"height" integer,
	"ratio" text,
	"config" text,
	"accessed_at" integer DEFAULT (unixepoch()) NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL
);

CREATE TABLE "generation_topics" (
	"id" text PRIMARY KEY NOT NULL,
	"user_id" text NOT NULL,
	"title" text,
	"cover_url" text,
	"accessed_at" integer DEFAULT (unixepoch()) NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL
);

CREATE TABLE "generations" (
	"id" text PRIMARY KEY NOT NULL,
	"user_id" text NOT NULL,
	"generation_batch_id" text NOT NULL,
	"async_task_id" text,
	"file_id" text,
	"seed" integer,
	"asset" text,
	"accessed_at" integer DEFAULT (unixepoch()) NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL
);

ALTER TABLE "files" ADD COLUMN "source" text;
ALTER TABLE "generation_batches" ADD CONSTRAINT "generation_batches_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "generation_batches" ADD CONSTRAINT "generation_batches_generation_topic_id_generation_topics_id_fk" FOREIGN KEY ("generation_topic_id") REFERENCES "public"."generation_topics"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "generation_topics" ADD CONSTRAINT "generation_topics_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "generations" ADD CONSTRAINT "generations_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "generations" ADD CONSTRAINT "generations_generation_batch_id_generation_batches_id_fk" FOREIGN KEY ("generation_batch_id") REFERENCES "public"."generation_batches"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "generations" ADD CONSTRAINT "generations_async_task_id_async_tasks_id_fk" FOREIGN KEY ("async_task_id") REFERENCES "public"."async_tasks"("id") ON DELETE set null ON UPDATE no action;
ALTER TABLE "generations" ADD CONSTRAINT "generations_file_id_files_id_fk" FOREIGN KEY ("file_id") REFERENCES "public"."files"("id") ON DELETE cascade ON UPDATE no action;

-- Migration: 0028_oauth_handoffs.sql
CREATE TABLE IF NOT EXISTS "oauth_handoffs" (
	"id" text PRIMARY KEY NOT NULL,
	"client" text NOT NULL,
	"payload" text NOT NULL,
	"accessed_at" integer DEFAULT (unixepoch()) NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL
);


-- Migration: 0029_add_apikey_manage.sql
CREATE TABLE IF NOT EXISTS "api_keys" (
	"id" integer PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY (sequence name "api_keys_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1),
	"name" text NOT NULL,
	"key" text NOT NULL,
	"enabled" boolean DEFAULT true,
	"expires_at" integer,
	"last_used_at" integer,
	"user_id" text NOT NULL,
	"accessed_at" integer DEFAULT (unixepoch()) NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL,
	CONSTRAINT "api_keys_key_unique" UNIQUE("key")
);

ALTER TABLE "rbac_roles" ADD COLUMN IF NOT EXISTS "metadata" text DEFAULT '{}'::text;
ALTER TABLE "api_keys" ADD CONSTRAINT "api_keys_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;


-- Migration: 0030_add_group_chat.sql
CREATE TABLE IF NOT EXISTS "chat_groups" (
	"id" text PRIMARY KEY NOT NULL,
	"title" text,
	"description" text,
	"config" text,
	"client_id" text,
	"user_id" text NOT NULL,
	"pinned" boolean DEFAULT false,
	"accessed_at" integer DEFAULT (unixepoch()) NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL
);

CREATE TABLE IF NOT EXISTS "chat_groups_agents" (
	"chat_group_id" text NOT NULL,
	"agent_id" text NOT NULL,
	"user_id" text NOT NULL,
	"enabled" boolean DEFAULT true,
	"order" integer DEFAULT 0,
	"role" text DEFAULT 'participant',
	"accessed_at" integer DEFAULT (unixepoch()) NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL,
	CONSTRAINT "chat_groups_agents_chat_group_id_agent_id_pk" PRIMARY KEY("chat_group_id","agent_id")
);

ALTER TABLE "messages" ADD COLUMN IF NOT EXISTS "group_id" text;
ALTER TABLE "messages" ADD COLUMN IF NOT EXISTS "target_id" text;
ALTER TABLE "topics" ADD COLUMN IF NOT EXISTS "group_id" text;
ALTER TABLE "chat_groups" ADD CONSTRAINT "chat_groups_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "chat_groups_agents" ADD CONSTRAINT "chat_groups_agents_chat_group_id_chat_groups_id_fk" FOREIGN KEY ("chat_group_id") REFERENCES "public"."chat_groups"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "chat_groups_agents" ADD CONSTRAINT "chat_groups_agents_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "public"."agents"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "chat_groups_agents" ADD CONSTRAINT "chat_groups_agents_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
CREATE UNIQUE INDEX "chat_groups_client_id_user_id_unique" ON "chat_groups" USING btree ("client_id","user_id");
ALTER TABLE "messages" ADD CONSTRAINT "messages_group_id_chat_groups_id_fk" FOREIGN KEY ("group_id") REFERENCES "public"."chat_groups"("id") ON DELETE set null ON UPDATE no action;
ALTER TABLE "topics" ADD CONSTRAINT "topics_group_id_chat_groups_id_fk" FOREIGN KEY ("group_id") REFERENCES "public"."chat_groups"("id") ON DELETE cascade ON UPDATE no action;


-- Migration: 0031_add_agent_index.sql
-- Truncate title to 150 characters if it exceeds the limit
UPDATE agents
SET title = LEFT(title, 200)
WHERE LENGTH(title) > 200;
-- Truncate description to 300 characters if it exceeds the limit
UPDATE agents
SET description = LEFT(description, 300)
WHERE LENGTH(description) > 300;
CREATE INDEX IF NOT EXISTS "agents_title_idx" ON "agents" USING btree ("title");
CREATE INDEX IF NOT EXISTS "agents_description_idx" ON "agents" USING btree ("description");


-- Migration: 0032_improve_agents_field.sql
ALTER TABLE "agents" ALTER COLUMN "title" SET DATA TYPE text;
ALTER TABLE "agents" ALTER COLUMN "description" SET DATA TYPE text;


-- Migration: 0033_add_table_index.sql
-- 解决 chunks 表慢查询
CREATE INDEX IF NOT EXISTS "chunks_user_id_idx" ON "chunks" USING btree ("user_id");
-- 解决 topics 表批量删除慢查询
CREATE INDEX IF NOT EXISTS "topics_user_id_idx" ON "topics" USING btree ("user_id");
CREATE INDEX IF NOT EXISTS "topics_id_user_id_idx" ON "topics" USING btree ("id","user_id");
-- 解决 sessions 表删除慢查询
CREATE INDEX IF NOT EXISTS "sessions_user_id_idx" ON "sessions" USING btree ("user_id");
CREATE INDEX IF NOT EXISTS "sessions_id_user_id_idx" ON "sessions" USING btree ("id","user_id");
-- 解决 messages 表统计查询慢查询
CREATE INDEX IF NOT EXISTS "messages_user_id_idx" ON "messages" USING btree ("user_id");
CREATE INDEX IF NOT EXISTS "messages_session_id_idx" ON "messages" USING btree ("session_id");
CREATE INDEX IF NOT EXISTS "messages_thread_id_idx" ON "messages" USING btree ("thread_id");
-- 解决 embeddings 删除慢查询
CREATE INDEX IF NOT EXISTS "embeddings_chunk_id_idx" ON "embeddings" USING btree ("chunk_id");


-- Migration: 0034_fix_chat_group.sql
ALTER TABLE "messages" ALTER COLUMN "role" SET DATA TYPE text;
ALTER TABLE "chat_groups" ADD COLUMN IF NOT EXISTS "group_id" text;
ALTER TABLE "chat_groups" DROP CONSTRAINT IF EXISTS "chat_groups_group_id_session_groups_id_fk";
ALTER TABLE "chat_groups" ADD CONSTRAINT "chat_groups_group_id_session_groups_id_fk" FOREIGN KEY ("group_id") REFERENCES "public"."session_groups"("id") ON DELETE set null ON UPDATE no action;


-- Migration: 0035_add_virtual.sql
ALTER TABLE "agents" ADD COLUMN IF NOT EXISTS "virtual" boolean DEFAULT false;

-- Migration: 0036_add_group_messages.sql
CREATE TABLE IF NOT EXISTS "message_groups" (
	"id" text PRIMARY KEY NOT NULL,
	"topic_id" text,
	"user_id" text NOT NULL,
	"parent_group_id" text,
	"parent_message_id" text,
	"title" text,
	"description" text,
	"client_id" text,
	"accessed_at" integer DEFAULT (unixepoch()) NOT NULL,
	"created_at" integer DEFAULT (unixepoch()) NOT NULL,
	"updated_at" integer DEFAULT (unixepoch()) NOT NULL
);

ALTER TABLE "messages" ADD COLUMN IF NOT EXISTS "message_group_id" text;
ALTER TABLE "message_groups" ADD CONSTRAINT "message_groups_topic_id_topics_id_fk" FOREIGN KEY ("topic_id") REFERENCES "public"."topics"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "message_groups" ADD CONSTRAINT "message_groups_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "message_groups" ADD CONSTRAINT "message_groups_parent_group_id_message_groups_id_fk" FOREIGN KEY ("parent_group_id") REFERENCES "public"."message_groups"("id") ON DELETE cascade ON UPDATE no action;
ALTER TABLE "message_groups" ADD CONSTRAINT "message_groups_parent_message_id_messages_id_fk" FOREIGN KEY ("parent_message_id") REFERENCES "public"."messages"("id") ON DELETE cascade ON UPDATE no action;
CREATE UNIQUE INDEX IF NOT EXISTS "message_groups_client_id_user_id_unique" ON "message_groups" USING btree ("client_id","user_id");
ALTER TABLE "messages" ADD CONSTRAINT "messages_message_group_id_message_groups_id_fk" FOREIGN KEY ("message_group_id") REFERENCES "public"."message_groups"("id") ON DELETE cascade ON UPDATE no action;


-- D1-specific optimizations
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
