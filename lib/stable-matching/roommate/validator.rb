# Provides a ruby implementation of several common matching algorithms
#
# Author::    Abhishek Chandrasekhar  (mailto:me@abhchand.me)
# License::   MIT

require_relative "../validator"

class StableMatching
  class Roommate
    class Validator < StableMatching::Validator
      def validate!
        case
        when !hash_of_arrays?         then handle_not_hash_of_arrays
        when empty?                   then handle_empty
        when !unique_keys?            then handle_not_unique_keys
        when !string_or_integer_keys? then handle_not_string_or_integer_keys
        when !even_sized?             then handle_not_even_sized
        when !symmetrical?            then handle_not_symmetrical
        end

        raise ::StableMatching::InvalidPreferences.new(@error) if @error
      end
    end
  end
end
