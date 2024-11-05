class User < ApplicationRecord
  mount_uploader :image, ImageUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attr_accessor :promoter_name

  enum role: { client: 0, admin: 1 }

  belongs_to :parent, class_name: User.name, foreign_key: 'parent_id', counter_cache: :children_members, optional: true
  has_many :addresses, class_name: "Client::Address"
  has_many :children, class_name: User.name, foreign_key: 'parent_id', dependent: :destroy

  validates :username, uniqueness: true, allow_nil: true
  validates :phone_number, phone: {
    possible: true,
    allow_blank: true,
    types: %i[voip mobile],
    countries: [:ph]
  }
  validates :coins, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :total_deposit, presence: true
  validates :children_members, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :image, allow_blank: true, format: { with: %r{.(gif|jpg|jpeg|png)\Z}i, message: 'must be a URL for GIF, JPG, JPEG or PNG image.' }
end
