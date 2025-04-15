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

  def self.get_followings(user, options = {})
    user_ids = user.active_relationships.map(&:target_id)
    query = {
      user_id: user_ids,
      clock_in_at: 7.days.ago...
    }

    if options[:exclude_unfinished]
      query[:duration] = Range.new(1, nil)
    end

    duration_sort = :desc
    if options[:duration_sort] == "asc"
      duration_sort = :asc
    end
    clock_ins = ClockIn.where(query).order(duration: duration_sort)
  end
end
