@AGENTS.md

# SaaS Boilerplate

## Stack

- Next.js 16 App Router, TypeScript strict mode
- Use 'use cache' directive instead of PPR
- proxy.ts instead of middleware.ts
- Supabase for auth + database
- Tailwind CSS + shadcn/ui
- Stripe for billing
- Vercel AI SDK (ai, @ai-sdk/anthropic, @ai-sdk/react) for AI streaming + Anthropic Claude for AI features

## Conventions

- Server components by default, client only when needed
- No 'any' types ever
- All API routes must have proper error handling
- Use server actions over API routes where possible
- Mobile-first responsive design

## Commands

- Package manager: npm
- dev: npm run dev
- build: npm run build
- test: npm run test
- lint: npm run lint

## What Claude gets wrong on this project

- Always use server actions for auth, never client-side Supabase auth calls
- profiles table auto-creates via trigger on auth.users insert — don't manually insert
- Use verifySession() from lib/dal.ts for protected routes, not getUser()
- Always use Vercel AI SDK (`ai`, `@ai-sdk/anthropic`, `@ai-sdk/react`) for AI streaming — never raw `@anthropic-ai/sdk` or manual ReadableStream
- Vercel AI SDK: use `toTextStreamResponse()` not `toDataStreamResponse()`
- Vercel AI SDK onFinish: callback receives `totalUsage` with `inputTokens`/`outputTokens`, not `usage.promptTokens`/`usage.completionTokens`
- Stripe SDK v21 (2025-03-31.basil): `current_period_start`/`current_period_end` moved from `Subscription` to `Subscription.items.data[0]` — always access period dates via `subscription.items.data[0].current_period_start
- Stripe checkout success_url and cancel_url must be absolute URLs with
  https:// scheme — use NEXT_PUBLIC_APP_URL env var as base,
  never relative paths
- Stripe webhook route must be excluded from proxy.ts auth matcher —
  add api/stripe/webhook to the negative lookahead in the matcher pattern
- useChat id prop: do NOT pass conversation_id as the id prop —
  it causes useChat to recreate its instance mid-stream.
  Pass conversation_id only via the request body.
