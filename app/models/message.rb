class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :to, type: String
  field :body, type: String
  field :status, type: String, default: "pending"
  field :twilio_sid, type: String
end
