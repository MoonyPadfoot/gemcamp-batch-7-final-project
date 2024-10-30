class CreateClientAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :client_addresses do |t|
      t.integer :genre, default: 0
      t.string :name, null: true, default: ""
      t.text :street_address, null: false
      t.string :phone_number, null: false
      t.text :remark, null: true, default: ""
      t.boolean :is_default, default: false
      t.belongs_to :user
      t.belongs_to :region
      t.belongs_to :province
      t.belongs_to :city
      t.belongs_to :barangay
      t.timestamps
    end
  end
end
