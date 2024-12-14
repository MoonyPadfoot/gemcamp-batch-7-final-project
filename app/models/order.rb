class Order < ApplicationRecord
  include AASM
  enum genre: { deposit: 0, increase: 1, deduct: 2, bonus: 3, share: 4, member_level: 5 }

  belongs_to :offer, optional: true
  belongs_to :user

  validates :amount, presence: true, numericality: { only_numeric: true, greater_than: 0 }, on: :shop_purchase
  validates :coin, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :remarks, presence: true, on: :balance_operate
  validate :check_purchase_limit, if: -> { offer.present? }, on: :shop_purchase

  after_create :assign_serial_number

  scope :filter_by_serial_number, ->(serial_number) { where(serial_number: serial_number) }
  scope :filter_by_email, ->(email) { joins(:user).where(users: { email: email }) }
  scope :filter_by_offer_name, ->(offer_name) { joins(:offer).where('offers.name LIKE ?', "%#{offer_name}%") }
  scope :filter_by_created_at, ->(start_date, end_date) { where(created_at: start_date..end_date) }
  scope :filter_by_genre, ->(genre) { where(genre: genre) }
  scope :filter_by_state, ->(state) { where(state: state) }

  aasm column: :state do
    state :pending, initial: true
    state :submitted, :cancelled, :paid

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :pay do
      transitions from: :submitted, to: :paid, success: [:adjust_coin_paid, :add_deposit]
      transitions from: :pending, to: :paid, guard: [:is_not_deposit?, :deduct_balance_enough?], success: :adjust_coin_paid
    end

    event :cancel do
      transitions from: [:pending, :submitted], to: :cancelled
      transitions from: :paid, to: :cancelled, guard: :cancel_balance_enough?, success: [:adjust_coin_cancelled, :deduct_deposit]
    end
  end

  def adjust_coin_paid
    adjusted_coins = deduct? ? user.coins - coin : user.coins + coin

    user.update(coins: adjusted_coins)
  end

  def adjust_coin_cancelled
    adjusted_coins = deduct? ? user.coins + coin : user.coins - coin

    user.update(coins: adjusted_coins)
  end

  def add_deposit
    user.update(total_deposit: user.total_deposit + amount) if deposit?
  end

  def deduct_deposit
    user.update(total_deposit: user.total_deposit - amount) if deposit?
  end

  def cancel_balance_enough?
    return true if deduct?

    user.coins >= coin
  end

  def deduct_balance_enough?
    return true unless deduct?

    user.coins > coin
  end

  def is_not_deposit?
    !deposit?
  end

  private

  def assign_serial_number
    number_count = Order.includes(:user).where(users: user).count
    self.serial_number = "#{Time.current.strftime("%Y%m%d")}-#{id}-#{user.id}-#{number_count.to_s.rjust(4, '0')}"
    save
  end

  def check_purchase_limit
    if offer.one_time?
      validate_one_time_offer
    elsif offer.monthly?
      validate_monthly_offer
    elsif offer.weekly?
      validate_weekly_offer
    elsif offer.daily?
      validate_daily_offer
    end
  end

  def validate_one_time_offer
    if Order.where.not(state: :cancelled)
            .exists?(user: user, offer: offer)
      errors.add(:base, "You have already purchased this one-time offer.")
    end
  end

  def validate_monthly_offer
    if Order.where(user: user, offer: offer)
            .where(created_at: Time.current.beginning_of_month..Time.current.end_of_month)
            .where.not(state: :cancelled)
            .exists?
      errors.add(:base, "You can only purchase this monthly offer once per month.")
    end
  end

  def validate_weekly_offer
    if Order.where(user: user, offer: offer)
            .where(created_at: Time.current.beginning_of_week..Time.current.end_of_week)
            .where.not(state: :cancelled)
            .exists?
      errors.add(:base, message: "You can only purchase this weekly offer once per week.")
    end
  end

  def validate_daily_offer
    if Order.where(user: user, offer: offer)
            .where(created_at: Time.current.beginning_of_day..Time.current.end_of_day)
            .where.not(state: :cancelled)
            .exists?
      errors.add(:base, "You can only purchase this daily offer once per day.")
    end
  end
end