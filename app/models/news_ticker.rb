class NewsTicker < ApplicationRecord
  enum status: { inactive: 0, active: 1 }

  belongs_to :admin, class_name: User.name, foreign_key: 'admin_id', optional: true

  validates :content, presence: true

  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.now)
  end
end