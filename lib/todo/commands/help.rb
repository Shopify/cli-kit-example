require 'todo'

module Todo
  module Commands
    class Help < Todo::Command
      def call(args, _name)
        puts self.class.name
        puts args.inspect
      end
    end
  end
end
