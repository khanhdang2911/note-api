class Topic < ApplicationRecord
  TOPIC_PARAMS = %i[name description user_id].freeze
  validates :name, presence: true,  length: { minimum: 5, maximum: 100 }
  validates :description, presence: false

  has_many :notes, dependent: :destroy
  belongs_to :user
end
