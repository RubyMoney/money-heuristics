require 'money/currency'

require 'money-heuristics/string'
require 'money-heuristics/heuristics'

Money::Currency.extend MoneyHeuristics::Heuristics
