# Provides a ruby implementation of several common matching algorithms
#
# Author::    Abhishek Chandrasekhar  (mailto:me@abhchand.me)
# License::   MIT

require "logger"

class StableMatching
  module LoggingHelper
    # rubocop:disable Style/AccessorMethodName
    def set_logger(opts = {})
      @logger = opts.key?(:logger) ? opts[:logger] : Logger.new(nil)
    end
    # rubocop:enable Style/AccessorMethodName
  end
end
