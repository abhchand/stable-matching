# Provides a ruby implementation of several common matching algorithms
#
# Author::    Abhishek Chandrasekhar  (mailto:me@abhchand.me)
# License::   MIT

require_relative "../validator"

class StableMatching
  class Marriage
    class Validator < StableMatching::Validator

      def self.validate_pair!(alpha_preferences, beta_preferences)
        new(alpha_preferences, beta_preferences).validate!
        new(beta_preferences, alpha_preferences).validate!
      end

      def initialize(preference_table, partner_table)
        @preference_table = preference_table
        @partner_table = partner_table
      end

      def validate!
        case
        when !hash_of_arrays?         then handle_not_hash_of_arrays
        when empty?                   then handle_empty
        when !strings_or_integers?    then handle_not_strings_or_integers
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
