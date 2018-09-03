require "spec_helper"

RSpec.describe "Stable Roommate Validation", type: :service do
  describe ".validate!" do
    it "succeeds when all validations pass" do
      input = {
        1 => [2, 3, 4],
        2 => [3, 4, 1],
        3 => [4, 1, 2],
        4 => [1, 2, 3]
      }

      expect do
        StableMatching::Roommate::Validator.validate!(input)
      end.to_not raise_error
    end

    describe "input format" do
      it "raises an error when input is not a hash" do
        input = [1, 2, 3]

        expect do
          StableMatching::Roommate::Validator.validate!(input)
        end.to raise_error(
          StableMatching::InvalidPreferences,
          /Expecting.*hash of arrays/
        )
      end

      it "raises an error when input is not a hash of arrays" do
        input = {
          1 => { foo: "bar" },
          2 => { foo: "bar" },
          3 => { foo: "bar" },
          4 => { foo: "bar" }
        }

        expect do
          StableMatching::Roommate::Validator.validate!(input)
        end.to raise_error(
          StableMatching::InvalidPreferences,
          /Expecting.*hash of arrays/
        )
      end

      it "raises an error when preference table has an odd number of keys" do
        input = {
          1 => [2, 3],
          2 => [3, 1],
          3 => [1, 2],
        }

        expect do
          StableMatching::Roommate::Validator.validate!(input)
        end.to raise_error(
          StableMatching::InvalidPreferences,
          /Preference table must have an even number of keys/
        )
      end
    end

    describe "element presence" do
      it "raises an error when input is empty" do
        input = {}

        expect do
          StableMatching::Roommate::Validator.validate!(input)
        end.to raise_error(
          StableMatching::InvalidPreferences,
          /Preferences table can not empty/
        )
      end

      it "raises an error when any preference lists are empty" do
        input = {
          1 => [],
          2 => [3, 4, 1],
          3 => [4, 1, 2],
          4 => [1, 2, 3]
        }

        expect do
          StableMatching::Roommate::Validator.validate!(input)
        end.to raise_error(
          StableMatching::InvalidPreferences,
          /Preferences table can not empty/
        )
      end
    end

    describe "element class" do
      it "raises an error when input keys are not strings or integers" do
        input = {
          1.to_f => [2, 3, 4],
          2.to_f => [3, 4, 1],
          3.to_f => [4, 1, 2],
          4.to_f => [1, 2, 3]
        }

        expect do
          StableMatching::Roommate::Validator.validate!(input)
        end.to raise_error(
          StableMatching::InvalidPreferences,
          /All keys must be String or Fixnum/
        )
      end

      it "raises an error when preference lists is not strings or integers" do
        input = {
          1 => [2, 3, 4].map(&:to_f),
          2 => [3, 4, 1].map(&:to_f),
          3 => [4, 1, 2].map(&:to_f),
          4 => [1, 2, 3].map(&:to_f)
        }

        expect do
          StableMatching::Roommate::Validator.validate!(input)
        end.to raise_error(
          StableMatching::InvalidPreferences,
          /All keys must be String or Fixnum/
        )
      end

      it "raises an error when keys are of mixed type" do
        input = {
          1 => ["B", 3, 4],
          "B" => [3, 4, 1],
          3 => [4, 1, "B"],
          4 => [1, "B", 3]
        }

        expect do
          StableMatching::Roommate::Validator.validate!(input)
        end.to raise_error(
          StableMatching::InvalidPreferences,
          /All keys must be String or Fixnum/
        )
      end
    end

    describe "data integrity" do
      it "raises an error when preference lists have missing keys" do
        input = {
          1 => [2, 3],
          2 => [3, 4, 1],
          3 => [4, 1, 2],
          4 => [1, 2, 3]
        }

        expect do
          StableMatching::Roommate::Validator.validate!(input)
        end.to raise_error(
          StableMatching::InvalidPreferences,
          /Entry 1 has invalid preferences./
        )
      end

      it "raises an error when preference lists have extra keys" do
        input = {
          1 => [2, 4, 3, 9],
          2 => [3, 4, 1],
          3 => [4, 1, 2],
          4 => [1, 2, 3]
        }

        expect do
          StableMatching::Roommate::Validator.validate!(input)
        end.to raise_error(
          StableMatching::InvalidPreferences,
          /Entry 1 has invalid preferences./
        )
      end
    end
  end
end
