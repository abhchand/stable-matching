# Provides a ruby implementation of several common matching algorithms
#
# Author::    Abhishek Chandrasekhar  (mailto:me@abhchand.me)
# License::   MIT

require "delegate"
require "pp"

require_relative "member"
require_relative "preference_list"

class StableMatching
  class PreferenceTable < SimpleDelegator
    attr_reader :name_to_member_mapping

    def initialize(raw_preference_table)
      members = initialize_members_from(raw_preference_table)

      raw_preference_table.each do |name, raw_preference_list|
        generate_preference_list(
          find_member_by_name(name),
          raw_preference_list
        )
      end

      super(members)
    end

    def to_s
      members.map { |m| "#{m.name} => #{m.preference_list}" }.join(", ")
    end

    def print
      table = {}
      members.each { |m| table[m.name] = m.preference_list.map(&:name) }

      pp(table)
    end

    def unmatched
      have_accepted = members.select(&:accepted_proposal?)
      have_been_accepted = have_accepted.map(&:current_proposer)

      members - have_been_accepted
    end

    def complete?
      counts = members.map { |member| member.preference_list.count }.uniq
      counts == [1]
    end

    def members
      __getobj__
    end

    private

    def find_member_by_name(name)
      @name_to_member_mapping[name]
    end

    def initialize_members_from(raw_preference_table)
      @name_to_member_mapping = {}

      raw_preference_table.keys.each do |name|
        @name_to_member_mapping[name] = Member.new(name)
      end

      @name_to_member_mapping.values
    end

    def generate_preference_list(member, raw_preference_list)
      member_list =
        raw_preference_list.map { |name| find_member_by_name(name) }

      member.preference_list = PreferenceList.new(member_list)
    end
  end
end
