class ApplicationController < ActionController::API
  before_action :authenticate_user

  private
  def authenticate_user
    header = request.headers["Authorization"]
    token = header.split(" ").last if header
    decoded = Authentication.decode_jwt_token(token)
    if decoded
      @current_user = User.find_by(id: decoded[:user_id])
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
