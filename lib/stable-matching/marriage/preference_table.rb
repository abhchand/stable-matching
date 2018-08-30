# Provides a ruby implementation of several commong matching algorithms
#
# Author::    Abhishek Chandrasekhar  (mailto:me@abhchand.me)
# License::   MIT

require_relative "../preference_table"

class StableMatching
  class Marriage
    class PreferenceTable < StableMatching::PreferenceTable
      attr_accessor :partner_table

      def self.initialize_pair(raw_preference_table_a, raw_preference_table_b)
        table_a = new(raw_preference_table_a)
        table_b = new(raw_preference_table_b)

        table_a.partner_table = table_b
        table_b.partner_table = table_a

        return table_a, table_b
      end

      def initialize(raw_preference_table)
        members = initialize_members_from(raw_preference_table)

        @raw_preference_table = raw_preference_table

        # Avoid calling the parent initializer, but we still need to set
        # the delegated object. Thankfully SimpleDelegator offers a method
        # to set this directly
        __setobj__(members)
      end

      def partner_table=(partner_table)
        @partner_table = partner_table

        @raw_preference_table.each do |name, raw_preference_list|
          generate_preference_list(
            find_member_by_name(name),
            raw_preference_list,
            partner_table
          )
        end
      end

      def unmatched
        have_accepted = partner_table.members.select(&:has_accepted_proposal?)
        have_been_accepted = have_accepted.map(&:current_proposer)

        members - have_been_accepted
      end

      private

      def generate_preference_list(member, raw_preference_list, partner_table)
        member_list = raw_preference_list.map do |name|
          partner_table.name_to_member_mapping[name]
        end

        member.preference_list = PreferenceList.new(member_list)
      end
    end
  end
end
