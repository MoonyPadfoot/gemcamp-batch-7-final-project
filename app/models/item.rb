class Item < ApplicationRecord
  include AASM
  mount_uploader :image, ImageUploader

  enum status: { inactive: 0, active: 1 }

  has_many :item_category_ships
  has_many :categories, through: :item_category_ships
  has_many :tickets
  has_many :winners

  validates :image, presence: true, format: { with: %r{.(gif|jpg|jpeg|png)\Z}i, message: 'must be a URL for GIF, JPG, JPEG or PNG image.' }
  validates :name, uniqueness: true, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :minimum_tickets, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :batch_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :online_at, presence: true, comparison: { less_than: :offline_at }
  validates :offline_at, presence: true, comparison: { greater_than: :online_at }
  validates :start_at, presence: true
  validates :batch_count, presence: true

  scope :filter_by_category, ->(category) { joins(:categories).where(categories: { name: category }) if category.present? }
  scope :filter_by_status, -> { where(status: self.statuses[:active]) }
  scope :filter_by_state, -> { where(state: :starting) }

  default_scope { where(deleted_at: nil) }

  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :ended, :cancelled], to: :starting,
                  guard: [:quantity_enough?, :active?, :offline_before_today?],
                  success: [:deduct_quantity, :add_batch_count]
      transitions from: :paused, to: :starting
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended
    end

    event :cancel do
      transitions from: [:starting, :paused], to: :cancelled, success: :cancel_batch_tickets
    end
  end

  def destroy
    update(deleted_at: Time.current)
  end

  def deduct_quantity
    self.update(quantity: self.quantity - 1)
  end

  def add_batch_count
    self.update(batch_count: self.batch_count + 1)
  end

  def quantity_enough?
    self.quantity >= 1
  end

  def offline_before_today?
    self.offline_at > Time.current
  end

  def cancel_batch_tickets
    tickets = Ticket.includes(:item).where(batch_count: batch_count, items: { id: self.id })
    tickets.each do |ticket|
      ticket.cancel! if ticket.may_cancel?
    end
  end
end