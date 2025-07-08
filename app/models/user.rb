class User < ApplicationRecord
  USER_PARAMS = %i[name email address password password_confirmation].freeze
  validates :name, presence: true, length: { minimum: 5, maximum: 100 }
  validates :email, presence: true, uniqueness: true
  validates :address, presence: true, length: { minimum: 5, maximum: 100 }
  validates :password, presence: true, length: { minimum: 6, maximum: 20 }
  validates :refresh_token, presence: true
  has_many :topics, dependent: :destroy
  has_secure_password
end
