require 'todo'
require 'todo/commands'

module Todo
  module EntryPoint
    def self.call(args)
      cmd, command_name, args = CLI::Kit::Resolver.new.call(args)
      CLI::Kit::Executor.new.call(cmd, command_name, args)
    end
  end
end
