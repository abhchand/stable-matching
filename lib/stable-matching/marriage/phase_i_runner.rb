=begin
Implements the Gale-Shapley (1962) algorithm.

See:
  https://en.wikipedia.org/wiki/Stable_marriage_problem#Solution
  https://www.youtube.com/watch?v=GsBf3fJFpSw

Each male "proposes" to his top female preference that has not yet rejected
him.

During the proposal, one of 3 things can happen -

1. The proposed female has not received a proposal and immediately accepts
2. The proposed female has already received a proposal, but preferes this one
   over the existing proposal. The proposed female "rejects" her initial
   proposer and accepts this new one
3. The proposed female has already received a proposal, and still prefers the
   existing one to the new proposal. The proposed female "rejects" the new
   proposal

In the above situations, every rejection is mutual - if `i` removes `j` from
its preference list, then `j` must also remove `i` from its list

This cycle continues until ever male/female has a match.
Mathematically, every participant is guranteed a match so this algorithm
always converges on a solution.
=end

require_relative "../common/phase_runner"

class StableMatching
  class Marriage
    class PhaseIRunner < StableMatching::PhaseRunner
      def initialize(male_preferences, female_preferences, opts = {})
        @male_preferences = male_preferences
        @female_preferences = female_preferences

        @logger = opts.fetch(:logger)
      end

      def run
        while @male_preferences.unmatched.any?
          @male_preferences.unmatched.each_with_index do |spouse, i|
            top_choice = spouse.first_preference
            simulate_proposal(spouse, top_choice)
          end
        end
      end
    end
  end
end
