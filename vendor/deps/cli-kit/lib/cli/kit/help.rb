require 'cli/kit'

module CLI
  module Kit
    class Help
      autoload :Command,   'cli/kit/help/command'
      autoload :Formatter, 'cli/kit/help/formatter'
      autoload :Output,    'cli/kit/help/output'

      def initialize
        @defs = {}
      end

      def add_section(name, defs)
        @defs[name] = defs
      end

      def call(*args)
        if args.empty?
          default_help
        elsif args.first == '--all'
          all_help
        else
          command_help(*args)
        end
      end

      private

      def default_help
        @defs.each do |_, section_defs|
          next unless help = section_defs['help']
          puts CLI::UI.fmt(help.fetch('summary'))
          return
        end
      end

      def command_help(*meths, out: STDOUT)
        tty ||= out.tty?
        @f = Formatter.new
        @out = Help::Output.new(out, tty)
        @command = Command.new(@out, @f)

        command_name = [meths.first]
        cmd = nil
        @defs.each do |_, section_defs|
          cmd = section_defs[meths.first]
          break if cmd
        end

        # Determine if a subcommand was specified
        # A subcommand was specified if there is more than 1 method given
        # And the subcommands array of the top level command has an entry for the
        # second speified method
        if meths.size > 1 && cmd && cmd['subcommands'] && cmd['subcommands'][meths[1]]
          cmd = cmd['subcommands'][meths[1]]
          command_name << meths[1]
        end

        # If the command is nil, then return
        if cmd.nil?
          @out.puts("#{@f.error 'command not found'} : #{@f.lit CLI::Kit.tool_name} #{@f.cmd meths.join(' ')}", indent: 0)
          return
        end

        @command.render(command_name: command_name.join(' '), command: cmd)
      end

      def all_help
        puts 'all'
      end
    end
  end
end
