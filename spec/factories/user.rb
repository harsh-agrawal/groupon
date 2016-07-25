FactoryGirl.define do

  factory :user do
    first_name 'Harry'
    last_name  'Potter'
    email { generate :email }
    verified_at Time.now
    password 'expecto patronum'
  end

  factory :invaild_user, parent: :user do
    first_name nil
  end

  factory :unverified_user, parent: :user do
    first_name 'Lucky'
    verified_at nil
    verification_token 'adfh5586'
  end

  factory :user_with_order, parent: :user do
    after(:build) do |user|
      user.orders << create(:order)
    end
  end

end
