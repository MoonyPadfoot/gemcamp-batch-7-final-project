class AddUniqToUsernameInUsers < ActiveRecord::Migration[7.0]
  def up
    change_column :users, :username, :string, unique: true
  end
end
