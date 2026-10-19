-- Pegar en Supabase > SQL Editor > Run
create table slots(
  id uuid primary key default gen_random_uuid(),
  fecha date not null, hora time not null,
  libre boolean not null default true,
  nombre text, telefono text, perfil text,
  unique(fecha,hora)
);
alter table slots enable row level security;
create policy admin_todo on slots for all to authenticated using(true) with check(true);
create view slots_publicos as select id,fecha,hora from slots where libre and fecha>=current_date;
grant select on slots_publicos to anon;
create function reservar(p_id uuid,p_nombre text,p_tel text,p_perfil text) returns boolean
language plpgsql security definer as $$
begin
  update slots set libre=false,nombre=p_nombre,telefono=p_tel,perfil=p_perfil where id=p_id and libre;
  return found;
end $$;
grant execute on function reservar to anon;
