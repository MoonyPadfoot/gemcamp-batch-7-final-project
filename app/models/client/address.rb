class Client::Address < ApplicationRecord
  validates :name, uniqueness: true
  validates :street_address, presence: true
  validates :phone_number, phone: {
    possible: true,
    allow_blank: false,
    types: %i[voip mobile],
    countries: [:ph]
  }

  belongs_to :user
  belongs_to :region
  belongs_to :province
  belongs_to :city
  belongs_to :barangay
end
