class JwtService
  def self.generate_refresh_token
    SecureRandom.hex(24)
  end

  def self.encode_token(payload)
    expiration = ENV["JWT_EXPIRATION"].to_i.hours.from_now
    exp = expiration || 24.hours.from_now
    payload[:exp] = exp.to_i
    JWT.encode(payload, ENV["JWT_SECRET"], "HS256")
  end

  def self.decode_token(token)
    begin
      JWT.decode(token, ENV["JWT_SECRET"], true, { algorithm: "HS256" })
    rescue JWT::DecodeError
      nil?
    end
  end

  def self.decode_expired_token(token)
    begin
      JWT.decode(token, ENV["JWT_SECRET"], true, { algorithm: "HS256", verify_expiration: false })
    rescue JWT::ExpiredSignature
      nil
    rescue JWT::DecodeError
      nil
    end
  end
end
