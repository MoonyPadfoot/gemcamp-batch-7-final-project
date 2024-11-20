class CreateNewsTickers < ActiveRecord::Migration[7.0]
  def change
    create_table :news_tickers do |t|
      t.text :content
      t.integer :status, default: 0
      t.belongs_to :admin
      t.timestamps
    end
  end
end
