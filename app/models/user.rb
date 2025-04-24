class User
  include Mongoid::Document
  include Mongoid::Timestamps
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ## Custom Fields
  field :username, type: String

  ## Devise Fields
  field :email, type: String, default: "", null: false
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token, type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
end
