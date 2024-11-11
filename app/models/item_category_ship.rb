class ItemCategoryShip < ApplicationRecord
  belongs_to :item, class_name: "Admin::Item"
  belongs_to :category
end
