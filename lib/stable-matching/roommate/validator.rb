# Provides a ruby implementation of several common matching algorithms
#
# Author::    Abhishek Chandrasekhar  (mailto:me@abhchand.me)
# License::   MIT

require_relative "../validator"

class StableMatching
  class Roommate
    class Validator < StableMatching::Validator
      # rubocop:disable Metrics/CyclomaticComplexity
      def validate!
        case
        when !hash_of_arrays?         then handle_not_hash_of_arrays
        when empty?                   then handle_empty
        when !strings_or_integers?    then handle_not_strings_or_integers
        when !even_sized?             then handle_not_even_sized
        when !symmetrical?            then handle_not_symmetrical
        end

        raise ::StableMatching::InvalidPreferences, @error if @error
      end
      # rubocop:enable Metrics/CyclomaticComplexity
    end
  end
end
