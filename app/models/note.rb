class Note < ApplicationRecord
  validates :title, presence: true, length: { minimum: 5, maximum: 100 }
  validates :content, presence: true

  belongs_to :topic
end
