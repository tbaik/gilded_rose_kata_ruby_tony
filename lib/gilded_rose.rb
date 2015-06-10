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
      if item.name != SULFURAS
        item.sell_in = item.sell_in - 1
      end

      quality_update_amount = quality_update_amount(item)
      update_item_quality(item, quality_update_amount)
    end
  end

  def quality_update_amount(item)
    if expired?(item)
      case
      when item.name == AGED_BRIE
        return CheeseUpdateRates.new.expired_quality_update_rate
      when item.name.start_with?(CONJURED)
        return ConjuredItemUpdateRates.new.expired_quality_update_rate
      when item.name == BACKSTAGE_PASSES
        return BackstagePassItemUpdateRates.new(item).expired_quality_update_rate
      when item.name == SULFURAS
        return LegendaryItemUpdateRates.new.expired_quality_update_rate
      else
        return ItemUpdateRates.new.expired_quality_update_rate
      end
    end

    case
    when item.name == AGED_BRIE
      return CheeseUpdateRates.new.quality_update_rate
    when item.name.start_with?(CONJURED)
      return ConjuredItemUpdateRates.new.quality_update_rate
    when item.name == BACKSTAGE_PASSES
      return BackstagePassItemUpdateRates.new(item).quality_update_rate
    when item.name == SULFURAS
      return LegendaryItemUpdateRates.new.quality_update_rate
    else
      return ItemUpdateRates.new.quality_update_rate
    end
  end

  def expired?(item)
    item.sell_in < 0
  end

  def update_item_quality(item, value)
    if ((item.quality < 50) && (item.quality > 0))
      item.quality = item.quality + value
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
