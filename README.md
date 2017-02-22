# SqlFormatter

It is ruby gem to format SQL.

## Installation

```
gem install sql_formatter
```

## Usage

```
[1] pry(main)> require 'sql_formatter'
=> true

[2] pry(main)> sql_string = "select col1, col2 from table1 where col3 in (select col3 from table2) order by col1;"
=> "select col1, col2 from table1 where col3 in (select col3 from table2) order by col1;"

[3] pry(main)> puts SqlFormatter.format(sql_string)
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




## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Kotaro Mochizuki/sql_formatter.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
