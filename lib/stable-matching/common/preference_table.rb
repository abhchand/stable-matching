require "delegate"
require "pp"

require_relative "member"
require_relative "preference_list"

class StableMatching
  class PreferenceTable < SimpleDelegator
    attr_reader :name_to_member_mapping

    def initialize(preference_table_data)
      members = initialize_members_from(preference_table_data)

      preference_table_data.each do |name, preference_list_data|
        generate_preference_list(
          find_member_by_name(name),
          preference_list_data
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
      have_accepted = members.select(&:has_accepted_proposal?)
      have_been_accepted = have_accepted.map(&:current_proposer)

      members - have_been_accepted
    end

    def complete?
      counts = members.map { |member| member.preference_list.count }.uniq
      counts == [1]
    end

    # This returns the same object - explain
    def members
      __getobj__
    end

    private

    def find_member_by_name(name)
      @name_to_member_mapping[name]
    end

    def initialize_members_from(preference_table_data)
      @name_to_member_mapping = {}

      preference_table_data.keys.each do |name|
        @name_to_member_mapping[name] = Member.new(name)
      end

      @name_to_member_mapping.values
    end

    def generate_preference_list(member, preference_list_data)
      member_list =
        preference_list_data.map { |name| find_member_by_name(name) }

      member.preference_list = PreferenceList.new(member_list)
    end
  end
end
