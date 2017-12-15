module MoneyHeuristics
  class Analyzer
    attr_reader :search_tree, :words
    attr_accessor :str, :currencies, :methods

    def initialize(str, search_tree)
      @str = (str || '').dup
      @search_tree = search_tree
      @currencies = []
      @methods = { iso_code: "search_by_iso_code", 
                   symbol: "search_by_symbol", 
                   name: "search_by_name" }
    end

    def process(filters)
      format
      return [] if str.empty?

      if (methods.keys & filters).any?
        filters.each{ |filter| send(methods[filter]) }
      else
        methods.values.each{|method| send(method)}
      end

      prepare_reply
    end

    private

    def format
      str.gsub!(/[\r\n\t]/,'')
      str.gsub!(/[0-9][\.,:0-9]*[0-9]/,'')
      str.gsub!(/[0-9]/, '')
      str.downcase!
      @words = str.unaccent.split
      @words.each {|word| word.chomp!('.'); word.chomp!(',') }
    end

    def search_by_symbol
      words.each do |word|
        if found = search_tree[:by_symbol][word]
          currencies.concat(found)
        end
      end
    end

    def search_by_iso_code
      words.each do |word|
        if found = search_tree[:by_iso_code][word]
          currencies.concat(found)
        end
      end
    end

    def search_by_name
      # remember, the search tree by name is a construct of branches and leaf!
      # We need to try every combination of words within the sentence, so we
      # end up with a x^2 equation, which should be fine as most names are either
      # one or two words, and this is multiplied with the words of given sentence

      search_words = words.dup

      while search_words.length > 0
        root = search_tree[:by_name]

        search_words.each do |word|
          if root = root[word]
            if root[:value]
              currencies.concat(root[:value])
            end
          else
            break
          end
        end

        search_words.delete_at(0)
      end
    end

    def prepare_reply
      codes = currencies.map do |currency|
        currency[:iso_code]
      end
      codes.uniq!
      codes.sort!
      codes
    end
  end
end
