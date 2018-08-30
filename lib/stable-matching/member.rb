# Provides a ruby implementation of several common matching algorithms
#
# Author::    Abhishek Chandrasekhar  (mailto:me@abhchand.me)
# License::   MIT

class StableMatching
  class Member
    attr_reader :name, :received_proposals_from, :accepted_proposal_from
    attr_writer :preference_list

    def initialize(name)
      @name = name
      @accepted_proposal_from = nil
    end

    def to_s
      name
    end

    def preference_list
      if @preference_list.nil?
        raise "preference list not set for member: #{name}"
      end

      @preference_list
    end

    def current_proposer
      @accepted_proposal_from
    end

    def current_acceptor
      preference_list.detect do |member|
        member.accepted_proposal_from == self
      end
    end

    def has_accepted_proposal?
      !current_proposer.nil?
    end

    def would_prefer?(new_proposer)
      return true unless has_accepted_proposal?
      preference_of(new_proposer) > preference_of(current_proposer)
    end

    def accept_proposal_from!(member)
      @accepted_proposal_from = member
    end

    def reject!(member)
      @accepted_proposal_from = nil if current_proposer == member

      # Delete each member from the other member's preference list
      preference_list.delete(member)
      member.preference_list.delete(self)
    end

    def first_preference
      preference_list.first
    end

    def second_preference
      preference_list[1]
    end

    def last_preference
      preference_list.last
    end

    private

    def preference_of(member)
      index = preference_list.index(member)

      unless index.nil?
        # Return the preference as the inverse of the index so a smaller index
        # has a greater preference
        preference_list.size - index
      end
    end
  end
end
