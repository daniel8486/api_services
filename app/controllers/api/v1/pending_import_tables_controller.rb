class Api::V1::PendingImportTablesController < ApplicationController
  before_action :authorize_super_admin!

  def approve
    pending = PendingImportTable.find(params[:id])
    pending.update!(status: :approved)
    ImportedClientsToSystemService.import_from_temp_table(pending.table_name, pending.schema)
    render json: { message: "Tabela aprovada e clientes importados!" }
  end

  def reject
    pending = PendingImportTable.find(params[:id])
    pending.update!(status: :rejected)
    # Opcional: remover a tabela imediatamente
    DropTempTableJob.perform_later("#{pending.schema}.#{pending.table_name}")
    render json: { message: "Tabela rejeitada e removida!" }
  end

  private

  def authorize_super_admin!
    unless current_user.super_admin? || current_user.super_root?
      render json: { error: "Acesso negado" }, status: :forbidden
    end
  end
end
