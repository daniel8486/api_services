class JwtService
  SECRET = ENV["DEVISE_JWT_SECRET_KEY"] || Rails.application.credentials.devise_jwt_secret_key!
  raise "JWT secret key not set!" unless SECRET.present?
  ALGORITHM = "HS256"

  def self.decode(token, verify_exp = true)
    JWT.decode(token, SECRET, verify_exp, { algorithm: ALGORITHM })
  end

  def self.extract_token(request)
    request.headers["Authorization"]&.split(" ")&.last
  end
end
