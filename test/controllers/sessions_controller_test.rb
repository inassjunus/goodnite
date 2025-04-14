require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get create" do
    get sessions_create_url(@user), params: { user: { email: @user.email, password: 'testpassword' } }, as: :json
    assert_response :success
  end
end
