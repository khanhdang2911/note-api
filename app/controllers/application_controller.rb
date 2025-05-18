class ApplicationController < ActionController::API
  private
  def handle_record_not_destroyed(exception)
    json_error_response exception.message
  end
end
