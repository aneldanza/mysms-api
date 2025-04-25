class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :to, type: String
  field :body, type: String
  field :status, type: String, default: "pending"
  field :twilio_sid, type: String

  belongs_to :user

  validates :to, :body, presence: true
  validates :to, format: { with: /\A\+?[1-9]\d{1,14}\z/, message: "must be a valid phone number" }
  validates :body, length: { maximum: 250, message: "must be less than 250 characters" }
end
