require 'rubygems'
require 'active_support/core_ext'
require 'api_cache'
require 'crack'
require 'fileutils'
require 'hmac-sha1'
require 'json'
require 'net/http'
require 'nokogiri'
require 'open-uri'
require 'yaml'
autoload :NetFlix, 'net_flix'
autoload :ActorBuilder, 'net_flix/builders/actor_builder'
autoload :FormatBuilder, 'net_flix/builders/format_builder'
autoload :Valuable, 'valuable'
