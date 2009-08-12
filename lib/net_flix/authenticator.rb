module NetFlix
  class Authenticator < Valuable

    has_value :request
    has_value :nonce, :default => rand(1_000_000)
    has_value :credentials

    def access_token
      credentials.access_token
    end

    def timestamp=stamp
      @timestamp=stamp
    end

    def timestamp 
      @timestamp ||= Time.now.to_i
    end

    def key
      credentials.key
    end
    
    def secret
      credentials.secret
    end

    def require_credentials
      raise( ArgumentError, "You must configure your NetFlix API key and secret before using flix4r.") unless credentials.valid?
    end

    def signature_base_string
      add_authentication_parameters!
      [request.http_method, encoded_url, encoded_parameters].join('&') 
    end

    def signature_key
      "#{Request.encode(secret)}&#{Request.encode(access_token)}"
    end

    def signature
      Base64.encode64(HMAC::SHA1.digest(signature_key,signature_base_string)).chomp.gsub(/\n/,'')
    end

    def authentication_parameters
      {
      'oauth_consumer_key' => key,
      'oauth_signature_method' => 'HMAC-SHA1',
      'oauth_timestamp' => timestamp,
      'oauth_nonce' => nonce,
      'oauth_version' => '1.0'
      }
    end

    def add_authentication_parameters!
      request.parameters.merge!(authentication_parameters)
    end

    def add_signature!
      sign = {'oauth_signature' => Request.encode(signature)}
      request.parameters.merge!( sign  )
    end

    def sign!
      require_credentials
      add_authentication_parameters!
      add_signature!
    end

    def encoded_parameters
      Request.encode request.parameter_string
    end

    def encoded_url
      Request.encode request.url
    end
  end
end
