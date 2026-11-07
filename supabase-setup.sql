-- Black Death City Warbands: one-time setup for syncing across devices.
-- Paste all of this into Supabase > SQL Editor > New query, then press Run.
create table if not exists public.warband_sync (
  user_id uuid primary key default auth.uid() references auth.users on delete cascade,
  data jsonb not null,
  updated_at timestamptz not null default now()
);
alter table public.warband_sync enable row level security;
drop policy if exists "read own warbands" on public.warband_sync;
drop policy if exists "add own warbands" on public.warband_sync;
drop policy if exists "change own warbands" on public.warband_sync;
create policy "read own warbands" on public.warband_sync for select to authenticated using (auth.uid() = user_id);
create policy "add own warbands" on public.warband_sync for insert to authenticated with check (auth.uid() = user_id);
create policy "change own warbands" on public.warband_sync for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
grant select, insert, update on public.warband_sync to authenticated;
