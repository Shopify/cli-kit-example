require 'cli/ui'
require 'cli/kit'

module Todo
  TOOL_NAME = 'todo'

  autoload :Config,     'todo/config'
  autoload :Command,    'todo/command'
  autoload :Commands,   'todo/commands'
  autoload :EntryPoint, 'todo/entry_point'
  autoload :Executor,   'todo/executor'
  autoload :Resolver,   'todo/resolver'
end
