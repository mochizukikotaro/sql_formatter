module SqlFormatter
  class Formatter

    NEWLINE = "\n"
    SPACE = " "

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
      @newline = false
      @inline_parentheses = false
      @tab = "  "
      @indent_level = 0
      tokenize
      remove_space
    end


    def format
      output = ''
      @tokens.each_with_index do |token, i|
        case

        when  RESERVED_TOPLEVEL.include?(token)
          output += NEWLINE if i > 0                 # head line dont need NEWLINE
          output += @tab * @indent_level
          @newline = true

        when token == ';' && i == (@tokens.size - 1) # end of tokens
          output += NEWLINE

        when token == ','                            # comma

        when token == '('
          if RESERVED_TOPLEVEL.include?(@tokens[i + 1]) # not inline
            @newline = true
            output += SPACE
          else                          # inline
            @newline = false
            @inline_parentheses = true
          end

        when token == ')'
          if @inline_parentheses        # inline
            @inline_parentheses = false
          else                          # not inline
            output += NEWLINE + @tab
          end

        else
          if @inline_parentheses
          elsif @newline
            output += NEWLINE + @tab
          else
            output += SPACE
          end
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
        when @ss.scan(REGEX_BOUNDARY)
          @ss.matched
        when @ss.scan(/\w+/)
          @ss.matched
        else
        end
      end

      def remove_space
        @tokens.select! { |token| !token.match(/^\s+$/) }
      end

  end
end
