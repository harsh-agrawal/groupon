FactoryGirl.define do

  factory :deal do
    title 'qazxsw'
    price 100
    max_qty 20
    max_qty_per_customer 5
    association :category, factory: :category
    association :merchant, factory: :merchant
  end

  factory :deal_with_order, parent: :deal do
    after(:build) do |deal|
      deal.orders << create(:order)
    end
  end

  factory :published_deal, parent: :deal do
    description 'This is a sample description for the test deal .'
    instructions 'Instructions for test deal.'
    min_qty 3
    sold_quantity 2
    start_time Time.current - 1.day
    expire_time Time.current + 2.days
    publishable true
  end

end
