module MoneyHeuristics
  class SearchTree
    def initialize(currency_data)
      @currency_data = currency_data
    end

    # Build a search tree from the currency database
    def build
      {
        by_symbol:   currencies_by_symbol,
        by_iso_code: currencies_by_iso_code,
        by_name:     currencies_by_name
      }
    end

    private

    attr_reader :currency_data

    def currencies_by_symbol
      {}.tap do |result|
        currency_data.each do |_, currency|
          symbol = (currency[:symbol]||"").downcase
          symbol.chomp!('.')
          (result[symbol] ||= []) << currency

          (currency[:alternate_symbols] || []).each do |ac|
            ac = ac.downcase
            ac.chomp!('.')
            (result[ac] ||= []) << currency
          end
        end
      end
    end

    def currencies_by_iso_code
      {}.tap do |result|
        currency_data.each do |_, currency|
          (result[currency[:iso_code].downcase] ||= []) << currency
        end
      end
    end

    def currencies_by_name
      {}.tap do |result|
        currency_data.each do |_, currency|
          name_parts = currency[:name].unaccent.downcase.split
          name_parts.each {|part| part.chomp!('.')}

          # construct one branch per word
          root = result
          while name_part = name_parts.shift
            root = (root[name_part] ||= {})
          end

          # the leaf is a currency
          (root[:value] ||= []) << currency
        end
      end
    end
  end
end
