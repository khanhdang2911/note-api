class Topic < ApplicationRecord
  validates :name, presence: true,  length: { minimum: 5, maximum: 100 }
  validates :description, presence: false

  has_many :notes, dependent: :destroy
end
