class User < ApplicationRecord
  mount_uploader :image, ImageUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { client: 0, admin: 1 }

  has_many :addresses, class_name: "Client::Address"

  validates :username, presence: true, uniqueness: true
  validates :phone_number, phone: {
    possible: true,
    allow_blank: true,
    types: %i[voip mobile],
    countries: [:ph]
  }
  validates :phone_number, uniqueness: { case_sensitive: false }
  validates :coins, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :total_deposit, presence: true
  validates :children_members, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :image, allow_blank: true, format: { with: %r{.(gif|jpg|png)\Z}i, message: 'must be a URL for GIF, JPG or PNG image.' }

  before_save :normalize_phone_number

  private

  def normalize_phone_number
    self.phone_number = Phonelib.parse(phone_number).e164
  end
end
