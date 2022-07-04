class JogsController < ApplicationController
  before_action :set_jog, only: [:show, :update, :destroy]

  # GET /jogs
  def index
    @jogs = nil

    if params[:user_id] && @current_user.regular_user?
      render status: :unauthorized
      return
    end

    if params[:user_id]
      @jogs = Jog.where(user_id: params[:user_id])
    else
      @jogs = @current_user.jogs
    end

    if params[:from_date]
      @jogs = @jogs.where('date >= ?', params[:from_date])
    end

    if params[:to_date]
      @jogs = @jogs.where('date < ?', params[:to_date])
    end

    render json: @jogs
  end

  def weekly_report
    @weekly_jogs = []
    total_distance = total_time = 0
    if @current_user.regular_user?
      @weekly_jogs = @current_user.jogs.where("created_at >= ?", Time.now - 7.days)
      @weekly_jogs.each do |jog|
        total_distance += jog.distance
        total_time     += jog.duration
      end
      avg_speed    = (total_distance.to_f/total_time.to_f).round(2)
      avg_distance = (total_distance/@weekly_jogs.count)
      render json: {Average_speed_in_meter_per_second: avg_speed,
                    Average_distance_in_meters: avg_distance,
                    Number_of_jogs: @weekly_jogs.count
                    }
    end
  end

  def filter_from_to
    @filtered_jogs = []
    if @current_user.regular_user?
      @filtered_jogs = @current_user.jogs.where("? <= created_at AND created_at <= ?", params[:from], params[:to])
    end

    render json: {FilteredJogs: @filtered_jogs}
  end

  # GET /jogs/1
  def show
    render json: @jog
  end

  # POST /jogs
  def create
    if params[:user_id] != @current_user.id && @current_user.regular_user?
      render status: :unauthorized
      return
    end

    @jog = Jog.new(jog_params)
    @jog.user_id = @current_user.id if params[:user_id].nil?

    if @jog.save
      render json: @jog, status: :created, location: @jog
    else
      render json: @jog.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /jogs/1
  def update
    if @jog.update(jog_params)
      render json: @jog
    else
      render json: @jog.errors, status: :unprocessable_entity
    end
  end

  # DELETE /jogs/1
  def destroy
    @jog.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jog
      @jog = Jog.find(params[:id])
      if (@jog.user_id != @current_user.id) && @current_user.regular_user?
        render status: :unauthorized
        return
      end
    end

    # Only allow a list of trusted parameters through.
    def jog_params
      params.require(:jog).permit(:duration, :distance, :date, :user_id)
    end
end
