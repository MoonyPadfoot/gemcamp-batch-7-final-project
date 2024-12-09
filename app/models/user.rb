class User < ApplicationRecord
  mount_uploader :image, ImageUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attr_accessor :promoter_name
  attr_accessor :ticket_count

  enum role: { client: 0, admin: 1 }

  belongs_to :parent, class_name: User.name, foreign_key: 'parent_id', counter_cache: :children_members, optional: true
  belongs_to :member_level, optional: true
  has_many :addresses, class_name: "Client::Address"
  has_many :children, class_name: User.name, foreign_key: 'parent_id', dependent: :destroy
  has_many :tickets
  has_many :winners
  has_many :orders

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
  validate :coins_sufficient?, on: :purchase

  after_create :upgrade_next_level

  private

  def coins_sufficient?
    if coins < ticket_count
      errors.add(:coins, 'are insufficient for the purchase.')
    end
  end

  def upgrade_next_level
    user = User.client.find_by(id: parent)
    user.member_level ||= MemberLevel.first
    next_level = MemberLevel.where("id > ?", user.member_level).first

    if next_level && User.where(parent: parent).count == next_level.required_members
      user.coins = user.coins + next_level.coins
      user.member_level = next_level
      user.save
    end
  end
end
