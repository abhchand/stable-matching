require_relative "../common/validator"

class StableMatching
  class Marriage
    class Validator < StableMatching::Validator

      def self.validate_pair!(male_preferences, female_preferences)
        new(male_preferences, female_preferences).validate!
        new(female_preferences, male_preferences).validate!
      end

      def initialize(preference_table, partner_table)
        @preference_table = preference_table
        @partner_table = partner_table
      end

      def validate!
        case
        when !hash_of_arrays?         then handle_not_hash_of_arrays
        when empty?                   then handle_empty
        when !unique_keys?            then handle_not_unique_keys
        when !string_or_integer_keys? then handle_not_string_or_integer_keys
        when !symmetrical?            then handle_not_symmetrical
        end

        raise ::StableMatching::InvalidPreferences.new(@error) if @error
      end

      private

      def symmetrical?
        @preference_table.each do |name, preference_list|
          expected_members = @partner_table.keys - [name]
          actual_members = preference_list

          unless expected_members.sort == actual_members.sort
            @name = name
            @extra = actual_members - expected_members
            @missing = expected_members - actual_members
            return false
          end
        end

        true
      end
    end
  end
end
