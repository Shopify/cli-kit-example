require 'todo'

module Todo
  module Commands
    class Help < Todo::Command
      def call(args, _name)
        puts CLI::UI.fmt("{{bold:Available commands}}")
        puts ""

        CLI::Kit.command_registry.resolved_commands.each do |name, klass|
          next if name == 'help'
          puts CLI::UI.fmt("{{command:#{CLI::Kit.tool_name} #{name}}}")
          if help = klass.help
            puts CLI::UI.fmt(help)
          end
          puts ""
        end
      end
    end
  end
end
