# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json
  # before_action :configure_sign_in_params, only: [:create]
  private

# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      @token = request.env["warden-jwt_auth.token"]
      headers["Authorization"] = @token

      # ✅ CORREÇÃO: Simplificar response sem serializer problemático
      render json: {
        status: {
          code: 200,
          message: "Logged in successfully.",
          data: {
            user: {
              id: resource.id,
              email: resource.email,
              role: resource.role,
              cpf: resource.cpf
            }
          }
        },
        token: @token
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
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound
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

  def is_valid_token
    if current_user
      # ✅ CORREÇÃO: Simplificar response sem serializer problemático
      render json: {
        status: 200,
        message: "Token válido",
        user: {
          id: current_user.id,
          email: current_user.email,
          role: current_user.role,
          cpf: current_user.cpf
        }
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Token inválido ou expirado."
      }, status: :unauthorized
    end
  end
end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
