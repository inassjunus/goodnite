require "test_helper"

class FollowingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_user_auth
    setup_admin_auth
    setup_invalid_auth
    @following = followings(:one)
  end

  test "should get index of followings" do
    get user_followings_url(@user), headers: @header_user, as: :json
    assert_response :success
  end

  test "should get index of followers" do
    get followers_user_url(@user), headers: @header_user, as: :json
    assert_response :success
  end

  test "should create following" do
    assert_difference("Following.count") do
      post follow_user_url(@user_admin, @user.id), headers: @header_admin, as: :json
    end

    assert_response :created
  end

  test "should destroy following" do
    assert_difference("Following.count", -1) do
      delete unfollow_user_url(@user, @following.target_id), headers: @header_user, as: :json
    end

    assert_response :success
  end
end
