class Api::V1::PlansController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!
  include JsonResponse
  def create
    company = Company.find(params[:company_id])

    if params[:plans].present?
      # Criação em lote
      plans = params[:plans].map do |plan_params|
        company.plans.create!(plan_params.permit(:name, :description))
      end
      render json: plans, status: :created
    else
      # Criação individual (mantém compatibilidade)
      plan = company.plans.create!(plan_params)
      render json: plan, status: :created
    end
  end

  private

  def plan_params
   params.fetch(:plan, {}).permit(:name, :description)
  end
end
