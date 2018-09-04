

# Stable Matching

![Stable Matching](https://gitlab.com/abhchand/stable-matching/raw/master/meta/logo.png)

[![Build Status](https://gitlab.com/abhchand/stable-matching/badges/master/build.svg)](https://gitlab.com/abhchand/stable-matching/pipelines)

A ruby implementation of various stable matching algorithms.

# Background

This gem provides a ruby implementation of the following matching algorithms

- [Stable Roommates Problem](https://en.wikipedia.org/wiki/Stable_roommates_problem)
- [Stable Marriage Problem](https://en.wikipedia.org/wiki/Stable_marriage_problem)

# Quick Start

## Stable Roommates

See or run `bin/stable-roommates-example` for an example usage.

Specify an input of ordered preferences as a hash of arrays. Keys may be `String` or `Integer` and preference table must include an even number of members.

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

The implementation of this algorithm is *not* guranteed to return a mathematically stable solution and may raise an error if no solution is found (see Errors below).

## Stable Marriage

See or run `bin/stable-marriage-example` for an example usage

Specify an input of ordered preferences as a hash of arrays for two groups. Keys may be `String` or `Integer`

```
alpha_preferences = {
  "A" => ["O", "M", "N", "L", "P"],
  "B" => ["P", "N", "M", "L", "O"],
  "C" => ["M", "P", "L", "O", "N"],
  "D" => ["P", "M", "O", "N", "L"],
  "E" => ["O", "L", "M", "N", "P"],
}

beta_preferences = {
  "L" => ["D", "B", "E", "C", "A"],
  "M" => ["B", "A", "D", "C", "E"],
  "N" => ["A", "C", "E", "D", "B"],
  "O" => ["D", "A", "C", "B", "E"],
  "P" => ["B", "E", "A", "C", "D"],
}

puts StableMarriage.solve!(alpha_preferences, beta_preferences,)
#=> {"A"=>"O", "B"=>"P", "C"=>"N", "D"=>"M", "E"=>"L", "L"=>"E", "M"=>"D", "N"=>"C", "O"=>"A", "P"=>"B"}
```

The implementation of this algorithm is always guranteed to return a mathematically stable solution.

# Errors

Your process should be prepared to handle the following errors when calling the stable matching library

```
StableMatching::Error
  |- StableMatching::NoStableSolutionError
  |- StableMatching::InvalidPreferences
```

# Logging

You may optionally pass a logger that will output the progress of the algorithm.

To utilize this option you'll have to instantiate an algorithm object yourself with a `:logger` option and then call `#solve!`.

``` ruby
logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG

StableRoommate.new(preference_table, logger: logger).solve!
```

# Benchmark / Performance

Below are some benchmarks for runtimes captured on a machine running OS X 10.11.5 (El Capitan) / 2.5 GHz Intel Core i7.

You can run `bin/benchmark` on any machine to regenerate these benchmarks

Note: Many combinatorics algorithms run in quadratic time (`O(n^2)`) and therfore performance degrades significantly when processing a large number of members.

### Stable Roommates

```
  N  | Avg Runtime (sec)
-----|------------------
  10 |            0.103
 100 |            1.075
 250 |           17.372
```

### Stable Marriage

```
   N  | Avg Runtime (sec)
------|------------------
   10 |            0.004
  100 |            0.053
 1000 |            0.334
```

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
