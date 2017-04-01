require 'money-heuristics/analyzer'

module MoneyHeuristics
  module Heuristics
    # An robust and efficient algorithm for finding currencies in
    # text. Using several algorithms it can find symbols, iso codes and
    # even names of currencies.
    # Although not recommendable, it can also attempt to find the given
    # currency in an entire sentence
    #
    # Returns: Array (matched results)
    def analyze(str)
      return MoneyHeuristics::Analyzer.new(str, search_tree).process
    end

    private

    # Build a search tree from the currency database
    def search_tree
      @_search_tree ||= {
        :by_symbol => currencies_by_symbol,
        :by_iso_code => currencies_by_iso_code,
        :by_name => currencies_by_name
      }
    end

    def currencies_by_symbol
      {}.tap do |r|
        table.each do |dummy, c|
          symbol = (c[:symbol]||"").downcase
          symbol.chomp!('.')
          (r[symbol] ||= []) << c

          (c[:alternate_symbols]||[]).each do |ac|
            ac = ac.downcase
            ac.chomp!('.')
            (r[ac] ||= []) << c
          end
        end
      end
    end

    def currencies_by_iso_code
      {}.tap do |r|
        table.each do |dummy,c|
          (r[c[:iso_code].downcase] ||= []) << c
        end
      end
    end

    def currencies_by_name
      {}.tap do |r|
        table.each do |dummy,c|
          name_parts = c[:name].unaccent.downcase.split
          name_parts.each {|part| part.chomp!('.')}

          # construct one branch per word
          root = r
          while name_part = name_parts.shift
            root = (root[name_part] ||= {})
          end

          # the leaf is a currency
          (root[:value] ||= []) << c
        end
      end
    end
  end
end
