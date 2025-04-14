require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

   # POST /session/create
  test "should create session" do
    get sessions_create_url(@user), params: { user: { email: @user.email, password: "testpassword" } }, as: :json
    assert_response :success
  end

  test "should not create session if credentials invalid" do
    get sessions_create_url(@user), params: { user: { email: @user.email, password: "testpasswordwrong" } }, as: :json
    assert_response 401
  end
end
