class Order < ApplicationRecord
  include AASM
  enum genre: { deposit: 0, increase: 1, deduct: 2, bonus: 3, share: 4 }

  after_create :assign_serial_number
  before_save :allow_nil_or_zero_unless_deposit, :offer_required_if_deposit

  belongs_to :offer, optional: true
  belongs_to :user

  validates :amount, presence: true, numericality: { only_numeric: true, greater_than_or_equal_to: 0 }
  validates :coin, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  aasm column: :state do
    state :pending, initial: true
    state :submitted, :cancelled, :paid

    event :start do
      transitions from: :pending, to: :submitted
    end

    event :pay do
      transitions from: :submitted, to: :paid, success: :adjust_user_if_paid
    end

    event :cancel do
      transitions from: [:pending, :submitted], to: :cancelled
      transitions from: :paid, to: :cancelled, success: :adjust_user_if_cancelled
    end
  end

  def adjust_user_if_paid
    if deduct?
      user.update(coins: user.coins + 1)
    else
      user.update(coins: user.coins - 1)
    end
    user.update(total_deposit: user.total_deposit + amount) if deposit?
  end

  def adjust_user_if_cancelled
    if deduct?
      user.update(coins: user.coins - 1)
    else
      user.update(coins: user.coins + 1)
    end
    user.update(total_deposit: user.total_deposit - amount) if deposit?
  end

  private

  def assign_serial_number
    number_count = Order.includes(:user).where(users: { id: user.id }).count
    self.serial_number = "#{Time.current.strftime("%Y%m%d")}-#{id}-#{user.id}-#{number_count.to_s.rjust(4, '0')}"
    save
  end

  def offer_required_if_deposit
    if deposit?
      errors.add(:offer, "only deposited orders allowed")
    end
  end

  def allow_nil_or_zero_unless_deposit
    if deposit?
      errors.add(:amount, "nil or zero not allowed")
    end
  end
end