# app/controllers/api/v1/cash_registers_controller.rb
class Api::V1::CashRegistersController < ApplicationController
  before_action :authenticate_user!

  def open
    caixa = CashRegister.create!(
      opening_value: params[:opening_value],
      opened_at: Time.current,
      user: current_user
    )
    render json: caixa, status: :created
  end

  def close
    caixa = CashRegister.where(closed_at: nil, user: current_user).last
    if caixa
      caixa.update!(
        closing_value: params[:closing_value],
        closed_at: Time.current
      )
      render json: caixa, status: :ok
    else
      render json: { error: "Nenhum caixa aberto encontrado" }, status: :not_found
    end
  end

   def registrar_saida
    caixa = CashRegister.where(closed_at: nil, user: current_user).last

    caixa.cash_register_transactions.create!(
      installment: nil,
      client: nil,
      valor: params[:valor],
      tipo: "saida",
      data: Time.current,
      troco: 0,
      observacao: params[:observacao]
    )

    render json: { success: true }
  end
end
