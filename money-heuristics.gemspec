lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "money-heuristics/version"

Gem::Specification.new do |s|
  s.name        = "money-heuristics"
  s.version     = MoneyHeuristics::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Shane Emmons']
  s.email       = ['shane@emmons.io']
  s.homepage    = 'https://rubymoney.github.io/money-heuristics'
  s.summary     = 'Heuristic module for for the money gem'
  s.description = 'This is a module for heuristic analysis of the string input for the money gem. It was formerly part of the gem.'
  s.license     = 'MIT'

  s.add_dependency 'money', '>= 6.8.2'
  s.add_dependency 'sixarm_ruby_unaccent', ['>= 1.1.1', '< 2']

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "~> 3.4.0"
  s.add_development_dependency "yard", "~> 0.8"

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
end
