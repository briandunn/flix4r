module NetFlix
  class Credentials < Valuable

    CONFIG_FILENAME = File.join( File.dirname(__FILE__), '..', '..', 'credentials.yml')
    
    has_value :key
    has_value :secret
    has_value :access_token
    
    def valid?
      (key && secret) != nil
    end
    
    class << self

      def from_file
        new(config_file_exists? ? YAML.load(File.open(CONFIG_FILENAME)) : {}) 
      end

      def config_file_exists?
        File.exist? CONFIG_FILENAME
      end

    end # class methods

    def to_file!
      credentials_store = File.new(CONFIG_FILENAME, 'w')
      credentials_store.puts(self.to_yaml)
      credentials_store.close
    end

    def to_yaml
      attributes.to_yaml
    end
  end

end
