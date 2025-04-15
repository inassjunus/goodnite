class ClockIn < ApplicationRecord
  belongs_to :user

  validate :correct_timing

  def correct_timing
    now = Time.now + 1.minute
    if clock_in_at.present? && clock_in_at > now
      errors.add(:clock_in_at, "Clock in time must be in the past")
    end

    if clock_out_at.present? && clock_out_at > now
      errors.add(:clock_out_at, "Clock out time must be in the past")
    end

    if !clock_in_at.present? && clock_out_at.present?
      errors.add(:clock_in_at, "Missing clock_in_at")
    end

    if clock_in_at.present? && clock_out_at.present? && clock_in_at > clock_out_at
      errors.add(:clock_out_at, "Clock out time must come after clock in time")
    end
  end
end
