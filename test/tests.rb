test_dir = File.dirname(__FILE__)
tests = Dir.entries(test_dir).select{|f| f=~/.*_test\.rb$/}
tests.each {|t| require File.join(test_dir, t)}
