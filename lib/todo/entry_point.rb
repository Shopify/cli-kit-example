require 'todo'

module Todo
  class EntryPoint < CLI::Kit::EntryPoint
    def self.log_file
      "/tmp/todo.log"
    end
  end
end
