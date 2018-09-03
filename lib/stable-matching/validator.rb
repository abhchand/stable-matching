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
      return true if @preference_table.empty?

      @preference_table.each_value.any?(&:empty?)
    end

    def handle_empty
      @error = "Preferences table can not empty"
    end

    def strings_or_integers?
      @preference_table.each do |key, array|
        @element_klass ||= key.class

        return false unless valid_element?(key)
        array.each { |value| return false unless valid_element?(value) }
      end

      true
    end

    def handle_not_strings_or_integers
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

    private

    def valid_element?(element)
      (element.is_a?(String) || element.is_a?(Fixnum)) &&
        element.class == @element_klass
    end
  end
end
