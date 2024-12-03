class NewsTicker < ApplicationRecord
  enum status: { inactive: 0, active: 1 }

  belongs_to :admin, class_name: User.name, foreign_key: 'admin_id'

  validates :content, presence: true
  validates :sort, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  default_scope { where(deleted_at: nil) }

  scope :filter_by_status, -> { where(status: :active) }

  def destroy
    update(deleted_at: Time.now)
  end
end