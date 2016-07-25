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

end
