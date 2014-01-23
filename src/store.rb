class Store
  
  def initialize(items, tax, reduction_types)
    @items = items
    @tax = tax
    @reduction_types = reduction_types
  end
  
  def calculate_total(items: nil, location: "tx")
    get_collection_of_prices(items, location).reduce(:+)
    rescue 
      0
  end
  
  def get_collection_of_prices(items, location)
    items.map do |item|
      calculate_price(item, location)
    end
  end
  
  def get_reduction(item, location)
    if check_if_item_has_reduction(item, location)
      @tax[location][:redux]
    else
      0
    end
  end
  
  def check_if_item_has_reduction(item, location)
    @reduction_types.detect { |item_name, state| item_name == item && state.include?(location) }
  end
  
  def calculate_price(item, location)
    @items[item] + @items[item] * (@tax[location][:rate] - get_reduction(item, location))
  end
end
