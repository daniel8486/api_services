class Api::V1::InstallmentsController < ApplicationController
  before_action :authenticate_user!
  def receber_pagamento
    required_params = [ :numero, :contract_id, :installment_id ]

    missing = required_params.select { |p| params[p].blank? }
    unless missing.empty?
      return render json: { error: "Parâmetros obrigatórios ausentes: #{missing.join(', ')}" }, status: :unprocessable_entity
    end

    installment = Installment.find(params[:installment_id])
    if installment.numero != params[:numero].to_i || installment.contract_id != params[:contract_id].to_i
      return render json: { error: "Dados da parcela não conferem com o contrato" }, status: :unprocessable_entity
    end

    installment = Installment.find(params[:installment_id])
    caixa = CashRegister.where(closed_at: nil, user: current_user).last
    client = installment.contract.client

    Installment.transaction do
      installment.update!(status: "paga", data_pagamento: Time.current)
      caixa.cash_register_transactions.create!(
         installment: installment,
         client: client,
         valor: params[:valor_recebido] || installment.valor,
         tipo: "entrada",
         data: Time.current,
         troco: params[:troco],
         observacao: params[:observacao]
      )
    end

    render json: { success: true, installment: installment }
   end
end
