# LaunchKit — Full-Stack SaaS Boilerplate

A production-ready SaaS starter built with **Next.js 16**, **Supabase**, **Stripe**, and **Claude AI**. Features complete authentication, subscription billing, AI-powered chat with streaming, and a polished dashboard — everything you need to launch a SaaS product.

<!-- > **Live Demo:** [launchkit.example.com](https://launchkit.example.com) -->

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Next.js 16 (App Router, React 19) |
| Language | TypeScript (strict mode) |
| Database & Auth | Supabase (PostgreSQL + Row-Level Security) |
| Payments | Stripe (Checkout, Customer Portal, Webhooks) |
| AI | Claude via Vercel AI SDK (streaming) |
| Styling | Tailwind CSS v4 |
| Charts | Recharts |
| Testing | Vitest + React Testing Library |
| Deployment | Vercel |

## Features

### Authentication
- Email/password sign up and sign in
- Google OAuth integration
- Password reset flow (forgot + update)
- Protected routes with session verification
- Automatic profile creation via database trigger

### AI Chat
- Real-time streaming responses powered by Claude
- Conversation history with create, rename, and delete
- Markdown rendering with syntax-highlighted code blocks
- Per-message token tracking (input/output)
- Usage limits enforced by subscription tier

### Subscription Billing
- **Free tier:** 100 AI messages/month
- **Pro tier:** $9/month, unlimited messages
- Stripe Checkout for upgrades
- Stripe Customer Portal for plan management
- Webhook-driven subscription sync
- Invoice history display

### Dashboard
- Welcome screen with subscription status
- 14-day message usage bar chart
- Activity feed (recent conversations, subscription changes)
- Monthly usage tracking with billing period awareness

### Architecture Highlights
- **Server Components by default** — client components only where interactivity is needed
- **Server Actions over API routes** — mutations use server actions for type safety and simplicity
- **Data Access Layer** (`lib/dal.ts`) — cached, request-scoped data fetching with `React.cache()`
- **Proxy-based auth** (`proxy.ts`) — session refresh on every request without Next.js middleware
- **Row-Level Security** — per-user data isolation enforced at the database level (auth.uid() = user_id)
- **Streaming AI** — Vercel AI SDK with `useChat` hook and custom transport

## Project Structure

```
app/
├── page.tsx                          # Landing page (hero, features, pricing, FAQ)
├── actions/                          # Server actions
│   ├── auth.ts                       #   Sign up, sign in, OAuth, password reset
│   ├── chat.ts                       #   Conversations and messages CRUD
│   ├── billing.ts                    #   Subscriptions, usage, checkout
│   └── dashboard.ts                  #   Analytics and activity feed
├── api/
│   ├── chat/route.ts                 # Streaming chat endpoint
│   └── stripe/webhook/route.ts       # Stripe webhook handler
├── (auth)/                           # Auth pages (login, signup, forgot/reset password)
└── (protected)/                      # Authenticated pages
    ├── dashboard/                    #   Dashboard + billing management
    └── chat/                         #   AI chat interface

lib/
├── dal.ts                            # Data access layer (cached queries)
├── supabase/                         # Supabase client helpers (server, client, admin, proxy)
├── stripe.ts                         # Stripe client
└── types/                            # TypeScript types (database schema)

tests/
├── setup.ts                          # Global test setup (module mocks)
└── mocks/                            # Shared mock factories
    ├── supabase.ts                   #   Chainable Supabase query builder mock
    ├── stripe.ts                     #   Stripe client mock
    └── user.ts                       #   Test fixtures (user, conversation, etc.)
```

## Getting Started

### Prerequisites

- Node.js 18+
- A [Supabase](https://supabase.com) project
- A [Stripe](https://stripe.com) account
- An [Anthropic](https://console.anthropic.com) API key

### 1. Clone and install

```bash
git clone https://github.com/your-username/saas-boilerplate.git
cd saas-boilerplate
npm install
```

### 2. Set up environment variables

Create a `.env.local` file in the project root:

```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key

# Anthropic (for AI chat)
ANTHROPIC_API_KEY=your_anthropic_api_key

# Stripe
STRIPE_SECRET_KEY=your_stripe_secret_key
STRIPE_WEBHOOK_SECRET=your_webhook_signing_secret
STRIPE_PRO_PRICE_ID=your_pro_plan_price_id

# App
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

### 3. Set up the database

Run the SQL migrations in your Supabase project to create the required tables (`profiles`, `conversations`, `messages`, `subscriptions`) and database functions. Enable Row-Level Security on all tables.

### 4. Configure Stripe

1. Create a product with a recurring price for the Pro plan
2. Set the price ID as `STRIPE_PRO_PRICE_ID`
3. Set up a webhook endpoint pointing to `/api/stripe/webhook` with events:
   - `checkout.session.completed`
   - `customer.subscription.updated`
   - `customer.subscription.deleted`

### 5. Run the dev server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) to see the app.

## Testing

The project uses **Vitest** with **React Testing Library** for unit and integration tests. Tests live next to source files in `__tests__/` directories.

```bash
npm run test              # Run all tests
npm run test:coverage     # Run with coverage report
```

**What's tested:**
- **Data Access Layer** — session verification, profile and subscription queries
- **Server Actions** — chat CRUD, dashboard analytics (14-day usage aggregation), billing period logic
- **Stripe Webhooks** — all three event types, status mapping, error handling
- **Chat Interface** — input behavior, keyboard shortcuts, sidebar delete flow, message limits

## Scripts

| Command | Description |
|---------|-------------|
| `npm run dev` | Start development server |
| `npm run build` | Create production build |
| `npm run start` | Start production server |
| `npm run lint` | Run ESLint |
| `npm run test` | Run tests |
| `npm run test:coverage` | Run tests with coverage |

## License

MIT
