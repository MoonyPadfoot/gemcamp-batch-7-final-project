class Order < ApplicationRecord
  include AASM
  enum genre: { deposit: 0, increase: 1, deduct: 2, bonus: 3, share: 4, member_level: 5 }

  after_create :assign_serial_number
  # before_save :allow_nil_or_zero_unless_deposit, :offer_required_if_deposit

  belongs_to :offer, optional: true
  belongs_to :user

  validates :amount, presence: true, numericality: { only_numeric: true, greater_than_or_equal_to: 0 }
  validates :coin, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :remarks, presence: true, on: :balance_operate
  validate :check_purchase_limit, if: -> { offer.present? }, on: :shop_purchase

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
      transitions from: [:submitted, :pending], to: :paid, success: [:adjust_coin_paid, :add_deposit]
    end

    event :cancel do
      transitions from: [:pending, :submitted], to: :cancelled
      transitions from: :paid, to: :cancelled, success: [:adjust_coin_cancelled, :deduct_deposit]
    end
  end

  def adjust_coin_paid
    if !deduct?
      user.update(coins: user.coins + coin)
    else
      user.update(coins: user.coins - coin)
    end
  end

  def add_deposit
    user.update(total_deposit: user.total_deposit + amount) if deposit?
  end

  def deduct_deposit
    user.update(total_deposit: user.total_deposit - amount) if deposit?
  end

  def adjust_coin_cancelled
    if !deduct?
      user.update(coins: user.coins - coin)
    else
      user.update(coins: user.coins + coin)
    end
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
    if Order.exists?(user: user, offer: offer)
      errors.add(:base, "You have already purchased this one-time offer.")
    end
  end

  def validate_monthly_offer
    if Order.where(user: user, offer: offer)
            .where(created_at: Time.now.beginning_of_month..Time.now.end_of_month)
            .exists?
      errors.add(:base, "You can only purchase this monthly offer once per month.")
    end
  end

  def validate_weekly_offer
    if Order.where(user: user, offer: offer)
            .where(created_at: Time.now.beginning_of_week..Time.now.end_of_week)
            .exists?
      errors.add(:base, "You can only purchase this weekly offer once per week.")
    end
  end

  def validate_daily_offer
    if Order.where(user: user, offer: offer)
            .where(created_at: Time.now.beginning_of_day..Time.now.end_of_day)
            .exists?
      errors.add(:base, "You can only purchase this daily offer once per day.")
    end
  end
end