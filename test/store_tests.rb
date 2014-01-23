$:.unshift(File.join(File.dirname(__FILE__), '..','src')) 
require 'simplecov'
SimpleCov.start
require 'json'
require 'test/unit'
require 'store'

class StoreTests < Test::Unit::TestCase
  
  def setup
    items = {"tshirt" => 10.00, "hat" => 15.00, "mug" => 5.00, "keychain" => 2.00}
    tax = {"tx" => {:rate => 0.0625, :redux => 0.01}, 
            "ca" => {:rate => 0.075, :redux => 0},
            "la" => {:rate => 0.050, :redux => 0.02}}
    reduction_types = {"keychain" => ["tx", "la"], "mug" => ["tx","la"]}
    @store = Store.new(items, tax, reduction_types)  
  end
  
  def test_store_canary
    assert true, "something is wrong in store class!!!"
  end
  
  def test_calculate_price_for_zero_items
    assert_equal 0, @store.calculate_total()
  end
  
  def test_calculate_price_for_one_item_and_tx_tax
    item = ["tshirt"]
    assert_equal 10.625, @store.calculate_total(items: item, location: "tx")
  end
  
  def test_calculate_price_for_two_items_and_tx_tax
    items = ["tshirt","hat"]
    assert_equal 26.5625, @store.calculate_total(items: items, location: "tx")
  end
  
  def test_calculate_price_for_one_item_and_ca_tax
    item = ["tshirt"]
    assert_equal 10.75, @store.calculate_total(items: item, location: "ca")
  end
  
  def test_calculate_price_for_two_items_and_ca_tax
    items = ["tshirt","hat"]
    assert_equal 26.875, @store.calculate_total(items: items, location: "ca")
  end
  
  def test_calculate_price_for_one_item_with_reduction
    item = ["keychain"]
    assert_equal 2.105, @store.calculate_total(items: item, location: "tx")
  end
  
  def test_calculate_price_for_two_items_with_reduction
    items = ["mug", "keychain"]
    assert_equal 7.3675, @store.calculate_total(items: items, location: "tx")
  end
  
  def test_calculate_price_for_one_reduction_and_one_not
    items = ["mug", "tshirt"]
    assert_equal 15.8875, @store.calculate_total(items: items, location: "tx")
  end
  
  def test_calculate_price_for_one_item_with_no_reduction_by_state
    item = ["mug"]
    assert_equal 5.375, @store.calculate_total(items: item, location: "ca")
  end
  
  def test_calculate_price_for_two_items_with_no_reduction_by_state
    items = ["mug", "keychain"]
    assert_equal 7.525, @store.calculate_total(items: items, location: "ca")
  end
  
  def test_calcutes_two_items_with_no_state_reduction
    items = ["tshirt", "mug"]
    assert_equal 16.125, @store.calculate_total(items: items, location: "ca")
  end
  
  def test_calculates_four_items_and_two_with_reduction
    items = ["tshirt", "mug", "keychain", "hat"]
    assert_equal 33.93, @store.calculate_total(items: items, location: "tx")
  end
  
  def test_calculates_four_items_and_two_with_no_state_reduction
    items = ["tshirt", "mug", "keychain", "hat"]
    assert_equal 34.4, @store.calculate_total(items: items, location: "ca")
  end
  
  def test_for_another_reduction_area_la
    item = ["keychain"]
    assert_equal 2.06, @store.calculate_total(items: item, location: "la")
  end
  
  def test_for_tax_area_not_in_the_tax_list
    item = ["keychain"]
    assert_equal 0, @store.calculate_total(items: item, location: "ak")
  end
end