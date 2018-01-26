require 'todo'
require 'yaml'

module Todo
  module Commands
    class Help < Todo::Command
      def call(args, _name)
        help_file = File.expand_path('misc/help.yml', Todo::ROOT)
        help_obj = YAML.load_file(help_file)
        hb = CLI::Kit::Help.new
        hb.add_section('Global Commands', help_obj)
        hb.call(*args)
      end
    end
  end
end
