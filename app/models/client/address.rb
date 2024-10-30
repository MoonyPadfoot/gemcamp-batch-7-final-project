class Client::Address < ApplicationRecord
  enum genre: { home: 0, work: 1 }

  belongs_to :user
  belongs_to :region, class_name: "Address::Region"
  belongs_to :province, class_name: "Address::Province"
  belongs_to :city, class_name: "Address::City"
  belongs_to :barangay, class_name: "Address::Barangay"

  validates :name, uniqueness: true
  validates :street_address, presence: true
  validates :phone_number, phone: {
    possible: true,
    allow_blank: false,
    types: %i[voip mobile],
    countries: [:ph]
  }

  validate :user_address_max

  private

  def user_address_max
    if user && user.addresses.count >= 5
      errors.add(:user, "can only have 5 addresses")
    end
  end
end
