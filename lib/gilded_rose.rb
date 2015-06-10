class GildedRose
  AGED_BRIE = "Aged Brie"
  BACKSTAGE_PASSES = "Backstage passes to a TAFKAL80ETC concert"
  CONJURED = "Conjured"
  SULFURAS = "Sulfuras, Hand of Ragnaros"

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      item_update_rates = item_update_rates(item)
      quality_update_rate = expired?(item) ?
        item_update_rates.expired_quality_update_rate :
        item_update_rates.quality_update_rate

      update_sell_in(item, item_update_rates.sell_in_update_rate)
      update_item_quality(item, quality_update_rate)
    end
  end

  def item_update_rates(item)
    item_name = item.name.start_with?("Conjured") ? CONJURED : item.name
    update_rate_hash = {
      AGED_BRIE => CheeseUpdateRates.new,
      BACKSTAGE_PASSES => BackstagePassItemUpdateRates.new(item),
      CONJURED => ConjuredItemUpdateRates.new,
      SULFURAS => LegendaryItemUpdateRates.new
    }

      if update_rate_hash.has_key? item_name
        return update_rate_hash[item_name]
      else
        return ItemUpdateRates.new
      end
  end

  def expired?(item)
    item.sell_in < 0
  end

  def update_sell_in(item, value)
    item.sell_in = item.sell_in + value
  end

  def update_item_quality(item, rate)
    if ((item.quality < 50) && (item.quality > 0))
      item.quality = item.quality + rate
    end
  end
end

class ItemUpdateRates
  attr_reader :expired_quality_update_rate, :quality_update_rate, :sell_in_update_rate

  def initialize
    @expired_quality_update_rate = -2
    @quality_update_rate = -1
    @sell_in_update_rate = -1
  end
end

class CheeseUpdateRates < ItemUpdateRates
  def initialize
    @expired_quality_update_rate = 2
    @quality_update_rate = 1
    @sell_in_update_rate = -1
  end
end

class ConjuredItemUpdateRates < ItemUpdateRates
  def initialize
    @expired_quality_update_rate = -4
    @quality_update_rate = -2
    @sell_in_update_rate = -1
  end
end

class LegendaryItemUpdateRates < ItemUpdateRates
  def initialize
    @expired_quality_update_rate = 0
    @quality_update_rate = 0
    @sell_in_update_rate = 0
  end
end

class BackstagePassItemUpdateRates < ItemUpdateRates
  def initialize(item)
    @expired_quality_update_rate = -item.quality
    @quality_update_rate = backstage_quality_amount(item.sell_in)
    @sell_in_update_rate = -1
  end

  def backstage_quality_amount(sell_in)
    case sell_in
    when (0..5)
      return 3
    when (6..10)
      return 2
    else
      return 1
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
