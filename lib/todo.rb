require 'cli/ui'
require 'cli/kit'

CLI::Kit.tool_name = 'todo'
CLI::UI::StdoutRouter.enable

module Todo
  ROOT = File.expand_path('../../', __FILE__)

  autoload :EntryPoint, 'todo/entry_point'
  autoload :Config,     'todo/config'
  autoload :Command,    'todo/command'

  module Commands
    extend CLI::Kit::CommandRegistry

    def self.default_command
      [Todo::Commands::Help, 'help']
    end

    register :Add,      'add',      'todo/commands/add'
    register :Complete, 'complete', 'todo/commands/complete'
    register :Help,     'help',     'todo/commands/help'
    register :List,     'list',     'todo/commands/list'
  end
end
