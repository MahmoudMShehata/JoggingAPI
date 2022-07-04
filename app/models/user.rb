class User < ApplicationRecord
  has_secure_password
  has_many :jogs

  def jwt_token
    payload = {user_id: id, created_at: Time.now}
    JWT.encode payload, ENV['RAILS_APP_PASS'], 'HS256'
  end

  def self.find_by_token token
    decoded_token = JWT.decode token, ENV['RAILS_APP_PASS'], false

    user_id = decoded_token[0]['user_id']
    User.find(user_id)
  rescue JWT::DecodeError
    return nil
  end

  def regular_user?
    user_type == 'regular'
  end

  def admin_user?
    user_type == 'admin'
  end

  def manager_user?
    user_type == 'user_manager'
  end
end
