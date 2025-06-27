class NeighborhoodSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :city_id


  belongs_to :city, serializer: CitySerializer
  has_many :zips, serializer: ZipSerializer
end
