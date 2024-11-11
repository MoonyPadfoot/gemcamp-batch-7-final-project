class Ticket < ApplicationRecord
  include AASM

  after_save :deduct_user_coin
  after_create :assign_serial_number

  belongs_to :user
  belongs_to :item

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