class Client::Address < ApplicationRecord
  enum genre: { home: 0, work: 1 }

  validates :name, uniqueness: true
  validates :street_address, presence: true
  validates :phone_number, phone: {
    possible: true,
    allow_blank: false,
    types: %i[voip mobile],
    countries: [:ph]
  }

  belongs_to :user
  belongs_to :region, class_name: "Address::Region"
  belongs_to :province, class_name: "Address::Province"
  belongs_to :city, class_name: "Address::City"
  belongs_to :barangay, class_name: "Address::Barangay"
end
