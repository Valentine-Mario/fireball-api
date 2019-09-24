require 'jwt'

class JsonWebToken
  MY_SECRET_KEY = Rails.application.secrets.secret_key_base. to_s

  def self.encode(payload, exp = 100.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, MY_SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, MY_SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
end