class NeighborhoodSerializer
  include JSONAPI::Serializer
  attributes :id, :name, city_id: [ :name ]


  belongs_to :city
  has_many :zips
end
