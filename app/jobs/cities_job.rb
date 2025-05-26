class CitiesJob < ApplicationJob
  queue_as :cache_cities

   def perform(city_name = nil, all: false)
      if all
        cache_all_cities
      else
        cache_city(city_name)
      end
   end

   private

   def cache_city(city_name)
    cache_key = "cities_index_#{city_name.presence || 'all'}"
    cities = if city_name.present?
      City.includes(:state, neighborhoods: :zips).where("cities.name ILIKE ?", "%#{city_name}%").to_a
    else
      City.includes(:state, neighborhoods: :zips).all.to_a
    end
    Rails.cache.write(cache_key, cities, expires_in: 12.hours)
   end

   def cache_all_cities
     # Cache geral (todas as cidades)
     Rails.cache.write("cities_index_all", City.includes(:state, neighborhoods: :zips).all.to_a, expires_in: 12.hours)

     # Opcional: cache individual para cada cidade
     City.pluck(:name).uniq.each do |city_name|
       cache_city(city_name)
     end
   end
end
