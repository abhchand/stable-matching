# Provides a ruby implementation of several commong matching algorithms
#
# Author::    Abhishek Chandrasekhar  (mailto:me@abhchand.me)
# License::   MIT

=begin
Implements Phase II of Irving's (1985) Stable Roommates algorithm.

See:
- https://en.wikipedia.org/wiki/Stable_roommates_problem
- https://www.youtube.com/watch?v=5QLxAp8mRKo

In this last phase we attempt to find any preference cycles and reject them.

This is done by building a pair of roommates (Xi, Y,), (Xi+1, Yi+i), ... as
follows

1. Start with the first roommate to have at least two preferences. This is Xi
2. Find their second preference. This is Yi
3. Find Yi's last preference, this is Xi+1
4. Repeat 2-4 until one of the Xi elements repeats.
5. Reject every pair of (Yi, Xi+1)

After this one of 3 possiblities exists -

A. At least one roommate has exhausted their preference list. In this case there
   is no mathematically stable matching
B. Every roommate has exactly one preference left. This is a stable matching
   and we are done
C. Some roommates have more than one preference left. We need to find and
   eliminate more preference cycles, so repeat steps 1-5 again

EXAMPLE -

Assume the reduced output of Phase II is

"A" => ["B", "F"],
"B" => ["E", "F", "A"],
"C" => ["D", "E"],
"D" => ["F", "C"],
"E" => ["C", "B"],
"F" => ["A", "B", "D"]

Start with "A" since it is the first roommate with at least two preferences

Alternating the cycle of finding the 2nd preference and the last preference, we
can build the following pairings

(A, F)(D, C)(E, B)(A, )

As soon as we see "A" again, we stop since we have found a cycle.

Now we will mutually reject the following pairs, as definied by the inner
pairings

- (F, D)
- (C, E)
- (B, A)

At this point, no preference list is exhausted and some have more than one
preference remaining. We need to find and eliminate more preference cycles.

Starting with "B" since it is the first roommate with at least two preferences,
we find the following cycle

(B, F)(B, )

Now we will mutually reject -

- (F, B)

Which gives us the stable solution below, since each roommate hss exactly one
preference remaining

"A" => ["F"],
"B" => ["E"],
"C" => ["D"],
"D" => ["C"],
"E" => ["B"],
"F" => ["A"]
=end

require_relative "../phase_runner"

class StableMatching
  class Roommate
    class PhaseIIIRunner < StableMatching::PhaseRunner
      def initialize(preference_table, opts = {})
        @preference_table = preference_table
        @logger = opts.fetch(:logger)
      end

      def run
        while table_is_stable? && !@preference_table.complete?
          x = [@preference_table.members_with_multiple_preferences.first]
          y = []

          while !any_repeats?(x)
            y << x.last.second_preference
            x << y.last.last_preference
          end

          # Take only the elements involved in the start and end of the cycle
          index = x.index(x.last)
          x = x[index..-1]
          y = y[index..-1]

          msg = "Found a cycle in - "
          y.each_with_index { |r1, i| msg << "(#{x[i].name}, #{y[i].name})" }
          msg << "(#{x.last.name}, )"
          @logger.debug(msg)

          y.each_with_index do |r1, i|
            r2 = x[i+1]
            @logger.debug("Mutually rejecting '#{r1.name}', '#{r2.name}'")
            r2.reject!(r1)
          end
        end
      end

      private

      def any_repeats?(arr)
        arr.uniq.count != arr.count
      end

      def table_is_stable?
        if @preference_table.stable?
          true
        else
          raise StableMatching::NoStableSolutionError.new(
            "No stable match found!"
          )
        end
      end
    end
  end
end
