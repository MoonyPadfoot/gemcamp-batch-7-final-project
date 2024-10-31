class AddDefaultToUsernameInUsers < ActiveRecord::Migration[7.0]
  def up
    change_column_default(:users, :username, nil)
  end
end
