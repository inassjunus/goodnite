ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def setup_user_auth
      @user = users(:one)
      @header_user = setup_valid_auth(@user)
    end

    def setup_admin_auth
      @user_admin = users(:two)
      @header_admin = setup_valid_auth(@user_admin)
    end

    def setup_new_user_auth
      @user_new = users(:three)
      @header_new_user = setup_valid_auth(@user_new)
    end

    def setup_valid_auth(user)
      token = Authentication.encode_jwt_token(user_id: user.id)
      header_admin = {
        'Authorization': "Bearer #{token}"
      }
    end

    def setup_invalid_auth
      @header_invalid = {
        'Authorization': "Bearer aaa"
      }
    end
  end
end
