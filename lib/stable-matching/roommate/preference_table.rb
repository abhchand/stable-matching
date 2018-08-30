require_relative "../common/preference_table"

class StableMatching
  class Roommate
    class PreferenceTable < StableMatching::PreferenceTable
      def stable?
        members.all? { |member| !member.preference_list.empty? }
      end

      def members_with_multiple_preferences
        members.select { |member| member.preference_list.count > 1 }
      end
    end
  end
end
