# Stable Matching

A ruby implementation of various stable matching algorithms.

# Background

This gem provides a ruby implementation of the following matching algorithms

- [Stable Roommates Problem](https://en.wikipedia.org/wiki/Stable_roommates_problem)
- [Stable Marriage Problem](https://en.wikipedia.org/wiki/Stable_marriage_problem)

# Quick Start

## Stable Roommates

See or run `bin/stable-roommates-example` for an example usage.

Specify an input of ordered preferences as a hash of arrays. Keys may be `String` or `Fixnum`

``` ruby
preference_table = {
  1 => [3, 4, 2, 6, 5],
  2 => [6, 5, 4, 1, 3],
  3 => [2, 4, 5, 1, 6],
  4 => [5, 2, 3, 6, 1],
  5 => [3, 1, 2, 4, 6],
  6 => [5, 1, 3, 4, 2]
}

StableRoommate.solve!(preference_table)
#=> {1=>6, 2=>4, 3=>5, 4=>2, 5=>3, 6=>1}
```

## Stable Marriage

See or run `bin/stable-marriage-example` for an example usage

Specify an input of ordered preferences as a hash of arrays for two groups. Keys may be `String` or `Fixnum`

```
male_preferences = {
  "A" => ["O", "M", "N", "L", "P"],
  "B" => ["P", "N", "M", "L", "O"],
  "C" => ["M", "P", "L", "O", "N"],
  "D" => ["P", "M", "O", "N", "L"],
  "E" => ["O", "L", "M", "N", "P"],
}

female_preferences = {
  "L" => ["D", "B", "E", "C", "A"],
  "M" => ["B", "A", "D", "C", "E"],
  "N" => ["A", "C", "E", "D", "B"],
  "O" => ["D", "A", "C", "B", "E"],
  "P" => ["B", "E", "A", "C", "D"],
}

puts StableMarriage.solve!(male_preferences, female_preferences,)
#=> {"A"=>"O", "B"=>"P", "C"=>"N", "D"=>"M", "E"=>"L", "L"=>"E", "M"=>"D", "N"=>"C", "O"=>"A", "P"=>"B"}
```

# Errors

Your process should be prepared to handle the following errors when calling the stable matching library

```
StableMatching::Error
  |- StableMatching::NoStableSolutionError
  |- StableMatching::InvalidPreferences
```

Errors are raised for either (a) failed validations or (b) mathematical instability

## Validations

All inputs will be validated to ensure the preference tables are of a valid structure. These include common sense format validations like "are the elements unique?", "are all the keys either strings or integers?", etc..


## Mathematical Stability

Often times a mathematically stable solution may not exist, in which case the above error will be raised.

The Stable Marriage algorithm is guranteed to always produce a mathematically stable solution.

# Logging

You may optionally pass a logger that will output the progress of the algorithm.

To utilize this option you'll have to instantiate an algorithm object yourself with a `:logger` option and then call `#solve!`.

``` ruby
logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG

StableRoommate.new(preference_table, logger: logger).solve!
```

# Benchmark / Performance

Given that many of these algorithms run in polynomial time (`O(n^2)`), performance degrades when processing more than ~1000 elements, since at that level a total of 1000 x 1000 = 1,000,000 comparisons are being made.

# Issues

Feel free to submit issues and enhancement requests.

# Contributing

All contributions to this project are welcome.

Code changes follow the "fork-and-pull" Git workflow.

 1. **Fork** the repository
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** so that your changes can be reviewed!
