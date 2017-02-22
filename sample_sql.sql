create table users (
  id serial,
  name varchar(255),
  team integer
)
;

insert into users (name, team) values
  ('taro', 1),
  ('yuki', 1),
  ('kent', 1),
  ('hoge', 2),
  ('piyo', 2),
  ('fuga', 2),
  ('aaaa', 3),
  ('bbbb', 3)
;
