require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    token = Authentication.encode_jwt_token(user_id: @user.id)
    @header = {
      'Authorization': "Bearer #{token}"
    }

    @user_admin = users(:two)
    token_admin = Authentication.encode_jwt_token(user_id: @user_admin.id)
    @header_admin = {
      'Authorization': "Bearer #{token_admin}"
    }

    @header_invalid = {
      'Authorization': "Bearer aaa"
    }
  end

  # GET /users
  test "should get index for admin" do
    get users_url, headers: @header_admin, as: :json
    assert_response :success
  end

  test "should not get index for normal user" do
    get users_url, headers: @header, as: :json
    assert_response 401
  end

  test "should not get index if token invalid" do
    get users_url, headers: @header_invalid, as: :json
    assert_response 401
  end

  # POST /users
  test "should create user" do
    assert_difference("User.count") do
      post users_url, params: { user: { email: "test@email.com", name: @user.name, password: "test", password_confirmation: "test" } }, as: :json
    end

    assert_response :created
  end

  test "should not create user if required params are missing" do
    assert_difference("User.count", 0) do
      post users_url, params: { user: { name: @user.name, password: "test", password_confirmation: "test" } }, as: :json
    end

    assert_response 422
  end

  # GET /users/1
  test "should show user" do
    get user_url(@user), headers: @header, as: :json
    assert_response :success
  end

  test "should show other user for admin" do
    get user_url(@user), headers: @header_admin, as: :json
    assert_response :success
  end

  test "should not show other user for normal  user" do
    get user_url(@user_admin), headers: @header, as: :json
    assert_response 401
  end

  test "should not show other user if token invalid" do
    get user_url(@user), headers: @header_invalid, as: :json
    assert_response 401
  end

  # PATCH/PUT /users/1
  test "should update user" do
    patch user_url(@user), headers: @header, params: { user: { email: @user.email, name: @user.name, password: "test", password_confirmation: "test" } }, as: :json
    assert_response :success
  end

  test "should update other user for admin" do
    patch user_url(@user), headers: @header_admin, params: { user: { email: @user.email, name: @user.name, password: "test", password_confirmation: "test" } }, as: :json
    assert_response :success
  end

  test "should not update other user for normal  user" do
    patch user_url(@user_admin), headers: @header, params: { user: { email: @user.email, name: @user.name, password: "test", password_confirmation: "test" } }, as: :json
    assert_response 401
  end

  test "should not update other user if token invalid" do
    patch user_url(@user), headers: @header_invalid, params: { user: { email: @user.email, name: @user.name, password: "test", password_confirmation: "test" } }, as: :json
    assert_response 401
  end

  # DELETE /users/1
  test "should destroy user for admin" do
    assert_difference("User.count", -1) do
      delete user_url(@user), headers: @header_admin, as: :json
    end

    assert_response :no_content
  end

  test "should not destroy user for normal user" do
    assert_difference("User.count", 0) do
      delete user_url(@user), headers: @header, as: :json
    end

    assert_response 401
  end

  test "should not destroy user if token invalid" do
    assert_difference("User.count", 0) do
      delete user_url(@user), headers: @header_invalid, as: :json
    end

    assert_response 401
  end
end
