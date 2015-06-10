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
    if past_sell_date?(item)
      case
      when item.name == AGED_BRIE
        return 2
      when item.name.start_with?(CONJURED)
        return -4
      when item.name == BACKSTAGE_PASSES
        return -item.quality
      when item.name == SULFURAS
        return 0
      else
        return -2
      end
    end

    case
    when item.name == AGED_BRIE
      return 1
    when item.name.start_with?(CONJURED)
      return -2
    when item.name == BACKSTAGE_PASSES
      return backstage_quality_amount(item.sell_in)
    when item.name == SULFURAS
      return 0
    else
      return -1
    end
  end

  def backstage_quality_amount(sell_in)
    amount = 1
    if sell_in < 11
      amount += 1
    end
    if sell_in < 6
      amount += 1
    end
    amount
  end

  def past_sell_date?(item)
    item.sell_in < 0
  end

  def update_item_quality(item, value)
    if ((item.quality < 50) && (item.quality > 0))
      item.quality = item.quality + value
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
