-- ============================================================
-- ESTUDO TRIBUTÁRIO MAXIMOS — estrutura do banco (Supabase)
-- Cole tudo no SQL Editor do Supabase e clique em RUN.
-- ============================================================

-- Tabela dos estudos salvos (biblioteca compartilhada)
create table if not exists public.estudos (
  id         uuid primary key default gen_random_uuid(),
  grupo      text not null default 'Sem grupo',
  empresa    text not null,
  cnpj       text,
  data       text,                       -- data formatada (exibição)
  ts         bigint,                      -- timestamp para ordenar
  form       jsonb,                       -- todos os campos do formulário
  resumo     jsonb,                       -- melhor regime, totais, receita
  created_by uuid default auth.uid() references auth.users(id),
  created_at timestamptz default now()
);

-- Índices para busca/ordenação
create index if not exists idx_estudos_ts    on public.estudos (ts desc);
create index if not exists idx_estudos_grupo on public.estudos (grupo);

-- Segurança (RLS): só usuários AUTENTICADOS acessam a biblioteca
alter table public.estudos enable row level security;

drop policy if exists "auth_select" on public.estudos;
drop policy if exists "auth_insert" on public.estudos;
drop policy if exists "auth_update" on public.estudos;
drop policy if exists "auth_delete" on public.estudos;

create policy "auth_select" on public.estudos for select to authenticated using (true);
create policy "auth_insert" on public.estudos for insert to authenticated with check (true);
create policy "auth_update" on public.estudos for update to authenticated using (true);
create policy "auth_delete" on public.estudos for delete to authenticated using (true);

-- Pronto! Agora crie os logins da equipe em:
-- Authentication > Users > Add user  (e-mail + senha de cada funcionário)
