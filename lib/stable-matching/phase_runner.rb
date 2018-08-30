class StableMatching
  class PhaseRunner

    private

    def simulate_proposal(proposer, proposed)
      @logger.debug("'#{proposer.name}' proposes to '#{proposed.name}'")

      case
      when !proposed.has_accepted_proposal?
        accept(proposer, proposed)
      when proposed.would_prefer?(proposer)
        accept_better_proposal(proposer, proposed)
      else
        reject(proposer, proposed)
      end
    end

    def accept(proposer, proposed)
      @logger.debug("'#{proposed.name}' accepts '#{proposer.name}'")

      proposed.accept_proposal_from!(proposer)
    end

    def accept_better_proposal(proposer, proposed)
      @logger.debug(
        "'#{proposed.name}' accepts '#{proposer.name}', "\
        "rejects '#{proposed.current_proposer.name}'"
      )

      proposed.reject!(proposed.current_proposer)
      proposed.accept_proposal_from!(proposer)
    end

    def reject(proposer, proposed)
      @logger.debug("'#{proposed.name}' rejects '#{proposer.name}'")
      proposed.reject!(proposer)
    end
  end
end
