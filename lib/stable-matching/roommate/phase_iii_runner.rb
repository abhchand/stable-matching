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
# In this last phase we attempt to find any preference cycles and reject them.
#
# This is done by building a pair of members (Xi, Yi) as follows
#
#   - Xi is the first member with at least 2 preferences
#   - Yi is null
#   - Yi+1 is the 2nd preference of Xi
#   - Xi+1 is the last preference of Yi+1
#
# Continue calculating pairs (Xi, Yi) until Xi repeats values. At this point a
# cycle has been found.
#
# Mutually reject every pair (Xi, Yi)
#
# After this one of 3 possiblities exists -
#
#   A. At least one member has exhausted their preference list
#       -> No solution exists
#
#   B. Some members have multiple preferences remaining
#       -> Repeat the above process to eliminate further cycles
#
#   C. All members have one preference remaining
#       -> Solution has been found
#
# === EXAMPLE
#
# Assume the reduced output of Phase II is
#
#   A => [B, F],
#   B => [E, F, A],
#   C => [D, E],
#   D => [F, C],
#   E => [C, B],
#   F => [A, B, D]
#
# Start with "A" since it is the first member with at least two preferences.
#
# Build (Xi, Yi) pairs as follows
#
#   i      1   2   3   4
#   -----+---+---+---+----
#   x:   | A | D | E | A
#   y:   | - | F | C | B
#
# Where -
#
#   'F' is the 2nd preference of 'A'
#   'D' is the last preference of 'F'
#   'C' is the 2nd preference of 'D'
#   etc...
#
# As soon as we see "A" again, we stop since we have found a cycle.
#
# Now we will mutually reject the following pairs, as definied by the inner
# pairings
#
#   - (D, F)
#   - (E, C)
#   - (A, B)
#
# At this point, no preference list is exhausted and some have more than one
# preference remaining. We need to find and eliminate more preference cycles.
#
#   i      1   2
#   -----+---+---
#   x:   | B | B
#   y:   | - | F
#
# Now we will mutually reject
#
#   - (F, B)
#
# This gives us the stable solution below, since each roommate has exactly one
# preference remaining
#
#   A => [F],
#   B => [E],
#   C => [D],
#   D => [C],
#   E => [B],
#   F => [A]

require_relative "../phase_runner"

class StableMatching
  class Roommate
    class PhaseIIIRunner < StableMatching::PhaseRunner
      def initialize(preference_table, opts = {})
        @preference_table = preference_table
        @logger = opts.fetch(:logger)
      end

      def run
        # The output of previous phase may have resulted in a complete
        # table, in which case this step doesn't need to be run
        return @preference_table if @preference_table.complete?

        while table_is_stable? && !@preference_table.complete?
          x = [@preference_table.members_with_multiple_preferences.first]
          y = [nil]

          until any_repeats?(x)
            # require 'pry'; binding.pry if x.last.second_preference.nil?
            y << x.last.second_preference
            x << y.last.last_preference
          end

          detect_and_reject_cycles(x, y)
        end
      end

      private

      def any_repeats?(arr)
        arr.uniq.count != arr.count
      end

      def detect_and_reject_cycles(x, y)
        x, y = retrieve_cycle(x, y)

        msg = "Found cycle: "
        y.each_with_index { |_, i| msg << "(#{x[i].name}, #{y[i].name})" }
        @logger.debug(msg)

        x.each_with_index do |r1, i|
          r2 = y[i]
          @logger.debug("Mutually rejecting '#{r1.name}', '#{r2.name}'")
          r2.reject!(r1)
        end
      end

      def retrieve_cycle(x, y)
        repeated_member = x.detect { |i| x.count(i) > 1 }

        first_index = 1
        last_index = x.count - x.reverse.index(repeated_member) - 1

        [x[first_index..last_index], y[first_index..last_index]]
      end

      def table_is_stable?
        return true if @preference_table.stable?
        raise StableMatching::NoStableSolutionError, "No stable match found!"
      end
    end
  end
end
