module SqlFormatter
  class Formatter

    NEWLINE = "\n"

    RESERVED_TOPLEVEL = [
      'select',
      'from',
      'where',
      'group by',
      'order by'
    ]
    BOUNDARY = %w( , ; : ( ) . = < > + - * / ! ~ % | & # )

    REGEX_RESERVED_TOPLEVEL = Regexp.new(RESERVED_TOPLEVEL.join('|').gsub(/ /, '\s+'))
    REGEX_BOUNDARY = Regexp.new(BOUNDARY.map{ |m| Regexp.escape m }.join('|'))


    def initialize(string)
      @ss = StringScanner.new(string)
      @tokens = []

      @newline = "\n"
      @tab = "  "
      @indent_level = 0
    end

    def tokens
      tokenize
      @tokens
    end

    def format
      output = ''
      binding.pry
      @tokens.each do |token|
        if RESERVED_TOPLEVEL.include?(token)
          output += NEWLINE + @tab * @indent_level
        else
          output += NEWLINE + @tab
        end
        output += token
      end
      output
    end

    private

      # Create token
      def tokenize
        until @ss.eos?
          @tokens << next_token
          # @ss.pos += 1 unless @ss.eos?
        end
      end

      def next_token
        case
        when @ss.scan(/\s+/)
          @ss.matched
        when @ss.scan(REGEX_RESERVED_TOPLEVEL)
          @ss.matched
        when @ss.scan(/\;/)
          @ss.matched
        when @ss.scan(REGEX_BOUNDARY)
          @ss.matched
        when @ss.scan(/\w+/)
          @ss.matched
        else
        end
      end

  end
end
