class Api::V1::CompaniesController < ApplicationController
before_action :authenticate_user!
before_action :authorize_admin!, only: [ :create ]

def authorize_admin!
  render json: { error: "Acesso negado" }, status: :forbidden unless current_user.admin? || current_user.super_admin?
end
  # POST /api/v1/companies
  def create
    @company = Company.new(company_params)
    if @company.save
      render json: @company, status: :created
    else
      render json: { errors: @company.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :cnpj, :name_fantasy, :size,
                                    :registration_status_date, :opening_date,
                                    :public_place, :number, :complement,
                                    :code_postal, :neighborhood, :municipality,
                                    :uf, :email, :phone, :country)
  end
end
