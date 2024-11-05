class Admin::Category < ApplicationRecord
  validates :name, uniqueness: true, presence: true

  has_many :item_category_ships
  has_many :items, through: :item_category_ships

  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
  end
end