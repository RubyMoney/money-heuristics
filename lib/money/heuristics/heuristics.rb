# encoding: utf-8

require "money"
require "sixarm_ruby_unaccent"

# Overwrites unaccent method of sixarm_ruby_unaccent.
class String
  def unaccent
    accentmap = ACCENTMAP
    accentmap.delete("\u{0142}") # Delete ł symbol from ACCENTMAP used in PLN currency
    accentmap.delete("\u{010D}") # Delete č symbol from ACCENTMAP used in CZK currency
    accentmap.delete("\u{FDFC}") # Delete ﷼ symbol from ACCENTMAP used in IRR, SAR and YER currencies
    accentmap.delete("\u{20A8}") # Delete ₨ symbol from ACCENTMAP used in INR, LKR, MUR, NPR, PKR and SCR currencies
    split(//u).map {|c| accentmap[c] || c }.join("")
  end
end

class Money
  class Currency
    module Heuristics

      # An robust and efficient algorithm for finding currencies in
      # text. Using several algorithms it can find symbols, iso codes and
      # even names of currencies.
      # Although not recommendable, it can also attempt to find the given
      # currency in an entire sentence
      #
      # Returns: Array (matched results)
      def analyze(str)
        return Analyzer.new(str, search_tree).process
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

      class Analyzer
        attr_reader :search_tree, :words
        attr_accessor :str, :currencies

        def initialize str, search_tree
          @str = (str||'').dup
          @search_tree = search_tree
          @currencies = []
        end

        def process
          format
          return [] if str.empty?

          search_by_symbol
          search_by_iso_code
          search_by_name

          prepare_reply
        end

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
  end
end

