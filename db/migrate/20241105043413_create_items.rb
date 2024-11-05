class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :image
      t.string :name, unique: true, null: false
      t.integer :quantity
      t.integer :minimum_tickets
      t.string :state
      t.integer :batch_count
      t.datetime :online_at
      t.datetime :offline_at
      t.datetime :start_at
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
