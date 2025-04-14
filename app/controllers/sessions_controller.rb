class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: [ :create ]

  # Login (Generate JWT)
   # POST /session/create
  def create
    @user = User.find_by(email: login_params[:email])
    if @user&.authenticate(login_params[:password])
      @token = Authentication.encode_jwt_token(user_id: @user.id)
      render :create, status: :created
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def login_params
    params.require(:user).permit(:email, :password)
  end
end
