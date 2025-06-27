class Api::V1::ClientsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!
  include JsonResponse
  def index
   clients = Client.where(company_id: current_user.company_id)
    result = ClientSerializer.new(
      clients,
      include: [
        :dependents,
        :affiliations,
        :addresses,
        :documents,
        :company,
        "documents.type_document"
      ]
    ).serializable_hash

    Rails.logger.info "INCLUDED TYPES: #{result[:included]&.map { |item| item[:type] }&.uniq}"

    # Ordena o included conforme desejado
    if result[:included]
      order = %w[dependents affiliations addresses documents type_documents companies]
      result[:included].sort_by! { |item| order.index(item[:type]) || 99 }
    end

    render_success result, status: :ok
  end

  def create
    @client = ClientService.build_with_address(client_params)
    if @client.save
      render_success ClientService.serialize_client(@client), status: :created
    else
      render_error({ json: { errors: @client.errors.full_messages }, status: :unprocessable_entity })
    end
  end

  def client_params
    params.require(:client).permit(
      :name, :email, :cpf, :rg, :dt_expedition, :organ, :phone, :cellphone,
      :dt_born, :nationality, :company_id,
      affiliations_attributes: [
        :id, :nm_mother, :nm_father, :_destroy
      ],
      addresses_attributes: [
        :id, :code_postal, :neighborhood, :city, :state, :street, :complement, :point_reference, :number, :_destroy
      ],
      dependents_attributes: [
        :id, :name, :cpf, :dt_born, :degree_dependent_id, :_destroy
      ],
      documents_attributes: [
        :id, :type_document_id, :client_id, :document_n, :document, :files, :_destroy
      ],
    )
  end
end
