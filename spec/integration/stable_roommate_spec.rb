require "spec_helper"

RSpec.describe "Stable Roommate Problem", type: :integration do
  # rubocop:disable Style/WordArray
  it "returns the correct solution" do
    preferences = {
      "A" => ["B", "D", "F", "C", "E"],
      "B" => ["D", "E", "F", "A", "C"],
      "C" => ["D", "E", "F", "A", "B"],
      "D" => ["F", "C", "A", "E", "B"],
      "E" => ["F", "C", "D", "B", "A"],
      "F" => ["A", "B", "D", "C", "E"]
    }

    actual = StableMatching::Roommate.solve!(preferences)
    expected = {
      "A" => "F",
      "B" => "E",
      "C" => "D",
      "D" => "C",
      "E" => "B",
      "F" => "A"
    }

    expect(actual).to eq(expected)
  end

  it "works with string or integer keys" do
    preferences = {
      1 => [2, 4, 6, 3, 5],
      2 => [4, 5, 6, 1, 3],
      3 => [4, 5, 6, 1, 2],
      4 => [6, 3, 1, 5, 2],
      5 => [6, 3, 4, 2, 1],
      6 => [1, 2, 4, 3, 5]
    }

    actual = StableMatching::Roommate.solve!(preferences)
    expected = {
      1 => 6,
      2 => 5,
      3 => 4,
      4 => 3,
      5 => 2,
      6 => 1
    }

    expect(actual).to eq(expected)
  end

  it "is not dependent on the initial order of keys" do
    preferences = {
      "B" => ["D", "E", "F", "A", "C"],
      "A" => ["B", "D", "F", "C", "E"],
      "D" => ["F", "C", "A", "E", "B"],
      "C" => ["D", "E", "F", "A", "B"],
      "F" => ["A", "B", "D", "C", "E"],
      "E" => ["F", "C", "D", "B", "A"]
    }

    actual = StableMatching::Roommate.solve!(preferences)
    expected = {
      "A" => "F",
      "B" => "E",
      "C" => "D",
      "D" => "C",
      "E" => "B",
      "F" => "A"
    }

    expect(actual).to eq(expected)
  end

  context "no stable solution exists" do
    it "raises an error when phase I fails" do
      # All other rooommates prefer "D" the least and prefer each other
      # with equal priority. In this case D's preference list will get
      # exhausted as no one prefers D to any other match
      preferences = {
        "A" => ["B", "C", "D"],
        "B" => ["C", "A", "D"],
        "C" => ["A", "B", "D"],
        "D" => ["A", "B", "C"]
      }

      expect do
        StableMatching::Roommate.solve!(preferences)
      end.to raise_error(
        StableMatching::NoStableSolutionError,
        "No stable match found!"
      )
    end

    it "raises an error when a cycle is detected in Phase III" do
      # Adapted from Irving's original paper as an example of a preference
      # table where a cycle is detected in Phase III
      # http://www.dcs.gla.ac.uk/~pat/jchoco/roommates/papers/Comp_sdarticle.pdf

      preferences = {
        "A" => ["B", "F", "D", "C", "E"],
        "B" => ["C", "E", "A", "F", "D"],
        "C" => ["A", "F", "B", "E", "D"],
        "D" => ["E", "B", "C", "F", "A"],
        "E" => ["F", "A", "C", "D", "B"],
        "F" => ["D", "B", "E", "A", "C"]
      }

      expect do
        StableMatching::Roommate.solve!(preferences)
      end.to raise_error(
        StableMatching::NoStableSolutionError,
        "No stable match found!"
      )
    end
  end
  # rubocop:enable Style/WordArray
end
