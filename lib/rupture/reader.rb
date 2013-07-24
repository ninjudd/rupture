require 'set'

module Rupture
  class Reader
    def initialize(input)
      @input  = input
      @buffer = []
    end

    def ungetc(*chars)
      @buffer.concat(chars)
      @space = false
      chars.last
    end

    def getc
      while c = (@buffer.shift || @input.getc.chr)
        if c =~ /[\s,;]/
          next if @space
          @space = true
          @input.gets if c == ';'
          return ' '
        else
          @space = false
          return c
        end
      end
    end

    def peekc
      unget(getc)
    end

    def read
      case c = getc
      when '('  then read_list
      when '['  then read_list(Array, ']')
      when '{'  then read_map
      when '"'  then read_string
      when ':'  then read_keyword
      when ' '  then read
      when /\d/ then ungetc(c); read_number
      when /\w/ then ungetc(c); read_symbol
      when '-'
        case c = getc
        when /\d/ then ungetc(c);     -read_number
        else           ungetc('-', c); read_symbol
        end
      when '#'
        case c = getc
        when '{' then read_list(Set, '}')
        end
      end
    end

    def read_list(klass = List, terminator = ')')
      list = klass.new
      while c = getc
        return list if c == terminator
        ungetc(c)
        list << read
      end
    end

    def read_map
      map = {}
      while c = getc
        return map if c == '}'
        ungetc(c)
        list[read] = read
      end
    end

    def read_string
      string = ''
      while c = getc
        return string if c == '"'
        string << c
      end
    end

    def read_while(pattern, token = '')
      while c = getc
        if c !~ pattern
          ungetc(c)
          return token
        end
        token << c
      end
    end

    def read_symbol(prefix = '@')
      read_while(/[^\s{}\[\]()]/, prefix).to_sym
    end

    def read_keyword
      read_symbol('')
    end

    def read_number
      number = read_while(/[-\d]/)
      if (c = getc) == '.'
        read_while(/\d/, number << '.').to_f
      else
        ungetc(c)
        number.to_i
      end
    end
  end
end
