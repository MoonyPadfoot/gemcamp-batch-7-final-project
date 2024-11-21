class Banner < ApplicationRecord
  mount_uploader :preview, ImageUploader

  enum status: { inactive: 0, active: 1 }

  validates :preview, presence: true, format: { with: %r{.(gif|jpg|jpeg|png)\Z}i, message: 'must be a URL for GIF, JPG, JPEG or PNG image.' }
  validates :online_at, presence: true, comparison: { less_than: :offline_at }
  validates :offline_at, presence: true, comparison: { greater_than: :online_at }

  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.now)
  end
end