require 'todo'
require 'json'

module Todo
  module Commands
    class Complete < Todo::Command
      def call(args, _name)
        list = Todo::Config.get('list') || '[]'
        data = JSON.parse(list)
        data.slice!(args.first.to_i)
        Todo::Config.set('list', data.to_json)
      end

      def self.help
        "Completes the todo entry at specified index.\nUsage: {{command:#{CLI::Kit.tool_name} add}} {{info:index_of_entry}}"
      end
    end
  end
end
