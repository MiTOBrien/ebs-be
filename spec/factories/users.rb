FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user_#{n}" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    charges_for_services { false }
    subscription_type { "free" }
    subscription_status { "active" }

    # Add associations for roles
    transient do
      roles { [] }
    end

    after(:create) do |user, evaluator|
      user.roles << evaluator.roles if evaluator.roles
    end

    # Add traits for different subscription types if needed
    trait :paid_monthly do
      subscription_type { "paid_monthly" }
      subscription_status { "incomplete" }
    end

    trait :paid_annual do
      subscription_type { "paid_annual" }
      subscription_status { "incomplete" }
    end
  end
end
