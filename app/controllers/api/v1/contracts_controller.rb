class Api::V1::ContractsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!
  include JsonResponse

  def index
    contracts = Contract.includes(:client, :plan, :campaign).accessible_by(current_ability)
    render json: contracts.as_json(
      include: {
        client: { only: [ :id, :name, :email ] },
        plan: { only: [ :id, :name, :valor ] },
        campaign: { only: [ :id, :name ] }
      },
      only: [ :id, :company_id, :client_id, :plan_id, :campaign_id, :details, :valor, :data_contrato, :created_at, :updated_at ]
    ), status: :ok
  end
  def show
     contract = Contract.find(params[:id])
      render json: contract.as_json.merge(
       parcelas: contract.installments.as_json(
         only: [ :id, :contract_id, :numero, :valor, :vencimento, :data_pagamento, :status, :created_at, :updated_at ]
       )
     ), status: :ok
     rescue ActiveRecord::RecordNotFound
      render json: { error: "Contrato não encontrado" }, status: :not_found
  end
  def create
    plan = Plan.find(params[:contract][:plan_id])
    client = Client.find(params[:contract][:client_id])

    # Garante que o cliente pertence à mesma empresa do plano
    puts "DEBUG: client.company_id=#{client.company_id}, plan.company_id=#{plan.company_id} (class: #{client.company_id.class})"
    unless client.company_id == plan.company_id
      return render json: { error: "Cliente não pertence à empresa do plano" }, status: :forbidden
    end

    # Se houver campanha, garanta que ela pertence ao mesmo plano/empresa
    if params[:contract][:campaign_id].present?
      campaign = Campaign.find(params[:contract][:campaign_id])
      unless campaign.plan_id == plan.id && campaign.company_id == plan.company_id
        return render json: { error: "Campanha não pertence ao plano/empresa" }, status: :forbidden
      end
    end

    contract = Contract.create!(contract_params)
    contract.gerar_parcelas!
    contract.generate_pdf # Gera o PDF após criar o contrato
    SendClientContractEmailJob.perform_later(contract.client_id, contract.id)
    render json: contract.as_json.merge(
    parcelas: contract.installments.as_json(
      only: [ :id, :contract_id, :numero, :valor, :vencimento, :data_pagamento, :status, :created_at, :updated_at ]
    )
    ), status: :created
  end

  private

  def contract_params
    params.require(:contract).permit(:company_id, :client_id, :plan_id, :campaign_id, :details, :valor, :parcelas, :data_contrato)
  end
end
