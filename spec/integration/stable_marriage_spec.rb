require "spec_helper"

RSpec.describe "Stable Marriage Problem", type: :integration do
  # rubocop:disable Style/WordArray
  it "returns the correct solution" do
    alpha_preferences = {
      "A" => ["O", "M", "N", "L", "P"],
      "B" => ["P", "N", "M", "L", "O"],
      "C" => ["M", "P", "L", "O", "N"],
      "D" => ["P", "M", "O", "N", "L"],
      "E" => ["O", "L", "M", "N", "P"]
    }

    beta_preferences = {
      "L" => ["D", "B", "E", "C", "A"],
      "M" => ["B", "A", "D", "C", "E"],
      "N" => ["A", "C", "E", "D", "B"],
      "O" => ["D", "A", "C", "B", "E"],
      "P" => ["B", "E", "A", "C", "D"]
    }

    actual =
      StableMatching::Marriage.solve!(alpha_preferences, beta_preferences)
    expected = {
      "A" => "O",
      "B" => "P",
      "C" => "N",
      "D" => "M",
      "E" => "L",
      "L" => "E",
      "M" => "D",
      "N" => "C",
      "O" => "A",
      "P" => "B"
    }

    expect(actual).to eq(expected)
  end

  it "works with string or integer keys" do
    alpha_preferences = {
      1 => [9, 7, 8, 6, 0],
      2 => [0, 8, 7, 6, 9],
      3 => [7, 0, 6, 9, 8],
      4 => [0, 7, 9, 8, 6],
      5 => [9, 6, 7, 8, 0]
    }

    beta_preferences = {
      6 => [4, 2, 5, 3, 1],
      7 => [2, 1, 4, 3, 5],
      8 => [1, 3, 5, 4, 2],
      9 => [4, 1, 3, 2, 5],
      0 => [2, 5, 1, 3, 4]
    }

    actual =
      StableMatching::Marriage.solve!(alpha_preferences, beta_preferences)
    expected = {
      1 => 9,
      2 => 0,
      3 => 8,
      4 => 7,
      5 => 6,
      6 => 5,
      7 => 4,
      8 => 3,
      9 => 1,
      0 => 2
    }

    expect(actual).to eq(expected)
  end

  it "is not dependent on the initial order of keys" do
    alpha_preferences = {
      "B" => ["P", "N", "M", "L", "O"],
      "A" => ["O", "M", "N", "L", "P"],
      "D" => ["P", "M", "O", "N", "L"],
      "C" => ["M", "P", "L", "O", "N"],
      "E" => ["O", "L", "M", "N", "P"]
    }

    beta_preferences = {
      "P" => ["B", "E", "A", "C", "D"],
      "M" => ["B", "A", "D", "C", "E"],
      "N" => ["A", "C", "E", "D", "B"],
      "L" => ["D", "B", "E", "C", "A"],
      "O" => ["D", "A", "C", "B", "E"]
    }

    actual =
      StableMatching::Marriage.solve!(alpha_preferences, beta_preferences)
    expected = {
      "A" => "O",
      "B" => "P",
      "C" => "N",
      "D" => "M",
      "E" => "L",
      "L" => "E",
      "M" => "D",
      "N" => "C",
      "O" => "A",
      "P" => "B"
    }

    expect(actual).to eq(expected)
  end

  it "is dependent on the order of preferences" do
    # Multiple solutions exists and while a stable solution is guranteed by
    # the algorithm, it may not be the most optimal. One example is how the
    # algorithm optimizes for the preferences of the first group, so swapping
    # prefernces yields a different stable matching.

    alpha_preferences = {
      "A" => ["O", "M", "N", "L", "P"],
      "B" => ["P", "N", "M", "L", "O"],
      "C" => ["M", "P", "L", "O", "N"],
      "D" => ["P", "M", "O", "N", "L"],
      "E" => ["O", "L", "M", "N", "P"]
    }

    beta_preferences = {
      "L" => ["D", "B", "E", "C", "A"],
      "M" => ["B", "A", "D", "C", "E"],
      "N" => ["A", "C", "E", "D", "B"],
      "O" => ["D", "A", "C", "B", "E"],
      "P" => ["B", "E", "A", "C", "D"]
    }

    actual =
      StableMatching::Marriage.solve!(beta_preferences, alpha_preferences)
    expected = {
      "A" => "M",
      "B" => "P",
      "C" => "N",
      "D" => "O",
      "E" => "L",
      "L" => "E",
      "M" => "A",
      "N" => "C",
      "O" => "D",
      "P" => "B"
    }

    expect(actual).to eq(expected)
  end
  # rubocop:enable Style/WordArray
end
