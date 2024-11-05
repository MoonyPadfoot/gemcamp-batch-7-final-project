class Admin::Category < ApplicationRecord
  validates :name, uniqueness: true, presence: true

  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
  end
end