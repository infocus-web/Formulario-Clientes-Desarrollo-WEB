-- Tabla donde se registra cada presupuesto aceptado
create table if not exists public.aceptaciones_presupuesto (
  id            bigint generated always as identity primary key,
  presupuesto   text        not null,          -- ej: chea-web-2026-10
  nombre        text        not null,
  cargo         text,
  email         text        not null,
  opcionales    text[]      not null default '{}',
  total_inicial numeric,
  total_mensual numeric,
  user_agent    text,
  creado        timestamptz not null default now()
);

-- Seguridad: los clientes solo pueden REGISTRAR una aceptación.
-- Nadie desde la web puede leer, modificar ni borrar registros.
alter table public.aceptaciones_presupuesto enable row level security;

create policy "Clientes pueden aceptar presupuestos"
  on public.aceptaciones_presupuesto
  for insert
  to anon
  with check (
    char_length(presupuesto) between 3 and 80
    and char_length(nombre) between 2 and 120
    and position('@' in email) > 1
    and char_length(email) <= 160
  );

grant insert on public.aceptaciones_presupuesto to anon;
