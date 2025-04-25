FactoryBot.define do
  factory :user do
    email { "test@example.com" }
    username { "testuser" }
    password { "password" }
  end
end