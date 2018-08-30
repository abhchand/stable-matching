require "delegate"

class StableMatching
  class PreferenceList < SimpleDelegator
    def initialize(preference_list, opts = {})
      super(preference_list)
    end

    def to_s
      map(&:name).to_s
    end
  end
end