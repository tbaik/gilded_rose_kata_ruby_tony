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

    def self.when_sell_by_date_is(date, &block)
      context_class = context "with 25 sell by date" do
        let(:initial_sell_in) {date}
      end

      context_class.class_eval &block
    end

    def self.when_initial_quality_is(value, &block)
      context_class = context "with #{value} initial quality" do
        let(:initial_quality) {value}
      end

      context_class.class_eval &block
    end

    context "Normal item" do
      it_does_not_change_the_name
      it_lowers_the_sell_in_value_by(1)
      it_lowers_the_quality_by(1)
      when_initial_quality_is(0) { it_lowers_the_quality_by(0) }
      when_sell_by_date_is(-1) {it_lowers_the_quality_by(2)}
    end

    context "Aged Brie" do
      let(:name) {"Aged Brie"}

      it_does_not_change_the_name
      it_lowers_the_sell_in_value_by(1)
      it_increases_the_quality_by(1)
      when_sell_by_date_is(-1) {it_increases_the_quality_by(2)}
      when_initial_quality_is(50) {it_increases_the_quality_by(0)}
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
      when_initial_quality_is(50) {it_increases_the_quality_by(0)}
      when_sell_by_date_is(25) { it_increases_the_quality_by(1) }
      when_sell_by_date_is(10) { it_increases_the_quality_by(2) }
      when_sell_by_date_is(5) { it_increases_the_quality_by(3) }
      when_sell_by_date_is(-1) do
        it "drops the quality to 0" do
          expect(items[0].quality).to eq(0)
        end
      end
    end

    context "Conjured items" do
      let(:name) {"Conjured Mana Cake"}

      it_does_not_change_the_name
      it_lowers_the_sell_in_value_by(1)
      it_lowers_the_quality_by(2)
      when_initial_quality_is(0) { it_lowers_the_quality_by(0) }
      when_sell_by_date_is(-1) {it_lowers_the_quality_by(2)}
    end
  end
end
