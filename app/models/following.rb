class Following < ApplicationRecord
  belongs_to :user
  belongs_to :target, class_name: "User", foreign_key: "target_id"

  validate :different_user
  validates_uniqueness_of :user_id, scope: :target_id

  def different_user
    if user_id == target_id
      errors.add(:target_id, "Can't follow your own account")
    end
  end
end
