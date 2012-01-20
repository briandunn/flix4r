require 'test_helper'

class NetflixTest < Test::Unit::TestCase

  def test_that_http_method_is_validated
    assert_equal false, NetFlix::Request.new(:http_method => 'Thing').valid?
  end

  def test_that_http_method_knows_valid_values
    assert_equal true, NetFlix::Request.new(:http_method => 'POST').valid?
    assert_equal true, NetFlix::Request.new(:http_method => 'GET').valid?
  end

  def test_that_parameters_appear_alphabetically_in_parameter_string
    assert_equal 'key_a=value1&key_b=value2', NetFlix::Request.new(:parameters => {'key_b' => 'value2', 'key_a' => 'value1'}).parameter_string
  end

  def test_that_authenticator_receives_copy_of_request
    request = NetFlix::Request.new(:parameters => {'key1' => '2'})
    NetFlix::Authenticator.expects(:new).with(has_entry(:request, request)).returns(stub_everything)
    Net::HTTP.stubs(:get)

    request.send
  end

  def test_that_request_is_logged_when_sent
    request = NetFlix::Request.new(:url => 'some_url', :parameters => {'logme' => 'please'})
    NetFlix.expects(:log).with('some_url?logme=please')
    request.log
  end

  context :encoding do
    should "encode parameter values" do
      request = NetFlix::Request.new(:url => 'some_url', :parameters => {'term' => 'with spaces'})
      assert_match /with%20spaces/, request.target.to_s
    end
  end
end
