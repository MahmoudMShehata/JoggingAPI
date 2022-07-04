class ApplicationController < ActionController::API
  before_action :set_current_user

  def set_current_user
    token = request.headers["jwt"]

    if token.nil? #|| ExperiedToken.where(token: token).any?
      render status: :unauthorized
      return
    end

    @current_user = User.find_by_token(token)

    render status: :unauthorized if @current_user.nil?
  end
end
