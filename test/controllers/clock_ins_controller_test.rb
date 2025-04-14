require "test_helper"

class ClockInsControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_user_auth
    setup_admin_auth
    setup_invalid_auth
    @clock_in = clock_ins(:one)
  end

  test "should get index" do
    get user_clock_ins_url(@user), headers: @header_user, as: :json
    assert_response :success
  end

  test "should create clock_in" do
    assert_difference("ClockIn.count") do
      post user_clock_ins_url(@user), headers: @header_user, params: { clock_in: { clockin_at: @clock_in.clock_in_at, clockout_at: @clock_in.clock_out_at, duration: @clock_in.duration, user_id: @clock_in.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show clock_in" do
    get user_clock_in_url(@user, @clock_in), headers: @header_user, as: :json
    assert_response :success
  end

  test "should update clock_in" do
    patch user_clock_in_url(@user, @clock_in), headers: @header_user, params: { clock_in: { clockin_at: @clock_in.clock_in_at, clockout_at: @clock_in.clock_out_at, duration: @clock_in.duration, user_id: @clock_in.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy clock_in" do
    assert_difference("ClockIn.count", -1) do
      delete user_clock_in_url(@user, @clock_in), headers: @header_user, as: :json
    end

    assert_response :no_content
  end
end
