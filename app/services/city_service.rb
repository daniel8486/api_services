class CityService
  def self.cached_cities(city_name)
    cache_key = "cities_index_#{city_name.presence || 'all'}"
    Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      Rails.logger.info "Populando cache para: #{cache_key}"
      CitiesJob.perform_later(city_name)
      if city_name.present?
        City.includes(:state, neighborhoods: :zips).where("cities.name ILIKE ?", "%#{city_name}%").to_a
      else
        City.includes(:state, neighborhoods: :zips).all.to_a
      end
    end
  end

  def self.search(query)
    return City.none unless query.present?
    City.where("name ILIKE ?", "%#{query}%")
  end

  def self.search_by_cep(cep)
    City.where("cep_start <= ? AND cep_end >= ?", cep, cep).first
  end

  def self.by_state_acronym(acronym)
    state = State.find_by(acronym: acronym.upcase)
    state ? state.cities : []
  end
end
