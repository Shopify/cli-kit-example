require 'todo'
require 'json'

module Todo
  module Commands
    class Add < Todo::Command
      def call(args, _name)
        list = Todo::Config.get('list') || '[]'
        data = JSON.parse(list)
        data << args.first
        Todo::Config.set('list', data.to_json)
      end
    end
  end
end
