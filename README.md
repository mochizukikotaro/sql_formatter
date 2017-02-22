# SqlFormatter

It is ruby gem to format SQL.

## Installation

```
gem install sql_formatter
```

## Usage

```
pry> require 'sql_formatter'
=> true

pry> sql_string = "select col1, col2 from table1 where col3 in (select col3 from table2) order by col1;"
=> "select col1, col2 from table1 where col3 in (select col3 from table2) order by col1;"

pry> puts SqlFormatter.format(sql_string)
select
  col1, col2
from
  table1
where
  col3 in (
    select col3
    from table2
  )
order by
  col1
;
=> nil
```


## Development

```
$ git clone git@github.com:mochizukikotaro/sql_formatter.git
$ cd sql_formatter
$ bundle exec irb
irb(main):001:0> require 'sql_formatter'
=> true
irb(main):002:0> puts SqlFormatter.format('select * from table;')
select
  *
from
  table
;
=> nil
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mochizukikotaro/sql_formatter.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
