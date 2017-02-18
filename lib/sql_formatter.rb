require "sql_formatter/version"
require "sql_formatter/formatter"

module SqlFormatter
  def self.format(string)
    formatter = SqlFormatter::Formatter.new(string)
    formatter.tokens
    formatter.format
  end
end
