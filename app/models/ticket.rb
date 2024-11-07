class Ticket < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :item, class_name: 'Admin::Item', counter_cache: :batch_count

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

  def deduct_coin
    user.update(coins: user.coins - 1)
  end

  def refund_coin
    user.update(coins: user.coins + 1)
  end

  private

  def assign_serial_number
    number_count = self.joins(:item).where(batch_count: item.batch_count).count
    self.update(serial_number: "#{Time.current.strftime("%Y%m%d")}-#{item.id}-#{item.batch_count}-#{number_count.to_s.rjust(4, '0')}")
  end

end