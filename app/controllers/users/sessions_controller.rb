# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      @token = request.env["warden-jwt_auth.token"]
      headers["Authorization"] = @token

      # ✅ CORREÇÃO: Evitar UserSerializer problemático
      begin
        # Tentar usar o serializer
        user_data = UserSerializer.new(resource).serializable_hash
        user_attributes = user_data.dig(:data, :attributes) || {}

        # Se der erro, usar dados simples
        user_attributes = {
          id: resource.id,
          email: resource.email,
          role: resource.role,
          cpf: resource.cpf
        } if user_attributes.empty?

      rescue => e
        Rails.logger.error "❌ UserSerializer error: #{e.message}"
        # Fallback para dados simples
        user_attributes = {
          id: resource.id,
          email: resource.email,
          role: resource.role,
          cpf: resource.cpf
        }
      end

      render json: {
        status: {
          code: 200,
          message: "Logged in successfully.",
          data: { user: user_attributes }
        }
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Invalid email or password."
      }, status: :unauthorized
    end
  end

  def respond_to_on_destroy
    if request.headers["Authorization"].present?
      begin
        jwt_payload = JWT.decode(request.headers["Authorization"].split(" ").last, Rails.application.credentials.devise_jwt_secret_key!).first
        current_user = User.find(jwt_payload["sub"])
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound => e
        Rails.logger.error "❌ JWT decode error: #{e.message}"
        current_user = nil
      end
    end

    if current_user
      render json: {
        status: 200,
        message: "Logged out successfully."
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end
