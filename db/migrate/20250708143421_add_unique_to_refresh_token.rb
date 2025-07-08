class AddUniqueToRefreshToken < ActiveRecord::Migration[7.2]
  def change
    add_index :users, :refresh_token, unique: true
  end
end
