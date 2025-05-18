class User < ApplicationRecord
  validates :name, presence: true, length: { minimum: 5, maximum: 100 }
  validates :email, presence: true, uniqueness: true
  validates :address, presence: true, length: { minimum: 5, maximum: 100 }

  has_many :topics, dependent: :destroy
end
