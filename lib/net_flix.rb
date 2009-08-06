module NetFlix

  class << self
	  
    def credentials
      @credentials ||= NetFlix::Credentials.from_file 
    end
  
    def logfile
      File.join( File.dirname(__FILE__), '..', 'log', 'netflix.log' )
    end

    def create_logger
      logdir = File.join( File.dirname(__FILE__), '..', 'log' )
      Dir.mkdir(logdir) unless File.exists? logdir

      Logger.new( logfile ) 
    end

    def logger
      @logger ||= create_logger 
    end

    def log(message)
      NetFlix.logger.info("[#{Time.now.to_i}] #{message}")
    end  
  end # class methods
end
