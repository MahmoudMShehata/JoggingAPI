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
