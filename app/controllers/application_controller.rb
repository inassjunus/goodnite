class ApplicationController < ActionController::API
  include Pagy::Backend

  before_action :authenticate_user
  after_action { pagy_headers_merge(@pagy) if @pagy }

  def render_error(error, http_status)
    @error = error
    @http_status = Rack::Utils.status_code(http_status)
    render "errors/error", status: http_status
  end

  private

  def authenticate_user
    header = request.headers["Authorization"]
    token = header.split(" ").last if header
    decoded = Authentication.decode_jwt_token(token)
    if decoded
      @current_user = User.find_by(id: decoded[:user_id])
    else
      render_error("Unauthorized", :unauthorized)
    end
  end
end
