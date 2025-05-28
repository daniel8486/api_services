class DependentSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :cpf, :dt_born, :degree_dependent_id

  belongs_to :client
end
