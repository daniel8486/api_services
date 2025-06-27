class Api::V1::CampaignsController < ApplicationController
load_and_authorize_resource
before_action :authenticate_user!
include JsonResponse
  def create
    company = Company.find(params[:company_id])

    if params[:campaigns].present?
      campaigns = params[:campaigns].map do |campaign_params|
        company.campaigns.create!(campaign_params.permit(:name, :description, :plan_id, :discount_percentage, :payment_method))
      end
      render json: campaigns, status: :created
    else
      campaign = company.campaigns.create!(campaign_params)
      render json: campaign, status: :created
    end
  end

private
   def campaign_params
     params.fetch(:campaign, {}).permit(:name, :description, :plan_id, :discount_percentage, :payment_method)
   end
end
