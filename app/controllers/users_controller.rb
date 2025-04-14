class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]
  before_action :authorize, only: %i[ show update ]
  skip_before_action :authenticate_user, only: [ :create ]

  # GET /users
  # GET /users.json
  def index
    if @current_user.admin?
      @users = User.all
      render json: @users
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    render json: @user
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    if @user.save
      @token = Authentication.encode_jwt_token(user_id: @user.id)
      render :create, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
      render :show, status: :ok, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if @current_user.admin?
      @user.destroy!
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params.expect(:id))
  end

  # check if user can access the resource
  def authorize
    if !@current_user.admin? && @current_user.id != @user.id
      render json: { error: "Unauthorized" }, status: :unauthorized
      nil
    end
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
