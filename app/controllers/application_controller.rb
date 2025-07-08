class ApplicationController < ActionController::API
  include Response
  include ActionController::Cookies
  private
  def handle_record_not_destroyed(exception)
    json_error_response exception.message
  end

  def authorized(skip_expired: false)
    header = request.headers["Authorization"]
    return nil unless header

    token = header.split(" ")[1]
    decoded_token = skip_expired ? JwtService.decode_expired_token(token) : JwtService.decode_token(token)
    user_id = decoded_token[0]["user_id"] if decoded_token
    @current_user ||= User.find_by(id: user_id) if user_id
    unless !!@current_user
      json_error_response "Unauthorized access", :unauthorized
      false
    end
  end

  def authorized_refresh_token
    authorized skip_expired: true
  end
end
