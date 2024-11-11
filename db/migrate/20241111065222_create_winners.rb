class CreateWinners < ActiveRecord::Migration[7.0]
  def change
    create_table :winners do |t|
      t.belongs_to :item
      t.belongs_to :ticket
      t.belongs_to :user
      t.belongs_to :address
      t.integer :item_batch_count
      t.string :state
      t.decimal :price, precision: 18, scale: 2, default: 0
      t.datetime :paid_at
      t.bigint :admin_id
      t.string :picture
      t.text :comment
      t.timestamps
    end
  end
end
