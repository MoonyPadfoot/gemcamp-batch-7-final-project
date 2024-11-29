class Offer < ApplicationRecord
  mount_uploader :image, ImageUploader

  enum status: { inactive: 0, active: 1 }
  enum genre: { one_time: 0, monthly: 1, weekly: 2, daily: 3, regular: 4 }

  has_many :orders

  validates :name, uniqueness: true, presence: true
  validates :amount, presence: true, numericality: { only_numeric: true, greater_than_or_equal_to: 0 }
  validates :coin, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :image, allow_blank: true, format: { with: %r{.(gif|jpg|jpeg|png)\Z}i, message: 'must be a URL for GIF, JPG, JPEG or PNG image.' }

  scope :filter_by_status, ->(status) { where(status: status) }
  scope :filter_by_genre, ->(genre) { where(genre: genre) }
end