require 'cli/ui'
require 'cli/kit'

CLI::Kit.configure do |config|
  config.command_registry = CLI::Kit::CommandRegistry.new
  config.default_command = 'help'
  config.error_handler = CLI::Kit::ErrorHandler.new
  config.executor = CLI::Kit::Executor.new
  config.log_file = "/tmp/todo.log"
  config.resolver = CLI::Kit::Resolver.new
  config.tool_name = "todo"
end

module Todo
  autoload :Config,       'todo/config'
  autoload :Command,      'todo/command'
  autoload :EntryPoint,   'todo/entry_point'
end
