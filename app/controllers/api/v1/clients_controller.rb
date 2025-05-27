class Api::V1::ClientsController < ApplicationController
  def index
   clients = Client.where(company_id: current_user.company_id)
   render_success json: ClientService.serialize_clients(clients)
  end

  def create
    @client = ClientService.build_with_address(client_params)
    if @client.save
      render_success json: ClientService.serialize_client(@client), status: :created
    else
      render_error json: { errors: @client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def client_params
    params.require(:client).permit(
      :name, :email, :cpf, :rg, :dt_expedition, :organ, :phone, :cellphone,
      :dt_born, :nationality, :code_postal, :company_id,
      affiliation_attributes: [
        :id, :nm_mother, :nm_father, :_destroy
      ],
      addresses_attributes: [
        :id, :code_postal, :neighborhood, :city, :state, :street, :complement, :point_reference, :number, :_destroy
      ],
      dependents_attributes: [
        :id, :name, :cpf, :dt_born, :_destroy
      ]
    )
  end
end
