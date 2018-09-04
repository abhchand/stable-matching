# Provides a ruby implementation of several common matching algorithms
#
# Author::    Abhishek Chandrasekhar  (mailto:me@abhchand.me)
# License::   MIT

# Implements Phase II of Irving's (1985) Stable Roommates algorithm.
#
# See:
# - https://en.wikipedia.org/wiki/Stable_roommates_problem
# - https://www.youtube.com/watch?v=9Lo7TFAkohEaccepted_proposal?
#
# In this phase, each member that has accepted a proposal will remove those they
# prefer less than their current proposer.
#
# At the end of one iteration, one of two states are possible -
#
#   A. At least one member has exhausted their preference list
#       -> No solution exists
#
#   B. Some members have multiple preferences remaining
#       -> Proceed to Phase III
#
#   C. All members have one preference remaining
#       -> Solution has been found, no need to run Phase III
#
#
# NOTE: For the ease of implementation, step (C) is implemented as the first
# check in Phase III, although it is logically part of this step.
#
#
# === EXAMPLE
#
# Assume the output of Phase I is
#
#   A => [-B, D, +F, C, E],
#   B => [-E, F, +A, C],
#   C => [-D, +E, F, A, B],
#   D => [-F, +C, A, E],
#   E => [-C, D, +B, A],
#   F => [-A, B, +D, C]
#
# Where a "-" indicates a proposal made and a "+" indicates a proposal accepted.
#
# Rejections for Phase II would occur as follows. Note that all rejections are
# mutual - if `i` removes `j` from its preference list, then `j` must also
# remove `i` from its list
#
#   A accepted by B. B rejecting members less preferred than A: ["C"]
#   B accepted by E. E rejecting members less preferred than B: ["A"]
#   C accepted by D. D rejecting members less preferred than C: ["A", "E"]
#   D accepted by F. F rejecting members less preferred than D: ["C"]
#   E accepted by C. C rejecting members less preferred than E: ["A"]
#   F accepted by A. A rejecting members less preferred than F: []
#
# The output of this phase is a further reduced table is as follows
#
#   A => [B, F],
#   B => [E, F, A],
#   C => [D, E],
#   D => [F, C],
#   E => [C, B],
#   F => [A, B, D]
#
# Since at least one member has multiple preferences remaining, we proceed to
# Phase III
#

require_relative "../phase_runner"

class StableMatching
  class Roommate
    class PhaseIIRunner < StableMatching::PhaseRunner
      def initialize(preference_table, opts = {})
        @preference_table = preference_table
        @logger = opts.fetch(:logger)
      end

      def run
        @preference_table.members.each do |proposer|
          acceptor, rejections =
            determine_acceptor_and_their_rejections(proposer)

          @logger.debug(
            "#{proposer.name} accepted by #{acceptor.name}. "\
            "#{acceptor.name} rejecting members less preferred than "\
            "#{proposer.name}: #{rejections.map(&:name)}"
          )

          rejections.each { |rejected| acceptor.reject!(rejected) }
        end
      end

      private

      def determine_acceptor_and_their_rejections(proposer)
        acceptor = proposer.current_acceptor
        current_proposer_index = acceptor.preference_list.index(proposer)

        rejections = acceptor.preference_list[current_proposer_index + 1..-1]

        [acceptor, rejections]
      end
    end
  end
end
