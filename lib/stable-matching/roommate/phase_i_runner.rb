# Provides a ruby implementation of several commong matching algorithms
#
# Author::    Abhishek Chandrasekhar  (mailto:me@abhchand.me)
# License::   MIT

=begin
Implements Phase I of Irving's (1985) Stable Roommates algorithm.

See:
- https://en.wikipedia.org/wiki/Stable_roommates_problem
- https://www.youtube.com/watch?v=5QLxAp8mRKo

In this round each roommate "proposes" to their top preference that has not
yet rejected them.

During the proposal, one of 3 things can happen

1. The proposed roommate has not received a proposal and immediately accepts
2. The proposed roommate has already received a proposal, but preferes this one
   over the existing proposal. The proposed roommate "rejects" it's initial
   proposer and accepts this new one
3. The proposed roommate has already received a proposal, and still prefers the
   existing one to the new proposal. The proposed roommate "rejects" the new
   proposal

In the above situations, every rejection is mutual - if `i` removes `j` from
its preference list, then `j` must also remove `i` from its list

This cycle continues until one of two things happens

A. Every roommate has a match - i.e. every user has proposed and been accepted
   In this case we move on to Phase II
B. At least one roommate has exhausted their preference list. In this case there
   is no mathematically stable matching

EXAMPLE:

Take the following preference lists

"A" => ["B", "D", "F", "C", "E"],
"B" => ["D", "E", "F", "A", "C"],
"C" => ["D", "E", "F", "A", "B"],
"D" => ["F", "C", "A", "E", "B"],
"E" => ["F", "C", "D", "B", "A"],
"F" => ["A", "B", "D", "C", "E"]

We always start with the first unmatched user. Initially this is "A". The
sequence of events are -

'A' proposes to 'B'
'B' accepts 'A'
'B' proposes to 'D'
'D' accepts 'B'
'C' proposes to 'D'
'D' accepts 'C', rejects 'B'
'B' proposes to 'E'
'E' accepts 'B'
'D' proposes to 'F'
'F' accepts 'D'
'E' proposes to 'F'
'F' rejects
'E' proposes to 'C'
'C' accepts 'E'
'F' proposes to 'A'
'A' accepts 'F'

The result of this phase is a reduced table, as shown below.

A "-" indicates a proposal made and a "+" indicates a proposal accepted.
Rejected elements are removed.

"A" => ["-B", "D", "+F", "C", "E"],
"B" => ["-E", "F", "+A", "C"],
"C" => ["-D", "+E", "F", "A", "B"],
"D" => ["-F", "+C", "A", "E"],
"E" => ["-C", "D", "+B", "A"],
"F" => ["-A", "B", "+D", "C"]
=end

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

          roommate = @preference_table.unmatched.first
          top_choice = roommate.first_preference

          simulate_proposal(roommate, top_choice)
        end

        # Check once more since final iteration may have left the table unstable
        ensure_table_is_stable!
      end

      private

      def ensure_table_is_stable!
        unless @preference_table.stable?
          raise StableMatching::NoStableSolutionError.new(
            "No stable match found!"
          )
        end
      end
    end
  end
end
