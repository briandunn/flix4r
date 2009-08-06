require 'test_helper'

class CredentialsTest < Test::Unit::TestCase

  def file_contents
    {:key => :value}.to_yaml
  end

  def test_that_credentials_file_is_not_loaded_if_it_dne
    File.stubs(:exist?).returns(false)
    File.expects(:open).never
    NetFlix::Credentials.from_file
  end

  def test_that_credentials_file_is_loaded_if_present
    File.stubs(:exist?).returns(true)
    File.expects(:open).returns(file_contents)
    NetFlix::Credentials.from_file
  end

  def test_that_values_from_file_are_present
    File.stubs(:exist?).returns(true)
    File.stubs(:open).returns({:key => :my_key, :secret => 'quiet!'}.to_yaml)
    assert_equal :my_key, NetFlix::Credentials.from_file.key
  end

end
