# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "version"

Gem::Specification.new do |spec|
  # rubocop:disable ExtraSpacing
  spec.name          = "stable-matching"
  spec.version       = StableMatching::VERSION
  spec.authors       = ["Abhishek Chandrasekhar"]
  spec.email         = ["me@abhchand.me"]
  spec.licenses      = ['MIT']

  spec.summary       = "A ruby implementation of various stable matching algorithms"
  spec.homepage      = "https://gitlab.com/abhchand/stable-matching"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(bin|benchmark|spec|doc|meta)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "pry", "~> 0.11.3"
  spec.add_development_dependency "rdoc", "~> 6.0", ">= 6.0.4"
  spec.add_development_dependency "rubocop", "~> 0.49.1"
  spec.add_development_dependency "rspec", "~> 3.4"
  # rubocop:enable ExtraSpacing
end
