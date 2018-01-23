require 'todo'

module Todo
  module Commands
    class Help < Todo::Command
      def call(args, _name)
        puts CLI::UI.fmt("{{bold:Available commands}}")
        puts ""

        Commands.commands.each do |name, klass_name|
          next if name == 'help'
          puts CLI::UI.fmt("{{command:#{CLI::Kit.tool_name} #{name}}}")
          if help = Todo::Commands.const_get(klass_name).help
            puts CLI::UI.fmt(help)
          end
          puts ""
        end
      end
    end
  end
end
