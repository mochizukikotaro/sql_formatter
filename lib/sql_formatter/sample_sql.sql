create table users (
  id serial,
  name varchar(255),
  team integer
);

insert into users (name, team) values
  ('taro', 1),
  ('yuki', 2),
  ('hoge', 3),
  ('piyo', 1),
  ('peco', 2);
