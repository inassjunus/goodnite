class ClockInsController < ApplicationController
  include Authorization
  before_action :set_user
  before_action :set_clock_in, only: %i[ show destroy manual_update ]

  before_action :authorize_user

  TIME_FORMAT = "%Y-%m-%d %H:%M"

  # GET /users/1/clock-ins
  # GET /users/1/clock-ins.json
  def index
    @pagy, @clock_ins = pagy_countless(@user.clock_ins.order(clock_in_at: clock_in_sort_params), countless_minimal: true)
  end

  # GET /users/1/clock-ins/followings
  # GET /users/1/clock-ins/followings.json
  def followings
    @pagy, @clock_ins = pagy_countless(ClockIn.get_followings(@user, query_options), countless_minimal: true)
    render :index, status: :ok
  end

  # GET /users/1/clock_ins/1
  # GET /users/1/clock_ins/1.json
  def show
    render :show, status: :ok
  end

  # POST /users/1/clock_in
  # POST /users/1/clock_in.json
  def create
    @clock_in = @user.clock_ins.build
    @clock_in.clock_in_at = Time.now
    if clock_in_param.present?
      clock_in_param_parsed = Time.zone.strptime(clock_in_param, TIME_FORMAT)
      @clock_in.clock_in_at = clock_in_param_parsed
    end

    if @clock_in.save
      render :show, status: :created
    else
      render_error(@clock_in.errors, :unprocessable_entity)
    end
  rescue ArgumentError
    render_error("Time format must be YYYY-MM-DD HH:MM", :unprocessable_entity)
  end

  # set clock out time to the latest sleep
  # PATCH /users/1/clock-out
  # PATCH /users/1/clock-out.json
  def update
    @clock_in = @user.clock_ins.last
    if !@clock_in.present?
      render_error("You haven't clock-in yet", :unprocessable_entity)
      return
    end
    @clock_in.clock_out_at = Time.now
    @clock_in.duration = @clock_in.clock_out_at - @clock_in.clock_in_at
    if @clock_in.save
      render :show, status: :ok
    else
      render_error(@clock_in.errors, :unprocessable_entity)
    end
  end

  # if user forgot to clock out on previous sleep session, they can manually set the clock out time on older clock ins data
  # PATCH /users/1/clock-ins/1/clock-out
  # PATCH /users/1/clock-ins/1/clock-out.json
  def manual_update
    clock_out_param_parsed = Time.zone.strptime(clock_out_param, TIME_FORMAT)
    @clock_in.clock_out_at = clock_out_param_parsed
    @clock_in.duration = @clock_in.clock_out_at - @clock_in.clock_in_at
    if @clock_in.save
      render :show, status: :ok
    else
      render_error(@clock_in.errors, :unprocessable_entity)
    end
  rescue ArgumentError
    render_error("Time format must be YYYY-MM-DD HH:MM", :unprocessable_entity)
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
    @clock_in = ClockIn.find(params.expect(:id))
    if @clock_in.user_id != @user.id
      render_error("Not Found", :not_found)
    end
  end

  def set_user
    if action_name == "update"
      @user = User.find(params.expect(:id))
      return
    end

    @user = User.find(params.expect(:user_id))
  end

  # Only allow a list of trusted parameters through.
  def clock_in_param
    params[:clock_in_at]
  end

  def clock_out_param
    params.expect(:clock_out_at)
  end

  def query_options
    params.permit(:exclude_unfinished, :duration_sort)
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
