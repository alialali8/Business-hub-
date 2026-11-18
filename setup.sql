-- ===== Business Hub database setup =====
-- Paste ALL of this into Supabase > SQL Editor > New query, then press "Run".
-- It is safe to run more than once.

create extension if not exists pgcrypto;

-- One table holds everything: businesses, tasks, files, money, history, settings
create table if not exists public.items (
  id text primary key default gen_random_uuid()::text,
  kind text not null,
  data jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists items_kind_idx on public.items (kind, created_at);
alter table public.items replica identity full;

-- Fully open: anyone with the website link can read and change data
alter table public.items enable row level security;
drop policy if exists "open read"   on public.items;
drop policy if exists "open insert" on public.items;
drop policy if exists "open update" on public.items;
drop policy if exists "open delete" on public.items;
create policy "open read"   on public.items for select to anon, authenticated using (true);
create policy "open insert" on public.items for insert to anon, authenticated with check (true);
create policy "open update" on public.items for update to anon, authenticated using (true) with check (true);
create policy "open delete" on public.items for delete to anon, authenticated using (true);

-- Safe "change only these fields" for edits
create or replace function public.patch_item(p_id text, p_patch jsonb)
returns void language sql security invoker as $$
  update public.items set data = data || p_patch, updated_at = now() where id = p_id;
$$;
grant execute on function public.patch_item(text, jsonb) to anon, authenticated;

-- Live updates (partners see changes without refreshing)
do $$ begin
  alter publication supabase_realtime add table public.items;
exception when duplicate_object then null; end $$;

-- File storage (up to 50 MB per file), open like the data
insert into storage.buckets (id, name, public, file_size_limit)
values ('files', 'files', true, 52428800)
on conflict (id) do nothing;
drop policy if exists "hub files read"   on storage.objects;
drop policy if exists "hub files upload" on storage.objects;
drop policy if exists "hub files delete" on storage.objects;
create policy "hub files read"   on storage.objects for select to anon, authenticated using (bucket_id = 'files');
create policy "hub files upload" on storage.objects for insert to anon, authenticated with check (bucket_id = 'files');
create policy "hub files delete" on storage.objects for delete to anon, authenticated using (bucket_id = 'files');

-- Your starting businesses and currency (you can change them later in Setup)
insert into public.items (id, kind, data) values
  ('b-wooden',     'businesses', '{"name":"Wooden Landscapes","budget":0,"slot":1,"order":0}'),
  ('b-chicken',    'businesses', '{"name":"Chicken Farm","budget":0,"slot":2,"order":1}'),
  ('b-fishcrab',   'businesses', '{"name":"Fish & Crab Breeding","budget":0,"slot":3,"order":2}'),
  ('b-greenhouse', 'businesses', '{"name":"Greenhouse Towers","budget":0,"slot":4,"order":3}'),
  ('b-nursery',    'businesses', '{"name":"Plant Nursery","budget":0,"slot":5,"order":4}'),
  ('b-nonfarm',    'businesses', '{"name":"Non-farm Projects","budget":0,"slot":6,"order":5}'),
  ('settings-main','settings',   '{"currency":"AED"}')
on conflict (id) do nothing;
