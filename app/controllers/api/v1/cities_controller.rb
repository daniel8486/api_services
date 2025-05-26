class Api::V1::CitiesController < ApplicationController
  def index
    city_name = params[:city_name]
    @cities = CityService.cached_cities(city_name)
    Rails.logger.info "Lendo do cache: cities_index_#{city_name.presence || 'all'}"
    resposta = @cities.flat_map { |city| CityResponseService.city_details(city) }
    render json: resposta
  end

  def show
   city = City.includes(:state, neighborhoods: :zips).find(params[:id])
   render json: CityResponseService.city_details(city)
  end

  def search
    @cities = CityService.search(params[:query])
    render json: CitySerializer.new(@cities, include: [ :state ]).serializable_hash
  end

  def search_by_cep
    cep = params[:cep].to_s.gsub(/\D/, "")
    @city = CityService.search_by_cep(cep)
    if @city
      render json: CitySerializer.new(@city, include: [ :state, :neighborhoods, :zips ]).serializable_hash
    else
      render json: { error: "Cidade não encontrada para o CEP informado." }, status: :not_found
    end
  end

  def search_by_acronym
    @cities = CityService.by_state_acronym(params[:state_acronym])
    render json: CitySerializer.new(@cities, include: [ :state ]).serializable_hash
  end
end
