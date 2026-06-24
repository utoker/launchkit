-- Reproduce the live RLS model in version control.
-- Source: pg_policies snapshot from the Supabase project (2026-06-24).
-- Idempotent: drops each policy before recreating so this can re-run safely.

alter table public.profiles      enable row level security;
alter table public.conversations enable row level security;
alter table public.messages      enable row level security;
alter table public.subscriptions enable row level security;

-- profiles ------------------------------------------------------------------

drop policy if exists "Users can read own profile"   on public.profiles;
drop policy if exists "Users can insert own profile" on public.profiles;
drop policy if exists "Users can update own profile" on public.profiles;

create policy "Users can read own profile"
  on public.profiles
  for select
  using (auth.uid() = id);

create policy "Users can insert own profile"
  on public.profiles
  for insert
  with check (auth.uid() = id);

create policy "Users can update own profile"
  on public.profiles
  for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- conversations -------------------------------------------------------------

drop policy if exists "Users can CRUD own conversations" on public.conversations;

create policy "Users can CRUD own conversations"
  on public.conversations
  for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- messages ------------------------------------------------------------------
-- messages has no user_id column; ownership is derived via conversation_id.

drop policy if exists "Users can access messages in own conversations" on public.messages;

create policy "Users can access messages in own conversations"
  on public.messages
  for all
  using (
    exists (
      select 1 from public.conversations c
      where c.id = messages.conversation_id
        and c.user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from public.conversations c
      where c.id = messages.conversation_id
        and c.user_id = auth.uid()
    )
  );

-- subscriptions -------------------------------------------------------------
-- Read-only from the client. Writes are performed server-side by the Stripe
-- webhook handler using the service-role key, which bypasses RLS.

drop policy if exists "Users can read own subscription" on public.subscriptions;

create policy "Users can read own subscription"
  on public.subscriptions
  for select
  using (auth.uid() = user_id);
