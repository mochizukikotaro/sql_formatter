module SqlFormatter
  class Formatter

    NEWLINE = "\n"
    SPACE   = " " * 1
    TAB     = " " * 2
    COMMA   = ","

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
      @ss       = StringScanner.new(string)
      @tokens   = []
      @space    = true
      @newline  = false
      @indent_level = 0
      @inline_parentheses = false
      @inline_parentheses_level = 0
      tokenize
      remove_space
    end


    def format
      output = ''
      @tokens.each_with_index do |token, index|
        case

        # Reserved toplevel
        when  RESERVED_TOPLEVEL.include?(token)
          lower_indent_level
          output += NEWLINE if index > 0
          output += TAB * @indent_level

          # TODO: Add optional..
          if @indent_level >= 2
            @newline = false
          else
            @newline = true
          end

          raise_indent_level

        # End of tokens
        when token == ';' && index == (@tokens.size - 1)
          output += NEWLINE

        # Comma
      when token == COMMA
          @space = true

        # Start parenthesis
        when token == '('
          if @newline
            output += NEWLINE + TAB * @indent_level
          end

          if inline_left_parenthesis?(index)
            @newline = false
            @space = false
            @inline_parentheses = true
            @inline_parentheses_level += 1
            output += SPACE if @tokens[index - 1] == COMMA
          else
            @newline = true
            @indent_level += 2
            output += SPACE
          end

        # End parenthesis
        when token == ')'
          if inline_right_parenthesis?
            @inline_parentheses_level = [0, @inline_parentheses_level - 1].max

            if @inline_parentheses_level == 0
              @inline_parentheses = false
              @space = true
            end
          else
            @indent_level -= 2
            output += NEWLINE + TAB
          end

        else
          if @inline_parentheses
            # Nothing to do
          elsif @newline
            output += NEWLINE + TAB * @indent_level
            @newline = false
          elsif @space
            output += SPACE
          else
            # Nothing to do
          end
        end

        output += token
      end
      output
    end

    private

      def raise_indent_level
        @indent_level += 1
      end

      def lower_indent_level
        @indent_level = [0, @indent_level -1].max
      end

      # TODO: It can not handle multiple parentheses...
      # ex) select ((1)) from users;
      def inline_left_parenthesis?(index)
        RESERVED_TOPLEVEL.include?(@tokens[index + 1]) ? false : true
      end

      # TODO: It can not handle multiple parentheses...
      def inline_right_parenthesis?
        @inline_parentheses ? true : false
      end

      def tokenize
        until @ss.eos?
          @tokens << next_token
        end
      end

      def next_token
        patterns = [
          /\s+/,
          REGEX_RESERVED_TOPLEVEL,
          REGEX_BOUNDARY,
          /(^'.*?'|^".*?"|^`.*?`)/,
          /\w+/
        ]
        patterns.each do |pattern|
          return @ss.matched if @ss.scan(pattern)
        end
        # TODO: エラーハンドリングしたい
        # ひとまずやっつけ対応。ループに入らないように処理をとめる。
        p 'Warning'
        p @ss.peek 20
        @ss.pos += 1
        return nil
      end

      def remove_space
        @tokens.select! { |token| !token.match(/^\s+$/) }
      end

  end
end
