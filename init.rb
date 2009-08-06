require File.join( File.dirname(__FILE__), 'lib', 'flix4r' )
NetFlix::Credentials.config_file_name = File.join( RAILS_ROOT, 'config', 'netflix.yml' )
