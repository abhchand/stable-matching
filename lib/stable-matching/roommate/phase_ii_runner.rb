=begin
Implements Phase II of Irving's (1985) Stable Roommates algorithm.

See:
- https://en.wikipedia.org/wiki/Stable_roommates_problem
- https://www.youtube.com/watch?v=5QLxAp8mRKo

In this phase, for each roommate we remove all preferences less desirable than
their currently accepted one.

EXAMPLE:

Assume the reduced output of Phase I is

"A" => ["-B", "D", "+F", "C", "E"],
"B" => ["-E", "F", "+A", "C"],
"C" => ["-D", "+E", "F", "A", "B"],
"D" => ["-F", "+C", "A", "E"],
"E" => ["-C", "D", "+B", "A"],
"F" => ["-A", "B", "+D", "C"]

where a "-" indicates a proposal made and a "+" indicates a proposal accepted.

Rejections for Phase II would occur as follows. Note that all rejections are
mutual - if `i` removes `j` from its preference list, then `j` must also
remove `i` from its list

'A' rejects ["C", "E"]
'B' rejects ["C"]
'C' rejects ["F"]
'D' rejects ["A", "E"]
'E' rejects []
'F' rejects []

The output of this phase is a further reduced table is as follows

"A" => ["B", "F"],
"B" => ["E", "F", "A"],
"C" => ["D", "E"],
"D" => ["F", "C"],
"E" => ["C", "B"],
"F" => ["A", "B", "D"]
=end

require_relative "../common/phase_runner"

class StableMatching
  class Roommate
    class PhaseIIRunner < StableMatching::PhaseRunner
      def initialize(preference_table, opts = {})
        @preference_table = preference_table
        @logger = opts.fetch(:logger)
      end

      def run
        @preference_table.members.each do |roommate|
          rejections = roommates_to_reject(roommate)

          @logger.debug("'#{roommate.name}' rejects #{rejections.map(&:name)}")

          rejections.each do |rejected_roommate|
            roommate.reject!(rejected_roommate)
          end
        end
      end

      private

      def roommates_to_reject(roommate)
        current_proposer_index =
          roommate
          .preference_list
          .index(roommate.current_proposer)

        roommate.preference_list[current_proposer_index+1..-1]
      end
    end
  end
end
