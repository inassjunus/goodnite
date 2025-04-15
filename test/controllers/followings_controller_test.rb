require "test_helper"

class FollowingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_user_auth
    setup_admin_auth
    setup_invalid_auth
    @following = followings(:one)
    @user3 = users(:three)
  end

  # GET /followings
  test "should get index of followings" do
    get user_followings_url(@user), headers: @header_user, as: :json
    assert_response :success
  end

  test "should get index of followings from other user for admin" do
    get user_followings_url(@user), headers: @header_admin, as: :json
    assert_response :success
  end

  test "should not get index of followings from other user for normal user" do
    get user_followings_url(@user_admin), headers: @header_user, as: :json
    assert_response 401
  end

  test "should not get index of followings if header invalid" do
    get user_followings_url(@user), headers: @header_invalid, as: :json
    assert_response 401
  end

  # GET /followers
  test "should get index of followers" do
    get followers_user_url(@user), headers: @header_user, as: :json
    assert_response :success
  end

  test "should get index of followers from other user for admin" do
    get followers_user_url(@user), headers: @header_admin, as: :json
    assert_response :success
  end

  test "should not get index of followers from other user for normal user" do
    get followers_user_url(@user_admin), headers: @header_user, as: :json
    assert_response 401
  end

  test "should not get index of followers if header invalid" do
    get followers_user_url(@user), headers: @header_invalid, as: :json
    assert_response 401
  end

  # POST /follow
  test "should create following" do
    assert_difference("Following.count") do
      post follow_user_url(@user_admin, @user.id), headers: @header_admin, as: :json
    end

    assert_response :created
  end

  test "should create following for other user for admin" do
    assert_difference("Following.count") do
      post follow_user_url(@user, @user3.id), headers: @header_admin, as: :json
    end

    assert_response :created
  end

  test "should not create following for other user for normal user" do
    assert_difference("Following.count", 0) do
      post follow_user_url(@user_admin, @user3.id), headers: @header_user, as: :json
    end

    assert_response 401
  end

  test "should not create following if header invalid" do
    assert_difference("Following.count", 0) do
      post follow_user_url(@user, @user3.id), headers: @header_invalid, as: :json
    end

    assert_response 401
  end

  # DELETE /unfollow
  test "should destroy following" do
    assert_difference("Following.count", -1) do
      delete unfollow_user_url(@user, @following.target_id), headers: @header_user, as: :json
    end

    assert_response :success
  end

  test "should destroy following for other user for admin" do
    assert_difference("Following.count", -1) do
      delete unfollow_user_url(@user, @following.target_id), headers: @header_admin, as: :json
    end

    assert_response :success
  end

  test "should not destroy following for other user for normal user" do
    assert_difference("Following.count", 0) do
      delete unfollow_user_url(@user_admin, @following.target_id), headers: @header_user, as: :json
    end

    assert_response 401
  end

  test "should not destroy following if header invalid" do
    assert_difference("Following.count", 0) do
      delete unfollow_user_url(@user, @following.target_id), headers: @header_invalid, as: :json
    end

    assert_response 401
  end
end
