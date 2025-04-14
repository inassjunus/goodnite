require "jwt"

module Authentication
  extend ActiveSupport::Concern
  SECRET_KEY = Rails.application.secret_key_base

  # Encode JWT token with 1 hour expiration
  def self.encode_jwt_token(payload, exp = 2.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, "HS256")
  end

  # Decode JWT token
  def self.decode_jwt_token(token)
    decoded = JWT.decode(token, SECRET_KEY, true, algorithm: "HS256")
    HashWithIndifferentAccess.new(decoded[0])
  rescue
    nil
  end
end
