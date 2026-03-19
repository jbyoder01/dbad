create table categories (
  id bigint generated always as identity primary key,
  user_id uuid references auth.users(id) on delete cascade not null default auth.uid(),
  name text not null check (char_length(name) between 1 and 255),
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null
);

create table flashcards (
  id bigint generated always as identity primary key,
  user_id uuid references auth.users(id) on delete cascade not null default auth.uid(),
  category_id bigint references categories(id) on delete cascade not null,
  question text not null,
  answer text not null,
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null
);

-- Indexes
create index idx_categories_user on categories(user_id);
create index idx_flashcards_user_category on flashcards(user_id, category_id);

-- RLS
alter table categories enable row level security;
alter table flashcards enable row level security;

create policy "Users can CRUD own categories"
  on categories for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "Users can CRUD own flashcards"
  on flashcards for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- Auto-update updated_at
create or replace function update_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger categories_updated_at
  before update on categories
  for each row execute function update_updated_at();

create trigger flashcards_updated_at
  before update on flashcards
  for each row execute function update_updated_at();