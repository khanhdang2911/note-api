class AddUserToTopic < ActiveRecord::Migration[7.2]
  def change
    add_reference :topics, :user, null: false, foreign_key: true
  end
end
