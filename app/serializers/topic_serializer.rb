class TopicSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :created_at, :updated_at
  has_many :notes, serializer: NoteSerializer
end
