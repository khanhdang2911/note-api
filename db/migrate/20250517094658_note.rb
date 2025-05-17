class Note < ActiveRecord::Migration[7.2]
  def change
    create_table :notes do |t|
      t.string :title
      t.text :content
      t.references :topic, foreign_key: true, index: true

      t.timestamps
    end
  end
end
