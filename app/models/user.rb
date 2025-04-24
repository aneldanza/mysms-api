class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::JTIMatcher

  ## Custom Fields
  field :username, type: String

  ## Devise Fields
  field :email, type: String, default: ""
  field :encrypted_password, type: String, default: ""
  field :jti, type: String, default: -> { SecureRandom.uuid }

  ## Recoverable
  field :reset_password_token, type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  index({ jti: 1 }, { unique: true })
end
