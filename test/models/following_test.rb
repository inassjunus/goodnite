require "test_helper"

class FollowingTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @user_admin = users(:two)
  end

  test "should create following" do
    @following = @user_admin.active_relationships.build({ target_id: @user.id })
    assert_difference("Following.count") do
      @following.save
    end

    assert_equal 0, @following.errors.count
  end

  test "should not create following if the target user is the same as current user" do
    @following = @user.active_relationships.build({ target_id: @user.id })
    assert_difference("Following.count", 0) do
      @following.save
    end

    assert_equal 1, @following.errors.count
  end

  test "should not create following if the target user is already followed" do
    @following = @user.active_relationships.build({ target_id: @user_admin.id })
    assert_difference("Following.count", 0) do
      @following.save
    end

    assert_equal 1, @following.errors.count
  end
end
