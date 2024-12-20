class Address::Barangay < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  belongs_to :city
  has_many :addresses, class_name: "Client::Address"
end
