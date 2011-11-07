# THis is essentioally purdytest, just extended, so lotsa <3 <3 <3 <3 for tenderlove is in order
module MiniTest

  class CustomOutput
    attr_reader :io
    attr_accessor :pass, :fail, :skip, :error

      # Colors stolen from /System/Library/Perl/5.10.0/Term/ANSIColor.pm
      COLORS = {
      :black      => 30,   :on_black   => 40,
      :red        => 31,   :on_red     => 41,
      :green      => 32,   :on_green   => 42,
      :yellow     => 33,   :on_yellow  => 43,
      :blue       => 34,   :on_blue    => 44,
      :magenta    => 35,   :on_magenta => 45,
      :cyan       => 36,   :on_cyan    => 46,
      :white      => 37,   :on_white   => 47
    }

    def initialize io
      @io    = io
      @pass  = :green
      @fail  = :red
      @error = :red
      @skip  = :yellow
      @started = false
    end

    def print o
      @started = true
      case o
      when '.' then io.print "\e[#{COLORS[pass]}m.\e[0m"
      when 'E' then io.print "\e[#{COLORS[error]}mE\e[0m"
      when 'F' then io.print "\e[#{COLORS[self.fail]}mF\e[0m"
      when 'S' then io.print "\e[#{COLORS[skip]}m*\e[0m"
      else
        io.print o
      end
    end

    def puts *o
      return unless @started
      text = o.first.to_s
      return if text.match("Run options")
      return if text.match("# Running tests")
      if text.match('Finished tests in')
        super green(text)
        return
      end

      if text.match(/^\d+ tests/)
        text.sub!(/\d+ assertions/, "\e[#{COLORS[:green]}m\\0\e[0m")
        text.sub!(/\d+ failures/, "\e[#{COLORS[error]}m\\0\e[0m")
        text.sub!(/\d+ errors/, "\e[#{COLORS[error]}m\\0\e[0m")
        text.sub!(/\d+ skips/, "\e[#{COLORS[skip]}m\\0\e[0m")
        super text + "\n\n"
        return
      end
      # STDOUT.puts "===="
      # STDOUT.puts o.first
      # STDOUT.puts "===="
      super *o
    end

    def green(txt)
      "\e[#{COLORS[:green]}m#{txt}\e[0m"
    end

    def method_missing msg, *args
      return super unless io.respond_to?(msg)
      io.send(msg, *args)
    end

  end

end

MiniTest::Unit.output = MiniTest::CustomOutput.new(MiniTest::Unit.output)

