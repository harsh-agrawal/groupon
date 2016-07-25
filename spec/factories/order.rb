FactoryGirl.define do
  factory :order do
    quantity 2
    price 500
    status 'processed'
    association :user, factory: :user
    association :deal, factory: :deal
  end
end
