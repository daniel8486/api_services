class Api::V1::SessionsController < ApplicationController
  include JsonResponse
  before_action :authenticate_user!, only: [ :is_valid_token ]

  def create
   if valid_token_present?
     render_error("You already have a valid token. Please use it before logging in again.", :forbidden)
     return
   end

   user = User.find_by(email: params[:email])
   if user&.valid_password?(params[:password])
     sign_in(:user, user)
     token = request.env["warden-jwt_auth.token"]
     if token.present?
       render_success({ token: token })
     else
       render_error("Unable to generate token.", :internal_server_error)
     end
   else
     render_error("Invalid email or password", :unauthorized)
   end
  end

  def refresh_token
    user = user_from_expired_token
    if user
      sign_in(:user, user)
      new_token = request.env["warden-jwt_auth.token"]
      if new_token.present?
        render_success({ token: new_token })
      else
        render_error("Unable to generate new token.", :internal_server_error)
      end
    else
      render_error("Token not provided or invalid. #{ @refresh_error}", :unauthorized)
    end
  end

  def is_valid_token
    token = JwtService.extract_token(request)
    if token
      begin
        decoded_token = JwtService.decode(token)
        exp = decoded_token[0]["exp"]
        if exp
          time_left = Time.at(exp) - Time.now
          if time_left > 0
            render_success({ valid: true, expires_in: (time_left / 60).to_i })
          else
            render_error("Token expired", :unauthorized)
          end
        else
          render_error("Token does not contain expiration", :unauthorized)
        end
      rescue JWT::DecodeError => e
        render_error("Invalid token: #{e.message}", :unauthorized)
      end
    else
      render_error("Token not provided", :unauthorized)
    end
  end

  private

  def valid_token_present?
    token = JwtService.extract_token(request)
    return false unless token
    begin
      decoded_token = JwtService.decode(token)
      exp = decoded_token[0]["exp"]
      exp && Time.at(exp) > Time.now
    rescue JWT::DecodeError
      false
    end
  end

  def user_from_expired_token
    token = JwtService.extract_token(request)
    return nil unless token
    begin
      JwtService.decode(token)
      @refresh_error = "Token still valid, no need to renew.."
      nil
    rescue JWT::ExpiredSignature
      decoded_token = JwtService.decode(token, false)
      user_id = decoded_token[0]["sub"]
      User.find_by(id: user_id)
    rescue JWT::DecodeError
      @refresh_error = "Invalid token."
      nil
    end
  end
end
