class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { client: 0, admin: 1 }

  validates :phone_number, phone: {
    possible: true,
    allow_blank: true,
    types: %i[voip mobile],
    countries: [:ph]
  }

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if role = conditions.delete(:role)
      where(conditions).where(role: role).first
    else
      where(conditions).first
    end
  end
end
