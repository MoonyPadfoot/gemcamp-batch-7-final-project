class AddDefaultToCoinsInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :coins, :integer, :default => 0
  end
end
