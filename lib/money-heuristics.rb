# frozen_string_literal: true

require 'money/currency'

require 'money-heuristics/string'
require 'money-heuristics/heuristics'

Money::Currency.extend MoneyHeuristics::Heuristics
