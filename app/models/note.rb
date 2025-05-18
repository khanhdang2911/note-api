class Note < ApplicationRecord
  NOTE_PARAMS = %i[title content topic_id].freeze
  validates :title, presence: true, length: { minimum: 5, maximum: 100 }
  validates :content, presence: true

  belongs_to :topic
end
