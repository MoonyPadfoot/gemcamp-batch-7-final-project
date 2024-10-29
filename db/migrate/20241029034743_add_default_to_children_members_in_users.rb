class AddDefaultToChildrenMembersInUsers < ActiveRecord::Migration[7.0]
  def up
    change_column :users, :children_members, :integer, :default => 0
  end
end
