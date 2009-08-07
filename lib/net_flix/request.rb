module NetFlix
  class Request < Valuable

    RESERVED_CHARACTERS = /[^A-Za-z0-9\-\._~]/

    has_value :http_method, :default => 'GET'
    has_value :url, :default => 'http://api.netflix.com/catalog/titles/index'
    has_value :parameters, :klass => HashWithIndifferentAccess, :default => {}

    def ordered_keys
      parameters.keys.sort
    end

    def parameter_string
      string = ordered_keys.map do |key, value|
        "#{key}=#{self.class.encode(parameters[key])}"
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
      authenticator.sign!
      log
      Net::HTTP.get(target)
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
