require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift File.dirname(__FILE__)

require 'rspec'
require 'money-heuristics'

RSpec.configure do |c|
  c.order = :random
  c.filter_run :focus
  c.run_all_when_everything_filtered = true
end
