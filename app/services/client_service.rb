class ClientService
  # Serializa um cliente com as relações principais
  def self.serialize_client(client)
    ClientSerializer.new(client, include: [ :dependents, :affiliations, :addresses, :documents, :company ]).serializable_hash
  end

  # Serializa uma coleção de clientes
  def self.serialize_clients(clients)
    ClientSerializer.new(clients, include: [ :dependents, :affiliations, :addresses, :documents, :company ]).serializable_hash
  end

  # Busca endereço por CEP usando cache (exemplo usando Faraday)
  def self.fetch_address_by_cep(cep)
    Rails.cache.fetch("cep:#{cep}", expires_in: 24.hours) do
      response = Faraday.get("https://viacep.com.br/ws/#{cep}/json/")
      response.success? ? JSON.parse(response.body) : nil
    end
  end

  # Cria um cliente preenchendo endereço via CEP
  def self.build_with_address(params)
    cep = params[:code_postal] || params[:cep]
    address_data = fetch_address_by_cep(cep)
    params.merge!(
      public_place: address_data["logradouro"],
      neighborhood: address_data["bairro"],
      municipality: address_data["localidade"],
      uf: address_data["uf"],
      code_postal: address_data["cep"]
    ) if address_data.present?
    Client.new(params)
  end
end
