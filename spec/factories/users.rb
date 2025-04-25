FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" } # Generates unique emails
    username { "example_user" }
    password { "example_password" }
  end
end