class Client::Address < ApplicationRecord
  enum genre: { home: 0, office: 1 }

  belongs_to :user
  belongs_to :region, class_name: "Address::Region"
  belongs_to :province, class_name: "Address::Province"
  belongs_to :city, class_name: "Address::City"
  belongs_to :barangay, class_name: "Address::Barangay"
  has_many :winners

  validates :name, presence: true
  validates :street_address, presence: true
  validates :phone_number, phone: {
    possible: true,
    allow_blank: false,
    types: %i[voip mobile],
    countries: [:ph]
  }
  validates :region_id, presence: true
  validates :province_id, presence: true
  validates :city_id, presence: true
  validates :barangay_id, presence: true
  validate :user_address_max, on: :create

  before_save :unset_other_defaults, if: :is_default?

  private

  def unset_other_defaults
    Client::Address.includes(:user).find_by(is_default: true, users: { id: user.id }).update(is_default: false)
  end

  def user_address_max
    if user && user.addresses.count >= 5
      errors.add(:user, "can only have 5 addresses")
    end
  end
end
