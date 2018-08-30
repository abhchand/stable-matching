require_relative "../common/preference_table"

class StableMatching
  class Marriage
    class PreferenceTable < StableMatching::PreferenceTable
      attr_accessor :partner_table

      def self.initialize_pair(preference_table_data_a, preference_table_data_b)
        table_a = new(preference_table_data_a)
        table_b = new(preference_table_data_b)

        table_a.partner_table = table_b
        table_b.partner_table = table_a

        return table_a, table_b
      end

      def initialize(preference_table_data)
        members = initialize_members_from(preference_table_data)

        @preference_table_data = preference_table_data

        # Avoid calling the parent initializer, but we still need to set
        # the delegated object. Thankfully SimpleDelegator offers a method
        # to set this directly
        __setobj__(members)
      end

      def partner_table=(partner_table)
        @partner_table = partner_table

        @preference_table_data.each do |name, preference_list_data|
          generate_preference_list(
            find_member_by_name(name),
            preference_list_data,
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

      def generate_preference_list(member, preference_list_data, partner_table)
        member_list = preference_list_data.map do |name|
          partner_table.name_to_member_mapping[name]
        end

        member.preference_list = PreferenceList.new(member_list)
      end
    end
  end
end
