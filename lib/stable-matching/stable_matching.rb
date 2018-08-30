# Provides a ruby implementation of several common matching algorithms
#
# Author::    Abhishek Chandrasekhar  (mailto:me@abhchand.me)
# License::   MIT

class StableMatching
  class Error < StandardError; end

  class NoStableSolutionError < Error; end
  class InvalidPreferences < Error; end
end
