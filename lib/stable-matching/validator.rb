# Provides a ruby implementation of several common matching algorithms
#
# Author::    Abhishek Chandrasekhar  (mailto:me@abhchand.me)
# License::   MIT

class StableMatching
  class Validator
    def self.validate!(preference_table)
      new(preference_table).validate!
    end

    def initialize(preference_table)
      @preference_table = preference_table
    end

    # @abstract Subclass is expected to implement #validate!
    # @!method validate!
    #    Validate the structure and content of the `preference_table` element

    private

    def hash_of_arrays?
      return false unless @preference_table.is_a?(Hash)
      @preference_table.values.each { |p| return false unless p.is_a?(Array) }

      true
    end

    def handle_not_hash_of_arrays
      @error = "Expecting a preference table hash of arrays"
    end

    def empty?
      @preference_table.empty?
    end

    def handle_empty
      @error = "Preferences table can not empty"
    end

    def unique_keys?
      keys = @preference_table.keys
      uniq_keys = keys.uniq

      if keys.size != uniq_keys.uniq.size
        @extra_keys = (keys - uniq_keys).uniq
        return false
      end

      true
    end

    def handle_not_unique_keys
      @error = "Duplicate keys found: #{@extra_keys}"
    end

    def string_or_integer_keys?
      @preference_table.keys.each do |key|
        return false unless key.is_a?(String) || key.is_a?(Fixnum)
      end

      true
    end

    def handle_not_string_or_integer_keys
      @error = "All keys must be String or Fixnum"
    end

    def even_sized?
      @preference_table.keys.size % 2 == 0
    end

    def handle_not_even_sized
      @error = "Preference table must have an even number of keys"
    end

    def symmetrical?
      @preference_table.each do |name, preference_list|
        expected_members = @preference_table.keys - [name]
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

    def handle_not_symmetrical
      @error = "Entry #{@name} has invalid preferences. "\
        "The extra elements are: #{@extra}. "\
        "The missing elements are: #{@missing}"
    end
  end
end
