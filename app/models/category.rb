class Category < ApplicationRecord
  validates :name, uniqueness: true, presence: true

  has_many :item_category_ships
  has_many :items, through: :item_category_ships

  validates :name, presence: true
  validates :sort, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
  end
end