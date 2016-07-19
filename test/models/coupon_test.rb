require 'test_helper'

class CouponTest < ActiveSupport::TestCase

  test "should not save coupon without order" do
    coupon = coupons(:valid_coupon)
    coupon.order_id = nil
    assert_not coupon.save, "Saved the coupon without an order"
  end

  test "should not save coupon without code" do
    coupon = coupons(:valid_coupon)
    coupon.code = nil
    assert_not coupon.save, "Saved the coupon without code"
  end

  test "coupon code should not be case sensitive" do
    # coupon = Coupon.new(order_id: 1, code: '53BCFBA447', redeemed_at: Time.current + 2.day)
    # debugger

  end

  test "check order association" do
    coupon = coupons(:valid_coupon)
    association = coupon.association(:order)
    assert_equal(association.class, ActiveRecord::Associations::BelongsToAssociation, "code belongs to coupon")
  end

  test "check no of redeemed coupons" do
    coupons = Coupon.redeemed
    assert_equal(coupons.size, 5, "incorrect no. of redeemed coupons")
    assert coupons.all?{ |coupon| coupon.redeemed_at? }
  end

  test "check random token method" do
    coupon = coupons(:valid_coupon)
    code = coupon.random_token
    assert_equal(code.length, 10, "length must be 10")
  end

  test "check code saved in token" do
    coupon = Coupon.new(order_id: 1)
    coupon.generate_token
    assert(coupon.code, "code must have been generated")
  end

  test "check unique code" do
    new_coupon = Coupon.new(order_id: 1)
    new_coupon.generate_token
    coupons = Coupon.all
    assert coupons.all?{ |coupon| coupon.code !=  new_coupon.code }, "code must be unique"
  end

end
