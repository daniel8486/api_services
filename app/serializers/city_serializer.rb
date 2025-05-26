class CitySerializer
  include JSONAPI::Serializer
  attributes :id, :name, state_id: [ :name, :acronym, :region ]

  belongs_to :state
  has_many :neighborhoods
  has_many :zips
end
