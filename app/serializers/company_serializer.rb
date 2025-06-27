class CompanySerializer
  include JSONAPI::Serializer
  attributes :name, :cnpj, :name_fantasy, :size, :registration_status_date,
             :opening_date, :public_place, :number, :complement, :code_postal,
             :neighborhood, :municipality, :uf, :email, :phone, :country
  has_many :users, serializer: UserSerializer
  has_many :clients, serializer: ClientSerializer
  has_many :contracts
end
