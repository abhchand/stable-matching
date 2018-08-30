require "logger"

class StableMatching
  module LoggingHelper
    def set_logger(opts = {})
      if opts.key?(:logger)
        @logger = opts[:logger]
      else
        @logger = Logger.new(STDOUT)
        @logger.level = opts[:log_level] || Logger::INFO
      end
    end
  end
end
