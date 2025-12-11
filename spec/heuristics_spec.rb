require 'spec_helper'

describe MoneyHeuristics do
  describe "#analyze_string" do
    subject { Money::Currency }

    it "is not affected by blank characters and numbers" do
      expect(subject.analyze('123')).to eq []
      expect(subject.analyze('\n123 \t')).to eq []
    end

    it "returns nothing when given nothing" do
      expect(subject.analyze('')).to eq []
      expect(subject.analyze(nil)).to eq []
    end

    it "finds a currency by use of its symbol" do
      expect(subject.analyze('zł')).to eq ['PLN']
    end

    it "is not affected by trailing dot" do
      expect(subject.analyze('zł.')).to eq ['PLN']
    end

    it "finds match even if has numbers after" do
      expect(subject.analyze('zł 123')).to eq ['PLN']
    end

    it "finds match even if has numbers before" do
      expect(subject.analyze('123 zł')).to eq ['PLN']
    end

    it "find match even if symbol is next to number" do
      expect(subject.analyze('300zł')).to eq ['PLN']
    end

    it "finds match even if has numbers with delimiters" do
      expect(subject.analyze('zł 123,000.50')).to eq ['PLN']
      expect(subject.analyze('zł123,000.50')).to eq ['PLN']
    end

    it "finds currencies with dots in symbols" do
      expect(subject.analyze('L.E.')).to eq ['EGP']
    end

    it "finds by name" do
      expect(subject.analyze('1900 bulgarian lev')).to eq ['BGN']
      expect(subject.analyze('Swedish Krona')).to eq ['SEK']
    end

    it "Finds several currencies when several match" do
      r = subject.analyze('$400')
      expect(r).to include("ARS")
      expect(r).to include("USD")
      expect(r).to include("NZD")

      r = subject.analyze('9000 £')
      expect(r).to include("GBP")
      expect(r).to include("SHP")
      expect(r).to include("SYP")
    end

    it "should use alternate symbols" do
      expect(subject.analyze('US$')).to eq ['USD']
    end

    it "finds a currency by use of its iso code" do
      expect(subject.analyze('USD 200')).to eq ['USD']
    end

    it "finds currencies in the middle of a sentence!" do
      expect(subject.analyze('It would be nice to have 10000 Albanian lek by tomorrow!')).to eq ['ALL']
    end

    it "finds several currencies in the same text!" do
      expect(subject.analyze("10EUR is less than 100:- but really, I want US$1")).to eq ['EUR', 'SEK', 'USD']
    end

    it "find currencies with normal characters in name using unaccent" do
      expect(subject.analyze("10 Nicaraguan Cordoba")).to eq ["NIO"]
    end

    it "find currencies with special characters in name using unaccent" do
      expect(subject.analyze("10 Nicaraguan Córdoba")).to eq ["NIO"]
    end

    it "find currencies with special symbols using unaccent" do
      expect(subject.analyze("ل.س")).not_to eq []
      expect(subject.analyze("R₣")).not_to eq []
      expect(subject.analyze("ரூ")).not_to eq []
      expect(subject.analyze("රු")).not_to eq []
      expect(subject.analyze("сом")).not_to eq []
      expect(subject.analyze("圓")).not_to eq []
      expect(subject.analyze("円")).not_to eq []
      expect(subject.analyze("৳")).not_to eq []
      expect(subject.analyze("૱")).not_to eq []
      expect(subject.analyze("௹")).not_to eq []
      expect(subject.analyze("रु")).not_to eq []
      expect(subject.analyze("ש״ח")).not_to eq []
      expect(subject.analyze("元")).not_to eq []
      expect(subject.analyze("¢")).not_to eq []
      expect(subject.analyze("£")).not_to eq []
      expect(subject.analyze("€")).not_to eq []
      expect(subject.analyze("¥")).not_to eq []
      expect(subject.analyze("د.إ")).not_to eq []
      expect(subject.analyze("؋")).not_to eq []
      expect(subject.analyze("֏")).not_to eq []
      expect(subject.analyze("ƒ")).not_to eq []
      expect(subject.analyze("₼")).not_to eq []
      expect(subject.analyze("৳")).not_to eq []
      expect(subject.analyze("лв")).not_to eq []
      expect(subject.analyze("лев")).not_to eq []
      expect(subject.analyze("дин")).not_to eq []
      expect(subject.analyze("د.ب")).not_to eq []
      expect(subject.analyze("₡")).not_to eq []
      expect(subject.analyze("Kč")).not_to eq []
      expect(subject.analyze("د.ج")).not_to eq []
      expect(subject.analyze("ج.م")).not_to eq []
      expect(subject.analyze("₾")).not_to eq []
      expect(subject.analyze("₵")).not_to eq []
      expect(subject.analyze("₪")).not_to eq []
      expect(subject.analyze("₹")).not_to eq []
      expect(subject.analyze("ع.د")).not_to eq []
      expect(subject.analyze("﷼")).not_to eq []
      expect(subject.analyze("د.ا")).not_to eq []
      expect(subject.analyze("៛")).not_to eq []
      expect(subject.analyze("₩")).not_to eq []
      expect(subject.analyze("د.ك")).not_to eq []
      expect(subject.analyze("₸")).not_to eq []
      expect(subject.analyze("₭")).not_to eq []
      expect(subject.analyze("ل.ل")).not_to eq []
      expect(subject.analyze("₨")).not_to eq []
      expect(subject.analyze("ل.د")).not_to eq []
      expect(subject.analyze("د.م.")).not_to eq []
      expect(subject.analyze("ден")).not_to eq []
      expect(subject.analyze("₮")).not_to eq []
      expect(subject.analyze("₦")).not_to eq []
      expect(subject.analyze("C$")).not_to eq []
      expect(subject.analyze("ر.ع.")).not_to eq []
      expect(subject.analyze("₱")).not_to eq []
      expect(subject.analyze("zł")).not_to eq []
      expect(subject.analyze("₲")).not_to eq []
      expect(subject.analyze("ر.ق")).not_to eq []
      expect(subject.analyze("РСД")).not_to eq []
      expect(subject.analyze("₽")).not_to eq []
      expect(subject.analyze("ر.س")).not_to eq []
      expect(subject.analyze("฿")).not_to eq []
      expect(subject.analyze("د.ت")).not_to eq []
      expect(subject.analyze("T$")).not_to eq []
      expect(subject.analyze("₺")).not_to eq []
      expect(subject.analyze("₴")).not_to eq []
      expect(subject.analyze("₫")).not_to eq []
      # expect(subject.analyze("B⃦")).not_to eq []
      expect(subject.analyze("₤")).not_to eq []
      expect(subject.analyze("ރ")).not_to eq []
    end

    it "should function with unicode characters" do
      expect(subject.analyze("10 ֏")).to eq ["AMD"]
    end

    context "with filters" do
        it "finds only by specified filters" do
          expect(subject.analyze("10 ₮ + 2USD", filters: [:iso_code])).to eq ["USD"]
          expect(subject.analyze("10 ₮ + 2USD", filters: [:iso_code, :symbol])).to eq ["MNT", "USD"]
        end

        it "ignores nonexistent filters" do
          expect(subject.analyze("10 ₮ + 2USD", filters: [:wrong_filter])).to eq ["MNT", "USD"]
        end
    end
  end
end
