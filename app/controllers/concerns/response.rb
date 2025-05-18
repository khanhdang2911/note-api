module Response
  def json_response(object = nil, message = nil, status = :ok)
    response = {}
    if message
      response["message"] = message
    end
    if object
      response["data"] = object
    end
    render json: response, status: status
  end

  def json_error_response(message = nil, status = :unprocessable_entity)
    response = {}
    if message
      response["message"] = message
    end
    render json: response, status: status
  end
end
