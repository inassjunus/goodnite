class ApplicationController < ActionController::API
  include Pagy::Backend

  before_action :authenticate_user
  after_action { pagy_headers_merge(@pagy) if @pagy }

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
