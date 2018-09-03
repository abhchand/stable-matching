require "spec_helper"

RSpec.describe "Stable Marriage Validation", type: :service do
  describe ".validate_pair!" do
    it "succeeds when all validations pass" do
      input_a = {
        1 => [3, 4],
        2 => [4, 3]
      }

      input_b = {
        3 => [1, 2],
        4 => [2, 1]
      }

      expect do
        StableMatching::Marriage::Validator.validate_pair!(input_a, input_b)
      end.to_not raise_error
    end

    describe "input format" do
      it "raises an error when input is not a hash" do
        input_a = [1, 2, 3]

        input_b = {
          3 => [1, 2],
          4 => [2, 1]
        }

        expect do
          StableMatching::Marriage::Validator.validate_pair!(input_a, input_b)
        end.to raise_error(
          StableMatching::InvalidPreferences,
          /Expecting.*hash of arrays/
        )
      end

      it "raises an error when input is not a hash of arrays" do
        input_a = {
          1 => { foo: "bar" },
          2 => { foo: "bar" }
        }

        input_b = {
          3 => [1, 2],
          4 => [2, 1]
        }

        expect do
          StableMatching::Marriage::Validator.validate_pair!(input_a, input_b)
        end.to raise_error(
          StableMatching::InvalidPreferences,
          /Expecting.*hash of arrays/
        )
      end

      it "accepts preference tables with an odd number of keys" do
        input_a = {
          1 => [4, 5, 6],
          2 => [5, 6, 4],
          3 => [6, 4, 5]
        }

        input_b = {
          4 => [1, 2, 3],
          5 => [2, 3, 1],
          6 => [3, 1, 2]
        }

        expect do
          StableMatching::Marriage::Validator.validate_pair!(input_a, input_b)
        end.to_not raise_error
      end
    end

    describe "element presence" do
      it "raises an error when input is empty" do
        input_a = {}

        input_b = {
          3 => [1, 2],
          4 => [2, 1]
        }

        expect do
          StableMatching::Marriage::Validator.validate_pair!(input_a, input_b)
        end.to raise_error(
          StableMatching::InvalidPreferences,
          /Preferences table can not empty/
        )
      end

      it "raises an error when any preference lists are empty" do
        input_a = {
          1 => [],
          2 => [4, 3]
        }

        input_b = {
          3 => [1, 2],
          4 => [2, 1]
        }

        expect do
          StableMatching::Marriage::Validator.validate_pair!(input_a, input_b)
        end.to raise_error(
          StableMatching::InvalidPreferences,
          /Preferences table can not empty/
        )
      end
    end

    describe "element class" do
      it "raises an error when input keys are not strings or integers" do
        input_a = {
          1.to_f => [3, 4],
          2.to_f => [4, 3]
        }

        input_b = {
          3 => [1, 2],
          4 => [2, 1]
        }

        expect do
          StableMatching::Marriage::Validator.validate_pair!(input_a, input_b)
        end.to raise_error(
          StableMatching::InvalidPreferences,
          /All keys must be String or Integer/
        )
      end

      it "raises an error when preference lists is not strings or integers" do
        input_a = {
          1 => [3, 4].map(&:to_f),
          2 => [4, 3].map(&:to_f)
        }

        input_b = {
          3 => [1, 2],
          4 => [2, 1]
        }

        expect do
          StableMatching::Marriage::Validator.validate_pair!(input_a, input_b)
        end.to raise_error(
          StableMatching::InvalidPreferences,
          /All keys must be String or Integer/
        )
      end

      it "raises an error when keys are of mixed type" do
        input_a = {
          1 => ["B", 4],
          2 => [4, "B"]
        }

        input_b = {
          "B" => [1, 2],
          4 => [2, 1]
        }

        expect do
          StableMatching::Marriage::Validator.validate_pair!(input_a, input_b)
        end.to raise_error(
          StableMatching::InvalidPreferences,
          /All keys must be String or Integer/
        )
      end
    end

    describe "data integrity" do
      it "raises an error when preference lists have missing keys" do
        input_a = {
          1 => [3],
          2 => [4, 3]
        }

        input_b = {
          3 => [1, 2],
          4 => [2, 1]
        }

        expect do
          StableMatching::Marriage::Validator.validate_pair!(input_a, input_b)
        end.to raise_error(
          StableMatching::InvalidPreferences,
          /Entry 1 has invalid preferences./
        )
      end

      it "raises an error when preference lists have extra keys" do
        input_a = {
          1 => [3, 4, 9],
          2 => [4, 3]
        }

        input_b = {
          3 => [1, 2],
          4 => [2, 1]
        }

        expect do
          StableMatching::Marriage::Validator.validate_pair!(input_a, input_b)
        end.to raise_error(
          StableMatching::InvalidPreferences,
          /Entry 1 has invalid preferences./
        )
      end

      it "raises an error when partner table preference lists are malformed" do
        input_a = {
          1 => [3, 4],
          2 => [4, 3]
        }

        input_b = {
          3 => [1],
          4 => [2, 1]
        }

        expect do
          StableMatching::Marriage::Validator.validate_pair!(input_a, input_b)
        end.to raise_error(
          StableMatching::InvalidPreferences,
          /Entry 3 has invalid preferences./
        )
      end
    end
  end
end
