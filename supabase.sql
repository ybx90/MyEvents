-- MY Events Room Planner — Supabase setup
-- Run this once in the Supabase SQL editor (Dashboard > SQL Editor > New query > paste > Run).

create table if not exists public.plans (
  id text primary key,
  kind text not null check (kind in ('project','hall')),
  name text,
  data jsonb not null,
  updated bigint not null,
  deleted boolean not null default false,
  created_at timestamptz not null default now()
);
create index if not exists plans_updated on public.plans (updated);

create table if not exists public.settings (key text primary key, value text not null);
insert into public.settings (key, value) values ('passcode', '0610')
  on conflict (key) do update set value = excluded.value;

alter table public.plans enable row level security;
alter table public.settings enable row level security;   -- no policies: nobody can read it directly

-- true when the request carried the right x-passcode header
create or replace function public.passcode_ok() returns boolean
language sql security definer stable set search_path = public as $$
  select coalesce(
    (current_setting('request.headers', true)::json ->> 'x-passcode') = (select value from public.settings where key = 'passcode'),
    false);
$$;

-- used by the site's code screen
create or replace function public.check_code(code text) returns boolean
language sql security definer stable set search_path = public as $$
  select exists (select 1 from public.settings where key = 'passcode' and value = code);
$$;

grant execute on function public.passcode_ok() to anon, authenticated;
grant execute on function public.check_code(text) to anon, authenticated;

drop policy if exists plans_select on public.plans;
drop policy if exists plans_insert on public.plans;
drop policy if exists plans_update on public.plans;
create policy plans_select on public.plans for select to anon, authenticated using (public.passcode_ok());
create policy plans_insert on public.plans for insert to anon, authenticated with check (public.passcode_ok());
create policy plans_update on public.plans for update to anon, authenticated using (public.passcode_ok()) with check (public.passcode_ok());

-- To change the access code later:
--   update public.settings set value = 'NEWCODE' where key = 'passcode';
-- (and tell me the new code so the site's own check matches)
