
this_dir = File.dirname(__FILE__)

  require 'rubygems'
  require 'activesupport'
  require 'open-uri'
  require 'yaml'
  require 'hmac-sha1'
  require 'json'
  require 'net/http'
  require 'ftools'
  require 'nokogiri'
  require 'crack'
  gem 'mloughran-api_cache'
  require 'api_cache'
  require File.join( this_dir, 'valuable' )

  builders = File.join( this_dir, 'net_flix', 'builders')

  ActiveSupport::Dependencies.load_paths << this_dir
  ActiveSupport::Dependencies.load_paths << builders 

