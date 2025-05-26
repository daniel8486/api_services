class CityResponseService
  def self.zip_details(zip)
    neighborhood = zip.neighborhood
    city = neighborhood.city
    state = city.state

    {
      cidade: city.name,
      uf: state.acronym,
      zona: zip.zone || neighborhood.try(:zone),
      cep: zip.code,
      bairro: neighborhood.name,
      cidade_nome: city.name
    }
  end

  def self.city_details(city)
    state = city.state
    city.neighborhoods.flat_map do |neighborhood|
      neighborhood.zips.map do |zip|
        {
          cidade: city.name,
          uf: state.acronym,
          zona: zip.zone || neighborhood.try(:zone),
          cep: zip.code,
          bairro: neighborhood.name,
          cidade_nome: city.name
        }
      end
    end
  end
end
