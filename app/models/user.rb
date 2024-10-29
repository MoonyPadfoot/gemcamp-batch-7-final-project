class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { client: 0, admin: 1 }

  validates :username, presence: true, uniqueness: true
  validates :phone_number, phone: {
    possible: true,
    allow_blank: true,
    types: %i[voip mobile],
    countries: [:ph]
  }
  validates :coins, numericality: { only_integer: true, greater_than: 0 }
  validates :total_deposit, numericality: { greater_than: -1 }
  validates :children_members, numericality: { greater_than: -1 }

end
