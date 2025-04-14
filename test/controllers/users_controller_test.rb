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
  end

  test "should get index" do
    get users_url, headers: @header_admin, as: :json
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do
      post users_url, params: { user: { email: "test@email.com", name: @user.name, password: 'test', password_confirmation: 'test' } }, as: :json
    end

    assert_response :created
  end

  test "should show user" do
    get user_url(@user), headers: @header, as: :json
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), headers: @header, params: { user: { email: @user.email, name: @user.name, password: 'test', password_confirmation: 'test' } }, as: :json
    assert_response :success
  end

  test "should destroy user" do
    assert_difference("User.count", -1) do
      delete user_url(@user), headers: @header_admin, as: :json
    end

    assert_response :no_content
  end
end
