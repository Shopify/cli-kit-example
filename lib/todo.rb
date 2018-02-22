require 'cli/ui'
require 'cli/kit'

CLI::UI::StdoutRouter.enable

module Todo
  extend CLI::Kit::Autocall

  TOOL_NAME = 'todo'
  ROOT      = File.expand_path('../..', __FILE__)
  LOG_FILE  = '/tmp/todo.log'

  autoload(:EntryPoint, 'todo/entry_point')
  autoload(:Commands,   'todo/commands')

  autocall(:Config)  { CLI::Kit::Config.new(tool_name: TOOL_NAME) }
  autocall(:Command) { CLI::Kit::BaseCommand }

  autocall(:Executor) { CLI::Kit::Executor.new(log_file: LOG_FILE) }
  autocall(:Resolver) do
    CLI::Kit::Resolver.new(
      tool_name: TOOL_NAME,
      command_registry: Todo::Commands::Registry
    )
  end

  autocall(:ErrorHandler) do
    CLI::Kit::ErrorHandler.new(
      log_file: LOG_FILE,
      exception_reporter: nil
    )
  end
end
