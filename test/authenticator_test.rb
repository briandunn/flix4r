require 'test_helper'
class AuthenticatorTest < Test::Unit::TestCase

  def test_that_url_is_properly_encoded
    fake_request = stub_everything(:url => 'http://photos.example.net/a pic')
    assert_equal 'http%3A%2F%2Fphotos.example.net%2Fa%20pic', NetFlix::Authenticator.new(:request => fake_request).encoded_url
  end

  def test_that_authentication_corresponds_to_known_values
    #based on http://developer.netflix.com/docs/Security#0_pgfId-1015486
    #based on http://term.ie/oauth/example/client.php

    cred = stub_everything(
	     :key => '123456789012345678901234',
             :secret => '1234567890',
             :valid? => true)
    
    expected_sbs = 'GET&http%3A%2F%2Fapi.netflix.com%2Fcatalog%2Ftitles&max_results%3D5%26oauth_consumer_key%3D123456789012345678901234%26oauth_nonce%3D24aea97b0b5dd516145966aaf2945c6a%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1233950836%26oauth_version%3D1.0%26term%3Dsneakers'

    expected_signature = 'vlROEST9UXwI+zc9fld82giaYPE='

    request = NetFlix::Request.new(
      :url => 'http://api.netflix.com/catalog/titles',
      :http_method => 'GET',
      :parameters => {'term' => 'sneakers', 'max_results' => '5'})
	    
    auth = NetFlix::Authenticator.new(
        :request => request,
        :timestamp => 1233950836,
        :nonce => '24aea97b0b5dd516145966aaf2945c6a',
	:credentials => cred
      )
	  
    assert_equal expected_sbs, auth.signature_base_string
    assert_equal expected_signature, auth.signature
  end

  def test_that_signature_key_includes_consumer_secret_and_ampersand
    cred = stub_everything(:secret => 'shhh', :key => 'letmein')
    assert_equal 'shhh&', NetFlix::Authenticator.new(:credentials => cred).signature_key
  end

  def test_that_access_token_is_included_in_signature_key_if_it_is_available
    cred = stub_everything(:secret => 'shhh', :key => 'letmein', :access_token => 'they_like_me')
    request = stub_everything

    assert_equal 'shhh&they_like_me', NetFlix::Authenticator.new(:request => request, :credentials => cred).signature_key
  end

  def test_that_signature_is_added_to_parameters_during_signing
    cred = stub_everything(:secred => 'shhh', :key => 'letmein', :valid? => true) 
    params = {}
    
    request = stub_everything(:parameters => params)
    auth = NetFlix::Authenticator.new(:request => request, :credentials => cred)
    auth.sign!
    assert params['oauth_signature']
  end

  def test_that_exception_is_raised_if_secret_is_missing
    credentials = stub_everything(:valid? => false)
    authenticator = NetFlix::Authenticator.new(:credentials => credentials)

    assert_raises ArgumentError do
      authenticator.require_credentials
    end
  end

end
