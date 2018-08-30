# Provides a ruby implementation of several commong matching algorithms
#
# Author::    Abhishek Chandrasekhar  (mailto:me@abhchand.me)
# License::   MIT

require_relative "stable_matching"
require_relative "logging_helper"

require_relative "marriage/validator"
require_relative "marriage/preference_table"
require_relative "marriage/phase_i_runner"

class StableMatching
  # Provides a solution to the Stable Marriage problem by implementing
  # the Gale-Shapley algorithm
  #
  # Takes as input the preferences of two groups - alpha and beta - and
  # produces a mathematically optimal matching/pairing between the two groups.
  #
  # Example Input:
  #
  #    alpha_preferences = {
  #      "A" => ["M", "N", "L"],
  #      "B" => ["N", "M", "L"],
  #      "C" => ["M", "L", "N"],
  #    }
  #
  #    beta_preferences = {
  #      "L" => ["B", "C", "A"],
  #      "M" => ["B", "A", "C"],
  #      "N" => ["A", "C", "B"],
  #    }
  #
  # Example Output:
  #
  #    {"A"=>"M", "B"=>"N", "C"=>"L", "L"=>"C", "M"=>"A", "N"=>"B"}
  class Marriage
    include StableMatching::LoggingHelper

    # Runs the algorithm with the specified inputs.
    #
    # This is a class level shortcut to initialize a new
    # +StableMatching::Marriage+ instance and calls +solve!+ on it.
    #
    # <b>Inputs:</b>
    #
    # <tt>alpha_preferences</tt>::
    #     A +Hash+ of +Array+ values specifying the preferences of the alpha
    #     group
    # <tt>beta_preferences</tt>::
    #     A +Hash+ of +Array+ values specifying the preferences of the beta
    #     group
    #
    # <b>Output:</b>
    # A +Hash+ mapping alpha members to beta and beta members to alpha members.
    def self.solve!(alpha_preferences, beta_preferences)
      new(alpha_preferences, beta_preferences).solve!
    end

    # Initializes a `StableMatching::Marriage` object.
    #
    #
    # <b>Inputs:</b>
    #
    # <tt>alpha_preferences</tt>::
    #     A +Hash+ of +Array+ values specifying the preferences of the alpha
    #     group. +Array+ can contain +String+ or +Fixnum+ entries.
    # <tt>beta_preferences</tt>::
    #     A +Hash+ of +Array+ values specifying the preferences of the beta
    #     group. +Array+ can contain +String+ or +Fixnum+ entries.
    # <tt>opts[:logger]</tt>::
    #     +Logger+ instance to use for logging
    #
    # <b>Output:</b>
    #
    # +StableMatching::Marriage+ instance
    def initialize(alpha_preferences, beta_preferences, opts = {})
      @orig_alpha_preferences = alpha_preferences
      @orig_beta_preferences = beta_preferences

      @alpha_preferences, @beta_preferences =
        PreferenceTable.initialize_pair(alpha_preferences, beta_preferences)

      set_logger(opts)
    end

    # Runs the algorithm on the alpha and beta preference sets.
    # Also validates the preference sets and raises an error if invalid.
    #
    # <b>Output:</b>
    #
    # A +Hash+ mapping alpha members to beta and beta members to alpha members.
    #
    # <b>Raises:</b>
    #
    # <tt>StableMatching::InvalidPreferences</tt>::
    #     When alpha or beta preference groups are of invalid format
    def solve!
      validate!

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
