class ApplicationController < ActionController::API
  include CanCan::ControllerAdditions
  before_action :configure_permitted_parameters, if: :devise_controller?
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name avatar cpf])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name avatar cpf])
  end

  # rescue_from CanCan::AccessDenied do |exception|
  #  render json: { error: "Access denied" }, status: :forbidden
  # end
  #
  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      render json: { error: "Access denied" }, status: :forbidden
    else
      render json: { error: "You need to sign in or sign up before continuing." }, status: :unauthorized
    end
  end
end
