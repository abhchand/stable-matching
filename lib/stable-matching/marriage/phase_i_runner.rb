=begin
Implements the Gale-Shapley (1962) algorithm.

Calculates a stable match between two groups - alpha and beta - given their
individual preference lists for members of the other group

See:
  https://en.wikipedia.org/wiki/Stable_marriage_problem#Solution
  https://www.youtube.com/watch?v=GsBf3fJFpSw

Each alpha "proposes" to their top beta preference that has not yet rejected
them.

During the proposal, one of 3 things can happen -

1. The proposed beta has not received a proposal.
    => They immediately accept
2. The proposed beta has already received a proposal, but preferes this one
   over the existing proposal.
    => The proposed beta "rejects" the initial proposal and accepts this new one
3. The proposed beta has already received a proposal, and prefers the
   existing over this new proposal.
    => The proposed beta "rejects" the new proposal

Note: Rejections are mutual. If `i` removes `j` from their preference list,
      then `j` must also remove `i` from its list

This cycle continues until every alpha/beta has a match.

Mathematically, every participant is guranteed a match so this algorithm
always converges on a solution.

EXAMPLE:

Take the following preference lists

alpha preferences:
"A"=>["O", "M", "N", "L", "P"]
"B"=>["P", "N", "M", "L", "O"]
"C"=>["M", "P", "L", "O", "N"]
"D"=>["P", "M", "O", "N", "L"]
"E"=>["O", "L", "M", "N", "P"]

beta preferences:
"L"=>["D", "B", "E", "C", "A"]
"M"=>["B", "A", "D", "C", "E"]
"N"=>["A", "C", "E", "D", "B"]
"O"=>["D", "A", "C", "B", "E"]
"P"=>["B", "E", "A", "C", "D"]

We always start with the first unmatched alpha user.
Initially this is "A" (we only cycle through alphas since they propose to the
betas). The sequence of events are -

'A' proposes to 'O'
'O' accepts 'A'
'B' proposes to 'P'
'P' accepts 'B'
'C' proposes to 'M'
'M' accepts 'C'
'D' proposes to 'P'
'P' rejects 'D'
'E' proposes to 'O'
'O' rejects 'E'
'D' proposes to 'M'
'M' accepts 'D', rejects 'C'
'E' proposes to 'L'
'L' accepts 'E'
'C' proposes to 'P'
'P' rejects 'C'
'C' proposes to 'L'
'L' rejects 'C'
'C' proposes to 'O'
'O' rejects 'C'
'C' proposes to 'N'
'N' accepts 'C'

At this point there are no alpha users left unmatched (and by definition, no
corresponding beta users left unmatched). All alpha members have had their
proposals accepted by a beta user.

The resulting solution is

"A" => "O"
"B" => "P"
"C" => "N"
"D" => "M"
"E" => "L"
"L" => "E"
"M" => "D"
"N" => "C"
"O" => "A"
"P" => "B"

=end

require_relative "../phase_runner"

class StableMatching
  class Marriage
    class PhaseIRunner < StableMatching::PhaseRunner
      def initialize(alpha_preferences, beta_preferences, opts = {})
        @alpha_preferences = alpha_preferences
        @beta_preferences = beta_preferences

        @logger = opts.fetch(:logger)
      end

      def run
        while @alpha_preferences.unmatched.any?
          @alpha_preferences.unmatched.each do |partner|
            top_choice = partner.first_preference
            simulate_proposal(partner, top_choice)
          end
        end
      end
    end
  end
end
