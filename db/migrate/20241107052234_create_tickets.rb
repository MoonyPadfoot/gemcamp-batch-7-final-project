class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets do |t|
      t.integer :coins, :default => 1
      t.integer :batch_count
      t.string :serial_number
      t.string :state
      t.belongs_to :user
      t.belongs_to :item
      t.timestamps
    end
  end
end
