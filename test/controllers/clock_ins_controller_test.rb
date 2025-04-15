require "test_helper"

class ClockInsControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_user_auth
    setup_admin_auth
    setup_invalid_auth
    @clock_in = clock_ins(:one)
    @clock_in_admin = clock_ins(:two)

    @clock_out_at = (@clock_in.clock_in_at + 1.minute).strftime("%Y-%m-%d %H:%M")
    @clock_out_at_admin = (@clock_in_admin.clock_in_at + 1.minute).strftime("%Y-%m-%d %H:%M")
  end

  # GET /users/1/clock_ins
  test "should get index" do
    get user_clock_ins_url(@user), headers: @header_user, as: :json
    assert_response :success
  end

  test "should get index from other user for admin" do
    get user_clock_ins_url(@user), headers: @header_admin, as: :json
    assert_response :success
  end

  test "should not get index from other user for normal user" do
    get user_clock_ins_url(@user_admin), headers: @header_user, as: :json
    assert_response 401
  end

  test "should not get index if header invalid" do
    get user_clock_ins_url(@user), headers: @header_invalid, as: :json
    assert_response 401
  end

  # GET /users/1/clock_ins/followings
  test "should get followings" do
    get followings_user_clock_ins_url(@user), headers: @header_user, as: :json
    assert_response :success
  end

  test "should get followings from other user for admin" do
    get followings_user_clock_ins_url(@user), headers: @header_admin, as: :json
    assert_response :success
  end

  test "should not get followings from other user for normal user" do
    get followings_user_clock_ins_url(@user_admin), headers: @header_user, as: :json
    assert_response 401
  end

  test "should not get followings if header invalid" do
    get followings_user_clock_ins_url(@user), headers: @header_invalid, as: :json
    assert_response 401
  end

  # POST /users/1/clock_in
  test "should create clock_in" do
    assert_difference("ClockIn.count") do
      post user_clock_ins_url(@user), headers: @header_user, params: { user_id: @clock_in.user_id }, as: :json
    end

    assert_response :created
  end

  test "should create clock_in for other user for admin" do
    assert_difference("ClockIn.count") do
      post user_clock_ins_url(@user), headers: @header_admin, params: { user_id: @clock_in.user_id }, as: :json
    end

    assert_response :created
  end

  test "should perform manual clock in" do
    assert_difference("ClockIn.count") do
      post user_clock_ins_url(@user), params: { clock_in_at: "2025-04-14 10:11" }, headers: @header_user, as: :json
    end

    assert_response :created
  end

  test "should perform manual clock in for other user for admin" do
    assert_difference("ClockIn.count") do
      post user_clock_ins_url(@user), params: { clock_in_at: "2025-04-14 10:11" }, headers: @header_admin, as: :json
    end

    assert_response :created
  end

  test "should not perform manual clock in if param invalid" do
    assert_difference("ClockIn.count", 0) do
      post user_clock_ins_url(@user), params: { clock_in_at: "2025-04-14" }, headers: @header_admin, as: :json
    end

    assert_response 422
  end

  test "should not create clock_in for other user for normal user" do
    assert_difference("ClockIn.count", 0) do
      post user_clock_ins_url(@user_admin), headers: @header_user, params: { user_id: @clock_in_admin.user_id }, as: :json
    end

    assert_response 401
  end

  test "should not create clock_in if header invalid" do
    assert_difference("ClockIn.count", 0) do
      post user_clock_ins_url(@user), headers: @header_invalid, params: { user_id: @clock_in.user_id }, as: :json
    end

    assert_response 401
  end

  # GET /users/1/clock_ins/1
  test "should show clock_in" do
    get user_clock_in_url(@user, @clock_in), headers: @header_user, as: :json
    assert_response :success
  end

  test "should show clock_in from other user for admin" do
    get user_clock_in_url(@user, @clock_in), headers: @header_admin, as: :json
    assert_response :success
  end

  test "should not show clock_in from other user for normal user" do
    get user_clock_in_url(@user_admin, @clock_in_admin), headers: @header_user, as: :json
    assert_response 401
  end

  test "should not show clock_in if header invalid" do
    get user_clock_in_url(@user, @clock_in), headers: @header_invalid, as: :json
    assert_response 401
  end

  # PATCH /users/1/clock-out
  test "should perform clock out" do
    patch clock_out_user_url(@user, @clock_in), headers: @header_user, as: :json
    assert_response :success
  end

  test "should perform clock out for other user for admin" do
    patch clock_out_user_url(@user, @clock_in), headers: @header_admin, as: :json
    assert_response :success
  end

  test "should not perform clock out for other user for normal user" do
    patch clock_out_user_url(@user_admin, @clock_in), headers: @header_user, as: :json
    assert_response 401
  end

  test "should not perform clock out for other user if header invalid" do
    patch clock_out_user_url(@user, @clock_in), headers: @header_invalid, as: :json
    assert_response 401
  end

  # PATCH /users/1/clock-ins/1/clock-out
  test "should perform manual clock out" do
    patch clock_out_user_clock_in_url(@user, @clock_in), params: { clock_out_at: @clock_out_at }, headers: @header_user, as: :json
    assert_response :success
  end

  test "should perform manual clock out for other user for admin" do
    patch clock_out_user_clock_in_url(@user, @clock_in), params: { clock_out_at: @clock_out_at }, headers: @header_admin, as: :json
    assert_response :success
  end

  test "should not perform manual clock out if param invalid" do
    patch clock_out_user_clock_in_url(@user, @clock_in), params: { clock_out_at: "2025-11-11" }, headers: @header_admin, as: :json
    assert_response 422
  end

  test "should not perform manual clock out for other user for normal user" do
    patch clock_out_user_clock_in_url(@user_admin, @clock_in_admin), params: { clock_out_at: @clock_out_at_admin }, headers: @header_user, as: :json
    assert_response 401
  end

  test "should not perform manual clock out for other user if header invalid" do
    patch clock_out_user_clock_in_url(@user, @clock_in), params: { clock_out_at: @clock_out_at }, headers: @header_invalid, as: :json
    assert_response 401
  end

  # DELETE /users/1/clock_ins/1
  test "should destroy clock_in" do
    assert_difference("ClockIn.count", -1) do
      delete user_clock_in_url(@user, @clock_in), headers: @header_user, as: :json
    end

    assert_response :success
  end

  test "should destroy clock_in for other user for admin" do
    assert_difference("ClockIn.count", -1) do
      delete user_clock_in_url(@user, @clock_in), headers: @header_admin, as: :json
    end

    assert_response :success
  end

  test "should not destroy clock_in for other user for normal user" do
    assert_difference("ClockIn.count", 0) do
      delete user_clock_in_url(@user_admin, @clock_in_admin), headers: @header_user, as: :json
    end

    assert_response 401
  end

  test "should not destroy clock_in if header invalid" do
    assert_difference("ClockIn.count", 0) do
      delete user_clock_in_url(@user, @clock_in), headers: @header_invalid, as: :json
    end

    assert_response 401
  end
end
