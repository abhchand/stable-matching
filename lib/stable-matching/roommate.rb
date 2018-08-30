require_relative "stable_matching"
require_relative "logging_helper"

require_relative "roommate/validator"
require_relative "roommate/preference_table"
require_relative "roommate/phase_i_runner"
require_relative "roommate/phase_ii_runner"
require_relative "roommate/phase_iii_runner"

class StableMatching
  class Roommate
    include StableMatching::LoggingHelper

    def self.solve!(preference_table)
      new(preference_table).solve!
    end

    def initialize(preference_table, opts = {})
      @orig_preference_table = preference_table
      set_logger(opts)
    end

    def solve!
      validate!

      @logger.debug("Running Phase I")
      PhaseIRunner.new(preference_table, logger: @logger).run

      @logger.debug("Running Phase II")
      PhaseIIRunner.new(preference_table, logger: @logger).run

      @logger.debug("Running Phase III")
      PhaseIIIRunner.new(preference_table, logger: @logger).run

      build_solution
    end

    private

    def validate!
      Validator.validate!(@orig_preference_table)
    end

    def preference_table
      @preference_table ||= PreferenceTable.new(@orig_preference_table)
    end

    def build_solution
      solution = {}

      preference_table.members.each do |roommate|
        solution[roommate.name] = roommate.first_preference.name
      end

      solution
    end
  end
end
