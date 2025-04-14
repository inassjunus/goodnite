class ClockInsController < ApplicationController
  include Authorization
  before_action :set_user
  before_action :set_clock_in, only: %i[ show destroy ]

  before_action :authorize_user

  # GET /clock_ins
  # GET /clock_ins.json
  def index
    @clock_ins = @user.clock_ins
  end

  # GET /clock_ins/1
  # GET /clock_ins/1.json
  def show
    render :show, status: :ok
  end

  # POST /clock_in
  # POST /clock_in.json
  def create
    @clock_in = @user.clock_ins.build(clock_in_params)
    @clock_in.clock_in_at = Time.now

    if @clock_in.save
      render :show, status: :created
    else
      render json: @clock_in.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /clock-out
  # PATCH/PUT /clock-out.json
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

  # DELETE /clock_ins/1
  # DELETE /clock_ins/1.json
  def destroy
    @clock_in.destroy!
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
end
