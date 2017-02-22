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

-- Sample query
puts SqlFormatter.format <<EOF
select (1), ((2)), hoge, piyo, count(*), max(score)
from users where name in (select *, aa from hoge) and team = '3' group by team order by id;
EOF
