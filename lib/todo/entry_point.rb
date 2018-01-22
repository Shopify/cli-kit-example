require 'todo'

module Todo
  class EntryPoint < CLI::Kit::EntryPoint
    def self.tool_name
      Todo::NAME
    end

    def self.log_file
      "/tmp/#{Todo::NAME}.log"
    end
  end
end
