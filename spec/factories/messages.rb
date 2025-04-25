FactoryBot.define do
  factory :message do
    association :user # Assumes a `belongs_to :user` relationship
    twilio_sid { "SM12345" }
    status { "queued" }
    to { "+1234567890" } # Valid phone number
    body { "Test message body" }
  end
end