require 'fileutils'

module CLI
  module Kit
    class Config
      XDG_CONFIG_HOME = 'XDG_CONFIG_HOME'

      attr_reader :toolname
      def initialize(toolname)
        @toolname = toolname
      end

      # Fixes a bug where setting a key,val would result in the key growing with whitespace
      # Remove on December 1, 2017
      #
      def reformat_config
        # Sort it all
        File.write(file, all_configs.sort.join)

        # Delete old configs
        all_configs.each do |line|
          key, val = line.split('=', 2)
          key.strip!
          val.strip!

          to_delete = %w(notifications gatekeeper.mtime gatekeeper.check_time ios.developer reformatted)
          if to_delete.include?(key)
            set(key, nil)
          else
            set(key, val)
          end
        end
      end

      # Returns the config corresponding to `name` from ~/.devconfig
      # `false` is returned if it doesn't exist
      #
      # #### Parameters
      # `name` : the name of the config value you are looking for
      #
      # #### Returns
      # `value` : the value of the config variable (false if none)
      #
      # #### Example Usage
      # `config.get('name.of.config')`
      #
      def get(*name)
        name = name.join('.')
        all_configs.each do |line|
          parts = line.split('=', 2)
          return parts[1].strip if parts.size == 2 && parts[0].strip == name
        end
        false
      end

      # Sets the config value in ~/.devconfig
      #
      # #### Parameters
      # `name` : the name of the config you are setting
      # `value` : the value of the config you are setting
      #
      # #### Example Usage
      # `config.set('name.of.config', 'value')`
      #
      def set(name, value)
        found = false

        # Parse through all lines in the config
        # We re-create the config on every set
        lines = load_file.map do |line|
          # Each line is in the format `name = value`
          parts = line.split('=', 2)
          # Check that we have the right number of parts and the first value matches the name
          # If it doesn't just put the line back where we found it
          if parts.size == 2 && parts[0].strip == name
            # If we do match, then indicate that we match
            found = true
            # If the value should be nil, then return nil
            # Otherwise, set the value as expected
            next nil if value.nil?
            "#{parts[0].strip} = #{value}"
          else
            line
          end
        end

        # If the entry wasn't found and the value shouldn't be nil, then set it
        lines << "#{name.strip} = #{value}" unless found || value.nil?

        # Write the config back out
        FileUtils.mkdir_p(File.dirname(file))
        File.open(file, "w") do |f|
          f.puts lines.compact
        end
      end

      # Returns a mapping of all srcpath variables in the ~/.devconfig file
      # e.g. Shopify projects are in ~/src/shopify, Rails projects are in ~/src/rails
      #
      # #### Example Usage
      # `config.all_srcpaths`
      #
      def all_srcpaths
        path_config = {}
        all_configs.each do |line|
          parts = line.split('=', 2)
          # selects srcpath prefixed config variables
          if parts.size == 2 && parts[0][/^srcpath./]
            account = parts[0].gsub('srcpath.', '').strip
            path_config[account] = parts[1].strip
          end
        end
        path_config
      end

      # Returns a path from config in expanded form
      # e.g. shopify corresponds to ~/src/shopify, but is expanded to /Users/name/src/shopify
      #
      # #### Example Usage
      # `config.get_path('srcpath.shopify')`
      #
      # #### Returns
      # `path` : the expanded path to the corrsponding value
      #
      def get_path(name)
        v = get(name)
        false == v ? v : File.expand_path(v)
      end

      # Returns a array of all config values in key=val format
      #
      # #### Example Usage
      # `config.all_configs`
      #
      # #### Returns
      # `all_configs`, e.g. `["config=val"]`
      #
      def all_configs
        load_file.reject { |l| l.strip.empty? } # Empty lines can cause issues
      end

      # The path on disk at which the configuration is stored:
      #   `$XDG_CONFIG_HOME/<toolname>/config`
      # if ENV['XDG_CONFIG_HOME'] is not set, we default to ~/.config, e.g.:
      #   ~/.config/tool/config
      #
      def file
        return legacy_file if toolname == 'dev'

        config_home = ENV.fetch(XDG_CONFIG_HOME, '~/.config')
        File.expand_path(File.join(toolname, 'config'), config_home)
      end

      def legacy_file
        if ENV.key?('TEST')
          FileUtils.mkdir_p(File.join(Dev::ROOT, '.dev'))
          File.join(Dev::ROOT, '.dev', 'devconfig')
        elsif ENV.key?(XDG_CONFIG_HOME)
          File.join(ENV.fetch(XDG_CONFIG_HOME), 'dev')
        else
          "#{ENV.fetch('HOME')}/.devconfig"
        end
      end

      private

      def load_file
        File.exist?(file) ? File.readlines(file) : []
      end
    end
  end
end
