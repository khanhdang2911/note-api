module Response
  def json_response(object, message = nil, status = :ok)
    response = {}
    puts "Message: #{message}"
    if message
      response["message"] = message
    end
    response["data"] = object
    render json: response, status: status
  end
end
