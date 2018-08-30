require_relative "stable_matching"
require_relative "logging_helper"

require_relative "marriage/validator"
require_relative "marriage/preference_table"
require_relative "marriage/phase_i_runner"

class StableMatching
  class Marriage
    include StableMatching::LoggingHelper

    def self.solve!(male_preferences, female_preferences)
      new(male_preferences, female_preferences).solve!
    end

    def initialize(male_preferences, female_preferences, opts = {})
      @orig_male_preferences = male_preferences
      @orig_female_preferences = female_preferences

      @male_preferences, @female_preferences =
        PreferenceTable.initialize_pair(male_preferences, female_preferences)

      set_logger(opts)
    end

    def solve!
      validate!

      # Ideally this would be in the initializer, but we wait to
      # instantiate the `PreferenceTable` models until after validation
      # Oh well..
      female_preferences.partner_table = male_preferences
      male_preferences.partner_table = female_preferences

      @logger.info("Running Phase I")
      PhaseIRunner.new(male_preferences, female_preferences, logger: @logger).run

      build_solution
    end

    private

    def validate!
      Validator.validate_pair!(@orig_male_preferences, @orig_female_preferences)
    end

    def male_preferences
      @male_preferences ||= PreferenceTable.new(@orig_male_preferences)
    end

    def female_preferences
      @female_preferences ||= PreferenceTable.new(@orig_female_preferences)
    end

    def build_solution
      solution = {}

      @male_preferences.members.each do |spouse|
        solution[spouse.name] = spouse.current_acceptor.name
      end

      @female_preferences.members.each do |spouse|
        solution[spouse.name] = spouse.current_proposer.name
      end

      solution
    end
  end
end
