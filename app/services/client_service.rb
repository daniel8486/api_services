class ClientService

  def self.serialize_client(client)
   result =  ClientSerializer.new(
      client,
      include: [
        :dependents,
        :affiliations,
        :addresses,
        :documents,
        :company,
        "documents.type_document" 
      ]
    ).serializable_hash

    
    if result[:included]
      order = %w[dependent affiliation address document type_document company]
      result[:included].sort_by! { |item| order.index(item[:type]) || 99 }
    end

    result
  end

 
  def self.serialize_clients(clients)
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

   
    if result[:included]
      order = %w[dependent affiliation address document type_document company]
      result[:included].sort_by! { |item| order.index(item[:type]) || 99 }
    end

    result
  end

 
  def self.fetch_address_by_cep(cep)
    Rails.cache.fetch("cep:#{cep}", expires_in: 24.hours) do
      response = Faraday.get("https://viacep.com.br/ws/#{cep}/json/")
      response.success? ? JSON.parse(response.body) : nil
    end
  end

  
   def self.build_with_address(params)
     cep = params[:code_postal] || params[:cep]
     address_data = fetch_address_by_cep(cep)
     if address_data.present?
       params[:addresses_attributes] ||= [ {} ]
       params[:addresses_attributes][0][:street]      ||= address_data["logradouro"]
       params[:addresses_attributes][0][:neighborhood] ||= address_data["bairro"]
       params[:addresses_attributes][0][:city]        ||= address_data["localidade"]
       params[:addresses_attributes][0][:state]       ||= address_data["uf"]
       params[:addresses_attributes][0][:code_postal] ||= address_data["cep"]
     end
     Client.new(params)
   end

  # def self.build_with_address(params)
  #   client = build_with_address(params)
  #   raise ActiveRecord::RecordInvalid.new(client) unless client.valid?
  #   client
  # rescue ActiveRecord::RecordInvalid => e
  #   Rails.logger.error "Erro ao criar cliente: #{e.message}"
  #   raise e
  # end
end
