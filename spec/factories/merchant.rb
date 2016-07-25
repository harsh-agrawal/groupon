FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  sequence :name do |n|
    "hgjh#{n}"
  end

  factory :merchant do
    name { generate :name }
    password '123456'
    email { generate :email }
  end

end
