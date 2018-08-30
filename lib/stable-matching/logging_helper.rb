require "logger"

class StableMatching
  module LoggingHelper
    def set_logger(opts = {})
      @logger = opts.key?(:logger) ? opts[:logger] : Logger.new(nil)
    end
  end
end
