FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" } # Generates unique emails
    sequence(:username) { |n| "example_user#{n}" }
    sequence(:password) { |n| "example_password#{n}" }
  end
end