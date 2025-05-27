class JwtService
  ALGORITHM = "HS256"
  def self.secret
    ENV["DEVISE_JWT_SECRET_KEY"].presence || Rails.application.credentials.devise_jwt_secret_key!
  end
  def self.decode(token, verify_exp = true)
    JWT.decode(token, SECRET, verify_exp, { algorithm: ALGORITHM })
  end

  def self.extract_token(request)
    request.headers["Authorization"]&.split(" ")&.last
  end
end
