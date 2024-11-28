class CreateMemberLevels < ActiveRecord::Migration[7.0]
  def change
    create_table :member_levels do |t|
      t.integer :level
      t.integer :required_members
      t.integer :coins
      t.timestamps
    end
  end
end
