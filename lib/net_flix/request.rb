module NetFlix
  class Request < Valuable

    RESERVED_CHARACTERS = /[^A-Za-z0-9\-\._~]/

    has_value :http_method, :default => 'GET'
    has_value :url, :default => 'http://api.netflix.com/catalog/titles/index'
    has_value :parameters, :klass => HashWithIndifferentAccess, :default => {}
    has_value :cache_options, :default => {}
    
    def self.default_cache_options
      {
        :cache => 600,    # 10 minutes  After this time fetch new data
        :valid => 86400,  # 1 day       Maximum time to use old data
                          #             :forever is a valid option
        :period => 60,    # 1 minute    Maximum frequency to call API
        :timeout => 5     # 5 seconds   API response timeout
      }
    end
    

    def ordered_keys
      parameters.keys.sort
    end
    def parameter_string
      ordered_keys.map do |key, value|
        "#{key}=#{ ( key == 'term' )? URI.escape( parameters[key] ) : parameters[key]}"
      end.join('&')
    end

    def authenticator
      @auth ||= NetFlix::Authenticator.new(:request => self, :credentials => NetFlix.credentials)
    end

    def target
      URI.parse "#{url}?#{parameter_string}"
    end

    def log
      NetFlix.log(target.to_s)
    end

    def send
      merged_cache_options = self.class.default_cache_options.merge(cache_options)
      APICache.get(target.to_s, merged_cache_options ) do
        authenticator.sign!
        log
        Net::HTTP.get(target)
      end
    end

    def write_to_file(file_name)
      authenticator.sign!
      Net::HTTP.start(target.host, target.port) do |http|
        File.open( file_name, 'w') do |file|
          http.request_get(target.request_uri) do |response|
            response.read_body do |body|
              file.write(body)
            end
          end
        end
      end
    end

    def self.encode(value)
      URI.escape( value.to_s, RESERVED_CHARACTERS ) if value
    end

    # validation stuff
    has_collection :errors

    def valid?
      errors.clear
      validate_http_method
      errors.empty?
    end

    def validate_http_method
      errors << "HTTP method must be POST or GET, but I got #{http_method}" unless ['POST', 'GET'].include? http_method 
    end
  end
end
