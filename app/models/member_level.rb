class MemberLevel < ApplicationRecord
  has_many :users

  validates :required_members, presence: true, numericality: { only_numeric: true, greater_than_or_equal_to: 0 }
  validates :coins, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_create :set_level
  after_destroy :adjust_levels_after_deletion

  private

  def adjust_levels_after_deletion
    deleted_level = level

    MemberLevel.where("level > ?", deleted_level).find_each do |record|
      record.update(level: record.level - 1)
    end
  end

  def set_level
    self.level = MemberLevel.count(:level)
  end
end