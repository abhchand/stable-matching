# Provides a ruby implementation of several common matching algorithms
#
# Author::    Abhishek Chandrasekhar  (mailto:me@abhchand.me)
# License::   MIT

require_relative "stable_matching"
require_relative "logging_helper"

require_relative "roommate/validator"
require_relative "roommate/preference_table"
require_relative "roommate/phase_i_runner"
require_relative "roommate/phase_ii_runner"
require_relative "roommate/phase_iii_runner"

class StableMatching
  # Provides a solution to the Stable Roommate problem by implementing
  # the Irving algorithm
  #
  # Takes as input the preferences of each member and produces a mathematically
  # optimal matching/pairing between members.
  #
  # Example Input:
  #
  #    preferences = {
  #      "A" => ["B", "D", "C"],
  #      "B" => ["D", "A", "C"],
  #      "C" => ["D", "A", "B"],
  #      "D" => ["C", "A", "B"]
  #    }
  #
  # Example Output:
  #
  #    {"A"=>"B", "B"=>"A", "C"=>"D", "D"=>"C"}
  class Roommate
    include StableMatching::LoggingHelper

    # Runs the algorithm with the specified inputs.
    #
    # This is a class level shortcut to initialize a new
    # +StableMatching::Roommate+ instance and calls +solve!+ on it.
    #
    # <b>Inputs:</b>
    #
    # <tt>preference_table</tt>::
    #     A +Hash+ of +Array+ values specifying the preferences of the group
    #
    # <b>Output:</b>
    # A +Hash+ mapping members to other members.
    def self.solve!(preference_table)
      new(preference_table).solve!
    end

    # Initializes a `StableMatching::Roommate` object.
    #
    #
    # <b>Inputs:</b>
    #
    # <tt>preference_table</tt>::
    #     A +Hash+ of +Array+ values specifying the preferences of the group.
    #     +Array+ can contain +String+ or +Fixnum+ entries.
    # <tt>opts[:logger]</tt>::
    #     +Logger+ instance to use for logging
    #
    # <b>Output:</b>
    #
    # +StableMatching::Roommate+ instance
    def initialize(preference_table, opts = {})
      @orig_preference_table = preference_table
      set_logger(opts)
    end

    # Runs the algorithm on the preference_table.
    # Also validates the preference_table and raises an error if invalid.
    #
    # The roommate algorithm is not guranteed to find a solution in all cases
    # and will raise an error if a solution is mathematically unstable (does
    # not exist).
    #
    # <b>Output:</b>
    #
    # A +Hash+ mapping members to other members.
    #
    # <b>Raises:</b>
    #
    # <tt>StableMatching::InvalidPreferences</tt>::
    #     When preference_table is of invalid format
    # <tt>StableMatching::NoStableSolutionError</tt>::
    #     When no mathematically stable solution can be found
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
