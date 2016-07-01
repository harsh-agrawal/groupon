require 'test_helper'

class DealTest < ActiveSupport::TestCase

  test "should not save deal without title" do
    deal = Deal.new
    deal.category = categories(:valid_category)
    deal.merchant = merchants(:valid_merchant)
    assert_not deal.save, "Saved the deal without a title"
  end

  test "should not save deal without category" do
    deal = Deal.new(title: 'Test Deal')
    deal.merchant = merchants(:valid_merchant)
    assert_not deal.save, "Saved the deal without a category"
  end

  test "should not save deal without merchant" do
    deal = Deal.new(title: 'Test Deal')
    deal.category = categories(:valid_category)
    assert_not deal.save, "Saved the deal without a merchant"
  end

  test "should not publish the deal without description" do
    deal = deals(:publishable_deal)
    deal.description = nil
    deal.publishable = true
    assert_not deal.save, "Published the deal without description"
  end

  test "should not publish the deal without instructions" do
    deal = deals(:publishable_deal)
    deal.instructions = nil
    deal.publishable = true
    assert_not deal.save, "Published the deal without instructions"

  end

  test "should not publish the deal if deal has a description of less than 10 words" do
    deal = deals(:publishable_deal)
    deal.description = 'description contains 9 w o r d s .'
    deal.publishable = true
    assert_not deal.save, "Published the deal with description of less than 10 words"
  end

  test "should publish the deal if the deal has a description of more than 10 words." do
    deal = deals(:publishable_deal)
    deal.description = 'description contains 11 w o r d s s s .'
    deal.publishable = true
    assert deal.save, "Publish the deal with description of more than 10 words"
  end

  test "should not publish the deal without minimum quantity" do
    deal = deals(:publishable_deal)
    deal.min_qty = nil
    deal.publishable = true
    assert_not deal.save, "Published the deal without minimum quantity"
  end

  test "should not publish the deal without maximum quantity" do
    deal = deals(:publishable_deal)
    deal.max_qty = nil
    deal.publishable = true
    assert_not deal.save, "Published the deal without maximum quantity"
  end

  test "should not publish the deal without maximum quantity per customer" do
    deal = deals(:publishable_deal)
    deal.max_qty_per_customer = nil
    deal.publishable = true
    assert_not deal.save, "Published the deal without maximum quantity per customer"
  end

  test "should not publish the deal without start time" do
    deal = deals(:publishable_deal)
    deal.start_time = nil
    deal.publishable = true
    assert_not deal.save, "Published the deal without start time"
  end

  test "should not publish the deal without expire time" do
    deal = deals(:publishable_deal)
    deal.expire_time = nil
    deal.publishable = true
    assert_not deal.save, "Published the deal without expire time"
  end

  test "min quantity should not be a string" do
    deal = deals(:publishable_deal)
    deal.min_qty = 'test'
    deal.publishable = true
    assert_not deal.save, 'Min. quantity must be a number'
  end

  test "min quantity should not be decimal" do
    deal = deals(:publishable_deal)
    deal.min_qty = 1.15
    deal.publishable = true
    assert_not deal.save, 'Min. quantity must be a number'
  end

  test "should publish if min quantity is 1" do
    deal = deals(:publishable_deal)
    deal.min_qty = 1
    deal.publishable = true
    assert deal.save, 'Publish if min qty is 1'
  end

  test "should publish if min qty is greater than 1" do
    deal = deals(:publishable_deal)
    deal.min_qty = 2
    deal.publishable = true
    assert deal.save, 'Publish if min qty is greater than 1'
  end

  test "should not publish if min qty is less than 1" do
    deal = deals(:publishable_deal)
    deal.min_qty = 0
    deal.publishable = true
    assert_not deal.save, 'Published the deal with min qty 0'
  end

  test "max quantity should be a number" do
    deal = deals(:publishable_deal)
    deal.max_qty = 'test'
    deal.publishable = true
    assert_not deal.save, 'Max. quantity must be a number'
  end

  test "max quantity should not be decimal" do
    deal = deals(:publishable_deal)
    deal.max_qty = 1.15
    deal.publishable = true
    assert_not deal.save, 'Max. quantity must be a number'
  end

  test "should publish if max qty is equal to min qty" do
    deal = deals(:publishable_deal)
    deal.max_qty = deal.min_qty
    deal.publishable = true
    assert deal.save, 'Publish if max qty is equal to min qty'
  end

  test "should publish if max qty is greater than min qty" do
    deal = deals(:publishable_deal)
    deal.max_qty = deal.min_qty + 1
    deal.publishable = true
    assert deal.save, 'Publish if max qty is greater than min qty'
  end

  test "should not publish if max qty is less than min qty" do
    deal = deals(:publishable_deal)
    deal.max_qty = deal.min_qty - 1
    deal.publishable = true
    assert_not deal.save, 'Published the deal with max qty less than min qty'
  end

  test "max quantity per customer should be a number" do
    deal = deals(:publishable_deal)
    deal.max_qty_per_customer = 'test'
    deal.publishable = true
    assert_not deal.save, 'Max. quantity per customer must be a number'
  end

  test "max quantity per customer should not be decimal" do
    deal = deals(:publishable_deal)
    deal.max_qty_per_customer = 1.15
    deal.publishable = true
    assert_not deal.save, 'Max. quantity per customer must be a number'
  end

  test "should not publish if max qty per customer is less than 1" do
    deal = deals(:publishable_deal)
    deal.max_qty_per_customer = 0
    deal.publishable = true
    assert_not deal.save, 'Published the deal with max qty per customer equal to 0'
  end

  test "should publish if max qty per customer is 1" do
    deal = deals(:publishable_deal)
    deal.max_qty_per_customer = 1
    deal.publishable = true
    assert deal.save, 'Publish if max qty per customer is 1'
  end

  test "should publish if max qty per customer is less than max qty" do
    deal = deals(:publishable_deal)
    deal.max_qty_per_customer = deal.max_qty - 1
    deal.publishable = true
    assert deal.save, 'Publish if max qty per customer is less than max qty'
  end

  test "should publish if max qty per customer is equal to max qty" do
    deal = deals(:publishable_deal)
    deal.max_qty_per_customer = deal.max_qty
    deal.publishable = true
    assert deal.save, 'Publish if max qty per customer is equal to max qty'
  end

  test "should not publish if max qty per customer is greater than max qty" do
    deal = deals(:publishable_deal)
    deal.max_qty_per_customer = deal.max_qty + 1
    deal.publishable = true
    assert_not deal.save, 'Published the deal with max qty per customer greater than max qty'
  end

  test "should contain atleast one location" do
    deal = deals(:publishable_deal)
    deal.locations.clear
    deal.publishable = true
    assert_not deal.save, 'Published the deal without location'
  end

  test "should contain atleast one image" do
    deal = deals(:publishable_deal)
    deal.deal_images.clear
    deal.publishable = true
    assert_not deal.save, 'Published the deal without image'
  end

  test "should not publish if price less than 0.01" do
    deal = deals(:publishable_deal)
    deal.price = 0
    deal.publishable = true
    assert_not deal.save, 'Published the deal with price less than 0.01'
  end

  test "should publish if price is 0.01" do
    deal = deals(:publishable_deal)
    deal.price = 0.01
    deal.publishable = true
    assert deal.save, 'Publish the deal with price 0.01'
  end

  test "should publish if price greater than 0.01" do
    deal = deals(:publishable_deal)
    deal.price = 0.11
    deal.publishable = true
    assert deal.save, 'Publish the deal with price greater than 0.01'
  end

  test "sold quantity should not be a string" do
    deal = deals(:publishable_deal)
    deal.sold_quantity = 'test'
    deal.publishable = true
    assert_not deal.save, 'Sold quantity must be a number'
  end

  test "sold quantity per should not be decimal" do
    deal = deals(:publishable_deal)
    deal.sold_quantity = 1.15
    deal.publishable = true
    assert_not deal.save, 'Sold quantity must be a number'
  end

  test "should publish if sold qty is less than max qty" do
    deal = deals(:publishable_deal)
    deal.sold_quantity = deal.max_qty - 1
    deal.publishable = true
    assert deal.save, 'Publish if sold qty is less than max qty'
  end

  test "should publish if sold qty is equal to max qty" do
    deal = deals(:publishable_deal)
    deal.sold_quantity = deal.max_qty
    deal.publishable = true
    assert deal.save, 'Publish if sold quantity is equal to max qty'
  end

  test "should not publish if sold qty is greater than max qty" do
    deal = deals(:publishable_deal)
    deal.sold_quantity = deal.max_qty + 1
    deal.publishable = true
    assert_not deal.save, 'Published the deal with sold quantity greater than max qty'
  end

  test "check no of published deals" do
    deals = Deal.published
    assert_equal(deals.size, 17, "incorrect no. of published deals")
    assert deals.all?{ |deal| deal.publishable? }
  end

  test "check no of live deals" do
    deals = Deal.live
    assert_equal(deals.size, 16, "incorrect no. of live deals")
    assert deals.all?{ |deal| deal.start_time <= Time.current && Time.current <= deal.expire_time }
  end

  test "check no of processed deals" do
    deals = Deal.processed
    assert_equal(deals.size, 10, "incorrect no. of processed deals")
    assert deals.all?{ |deal| deal.processed? }
  end

  test "check no of unprocessed deals" do
    deals = Deal.not_processed
    assert_equal(deals.size, 9, "incorrect no. of unprocessed deals")
    assert deals.all?{ |deal| !deal.processed? }
  end

  test "check locations association" do
    deal = deals(:publishable_deal)
    association = deal.association(:locations)
    assert_equal(association.class, ActiveRecord::Associations::HasManyAssociation, "should be has_many locations")
    assert_equal(association.options[:dependent], :destroy, "location dependent should be destroy")
    assert_equal(association.options[:validate], false, "location validations should be false")
  end

  test "check deal images association" do
    deal = deals(:publishable_deal)
    association = deal.association(:deal_images)
    assert_equal(association.class, ActiveRecord::Associations::HasManyAssociation, "should be has_many deal_images")
    assert_equal(association.options[:dependent], :destroy, "deal_images dependent should be destroy")
    assert_equal(association.options[:validate], false, "deal_images validations should be false")
  end

  test "check orders association" do
    deal = deals(:publishable_deal)
    association = deal.association(:orders)
    assert_equal(association.class, ActiveRecord::Associations::HasManyAssociation, "should be has_many orders")
    assert_equal(association.options[:dependent], :restrict_with_error, "orders dependent should be restrict with error")
  end

  test "check coupons association" do
    deal = deals(:publishable_deal)
    association = deal.association(:coupons)
    assert_equal(association.class, ActiveRecord::Associations::HasManyThroughAssociation, "should be has_many coupons through orders")
    assert_equal(association.options[:through], :orders, "coupons through orders")
  end

  test "check category association" do
    deal = deals(:publishable_deal)
    association = deal.association(:category)
    assert_equal(association.class, ActiveRecord::Associations::BelongsToAssociation, "deal belongs to category")
  end

  test "check merchant association" do
    deal = deals(:publishable_deal)
    association = deal.association(:merchant)
    assert_equal(association.class, ActiveRecord::Associations::BelongsToAssociation, "deal belongs to merchant")
  end

  test "check publish method" do
    deal = deals(:publishable_deal)
    deal.publish
    deal.reload
    assert deal.publishable?, 'deal should have been published'
  end

  test "check unpublish method" do
    deal = deals(:publishable_deal_14)
    deal.unpublish
    assert_not deal.publishable?, 'deal should have been unpublished'
  end

  test "check live method" do
    deal = deals(:live_deal)
    assert deal.live?, 'deal was live'
  end

  test "check expired method" do
    deal = deals(:expired_deal)
    assert deal.expired?, 'deal was expired'
  end

  test "check sold out method" do
    deal = deals(:live_deal)
    assert deal.sold_out?, 'deal was sold out'
    assert_not deals(:publishable_deal).sold_out?, 'deas was not sold out'
  end

  test "check quantity available method" do
    deal = deals(:publishable_deal)
    assert_equal(deal.quantity_available, 8, "should display the quantity available for the deal")
  end

  test "check remaining quantity method" do
    deal = deals(:publishable_deal)
    assert_equal(deal.remaining_quantity_to_activate, 1, "should display the remaining quantity to activate the deal")
  end

  test "increase sold quantity method" do
    deal = deals(:publishable_deal)
    deal.increase_sold_qty_by(1)
    assert_equal(deal.sold_quantity, 3, "should display the increased value of the sold qty")
  end

  test "expired deals cannot be updated" do
    deal = deals(:expired_deal)
    deal.title = 'qwerty'
    assert_not deal.save,'expired deals cannot be updated'
  end

  test "live deals cannot be updated" do
    deal = deals(:live_deal)
    deal.title = 'qwerty'
    assert_not deal.save,'live deals cannot be updated'
  end

  test "search deals with title" do
    deals = Deal.search("st")
    assert_equal( deals.size, 5, "incorrect search result")
    assert deals.all?{ |deal| deal.publishable? && deal.title.match('st')  }
  end

end
