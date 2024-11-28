class RemoveMemberLevelFromUsers < ActiveRecord::Migration[7.0]
  def up
    add_reference :users, :member_level, foreign_key: true
    add_column :users, :member_leve_id, :bigint
  end

  def down
    remove_column :users, :member_level_id, :bigint
    remove_column :users, :member_leve_id, :bigint
  end
end