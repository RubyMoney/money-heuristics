require 'money-heuristics/analyzer'
require 'money-heuristics/search_tree'

module MoneyHeuristics
  module Heuristics
    # An robust and efficient algorithm for finding currencies in
    # text. Using several algorithms it can find symbols, iso codes and
    # even names of currencies.
    # Although not recommendable, it can also attempt to find the given
    # currency in an entire sentence
    #
    # Returns: Array (matched results)
    def analyze(str, *filters)
      @_heuristics_search_tree ||= MoneyHeuristics::SearchTree.new(table).build

      return MoneyHeuristics::Analyzer.new(str, @_heuristics_search_tree).process(filters)
    end
  end
end
