require 'gilded_rose'

describe GildedRose do

  describe "#update_quality" do
    let(:name) {"foo"}
    let(:initial_sell_in) {1}
    let(:initial_quality) {1}
    let(:items) {[Item.new(name, initial_sell_in, initial_quality)]}

    before(:each) {
      GildedRose.new(items).update_quality()
    }

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

    it "does not change the name" do
      expect(items[0].name).to eq("foo")
    end

    context "with 0 initial quality" do
      let(:initial_quality) {0}

      it_lowers_the_quality_by(0)
    end

    context "Normal item" do
      context "with positive quality" do
        let(:initial_quality) {25}

        context "with positive sell by date and quality" do
          let(:initial_sell_in) {10}

          it_lowers_the_sell_in_value_by(1)
          it_lowers_the_quality_by(1)
        end

        context "with negative sell by date" do
          let(:initial_sell_in) {-1}

          it_lowers_the_quality_by(2)
        end
      end
    end

    context "Aged Brie" do
      let(:name) {"Aged Brie"}

      it_lowers_the_sell_in_value_by(1)
      it_increases_the_quality_by(1)

      context "with negative sell by date" do
        let(:initial_sell_in) {-1}

        it_increases_the_quality_by(2)
      end

      context "with 50 initial quality" do
        let(:initial_quality) {50}

        it_increases_the_quality_by(0)
      end
    end

  end
end
