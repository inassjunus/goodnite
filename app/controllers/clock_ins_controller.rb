class ClockInsController < ApplicationController
  include Authorization
  before_action :set_user
  before_action :set_clock_in, only: %i[ show update destroy ]

  before_action :authorize_user

  # GET /clock_ins
  # GET /clock_ins.json
  def index
    @clock_ins = @user.clock_ins
  end

  # GET /clock_ins/1
  # GET /clock_ins/1.json
  def show
  end

  # POST /clock_ins
  # POST /clock_ins.json
  def create
    @clock_in = @user.clock_ins.build(clock_in_params)

    if @clock_in.save
      render :show, status: :created
    else
      render json: @clock_in.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /clock_ins/1
  # PATCH/PUT /clock_ins/1.json
  def update
    if @clock_in.update(clock_in_params)
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
    @user = User.find(params.expect(:user_id))
  end

  # Only allow a list of trusted parameters through.
  def clock_in_params
    params.expect(clock_in: [ :user_id, :duration, :clock_in_at, :clock_out_at ])
  end
end
