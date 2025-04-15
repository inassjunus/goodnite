class ClockInsController < ApplicationController
  include Authorization
  before_action :set_user
  before_action :set_clock_in, only: %i[ show destroy ]

  before_action :authorize_user

  # GET /users/1/clock_ins
  # GET /users/1/clock_ins.json
  def index
    @pagy, @clock_ins = pagy(@user.clock_ins.order(clock_in_at: clock_in_sort_params))
  end

  # GET /users/1/clock_ins/1
  # GET /users/1/clock_ins/1.json
  def show
    render :show, status: :ok
  end

  # POST /users/1/clock_in
  # POST /users/1/clock_in.json
  def create
    @clock_in = @user.clock_ins.build(clock_in_params)
    @clock_in.clock_in_at = Time.now

    if @clock_in.save
      render :show, status: :created
    else
      render json: @clock_in.errors, status: :unprocessable_entity
    end
  end

  # PATCH /users/1/clock-out
  # PATCH /users/1/clock-out.json
  def update
    @clock_in = @user.clock_ins.last
    @clock_in.clock_out_at = Time.now
    @clock_in.duration = @clock_in.clock_out_at - @clock_in.clock_in_at
    if @clock_in.save
      render :show, status: :ok
    else
      render json: @clock_in.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1/clock_ins/1
  # DELETE /users/1/clock_ins/1.json
  def destroy
    @clock_in.destroy!
    render json: { message: "OK" }, status: :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_clock_in
    @clock_in = @user.clock_ins.find(params.expect(:id))
  end

  def set_user
    if action_name == "update"
      @user = User.find(params.expect(:id))
      return
    end

    @user = User.find(params.expect(:user_id))
  end

  # Only allow a list of trusted parameters through.
  def clock_in_params
    { user_id: params.expect(:user_id) }
  end

  def clock_in_sort_params
    if params[:sort] == "asc"
      :asc
    else
      # sort by latest clock ins by default
      :desc
    end
  end
end
