class Ticket < ApplicationRecord
  include AASM

  after_create :assign_serial_number, :deduct_user_coin

  belongs_to :user
  belongs_to :item
  has_many :winners

  scope :filter_by_serial_number, ->(serial_number) { where(serial_number: serial_number) }
  scope :filter_by_item_name, ->(item_name) { joins(:item).where('items.name LIKE ?', "%#{item_name}%") }
  scope :filter_by_email, ->(email) { joins(:user).where(users: { email: email }) }
  scope :filter_by_created_at, ->(start_date, end_date) { where(created_at: start_date..end_date) }
  scope :filter_by_state, ->(state) { where(state: state) }

  aasm column: :state do
    state :pending, initial: true
    state :won, :lost, :cancelled

    event :win do
      transitions from: :pending, to: :won
    end

    event :lose do
      transitions from: :pending, to: :lost
    end

    event :cancel do
      transitions from: :pending, to: :cancelled, success: :refund_coin
    end
  end

  def refund_coin
    user.update(coins: user.coins + 1)
  end

  private

  def assign_serial_number
    number_count = Ticket.includes(:item).where(batch_count: batch_count, items: { id: item.id }).count
    self.serial_number = "#{Time.current.strftime("%Y%m%d")}-#{item.id}-#{item.batch_count}-#{number_count.to_s.rjust(4, '0')}"
    save
  end

  def deduct_user_coin
    user.update(coins: user.coins - 1)
  end
end