class FollowingsController < ApplicationController
  include Authorization
  before_action :set_user
  before_action :set_following, only: %i[ destroy ]
  before_action :authorize_user

  # GET /followings
  # GET /followings.json
  def index
    @pagy, @followings = pagy_countless(@user.followings, countless_minimal: true)
  end

  # GET /followers
  # GET /followers.json
  def followers
    @pagy, @followings = pagy_countless(@user.followers, countless_minimal: true)
    render :index, status: :ok
  end

  # POST /follow
  # POST /follow.json
  def create
    @following = @user.active_relationships.build(following_params)

    if @following.save
      render :show, status: :created
    else
      render_error(@following.errors, :unprocessable_entity)
    end
  end

  # DELETE /unfollow
  # DELETE /unfollow.json
  def destroy
    if @following.nil?
      render json: { message: "You are not following this user" }, status: :ok
    else
      @following.destroy!
      render json: { message: "OK" }, status: :ok
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    if action_name == "index"
      @user = User.find(params.expect(:user_id))
      return
    end

    @user = User.find(params.expect(:id))
  end

  def set_following
    @following = @user.active_relationships.where(target_id: params.expect(:target_id)).first
  end

  # Only allow a list of trusted parameters through.
  def following_params
    { target_id: params.expect(:target_id) }
  end
end
