create table public.complaints (
  id uuid primary key default gen_random_uuid(), complaint_id text unique not null,
  name text not null, mobile text not null check (mobile ~ '^[0-9]{10}$'), issue text not null,
  priority text not null default 'சாதாரணம்', location text not null, details text not null,
  latitude double precision, longitude double precision, media_url text,
  status text not null default 'புதியது', admin_note text default '',
  created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
alter table public.complaints enable row level security;
create policy "public can submit complaints" on public.complaints for insert to anon with check (true);
create policy "admins can read complaints" on public.complaints for select to authenticated using (true);
create policy "admins can update complaints" on public.complaints for update to authenticated using (true) with check (true);
create or replace function public.track_complaint(lookup_id text, lookup_mobile text)
returns table(complaint_id text, issue text, status text, admin_note text)
language sql security definer set search_path=public as $$
  select c.complaint_id,c.issue,c.status,c.admin_note from complaints c
  where upper(c.complaint_id)=upper(lookup_id) and c.mobile=lookup_mobile limit 1;
$$;
grant execute on function public.track_complaint(text,text) to anon;
insert into storage.buckets (id,name,public) values ('complaint-media','complaint-media',true) on conflict do nothing;
create policy "public can upload complaint media" on storage.objects for insert to anon with check (bucket_id='complaint-media');
create policy "public can view complaint media" on storage.objects for select to public using (bucket_id='complaint-media');
