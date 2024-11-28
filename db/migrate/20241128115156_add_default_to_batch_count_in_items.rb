class AddDefaultToBatchCountInItems < ActiveRecord::Migration[7.0]
  def change
    change_column :items, :batch_count, :integer, :default => 0
  end
end
