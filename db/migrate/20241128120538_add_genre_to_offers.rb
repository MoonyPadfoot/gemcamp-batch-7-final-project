class AddGenreToOffers < ActiveRecord::Migration[7.0]
  def change
    add_column :offers, :genre, :integer, :default => 0
  end
end
