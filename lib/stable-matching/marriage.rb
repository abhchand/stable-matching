require_relative "stable_matching"
require_relative "logging_helper"

require_relative "marriage/validator"
require_relative "marriage/preference_table"
require_relative "marriage/phase_i_runner"

class StableMatching
  class Marriage
    include StableMatching::LoggingHelper

    def self.solve!(alpha_preferences, beta_preferences)
      new(alpha_preferences, beta_preferences).solve!
    end

    def initialize(alpha_preferences, beta_preferences, opts = {})
      @orig_alpha_preferences = alpha_preferences
      @orig_beta_preferences = beta_preferences

      @alpha_preferences, @beta_preferences =
        PreferenceTable.initialize_pair(alpha_preferences, beta_preferences)

      set_logger(opts)
    end

    def solve!
      validate!

      # Ideally this would be in the initializer, but we wait to
      # instantiate the `PreferenceTable` models until after validation
      # Oh well..
      beta_preferences.partner_table = alpha_preferences
      alpha_preferences.partner_table = beta_preferences

      @logger.info("Running Phase I")
      PhaseIRunner.new(alpha_preferences, beta_preferences, logger: @logger).run

      build_solution
    end

    private

    def validate!
      Validator.validate_pair!(@orig_alpha_preferences, @orig_beta_preferences)
    end

    def alpha_preferences
      @alpha_preferences ||= PreferenceTable.new(@orig_alpha_preferences)
    end

    def beta_preferences
      @beta_preferences ||= PreferenceTable.new(@orig_beta_preferences)
    end

    def build_solution
      solution = {}

      @alpha_preferences.members.each do |partner|
        solution[partner.name] = partner.current_acceptor.name
      end

      @beta_preferences.members.each do |partner|
        solution[partner.name] = partner.current_proposer.name
      end

      solution
    end
  end
end
