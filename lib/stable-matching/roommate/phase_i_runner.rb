# Provides a ruby implementation of several common matching algorithms
#
# Author::    Abhishek Chandrasekhar  (mailto:me@abhchand.me)
# License::   MIT

#
# Implements Phase I of Irving's (1985) Stable Roommates algorithm.
#
# See:
# - https://en.wikipedia.org/wiki/Stable_roommates_problem
# - https://www.youtube.com/watch?v=9Lo7TFAkohEaccepted_proposal?
#
# In this round each member who has not had their proposal accepted "proposes"
# to their top remaining preference
#
# Each recipient of a proposal can take one of 3 actions -
#
# 1. The recipient has not received a previous proposal and immediately accepts
#
# 2. The recipient prefers this new proposal over an existing one.
#    The recipient "rejects" it's initial proposl and accepts this new one
#
# 3. The recipient prefers the existing proposal over the new one.
#    The recipient "rejects" the new proposal
#
# In the above situations, every rejection is mutual - if `i` removes `j` from
# its preference list, then `j` must also remove `i` from its list
#
# This cycle continues until one of two things happens
#
# A. Every member has had their proposal accepted
#     -> Move on to Phase II
# B. At least one member has exhausted their preference list
#     -> No solution exists
#
#
# === EXAMPLE
#
# Take the following preference lists
#
#   A => [B, D, F, C, E],
#   B => [D, E, F, A, C],
#   C => [D, E, F, A, B],
#   D => [F, C, A, E, B],
#   E => [F, C, D, B, A],
#   F => [A, B, D, C, E]
#
# We always start with the first unmatched user. Initially this is "A".
# The sequence of events are -
#
#   'A' proposes to 'B'
#   'B' accepts 'A'
#   'B' proposes to 'D'
#   'D' accepts 'B'
#   'C' proposes to 'D'
#   'D' accepts 'C', rejects 'B'
#   'B' proposes to 'E'
#   'E' accepts 'B'
#   'D' proposes to 'F'
#   'F' accepts 'D'
#   'E' proposes to 'F'
#   'F' rejects
#   'E' proposes to 'C'
#   'C' accepts 'E'
#   'F' proposes to 'A'
#   'A' accepts 'F'
#
# The result of this phase is shown below.
# A "-" indicates a proposal made and a "+" indicates a proposal accepted.
# Rejected elements are removed.
#
#   A => [-B, D, +F, C, E],
#   B => [-E, F, +A, C],
#   C => [-D, +E, F, A, B],
#   D => [-F, +C, A, E],
#   E => [-C, D, +B, A],
#   F => [-A, B, +D, C]

require_relative "../phase_runner"

class StableMatching
  class Roommate
    class PhaseIRunner < StableMatching::PhaseRunner
      def initialize(preference_table, opts = {})
        @preference_table = preference_table
        @logger = opts.fetch(:logger)
      end

      def run
        while @preference_table.unmatched.any?
          ensure_table_is_stable!

          member = @preference_table.unmatched.first
          top_choice = member.first_preference

          simulate_proposal(member, top_choice)
        end

        # Check once more since final iteration may have left the table unstable
        ensure_table_is_stable!
      end

      private

      def ensure_table_is_stable!
        return true if @preference_table.stable?
        raise StableMatching::NoStableSolutionError, "No stable match found!"
      end
    end
  end
end
