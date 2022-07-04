class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  skip_before_action :set_current_user, only: [:login, :create]

  # GET /users
  def index
    if !@current_user.admin_user? || @current_user.manager_user?
      render status: :unauthorized
      return
    end

    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    if @current_user.id != params[:id] && @current_user.regular_user?
      render status: :unauthorized
    elsif @current_user.admin_user?
      @user = User.find(params[:id])
      #user's jogs must be deleted first be because of the user-jog association 
      @user.jogs.each do |jog|
        jog.destroy
      end
      @user.destroy
      render json: {Deleted_User: @user.email}
    elsif @current_user.id != params[:id] && @current_user.manager_user?
      @user = User.find(params[:id])
      render status: :unauthorized unless !@user.admin_user?
      @user.jogs.each do |jog|
        jog.destroy
      end
      @user.destroy
      render json: {Deleted_User: @user.email}
    end
  end

  def login
    if params[:email].nil? || params[:password].nil?
      render status: :bad_request
      return
    end

    user = User.find_by(email: params[:email])

    if user.nil?
      render status: :not_found
      return
    end

    user = user.authenticate(params[:password])

    if user
      render json: {token: user.jwt_token}
    else
      render status: :unauthorized
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :user_type)
    end
end
