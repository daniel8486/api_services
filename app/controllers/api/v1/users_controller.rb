class Api::V1::UsersController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!
  include JsonResponse
  # before_action :set_user, only: [ :show ]
  def index
    users = @users.includes(:company).accessible_by(current_ability)
    render_success({ users: UserService.serialize_users(users) })
  end

  def show
    render_success({ message: "User found", data: UserService.serialize_user(@user) })
  end

  def update
    if @user.super_root? && !current_user.super_root?
    render_error("Você não pode editar o super_root.", :forbidden)
    elsif @user.update(user_params)
      render_success({ message: "User updated successfully", data: UserService.serialize_user(@user) })
    else
      render_error(@user.errors.full_messages.join(", "), :unprocessable_entity)
    end
  end

  def destroy
    if @user.super_root? || @user.super_admin?
    render_error("Não é permitido remover super_root ou super_admin.", :forbidden)
    elsif @user.destroy
      render_success({ message: "User deleted successfully" })
    else
      render_error(@user.errors.full_messages.join(", "), :unprocessable_entity)
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end

  def user_params
   allowed = [ :name, :email, :password, :password_confirmation, :cpf, :avatar, :role, :company_id ]
   # Só super_admin ou super_root podem definir qualquer role
   allowed << :role if current_user&.super_admin? || current_user&.super_root? || User.admin.count == 0
   params.require(:user).permit(allowed)
  end
end
