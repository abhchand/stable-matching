# Provides a ruby implementation of several common matching algorithms
#
# Author::    Abhishek Chandrasekhar  (mailto:me@abhchand.me)
# License::   MIT

require "logger"

class StableMatching
  module LoggingHelper
    def set_logger(opts = {})
      @logger = opts.key?(:logger) ? opts[:logger] : Logger.new(nil)
    end
  end
end
