require 'gilded_rose'

describe GildedRose do

  describe "#update_quality" do
    let(:name) {"foo"}
    let(:initial_sell_in) {5}
    let(:initial_quality) {5}
    let(:items) {[Item.new(name, initial_sell_in, initial_quality)]}

    before {
      GildedRose.new(items).update_quality()
    }

    def self.it_does_not_change_the_name
      it "does not change the name" do
        expect(items[0].name).to eq(name)
      end
    end

    def self.it_does_not_lower_the_quality_beyond_0
      context "with 0 initial quality" do
        let(:initial_quality) {0}

        it_lowers_the_quality_by(0)
      end
    end

    def self.it_lowers_the_sell_in_value_by(value)
      it "lowers the sell_in value by #{value}" do
        expect(items[0].sell_in).to eq(initial_sell_in - value)
      end
    end

    def self.it_lowers_the_quality_by(value)
      it "lowers the quality value by #{value}" do
        expect(items[0].quality).to eq(initial_quality - value)
      end
    end

    def self.it_increases_the_quality_by(value)
      it "increases the quality value by #{value}" do
        expect(items[0].quality).to eq(initial_quality + value)
      end
    end

    def self.it_lowers_the_quality_by_2_with_negative_sell_by_date
      context "with negative sell by date" do
        let(:initial_sell_in) {-1}

        it_lowers_the_quality_by(2)
      end
    end

    def self.it_increases_the_quality_by_2_with_negative_sell_by_date
      context "with negative sell by date" do
        let(:initial_sell_in) {-1}

        it_increases_the_quality_by(2)
      end
    end

    def self.it_does_not_increase_quality_beyond_50_quality
      context "with 50 initial quality" do
        let(:initial_quality) {50}

        it_increases_the_quality_by(0)
      end
    end

    context "Normal item" do
      it_does_not_change_the_name
      it_does_not_lower_the_quality_beyond_0
      it_lowers_the_sell_in_value_by(1)
      it_lowers_the_quality_by(1)
      it_lowers_the_quality_by_2_with_negative_sell_by_date
    end

    context "Aged Brie" do
      let(:name) {"Aged Brie"}

      it_does_not_change_the_name
      it_lowers_the_sell_in_value_by(1)
      it_increases_the_quality_by(1)
      it_increases_the_quality_by_2_with_negative_sell_by_date
      it_does_not_increase_quality_beyond_50_quality
    end

    context "Sulfuras, Hand of Ragnaros" do
      let(:name) {"Sulfuras, Hand of Ragnaros"}
      let(:initial_quality) {80}

      it_does_not_change_the_name
      it_lowers_the_sell_in_value_by(0)
      it_lowers_the_quality_by(0)

      it "always has a quality of 80" do
        expect(items[0].quality).to eq(80)
      end
    end

    context "Backstage passes" do
      let(:name) {"Backstage passes to a TAFKAL80ETC concert"}

      it_does_not_change_the_name
      it_lowers_the_sell_in_value_by(1)
      it_does_not_increase_quality_beyond_50_quality

      context "with 25 sell by date" do
        let(:initial_sell_in) {25}

        it_increases_the_quality_by(1)
      end

      context "with 10 sell by date" do
        let(:initial_sell_in) {10}

        it_increases_the_quality_by(2)
      end

      context "with 5 sell by date" do
        let(:initial_sell_in) {5}

        it_increases_the_quality_by(3)
      end

      context "after the concert is over" do
        let(:initial_sell_in) {-1}

        it "drops the quality to 0" do
          expect(items[0].quality).to eq(0)
        end
      end
    end

    context "Conjured items" do
      let(:name) {"Conjured Mana Cake"}

      it_does_not_change_the_name
      it_does_not_lower_the_quality_beyond_0
      it_lowers_the_sell_in_value_by(1)
      it_lowers_the_quality_by(2)
      it_lowers_the_quality_by_2_with_negative_sell_by_date
    end
  end
end
