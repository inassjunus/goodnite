require "test_helper"

class ClockInTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @user_admin = users(:two)
  end

  test "should create clock in" do
    @clock_in = @user.clock_ins.build({ clock_in_at: Time.now })
    assert_difference("ClockIn.count") do
      @clock_in.save
    end

    assert_equal 0, @clock_in.errors.count
  end

  test "should not create clock in if clock_in_at is in the future" do
    @clock_in = @user.clock_ins.build({ clock_in_at: Time.now + 1.day })
    assert_difference("ClockIn.count", 0) do
      @clock_in.save
    end

    assert_equal 1, @clock_in.errors.count
  end

  test "should not create clock in if clock_in_at is missing while clock_out_at is present" do
    @clock_in = @user.clock_ins.build({ clock_out_at: Time.now })
    assert_difference("ClockIn.count", 0) do
      @clock_in.save
    end

    assert_equal 1, @clock_in.errors.count
  end

  test "should not create clock in if clock_out_at is in the future" do
    @clock_in = @user.clock_ins.build({ clock_in_at: Time.now, clock_out_at: Time.now + 1.day })
    assert_difference("ClockIn.count", 0) do
      @clock_in.save
    end

    assert_equal 1, @clock_in.errors.count
  end

  test "should not create clock in if clock_out_at is before clock_in_at" do
    @clock_in = @user.clock_ins.build({ clock_in_at: Time.now - 1.day, clock_out_at: Time.now - 2.day })
    assert_difference("ClockIn.count", 0) do
      @clock_in.save
    end

    assert_equal 1, @clock_in.errors.count
  end

  test "should return followings" do
    @clock_ins = ClockIn.get_followings(@user_admin)

    assert_not_equal 0, @clock_ins
  end

  test "should return followings with options" do
    options = {
      exclude_unfinished: true,
      duration_sort: "asc"
    }
    @clock_ins = ClockIn.get_followings(@user_admin, options)

    assert_not_equal 0, @clock_ins
  end
end
