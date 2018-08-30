class StableMatching
  class Error < StandardError; end

  class NoStableSolutionError < Error; end
  class InvalidPreferences < Error; end
end
