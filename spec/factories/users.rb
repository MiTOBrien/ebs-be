FactoryBot.define do
  factory :user do
    username { Faker::Internet.unique.username }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.unique.email }
    password { "password123" }
    password_confirmation { "password123" }
    charges_for_services { false }
    subscription_type { "free" }
    subscription_status { "active" }

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
