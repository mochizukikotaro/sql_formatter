module SqlFormatter

  class Formatter

    RESERVED_KEY_WORDS = %w(
      select
      from
      group
      order
    )

    def initialize(string)
      @ss = StringScanner.new(string)
      @tokens = []
    end

    # Example:
    # 'select * from users;'
    # => ['select', '*', 'from', 'users', ';']
    # @return [Array]
    def tokens
      until @ss.eos?
        if @ss.scan(/(\w|\*)+/)
          @tokens << @ss.matched
        end
        if @ss.scan(/\;/)
          @tokens << @ss.matched
        end
        @ss.pos += 1 unless @ss.eos?
      end
      @tokens
    end

    def format
      output_string = ''
      @tokens.each do |token|
        if RESERVED_KEY_WORDS.include?(token)
          token = "\n" + token + "\n  "
        end
        output_string += token
      end
      output_string
    end

  end

end
