require 'todo'

module Todo
  module Commands
    def self.register(const, cmd, path)
      autoload(const, path)
      CLI::Kit.command_registry.add(->() { const_get(const) }, cmd)
    end

    register :Add,      'add',      'todo/commands/add'
    register :Complete, 'complete', 'todo/commands/complete'
    register :Help,     'help',     'todo/commands/help'
    register :List,     'list',     'todo/commands/list'
  end
end
