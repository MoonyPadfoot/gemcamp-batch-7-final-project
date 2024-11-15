class Winner < ApplicationRecord
  include AASM
  mount_uploader :picture, ImageUploader

  belongs_to :item
  belongs_to :ticket
  belongs_to :user
  belongs_to :address, class_name: "Client::Address", optional: true
  belongs_to :admin, class_name: User.name, foreign_key: 'admin_id', optional: true

  scope :filter_by_serial_number, ->(serial_number) { joins(:ticket).where(tickets: { serial_number: serial_number }) }
  scope :filter_by_email, ->(email) { joins(:user).where(users: { email: email }) }
  scope :filter_by_created_at, ->(start_date, end_date) { where(created_at: start_date..end_date) }
  scope :filter_by_state, ->(state) { where(state: state) }

  aasm column: :state do
    state :won, initial: true
    state :claimed, :submitted, :paid, :shipped, :delivered, :shared, :published, :remove_published

    event :claim do
      transitions from: :won, to: :claimed
    end

    event :submit do
      transitions from: :claimed, to: :submitted
    end

    event :pay do
      transitions from: :submitted, to: :paid
    end

    event :ship do
      transitions from: :paid, to: :shipped
    end

    event :deliver do
      transitions from: :shipped, to: :delivered
    end

    event :share do
      transitions from: :delivered, to: :shared
    end

    event :publish do
      transitions from: [:shared, :remove_published], to: :published
    end

    event :remove_publish do
      transitions from: :published, to: :remove_published
    end
  end
end