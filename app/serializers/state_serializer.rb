class StateSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :acronym, :region
  has_many :cities, serializer: CitySerializer
end
