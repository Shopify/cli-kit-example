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
    end
  end
end
